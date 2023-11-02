## Synthesis_UI_using_TCL
> Using TCL to generate a report from a design and the free and open-source EDA tools Yosys and Opentimer, a five-day TCL training course by VSD takes place. The program's input is the paths of design files in.csv format. The ultimate goal by day five is to provide design information, namely paths of design data, to the "TCL BOX," (synui) which generates a report detailing the characteristics of the design. Yosys and Opentimer, two free and open-source EDA tools, are used to run the design and generate timing reports.
 
![Screenshot (264)](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/dcf3a9f9-2281-4d6f-b318-a52ddea1fb7d)
![Screenshot (265)](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/6194ce14-1cf5-41c2-9de3-6938f205f912)

## Requirements
* Linux OS
* Yosys Synthesis Suite
* OpenTimer STA Tool
* TCL Matrix Package

## Usage
* Clone the repo, and in the directory in the bash terminal, run `./synui openMSP430_design_details.csv` and then design '*openMSP430*. Yosys synthesis and OpenTimer STA will be run, and at the end you will receive '*PRELAYOUT TIMING RESULTS*' as illustrated in the above images.
* You can also type in `./synui -help`, wherein the command gives you a usage guide to help explore its functionalities.

