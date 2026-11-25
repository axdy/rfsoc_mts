# ZCU216 RFSoC MTS

The ZCU216 overlay targets Vivado 2025.2 and PYNQ 4.0.0. The packed
`bitstream/mts.xsa` contains the bitstream and hardware metadata.

Build with `make all` in this directory. To recreate the editable project alone,
run `make block_design`. The project uses the saved block design and its IP
configurations.

## Install and run

Boot the ZCU216 PYNQ 4.0 image. From the repository root on the board, run
`bash install.sh` in the PYNQ environment with permission to install packages.
The installer needs Git, Make, GCC, CMake, and network access. It builds the
patched RFDC package from the PYNQ 4.0.0 source and installs the 500 MHz CLK104
profiles with `xrfclk`.

Open the `rfsoc_mts` folder in JupyterLab. Run the setup notebook, then the
loopback and MTS demonstrator. The RFDC runs at 2 GS/s with 4× DAC interpolation
and ADC decimation. Both complex buffers run at 500 MS/s.

## Board validation TODO

- [ ] Boot PYNQ 4.0 and confirm the device tree reports `ZCU216` and exposes
  the CLK104 SPI devices.
- [ ] Run the installer and confirm the patched `xrfdc` methods import and the
  XSA loads with the expected RFDC and capture hierarchies.
- [ ] Confirm the CLK104 profiles produce the 500 MHz PL clock, 500 MHz RFDC
  references, and 5 MHz SYSREF. Check ADC and DAC tile 2 PLL lock.
- [ ] Check XM655 channel mapping and capture a tone through one DAC-to-ADC
  loopback. Add a second ADC tile and compare latency and relative phase
  across repeated MTS runs.
