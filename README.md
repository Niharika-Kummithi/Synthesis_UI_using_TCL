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
***Note: The screenshots in the following sections are purely based on the 'synui.tcl' script that I have uploaded and are not a direct output of the code snippet in the corresponding section. The code snippets contain only the crucial portions of the 'synui.tcl' script required to execute the tasks mentioned in the respective sections.***
## Day 1 - Introduction to TCL and VSDSYNTH Toolbox Usage (01/11/2023)
Day 1's task is to create a command (in my case, ***synui***) and pass a .csv file from the UNIX shell to the TCL script, taking into consideration mainly three general scenarios from the user's point of view.
![Screenshot 2023-08-24 183526](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/a1c31fb3-a8e5-4a7e-987d-3d7e6ff4ad65)
**Review of input files provided in work directory**
![Screenshot from 2023-08-23 22-48-19](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/7dd31089-d1a4-44a2-9d31-f828af25e37c)
**Review of input file - openMSP430_design_details.csv**
![Screenshot from 2023-08-23 22-29-25](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/de69f8ea-92cc-40e6-b570-e7a364c72c04)
### Implementation
Creation of the *yosysui* command script and *yosysui.tcl* files.
![Screenshot from 2023-08-24 19-28-08](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/53d902f7-9ec4-4a8f-a2cd-683f74a7ca2f)
*yosysui.tcl*
![Screenshot from 2023-08-24 19-36-52](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/c0e5a04d-2d6b-40ea-bcd1-9bd76be60116)
The basic structure of bash code used for the implementation of general scenarios is shown below.

In my command ***synui***, I have implemented a total of *5 general scenarios* from the user's point of view in the bash script.
#### 1. No input file provided
![Screenshot from 2023-08-24 19-39-50](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/cb679d28-e0de-448a-ad2a-5d31031d2f8b)
#### 2. File provided exists but is not of .csv format
![Screenshot from 2023-08-24 19-41-41](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/45653ab6-96be-49f1-8af2-afcce1ee0392)
#### 3. More than one file or parameters provided
![Screenshot from 2023-08-24 19-53-06](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/8ad5345c-1fa8-4432-b618-b5a0bd5f3934)
#### 4. Provide a .csv file that does not exist
![Screenshot from 2023-08-24 19-54-26](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/96ee26cd-43ed-4056-a1ac-c42a5207542a)
#### 5. Type "-help" to find out usage
![Screenshot from 2023-08-24 19-55-32](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/86488924-9fe5-4702-a41d-3916ac7044de)
