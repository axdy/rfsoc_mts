<img src="strathsdr_nw_banner.png" width="100%">

<table border="0" align="center">
    <tr border="0">
        <td align="center" width="50%" border="0">
            <img src="https://www.rfsocbook.com/wp-content/uploads/2022/12/RFSoC3D_v4-1433x1536.png" alt="oscthumb" style="width: 60%" border="0"/>
        </td>
        <td align="center" width="50%" border="0">
            <font size=7><b>Available Now!</b></font size> <br> <font size=5>Software Defined Radio with Zynq® UltraScale+ RFSoC</font size> <br> <font size=4><a href="https://rfsocbook.com/">Free Download</a> <br><a href="https://www.amazon.com/Software-Defined-Radio-Ultrascale-RFSoC/dp/1739588606?keywords=zynq+rfsoc&qid=1673452844&sprefix=%2Caps%2C137&sr=8-1&linkCode=ll1&tag=thzybo-20&linkId=0bf245a543fd4af4625086df4c190928&language=en_US&ref_=as_li_ss_tl">Printed Edition</a></font size>
        </td>
    </tr>
</table>

# PYNQ Multi-Tile Sychronisation Reference Design with Synhronisation of Fine Mixing Digital Features.
| Board | PYNQ image | Vivado build | Converter rate |
| --- | --- | --- | --- |
| [RFSoC4x2](http://rfsoc-pynq.io/) | 3.1.1 | 2024.1 | 4 GS/s |
| [ZCU208](https://www.xilinx.com/products/boards-and-kits/zcu208.html) | 3.1.1 | 2024.1 | 4 GS/s |
| ZCU216 | 4.0.0 | 2025.2 | 2 GS/s |

ZCU216 hardware validation is pending. See the
[ZCU216 board guide](boards/ZCU216/rfsoc_mts/README.md) for installation.

<p align="center">
  <img src="./demonstration.gif" width="75%" height="75%" />
</p>

## Quick Start
Follow the instructions below to install the Multi-Tile Synchronisation (MTS) Demonstrator now. <b>You will need to give your board access to the internet</b>.
*  Power on the board with the PYNQ image listed above.
*  Navigate to Jupyter Labs by opening a browser (preferably Chrome) and connecting to `http://<board_ip_address>:9090/lab`.
* We need to open a terminal in Jupyter Lab. Firstly, open a launcher window as shown in the figure below:

<p align="center">
  <img src="./open_jupyter_launcher.jpg" width="50%" height="50%" />
</p>

* Now open a terminal in Jupyter as illustrated below:

<p align="center">
  <img src="./open_terminal_window.jpg" width="50%" height="50%" />
</p>

Run the commands below in the Jupyter terminal to install the MTS demonstrator.

> [!WARNING]
> The commands below modify the `xrfdc` package included with PYNQ. If you have made local changes to this package, you should back them up before installing this repository. Additionally, because these modifications replace the default `xrfdc` package, they may affect the behaviour of other PYNQ designs on your device.

```sh
git clone https://github.com/strath-sdr/rfsoc_mts
cd rfsoc_mts
bash install.sh
```

Once installation has complete you will find the Multi-Tile Synchronisation notebooks in the Jupyter workspace directory. The folder will be named 'rfsoc_mts'.

## Using the Project Files
Use the Vivado version listed for the board. Run the following in a shell with
Vivado on `PATH`:
```sh
cd /<repository-location>/boards/<board-name>/rfsoc_mts/
```
Now that we have moved into the correct directory, make the Vivado project by running the make commands below sequentially.
```sh
make block_design
make bitstream
```

Alternatively, run the entire project build:
```sh
make all
```

## Acknowledgements
This work was inspired by AMD's open-source [RFSoC-MTS](https://github.com/Xilinx/RFSoC-MTS/) project.

## License 
[BSD 3-Clause](../../blob/master/LICENSE)
 
