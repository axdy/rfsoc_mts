__author__ = "Ryan Provan"
__organisation__ = "The Univeristy of Strathclyde"
__support__ = "https://github.com/strath-sdr/rfsoc_mts"

import xrfdc
import os
from time import sleep

board = os.getenv('BOARD')


class MultiTileSynchronisation():
    
    def __init__(
        self,
        rfdc,
        clkwiz,
        dac_active=0b1111,
        adc_active=0b1111,
        dac_reftile=0,
        adc_reftile=0,
        nco_dac=1000,
        nco_adc=1000,
        DigitalFeatureSynch=False,
        sync_on_init=True,
        rfdc_parameters=None,
    ):
        
        # -- Init attributes --
        self.rfdc = rfdc # pynq rfdc object
        self.clkwiz = clkwiz # clkwiz used in MTS PL_SYSREF capture
        self.dac_active = dac_active # bitmask describing dac tiles to synch
        self.adc_active = adc_active # bitmask describing adc tiles to synch
        self.dac_reftile = dac_reftile # tile whose sampling clock drives all dac mts tiles
        self.adc_reftile = adc_reftile # tile whose sampling clock drives all adc mts tiles
        self.dfs_en = DigitalFeatureSynch # Digital Feature Synchronisation enable
        self.rfdc_dict = self._discover_rfdcs(dac_active, adc_active, rfdc_parameters)
        
        # -- Reset MTS clkwiz --
        self.clkwiz.mmio.write_reg(0x0000, 0x000A) # necessary else adc won't synch consistently
        
        # -- Get DAC and ADC NCO frequencies --
        self._nco_dac = nco_dac
        self._nco_adc = nco_adc
        
        # -- Synchronise on initilisation --
        if sync_on_init:
            self.mts_sync(nco_dac, nco_adc)
    
    @property
    def nco_adc(self):
        return self._nco_adc
    @nco_adc.setter
    def nco_adc(self, fc):
        self._sync_nco_adc(fc)
        
    @property
    def nco_dac(self):
        return self._nco_dac
    @nco_dac.setter
    def nco_dac(self, fc):
        self._sync_nco_dac(fc)
    
    def mts_sync(self, dac=None, adc=None):
        """Synchronises gearbox FIFOs and digital features (if required) for ALL active ADCs/DACs in one step.
        """
        self._sync_fifos() # Synchronise gearbox FIFOs
        
        if self.dfs_en: # Synchronise digital features
            if dac is not None:
                self.nco_dac = dac
            if adc is not None:
                self.nco_adc = adc
                
    def report_latency(self):
        """Reports MTS config (gearbox FIFO) latencies for all enabled RFDCs.
        """
        reports = [
            ("DAC", self.rfdc.dac_mts_config, self.rfdc_dict["DAC"]),
            ("ADC", self.rfdc.adc_mts_config, self.rfdc_dict["ADC"]),
        ]

        for name, config, tile_dict in reports:
            for n in tile_dict:
                print(f"--- {name} Tile {n} report ---")
                print(f"  Latency:\t{config.Latency[n]}")
                print(f"  Offset:\t{config.Offset[n]}")
                print(f"  DTC Code:\t{config.DTC_Set_T1.DTC_Code[n]}")
                print(f"  Num Windows:\t{config.DTC_Set_T1.Num_Windows[n]}")
                print(f"  Max Gap:\t{config.DTC_Set_T1.Max_Gap[n]}")
                print(f"  Min Gap:\t{config.DTC_Set_T1.Min_Gap[n]}")
                print(f"  Max Overlap:\t{config.DTC_Set_T1.Max_Overlap[n]}\n")
                
    def _sync_fifos(self, dac_target=-1, adc_target=-1):
        """Synchronises gearbox FIFOs of the enabled RF-ADC and RF-DAC tiles using the MTS.
        """
        # -- Initialise MTS for DAC & ADC tiles --
        self.rfdc.dac_mts_init(RefTile=self.dac_reftile)
        self.rfdc.dac_mts_config.Tiles = self.dac_active # group defined in binary 0b1111
        self.rfdc.dac_mts_config.Target_Latency = dac_target 
        
        self.rfdc.adc_mts_init(RefTile=self.adc_reftile)
        self.rfdc.adc_mts_config.Tiles = self.adc_active
        self.rfdc.adc_mts_config.Target_Latency = adc_target
        
        # -- Synchronise DAC & ADC tiles --
        self.rfdc.mts_sysref_enable(SysRefEnable=True) # Ensure SYSREF capture is enabled
        sleep(0.1)
        self.rfdc.dac_mts_sync()
        self.rfdc.adc_mts_sync()
        
        # -- Disable SYSREF capture (no longer necessary) --
        sleep(0.1)
        self.rfdc.mts_sysref_enable(SysRefEnable=False)
                
    def _sync_nco_dac(self, freq, nyquist_zone=1):
        """Sets/resets enabled RF-DAC NCO frequency/phase on the SYSREF trigger.
        """
        self.rfdc.mts_sysref_enable(SysRefEnable=False) # Ensure SYSREF capture is disabled
        
        # -- Set DAC NCO frequency --
        for t, blocks in self.rfdc_dict["DAC"].items():
            tile = self.rfdc.dac_tiles[t]
            for b in blocks:
                block = tile.blocks[b]
                block.NyquistZone = nyquist_zone
                block.MixerSettings = {
                    "CoarseMixFreq": xrfdc.COARSE_MIX_BYPASS,
                    "EventSource": xrfdc.EVNT_SRC_SYSREF,
                    "FineMixerScale": xrfdc.MIXER_SCALE_1P0,
                    "Freq": freq,
                    "MixerMode": xrfdc.MIXER_MODE_C2R,
                    "MixerType": xrfdc.MIXER_TYPE_FINE,
                    "PhaseOffset": 0.0,
                }
                block.ResetNCOPhase()
                tile.SetupFIFO(True)
        self._nco_dac = freq
        self._trigger_sysref() # Invoke a rising edge on the sysref signal
            
    def _sync_nco_adc(self, freq, nyquist_zone=1):
        """Sets/resets enabled RF-ADC NCO frequency/phase on the SYSREF trigger.
        """
        self.rfdc.mts_sysref_enable(SysRefEnable=False) # Ensure SYSREF capture is disabled
        
        # -- Set ADC NCO frequency --
        for t, blocks in self.rfdc_dict["ADC"].items():
            tile = self.rfdc.adc_tiles[t]
            for b in blocks:
                block = tile.blocks[b]
                block.NyquistZone = nyquist_zone
                block.MixerSettings = {
                    "CoarseMixFreq": xrfdc.COARSE_MIX_BYPASS,
                    "EventSource": xrfdc.EVNT_SRC_SYSREF,
                    "FineMixerScale": xrfdc.MIXER_SCALE_1P0,
                    "Freq": -freq,
                    "MixerMode": xrfdc.MIXER_MODE_R2C,
                    "MixerType": xrfdc.MIXER_TYPE_FINE,
                    "PhaseOffset": 0.0,
                }
                block.ResetNCOPhase()
                tile.SetupFIFO(True)
        self._nco_adc = freq
        self._trigger_sysref() # Invoke a rising edge on the sysref signal
        
    def _trigger_sysref(self):
        """Briefly toggles SYSREF capture to invoke a rising edge
        """
        self.rfdc.mts_sysref_enable(SysRefEnable=True)
        sleep(0.1)
        self.rfdc.mts_sysref_enable(SysRefEnable=False)
        
    def _discover_rfdcs(self, dac_bitmask=0, adc_bitmask=0, rfdc_parameters=None):
        """Find usable RFDC blocks on the selected tiles."""
        parameters = rfdc_parameters or {}
        rfdc_dict = {"DAC": {}, "ADC": {}}
        converters = (("DAC", dac_bitmask, self.rfdc.dac_tiles),
                      ("ADC", adc_bitmask, self.rfdc.adc_tiles))

        for name, mask, tiles in converters:
            for tile, driver in enumerate(tiles):
                if (mask & (1 << tile)) == 0:
                    continue
                blocks = []
                for block in range(4):
                    enabled = parameters.get(f"C_{name}_Slice{tile}{block}_Enable")
                    if str(enabled).lower() in ("0", "false"):
                        continue
                    try:
                        _ = driver.blocks[block].MixerSettings
                    except (RuntimeError, IndexError):
                        continue
                    blocks.append(block)
                if blocks:
                    rfdc_dict[name][tile] = tuple(blocks)

        return rfdc_dict
