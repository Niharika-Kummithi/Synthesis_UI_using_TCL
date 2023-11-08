
## Synthesis_UI_using_TCL
> Using TCL to generate a report from a design and the free and open-source EDA tools Yosys and Opentimer, a five-day TCL training course by VSD takes place. The program's input is the paths of design files in.csv format. The ultimate goal by day five is to provide design information, namely paths of design data, to the "TCL BOX," (synui) which generates a report detailing the characteristics of the design. Yosys and Opentimer, two free and open-source EDA tools, are used to run the design and generate timing reports.
 
![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/6a378073-b6f3-4b47-af58-452b8aef32eb)
![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/9bfb1f56-9b6b-43de-8dc4-945f488aadda)

## Requirements
* Linux OS
* Yosys Synthesis Suite
* OpenTimer STA Tool
* TCL Matrix Package

## Usage
* Clone the repo, and in the directory in the bash terminal, run `./synui openMSP430_design_details.csv` and then design '*openMSP430*. Yosys synthesis and OpenTimer STA will be run, and at the end you will receive '*PRELAYOUT TIMING RESULTS*' as illustrated in the above images.
* You can also type in `./synui -help`, wherein the command gives you a usage guide to help explore its functionalities.

***Note: The screenshots are part of synui.tcl code. The outputs are not the result of entire code. They show the results of particular blocks of code only.***

## Day 1 - Introduction to TCL and VSDSYNTH Toolbox Usage (01/11/2023)

Day 1's task is to create a command (in my case, ***synui***) and pass a .csv file from the UNIX shell to the TCL script, taking into consideration mainly three general scenarios from the user's point of view.

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/53593010-5a25-4e8d-ba33-1bc30eb14142)

**Review of input file - openMSP430_design_details.csv**

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/c9199ac5-6c69-4273-ac90-40a677e06962)


### Implementation

Creation of the *synui* command script and *synui.tcl* files.

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/ea68e2da-f6ad-4d75-b66f-2dbbf4d8ae20)


*synui Code*
![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/0aaed71a-4854-40f3-a0d8-301a57a62e5f)



The basic structure of bash code used for the implementation of general scenarios is shown below.

```bash
#Code to handle the scenario where user does not give any file, does not give .csv file, gives more than one file as argument

if [ $# -eq 0 ]
then
        echo "Info: Please provide a CSV file"
        exit 1
elif [ $# -gt 1 ]
then
        echo "Info: Please provide only 1 CSV file"
        exit 1
else
        if [[ $1 != *.csv  &&  $1 != "-help" ]]
        then
                echo "Info: Please provide a .csv format file"
                exit 1
        fi
fi
# Code to check if the .csv file is present in directory or not, and also to display information for -help argument.
if [ ! -f $1 ] || [ $1 == "-help" ]
then
        if [ $1 != "-help" ]
        then
                echo "Error: The file $1 is not found in current directory."
                exit 1
        else
                echo "USAGE: ./synui <csv_file>"
                echo
                echo " where <csv file> consists of 2 columns, below keyword being in 1st column and is Case Sensitive. Please request Niharika for sample csv file."
                echo
                echo " <Design Name> is the name of top level module."
                echo
                echo " <Output Directory> is the name of output directory where you want to dump synthesis script, synthesized netlist and timing reports."
                echo
                echo " <Netlist Directory> is the name of directory where all RTL netlist are present."
                echo
                echo " <Early Library Path> is the file path of the early cell library to be used for STA."
                echo
                echo " <Late Library Path> is file path of the late cell library to be used for STA."
                echo
                echo " <Constraints file> is csv file path of constraints to be used for STA."
                exit 1
        fi
else
        #Code to execute if the proper CSV file exists.
        echo "Info: CSV file accepted"
        tclsh synui.tcl $1
fi
```

In my command ***synui***, I have implemented a total of *5 general scenarios* from the user's point of view in the bash script.

#### 1. No input file provided

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/75e05d7e-8a67-47c0-bb6b-6b9090800a7d)


#### 2. File provided exists but is not of .csv format

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/231d6a08-bfc6-4d29-b5c5-6d8b5b083268)


#### 3. More than one file or parameters provided

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/8f845166-881b-4640-ba72-c2ae101c501f)


#### 4. Provide a .csv file that does not exist

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/d09b28a5-78dd-4a02-a895-8e9995e815df)


#### 5. Type "-help" to find out usage

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/8ea9088c-de2f-4446-a714-9061fee7c521)


## Day 2 - Variable Creation and Processing Constraints from CSV (06/11/2023)

Day 2's task is to create variables, check file/directory existence, and convert constraints csv file to format[1] and SDc format. This is done by writing the code in *synui.tcl*.

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/15011298-d33c-438c-a5af-5990e972dd37)


**Review of input file - openMSP430_design_constraints.csv**

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/0987a45d-426f-4dc2-8132-4ae41d757731)


### Implementation

I have successfully completed Day 2 tasks, namely variable creation, file and directory existence checks, and the processing of the constraints csv file.

**synui.tcl snapshot**

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/0af273e8-67ae-41ca-be68-68e134c5c8aa)


#### Variable Creation

I have auto-created the variables (*have used special condition to identify design name*) from the csv file by converting it into a matrix and then to an array (*also added command to capture the start time of the script so that it can be used to calculate runtime at the end*). 

*Code*

```tcl
#!/bin/tclsh

set start_time [clock clicks -microseconds]
set csv_design [lindex $argv 0]

package require csv
package require struct::matrix

struct::matrix m

set f [open $csv_design]

csv::read2matrix $f m , auto

close $f

set n_columns [m columns]
set n_rows [m rows]

puts "\nInfo:Variable values"
puts "No. of rows =  $n_rows"
puts "No. of columns = $n_columns"

m link csv_arr

set i 0
while {$i < $n_rows} {
        puts "\nInfo: Setting $csv_arr(0,$i) as '$csv_arr(1,$i)'"
        if { ![string match "*/*" $csv_arr(1,$i)] && ![string match "*.*" $csv_arr(1,$i)] } {
                        set [string map {" " "_"} $csv_arr(0,$i)] $csv_arr(1,$i)
        } else {
                set [string map {" " "_"} $csv_arr(0,$i)] [file normalize $csv_arr(1,$i)]
        }
        set i [expr {$i+1}]
}


```

*Screenshot*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/bd530094-85fd-44b9-acce-71fe56e4a9bf)


#### File / Directory Existence Check

Since the existence of these files and directories is essential to the program's operation, I have built code to check for their existence. If the input files do not exist, we exit from the code except for output directory in which case it  is created. Below are screenshots of the terminal displaying the functionality and the basic code for the same.

*Code*

```tcl
############# FILE EXISTENCE CHECK ###################
# IF the directory does not exist, then create one 


if { ![file isdirectory $Output_Directory] } {
        puts "\nInfo: Cannot find output directory $Output_Directory. Creating $Output_Directory"
        file mkdir $Output_Directory
} else {
        puts "\nInfo: Output directory found in path $Output_Directory"
}

# Checking if netlist directory exists if not exits
if { ![file isdirectory $Netlist_Directory] } {
        puts "\nError: Cannot find RTL netlist directory in path $Netlist_Directory. Exiting..."
        exit
} else {
        puts "\nInfo: RTL netlist directory found in path $Netlist_Directory"
}

# Checking if early cell library file exists if not exits
if { ![file exists $Early_Library_Path] } {
        puts "\nError: Cannot find early cell library in path $Early_Library_Path. Exiting..."
        exit
} else {
        puts "\nInfo: Early cell library found in path $Early_Library_Path"
}

# Checking if late cell library file exists if not exits
if { ![file exists $Late_Library_Path] } {
        puts "\nError: Cannot find late cell library in path $Late_Library_Path. Exiting..."
        exit
} else {
        puts "\nInfo: Late cell library found in path $Late_Library_Path"
}

# Checking if constraints file exists if not exits
if { ![file exists $Constraints_File] } {
        puts "\nError: Cannot find constraints file in path $Constraints_File. Exiting..."
        exit
} else {
        puts "\nInfo: Constraints file found in path $Constraints_File"
}


```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/9de8b0db-83c2-43a8-9fbc-5e48de115524)

#### Processing of the constraints openMSP430_design_constraints.csv file

The file was successfully analyzed and turned into a matrix. The beginning rows of the clocks, inputs, and outputs were also extracted, along with the rows and columns count. Below are the basic code for the same and a screenshot of the terminal showing many "puts" writing the variables.

*Code*

```tcl
# Constraints csv file data processing for convertion to format[1] and SDC
# ------------------------------------------------------------------------
puts "\nInfo: Dumping SDC constraints for $Design_Name"
::struct::matrix m1
set f1 [open $Constraints_File]
csv::read2matrix $f1 m1 , auto
close $f1
set n_rows_concsv [m1 rows]
set n_columns_concsv [m1 columns]
# Finding row number starting for CLOCKS section
set clocks_start_row [lindex [lindex [m1 search all CLOCKS] 0] 1]
# Finding column number starting for CLOCKS section
set clocks_start_column [lindex [lindex [m1 search all CLOCKS] 0] 0]
# Finding row number starting for INPUTS section
set inputs_start [lindex [lindex [m1 search all INPUTS] 0] 1]
# Finding row number starting for OUTPUTS section
set outputs_start [lindex [lindex [m1 search all OUTPUTS] 0] 1]

puts "\nInfo: Listing value of variables for user debug"
puts "Number of rows in CSV file = $n_rows_concsv"
puts "Number of columns in CSV file = $n_columns_concsv"
puts "CLOCKS starting row in CSV file = $clocks_start_row"
puts "CLOCKS starting column in CSV file = $clocks_start_column"
puts "INPUTS starting row in CSV file = $inputs_start "
puts "OUTPUTS starting row in CSV file = $outputs_start "

```

*Screenshot*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/b2dc950e-8ea7-40ab-b448-cf62ab7ae13a)


## Day 3 - Processing Clock and Input Constraints from CSV and dumping SDC (07/11/2023)

The assignment for Day 3 is to essentially to analyze clock and input constraints in a CSV file and output SDC commands into a .sdc file with the actual processed data. In addition to a number of matrix search algorithms, it also uses an algorithm to distinguish between inputs that are buses and bits.

**Review of input file - openMSP430_design_constraints.csv**

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/d74d6bbd-20a8-4521-a1d6-38d08c61b8ec)


### Implementation

Day 3 tasks are succesfully complete i.e. To process constraints in a csv file for clocks and inputs and dump SDC commands into a .sdc file with actual processed data.

#### Processing of the constraints .csv file for CLOCKS and dumping SDC commands to .sdc

The csv file containing the CLOCKS data has been successfully processed, and clock-based SDC commands (*with distinct clock names by appending "_synyui" to the SDC create_clock command*) have been dumped into the.sdc file. Below are screenshots of the terminal with many "puts" spitting out the variables, user debug information, and output.sdc, along with the basic code for the same.

*Code*

```tcl
##############################################################################################
################### Day 3 ###################################################################
# Conversion of constraints csv file to SDC
# -----------------------------------------
# CLOCKS section
# Finding column number starting for clock latency in CLOCKS section
#
#puts "$n_columns_concsv"
set clk_erd_st_col [lindex [lindex [m1 search rect $clocks_start_column $clocks_start_row [expr { $n_columns_concsv - 1}] [expr {$inputs_start-1}] early_rise_delay] 0 ] 0 ]
set clk_efd_st_col [lindex [lindex [m1 search rect $clocks_start_column $clocks_start_row [expr { $n_columns_concsv - 1}] [expr {$inputs_start-1}] early_fall_delay] 0 ] 0 ]
set clk_lrd_st_col [lindex [lindex [m1 search rect $clocks_start_column $clocks_start_row [expr { $n_columns_concsv - 1}] [expr {$inputs_start-1}] late_rise_delay] 0 ] 0 ]
set clk_lfd_st_col [lindex [lindex [m1 search rect $clocks_start_column $clocks_start_row [expr { $n_columns_concsv - 1}] [expr {$inputs_start-1}] late_fall_delay] 0 ] 0 ]

# Finding column number starting for clock transition in CLOCKS section
#

set clk_ers_st_col [lindex [lindex [m1 search rect $clocks_start_column $clocks_start_row [expr { $n_columns_concsv - 1}] [expr {$inputs_start-1}] early_rise_slew] 0 ] 0 ]
set clk_efs_st_col [lindex [lindex [m1 search rect $clocks_start_column $clocks_start_row [expr { $n_columns_concsv - 1}] [expr {$inputs_start-1}] early_fall_slew] 0 ] 0 ]
set clk_lrs_st_col [lindex [lindex [m1 search rect $clocks_start_column $clocks_start_row [expr { $n_columns_concsv - 1}] [expr {$inputs_start-1}] late_rise_slew] 0 ] 0 ]
set clk_lfs_st_col [lindex [lindex [m1 search rect $clocks_start_column $clocks_start_row [expr { $n_columns_concsv - 1}] [expr {$inputs_start-1}] late_fall_slew] 0 ] 0 ]

# Finding column number starting for frequency and duty cycle in CLOCKS section only
set clk_freq_st_col [lindex [lindex [m1 search rect $clocks_start_column $clocks_start_row [expr { $n_columns_concsv - 1}] [expr {$inputs_start-1}] frequency] 0 ] 0 ]
set clk_dc_st_col [lindex [lindex [m1 search rect $clocks_start_column $clocks_start_row [expr { $n_columns_concsv - 1}] [expr {$inputs_start-1}] duty_cycle] 0 ] 0 ]

# Creating .sdc file with design name in output directory and opening it in write mode
#
set sdc_file [open $Output_Directory/$Design_Name.sdc "w"]

# Setting variables for actual clock row start and end
#
set i [expr {$clocks_start_row+1}]
set end_of_clocks [expr {$inputs_start-1}]

puts "\nInfo-SDC: Working on clock constraints and creating clocks. Please wait"

# while loop to write constraint commands to .sdc file
while { $i < $end_of_clocks } {
	#Create SDC command to create clocks.
	puts -nonewline $sdc_file "\ncreate_clock -name [concat [m1 get cell 0 $i]_synui] -period [m1 get cell $clk_freq_st_col $i] -waveform \{0 [expr {[m1 get cell $clk_freq_st_col $i]*[m1 get cell $clk_dc_st_col $i]/100}]\} \[get_ports [m1 get cell 0 $i]\]"

	# set_clock_transition SDC command to set clock transition values
	puts -nonewline $sdc_file "\nset_clock_transition -min -rise [m1 get cell $clk_ers_st_col $i] \[get_clocks [m1 get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_transition -min -fall [m1 get cell $clk_efs_st_col $i] \[get_clocks [m1 get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_transition -max -rise [m1 get cell $clk_lrs_st_col $i] \[get_clocks [m1 get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_transition -max -fall [m1 get cell $clk_lfs_st_col $i] \[get_clocks [m1 get cell 0 $i]\]"

	# set_clock_latency SDC command to set clock latency values
	puts -nonewline $sdc_file "\nset_clock_latency -source -early -rise [m1 get cell $clk_erd_st_col $i] \[get_clocks [m1 get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_latency -source -early -fall [m1 get cell $clk_efd_st_col $i] \[get_clocks [m1 get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_latency -source -late -rise [m1 get cell $clk_lrd_st_col $i] \[get_clocks [m1 get cell 0 $i]\]"
	puts -nonewline $sdc_file "\nset_clock_latency -source -late -fall [m1 get cell $clk_lfd_st_col $i] \[get_clocks [m1 get cell 0 $i]\]"

	set i [expr {$i+1}]
}
set clocks_start_row_actual [expr {$clocks_start_row+1}]
puts "\n Clocks created in .sdc file. Values for debugging: "
puts "\n Clock early rise delay start column in constraint file = $clk_erd_st_col"
puts "\n Clock early fall delay start column in constraint file = $clk_efd_st_col"
puts "\n Clock late rise delay start column in constraint file = $clk_lrd_st_col"
puts "\n Clock late fall delay start column in constraint file = $clk_lfd_st_col"
puts "\n Clock early rise slew start column in constraint file = $clk_ers_st_col"
puts "\n Clock early fall slew start column in constraint file = $clk_efs_st_col"
puts "\n Clock late rise slew start column in constraint file = $clk_lrs_st_col"
puts "\n Clock late fall slew start column in constraint file = $clk_lfs_st_col"
puts "\n Clock frequency start column in constraint file = $clk_freq_st_col"
puts "\n Clock duty cycle start column in constraint file = $clk_dc_st_col"
puts "\n Clock actual starting row = $clocks_start_row_actual"
puts "\n Clock actual ending row = $end_of_clocks"
```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/1873682e-c453-45b1-bf5b-4cad9a237290)

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/3a8fa7e3-5fc8-4c5c-b958-f6e082c339e5)



*openMSP430.sdc*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/568d2d09-b06f-4cb8-ba49-a78353566e2f)



#### Processing of the constraints .csv file for INPUTS and dumping SDC commands to .sdc

I've processed the inputs data csv file, separated bit and bus inputs, and dumped input-based SDC commands into a.sdc file correctly. Below are screenshots of the terminal with many "puts" spitting out the variables, user debug information, and output.sdc, along with the basic code for the same.

*Code*

```tcl
######################## DAY3 Part 2 ######################################

# Finding the starting column number for input clock latency in INPUTS section
set ip_erd_st_col [lindex [lindex [m1 search rect $clocks_start_column $inputs_start [expr {$n_columns_concsv-1}] [expr {$outputs_start-1}] early_rise_delay] 0 ] 0 ]
set ip_efd_st_col [lindex [lindex [m1 search rect $clocks_start_column $inputs_start [expr {$n_columns_concsv-1}] [expr {$outputs_start-1}] early_fall_delay] 0 ] 0 ]
set ip_lrd_st_col [lindex [lindex [m1 search rect $clocks_start_column $inputs_start [expr {$n_columns_concsv-1}] [expr {$outputs_start-1}] late_rise_delay] 0 ] 0 ]
set ip_lfd_st_col [lindex [lindex [m1 search rect $clocks_start_column $inputs_start [expr {$n_columns_concsv-1}] [expr {$outputs_start-1}] late_fall_delay] 0 ] 0 ]

# Finding column number starting for input clock transition in INPUTS section only
set ip_ers_st_col [lindex [lindex [m1 search rect $clocks_start_column $inputs_start [expr {$n_columns_concsv-1}] [expr {$outputs_start-1}] early_rise_slew] 0 ] 0 ]
set ip_efs_st_col [lindex [lindex [m1 search rect $clocks_start_column $inputs_start [expr {$n_columns_concsv-1}] [expr {$outputs_start-1}] early_fall_slew] 0 ] 0 ]
set ip_lrs_st_col [lindex [lindex [m1 search rect $clocks_start_column $inputs_start [expr {$n_columns_concsv-1}] [expr {$outputs_start-1}] late_rise_slew] 0 ] 0 ]
set ip_lfs_st_col [lindex [lindex [m1 search rect $clocks_start_column $inputs_start [expr {$n_columns_concsv-1}] [expr {$outputs_start-1}] late_fall_slew] 0 ] 0 ]

# Finding column number starting for input related clock in INPUTS section only
set ip_rc_st_col [lindex [lindex [m1 search rect $clocks_start_column $inputs_start [expr {$n_columns_concsv-1}] [expr {$outputs_start-1}] clocks] 0 ] 0 ]

# Setting variables for actual input row start and end
set i [expr {$inputs_start+1}]
set end_of_inputs [expr {$outputs_start-1}]

puts "\nInfo-SDC: Working on input constraints.."
puts "\nInfo-SDC: Categorizing input ports as bits and busses"

# while loop to write constraint commands to .sdc file
while { $i < $end_of_inputs } {
# Checking if input is bussed or not
	set netlist [glob -dir $Netlist_Directory *.v]
	set tmp_file [open /tmp/1 w]
	foreach f $netlist {
		set fd [open $f]
		while { [gets $fd line] != -1 } {
			set pattern1 " [m1 get cell 0 $i];"
			if { [regexp -all -- $pattern1 $line] } {
				set pattern2 [lindex [split $line ";"] 0]
				if { [regexp -all {input} [lindex [split $pattern2 "\S+"] 0]] } {
					set s1 "[lindex [split $pattern2 "\S+"] 0] [lindex [split $pattern2 "\S+"] 1] [lindex [split $pattern2 "\S+"] 2]"
					puts -nonewline $tmp_file "\n[regsub -all {\s+} $s1 " "]"
				
				}
			}
		}
		close $fd
	}
	close $tmp_file
	set tmp_file [open /tmp/1 r]
	set tmp2_file [open /tmp/2 w]
	puts -nonewline $tmp2_file "[join [lsort -unique [split [read $tmp_file] \n]] \n]"
	close $tmp_file
	close $tmp2_file
	set tmp2_file [open /tmp/2 r]
	set count [llength [read $tmp2_file]]
	close $tmp2_file
	if {$count > 2} {
		set inp_ports [concat [m1 get cell 0 $i]*]
	} else {
		set inp_ports [m1 get cell 0 $i]
	}
		# set_input_transition SDC command to set input transition values
	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [m1 get cell $ip_rc_st_col $i]\] -min -rise -source_latency_included [m1 get cell $ip_ers_st_col $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [m1 get cell $ip_rc_st_col $i]\] -min -fall -source_latency_included [m1 get cell $ip_efs_st_col $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [m1 get cell $ip_rc_st_col $i]\] -max -rise -source_latency_included [m1 get cell $ip_lrs_st_col $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_transition -clock \[get_clocks [m1 get cell $ip_rc_st_col $i]\] -max -fall -source_latency_included [m1 get cell $ip_lfs_st_col $i] \[get_ports $inp_ports\]"
# set_input_delay SDC command to set input latency values
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [m1 get cell $ip_rc_st_col $i]\] -min -rise -source_latency_included [m1 get cell $ip_erd_st_col $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [m1 get cell $ip_rc_st_col $i]\] -min -fall -source_latency_included [m1 get cell $ip_efd_st_col $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [m1 get cell $ip_rc_st_col $i]\] -max -rise -source_latency_included [m1 get cell $ip_lrd_st_col $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\nset_input_delay -clock \[get_clocks [m1 get cell $ip_rc_st_col $i]\] -max -fall -source_latency_included [m1 get cell $ip_lfd_st_col $i] \[get_ports $inp_ports\]"
	set i [expr {$i+1}]

}
```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/160f3caf-d3a0-4dd6-8840-cecba8532b70)


*openMSP430.sdc*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/f7a8d3c2-f60d-4b4b-95d4-76249961d668)


/tmp/1 and /tmp/2 file screenshots for bit port

*/tmp/1*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/fc4a5897-69b5-4c9c-bea2-441568c48ac6)


*/tmp/2*

![Screenshot from 2023-08-29 15-47-30](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/8c27a27e-7693-4017-9f35-52e35ee59dde)


/tmp/1 and /tmp/2 file screenshots for bussed port

*/tmp/1*

![Screenshot from 2023-08-29 15-42-44](https://github.com/fayizferosh/yosys-tcl-ui-report/assets/63997454/e16d45ea-24ee-47c2-baf9-e90a35134bc6)

*/tmp/2*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/1e31a116-0ed2-4ab7-b198-0834887315dd)


## Day 4 - Complete Scripting and Yosys Synthesis Introduction (04/11/2023)

The activities for Day 4 included processing the output section and dumping the SDC file, checking the Yosys hierarchy, resolving errors, and doing a sample Yosys synthesis using example memory and explanation.

**Review of input file - openMSP430_design_constraints.csv**

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/baa4d034-475a-4cb2-b96f-40fdaea0aefc)


### Implementation

I've successfully finished the tasks assigned for Day 4: writing code to handle errors in hierarchy check, learning about sample memory synthesis and its memory write and read processes, processing constraints csv files for outputs, and dumping SDC commands to.sdc files with actual processed data.

#### Processing of the constraints .csv file for OUTPUTS and dumping SDC commands to .sdc

I've processed the csv file for the outputs data, separated the bit and bus outputs, then dumped the output-based SDC instructions into a.sdc file successfully. Below are images of the terminal with many "puts" spitting out the variables, user debug information, and output.sdc, along with the basic code for the same.

*Code*

```tcl
#################################################################################################
######################################## Day 4 ##################################################
#################################################################################################
#
#Output constraint
#

# Finding column number starting for output clock latency in OUTPUTS section only
set op_erd_st_col [lindex [lindex [m1 search rect $clocks_start_column $outputs_start [expr {$n_columns_concsv-1}] [expr {$n_rows_concsv-1}] early_rise_delay] 0 ] 0 ]
set op_efd_st_col [lindex [lindex [m1 search rect $clocks_start_column $outputs_start [expr {$n_columns_concsv-1}] [expr {$n_rows_concsv-1}] early_fall_delay] 0 ] 0 ]
set op_lrd_st_col [lindex [lindex [m1 search rect $clocks_start_column $outputs_start [expr {$n_columns_concsv-1}] [expr {$n_rows_concsv-1}] late_rise_delay] 0 ] 0 ]
set op_lfd_st_col [lindex [lindex [m1 search rect $clocks_start_column $outputs_start [expr {$n_columns_concsv-1}] [expr {$n_rows_concsv-1}] late_fall_delay] 0 ] 0 ]

# Finding column number starting for output related clock in OUTPUTS section only
set op_rc_st_col [lindex [lindex [m1 search rect $clocks_start_column $outputs_start [expr {$n_columns_concsv-1}] [expr {$n_rows_concsv-1}] clocks] 0 ] 0 ]

# Finding column number starting for output load in OUTPUTS section only
set op_load_st_col [lindex [lindex [m1 search rect $clocks_start_column $outputs_start [expr {$n_columns_concsv-1}] [expr {$n_rows_concsv-1}] load] 0 ] 0 ]

# Setting variables for actual input row start and end
set i [expr {$outputs_start+1}]
set end_of_outputs [expr {$n_rows_concsv-1}]

puts "\nInfo-SDC: Working on output constraints.."
puts "\nInfo-SDC: Categorizing output ports as bits and busses"

# while loop to write constraint commands to .sdc file
while { $i < $end_of_outputs } {
	# Checking if input is bussed or not
	set netlist [glob -dir $Netlist_Directory *.v]
	set tmp_file [open /tmp/1 w]
	foreach f $netlist {
		set fd [open $f]
		while { [gets $fd line] != -1 } {
			set pattern1 " [m1 get cell 0 $i];"
			if { [regexp -all -- $pattern1 $line] } {
				set pattern2 [lindex [split $line ";"] 0]
				if { [regexp -all {output} [lindex [split $pattern2 "\S+"] 0]] } {
					set s1 "[lindex [split $pattern2 "\S+"] 0] [lindex [split $pattern2 "\S+"] 1] [lindex [split $pattern2 "\S+"] 2]"
					puts -nonewline $tmp_file "\n[regsub -all {\s+} $s1 " "]"
				}
			}
		}
	close $fd
	}
	close $tmp_file
	set tmp_file [open /tmp/1 r]
	set tmp2_file [open /tmp/2 w]
	puts -nonewline $tmp2_file "[join [lsort -unique [split [read $tmp_file] \n]] \n]"
	close $tmp_file
	close $tmp2_file
	set tmp2_file [open /tmp/2 r]
	set count [llength [read $tmp2_file]]
	close $tmp2_file
	if {$count > 2} {
		set op_ports [concat [m1 get cell 0 $i]*]
	} else {
		set op_ports [m1 get cell 0 $i]
	}

	# set_output_delay SDC command to set output latency values
	puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [m1 get cell $op_rc_st_col $i]\] -min -rise -source_latency_included [m1 get cell $op_erd_st_col $i] \[get_ports $op_ports\]"
	puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [m1 get cell $op_rc_st_col $i]\] -min -fall -source_latency_included [m1 get cell $op_efd_st_col $i] \[get_ports $op_ports\]"
	puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [m1 get cell $op_rc_st_col $i]\] -max -rise -source_latency_included [m1 get cell $op_lrd_st_col $i] \[get_ports $op_ports\]"
	puts -nonewline $sdc_file "\nset_output_delay -clock \[get_clocks [m1 get cell $op_rc_st_col $i]\] -max -fall -source_latency_included [m1 get cell $op_lfd_st_col $i] \[get_ports $op_ports\]"

	# set_load SDC command to set load values
	puts -nonewline $sdc_file "\nset_load [m1 get cell $op_load_st_col $i] \[get_ports $op_ports\]"

	set i [expr {$i+1}]
}

close $sdc_file
puts "\nInfo-SDC: SDC created. Please use constraints in path $Output_Directory/$Design_Name.sdc"
```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/f9b55fc6-88b3-41cc-91d6-2481eb2e3109)



*openMSP430.sdc*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/d3498b58-6af0-460b-800f-673f7a5e2bf3)


/tmp/1 and /tmp/2 files similar to input ports

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/420ea3b0-af02-465a-b620-1969668f0cf0)
![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/3a496abe-b82c-42ae-b052-ef71cd183115)


#### Memory module yosys synthesis and explanation

The verilog code *memory.v* for a single-bit address and single-bit data memory unit is given below.

*Code*

```verilog
module memory (CLK, ADDR, DIN, DOUT);

parameter wordSize = 1;
parameter addressSize = 1;

input ADDR, CLK;
input [wordSize-1:0] DIN;
output reg [wordSize-1:0] DOUT;
reg [wordSize:0] mem [0:(1<<addressSize)-1];

always @(posedge CLK) begin
	mem[ADDR] <= DIN;
	DOUT <= mem[ADDR];
	end

endmodule
```

The basic Yosys script *memory.ys* to run this and obtain a gate-level netlist and 2D representation of the memory module in gate components is provided below.

*Script*

```tcl
# Reading the library
read_liberty -lib -ignore_miss_dir -setattr blackbox /home/kunalg/Desktop/work/openmsp430/openmsp430/osu018_stdcells.lib
# Reading the verilog
read_verilog verilog/memory.v
synth top memory
splitnets -ports -format ___
dfflibmap -liberty /home/kunalg/Desktop/work/openmsp430/openmsp430/osu018_stdcells.lib
opt
abc -liberty /home/kunalg/Desktop/work/openmsp430/openmsp430/osu018_stdcells.lib
flatten
clean -purge
opt
clean
# Writing the netlist
write_verilog memory_synth.v
# Representation of netlist with it's components
show
~     
```

The output view of netlist from the code is shown below.

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/bc471dc9-7abf-4bf7-98b0-6b9d0fcfec5e)


*Memory write process explained in following images using truth table*

Basic illustration of the write process

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/be50e508-dd21-4e4f-b884-ebbf5b738ebe)


Before first rising edge of the clock

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/5a17e6fc-ca77-43f6-87c0-9fb9aa82cc5e)


After first rising edge of the clock - write process done

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/0a241feb-b155-46e6-bf64-c7923542074c)


*Memory read process explained in following images using truth table*

Basic illustration of the read process

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/5bb227cd-e216-4b08-bec3-cfb3b8c58b99)


After first rising edge and before second rising edge of the clock

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/ed9602bd-ca76-431b-b446-0b9623030087)


After second rising edge of the clock - read process done

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/0ca4528d-c96c-4165-b173-2b6d0025423b)


#### Hierarchy check script dumping

I have successfully written the code for dumping the hierarchy check script. The basic code of the same and screenshots of the terminal with several "puts" printing out the variables and user debug information as well as output .hier.ys are shown below.

*Code*

```tcl
######################################## Day 4 part 2 #######################################
# Hierarchy Check
#############################################################################################
puts "\nInfo: Creating hierarchy check script to be used by Yosys"
set data "read_liberty -lib -ignore_miss_dir -setattr blackbox ${Late_Library_Path}"
set filename "$Design_Name.hier.ys"
set fileId [open $Output_Directory/$filename "w"]
puts -nonewline $fileId $data
set netlist [glob -dir $Netlist_Directory *.v]
foreach f $netlist {
	set data $f
	puts -nonewline $fileId "\nread_verilog $f"
	puts "\nInfo: Netlist being read for user debug: $f" 
}
puts -nonewline $fileId "\nhierarchy -check"
close $fileId


```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/b24d8c13-a241-4249-910e-6384823b58a4)

*openMSP430.hier.ys*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/7afcf456-19f3-4f74-85fe-049ed24b4b69)


#### Hierarchy Check Run & Error Handling

I have successfully written the code for hierarchy check error handling in case any error pops up during hierarchy check run in Yosys and *exits if hierarchy check fails*. The basic code of the same and screenshots of the terminal with several "puts" printing out the variables and user debug information are shown below.

*Code*

```tcl
# Hierarchy check error handling
# Hierarchy check error handling done to see any errors popping up in above script.
# Running hierarchy check in yosys by dumping log to log file and catching execution message
set error_flag [catch {exec yosys -s $Output_Directory/$Design_Name.hier.ys >& $Output_Directory/$Design_Name.hierarchy_check.log} msg]
puts "Errfor flag value for user debug: $error_flag"
if { $error_flag } {
	set filename "$Output_Directory/$Design_Name.hierarchy_check.log"
	# EDA tool specific hierarchy error search pattern
	set pattern {referenced in module}
	set count 0
	set fid [open $filename r]
	while { [gets $fid line] != -1 } {
		incr count [regexp -all -- $pattern $line]
		if { [regexp -all -- $pattern $line] } {
			puts "\nError: Module [lindex $line 2] is not part of design $Design_Name. Please correct RTL in the path '$Netlist_Directory'"
			puts "\nInfo: Hierarchy check FAIL"
		}
	}
	close $fid
	puts "\nInfo: Please find hierarchy check details in '[file normalize $Output_Directory/$Design_Name.hierarchy_check.log]' for more info. Exiting..."
	
} else {
	puts "\nInfo: Hierarchy check PASS"
	puts "\nInfo: Please find hierarchy check details in '[file normalize $Output_Directory/$Design_Name.hierarchy_check.log]' for more info"
}

```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/bd06b80d-8a87-487c-86bb-372e9159931a)


*openMSP430.hierarchy_check.log*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/346eb0bc-cc10-404b-8071-be43765c46f6)

*Change module name by adding _vsd to check error is coming or not.*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/6c93a313-443a-4c7f-879e-e996936173fc)


![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/c4400400-ab35-4341-b83a-0c1b02708914)

*openMSP430.hierarchy_check.log*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/c5666238-73ff-4af3-a94e-bf7079c4245c)



## Day 5 - Advanced Scripting Techniques and Quality of Results (QoR) Generation (27/08/2023)

The activities for day five include running Yosys' main synthesis, learning about and using procedures at the application level, creating commands, and writing the files needed for the OpenTimer tool, like .conf,.spef, and timing Create an OpenTimer script, launch an OpenTimer STA, and gather the information needed to create a QoR.final step is to print the gathered data in a tool-standard QoR output format using the results file that was created during the OpenTimer STA run.

### Implementation

I have successfully coded all the required elements to achieve Day 5 tasks, and all the details of the sub-tasks achieved are shown below.

#### Main Yosys synthesis script dumping

I have successfully written the code for the main Yosys synthesis script .ys file and dumped the script. The basic code of the same and screenshots of the terminal with several "puts" printing out the variables and user debug information are shown below.

*Code*

```tcl
##################################################################################################################################################
######################################################## Day 5 ###################################################################################
####################################################### Sub task 1 ###############################################################################
##################################################################################################################################################
# Main Synthesis Script for yosys
# ---------------------
puts "\nInfo: Creating main synthesis script to be used by Yosys"
set data "read_liberty -lib -ignore_miss_dir -setattr blackbox ${Late_Library_Path}"
set filename "$Design_Name.ys"
set fileId [open $Output_Directory/$filename "w"]
puts -nonewline $fileId $data
set netlist [glob -dir $Netlist_Directory *.v]
foreach f $netlist {
	puts -nonewline $fileId "\nread_verilog $f"
}
puts -nonewline $fileId "\nhierarchy -top $Design_Name"
puts -nonewline $fileId "\nsynth -top $Design_Name"
puts -nonewline $fileId "\nsplitnets -ports -format ___\ndfflibmap -liberty ${Late_Library_Path} \nopt"
puts -nonewline $fileId "\nabc -liberty ${Late_Library_Path}"
puts -nonewline $fileId "\nflatten"
puts -nonewline $fileId "\nclean -purge\niopadmap -outpad BUFX2 A:Y -bits\nopt\nclean"
puts -nonewline $fileId "\nwrite_verilog $Output_Directory/$Design_Name.synth.v"
close $fileId
puts "\nInfo: Synthesis script created and can be accessed from path $Output_Directory/$Design_Name.ys"

```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/92e9b582-ef79-4db0-af96-2de93c4bdcd2)


*openMSP430.ys*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/3c9a5541-913a-495a-88f4-32aebb38a688)


#### Running main synthesis script & error handling

I have successfully written the code for running the main Yosys synthesis script and exiting if errors are found. The basic code and screenshots of the terminal are shown below.

*Code*

```tcl
puts "\nInfo: Running synthesis......."
# Main synthesis error handling
# Running main synthesis in yosys by dumping logs to the log directory and catching execution message
if { [catch {exec yosys -s $Output_Directory/$Design_Name.ys >& $Output_Directory/$Design_Name.synthesis.log} msg] } {
	puts "\nError: Synthesis failed due to errors. Please refer to log $Output_Directory/$Design_Name.synthesis.log for errors. Exiting...."
	exit
} else {
	puts "\nInfo: Synthesis finished successfully"
}
puts "\nInfo: Please refer to log $Output_Directory/$Design_Name.synthesis.log"

```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/672babce-8bc3-40dd-aa12-18caaa73a2aa)


*openMSP430.synthesis.log*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/4cbbc0d3-6a88-4d55-b32a-72fbd5df2d95)

*openMSP430.synth.v*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/91034e4c-600c-4518-9408-1f5aa3887290)

*Error handling*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/2a93510f-4110-4057-ab0c-f4e759130474)

*Log file for error handling*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/de9aae64-7e37-4b00-84eb-2bdeedcfa5bb)


#### Editing .synth.v to be usable by OpenTimer

I have successfully written the code to edit the main synthesis output netlist .synth.v to make it usable for OpenTimer and other STA and PnR needs by replacing lines with "*" as a word and by removing "\" from any and all lines that have it. The basic code of the same and screenshots of the terminal with several "puts" printing out the variables and user debug information are shown below.

*Code*

```tcl
############################################## Editing .synth.v to be usable by Opentimer #######################################################

puts "\nInfo: Removing '*' and '\\' from netlist"
set fileId [open /tmp/1 "w"]
puts -nonewline $fileId [exec grep -v -w "*" $Output_Directory/$Design_Name.synth.v]
close $fileId
set output [open $Output_Directory/$Design_Name.final.synth.v "w"]
set filename "/tmp/1"
set fid [open $filename r]
while { [gets $fid line] != -1 } {
	puts -nonewline $output [string map {"\\" ""} $line]
	puts -nonewline $output "\n"
}
close $fid
close $output
puts "\nInfo: Please find the synthesized netlist for $Design_Name at below path. You can use this netlist for STA or PNR"
puts "\nPath: $Output_Directory/$Design_Name.final.synth.v"
```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/a9c0a733-3111-408b-8ee8-487f839a141f)


*openMSP430.synth.v*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/8f028452-f788-4a7c-ba2b-0784250d55dd)


*/tmp/1*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/e0a31938-408c-475b-9f9f-3138f28b2929)

*openMSP430.final.synth.v*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/9fcee46b-5004-41f0-9925-e17632b0944e)


#### World of Procs (TCL Procedure)

Procs can be used to create user-defined commands, as shown below. I have successfully written the code for all the procs. The basic codes of all the procs and screenshots of the terminal with several "puts" printing out the variables and user debug information for the 'set_multi_cpu_usage' and the 'read_sdc' procs are shown below.

##### reopenStdout.proc

This proc redirects the 'stdout' screen log to the file in the proc's argument.

*Code*

```tcl
#!/bin/tclsh
# proc to redirect screen log to file
proc reopenStdout {file} {
    close stdout
    open $file w       
}
```

##### set_multi_cpu_usage.proc

This proc outputs multiple threads of the CPU usage command required for the OpenTimer tool.

*Code*

```tcl
#!/bin/tclsh

proc set_multi_cpu_usage {args} {
        array set options {-localCpu <num_of_threads> -help "" }
        foreach {switch value} [array get options] {
       # puts "Option $switch is $value"
        }
        while {[llength $args]} {
       # puts "llength is [llength $args]"
       # puts "lindex 0 of \"$args\" is [lindex $args 0]"
                switch -glob -- [lindex $args 0] {
                -localCpu {
                           #puts "old args is $args"
                           set args [lassign $args - options(-localCpu)]
                           #puts "new args is \"$args\""
                           puts "set_num_threads $options(-localCpu)"
                          }
                -help {
                           #puts "old args is $args"
                           set args [lassign $args - options(-help) ]
                           #puts "new args is \"$args\""
                           puts "Usage: set_multi_cpu_usage -localCpu <num_of_threads> -help"
                           puts "\t-localCpu - To limit number of threads used"
                           puts "\t-help - To print details of proc"
                      }
                }
        }
}

#set_multi_cpu_usage -localCpu 5 -help
```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/b1ef0281-3b72-42cd-86fa-ba4f3f99691b)


##### read_lib.proc

This proc outputs commands to read early and late libraries required for the OpenTimer tool.

*Code*

```tcl
#!/bin/tclsh
proc read_lib args {
	# Setting command parameter options and its values
	array set options {-late <late_lib_path> -early <early_lib_path> -help ""}
	while {[llength $args]} {
		switch -glob -- [lindex $args 0] {
		-late {
			set args [lassign $args - options(-late) ]
			puts "set_late_celllib_fpath $options(-late)"
		      }
		-early {
			set args [lassign $args - options(-early) ]
			puts "set_early_celllib_fpath $options(-early)"
		       }
		-help {
			set args [lassign $args - options(-help) ]
			puts "Usage: read_lib -late <late_lib_path> -early <early_lib_path>"
			puts "-late <provide late library path>"
			puts "-early <provide early library path>"
			puts "-help - Provides user deatails on how to use the command"
		      }	
		default break
		}
	}
}
```

##### read_verilog.proc

This proc outputs commands to read the synthesised netlist required for the OpenTimer tool.

*Code*

```tcl
#!/bin/tclsh

# Proc to convert read_verilog to OpenTimer format
proc read_verilog {arg1} {
	puts "set_verilog_fpath $arg1"
}
```

##### read_sdc.proc

This proc outputs commands to read constraints .timing file required for the OpenTimer tool. This procs converts SDC file contents to .timing file format for use by the OpenTimer tool, and the conversion code is explained stage by stage with sufficient screenshots.

###### Converting 'create_clock' constraints

Initially, the proc takes the SDC file as an input argument or parameter and processes the 'create_clock' constraints part of SDC.

*Code*

```tcl
#!/bin/tclsh
proc read_sdc {arg1} {

# 'file dirname <>' to get directory path only from full path
set sdc_dirname [file dirname $arg1]
# 'file tail <>' to get last element
set sdc_filename [lindex [split [file tail $arg1] .] 0 ]
set sdc [open $arg1 r]
set tmp_file [open /tmp/1 w]

# Removing "[" & "]" from SDC for further processing the data with 'lindex'
# 'read <>' to read entire file
puts -nonewline $tmp_file [string map {"\[" "" "\]" " "} [read $sdc]]     
close $tmp_file

# Opening tmp file to write constraints converted from generated SDC
set timing_file [open /tmp/3 w]

# Converting create_clock constraints
# -----------------------------------
set tmp_file [open /tmp/1 r]
set lines [split [read $tmp_file] "\n"]
# 'lsearch -all -inline' to search list for pattern and retain elementas with pattern only
set find_clocks [lsearch -all -inline $lines "create_clock*"]
foreach elem $find_clocks {
	set clock_port_name [lindex $elem [expr {[lsearch $elem "get_ports"]+1}]]
	set clock_period [lindex $elem [expr {[lsearch $elem "-period"]+1}]]
	set duty_cycle [expr {100 - [expr {[lindex [lindex $elem [expr {[lsearch $elem "-waveform"]+1}]] 1]*100/$clock_period}]}]
	puts $timing_file "\nclock $clock_port_name $clock_period $duty_cycle"
}
close $tmp_file
```

*Screenshots*

*openMSP430.sdc*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/3a242e4d-cb59-4f72-af38-630b276966b4)


*/tmp/1*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/c7589b9c-a500-43f8-a7b9-d4a478d36fb0)



*/tmp/3*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/1764cb53-d0e5-49c1-9f83-a9ed20b1fd73)



###### Converting 'set_clock_latency' constraints

Processes 'set_clock_latency' constraints part of SDC.

*Code*

```tcl
# Converting set_clock_latency constraints
# ----------------------------------------
set find_keyword [lsearch -all -inline $lines "set_clock_latency*"]
set tmp2_file [open /tmp/2 w]
set new_port_name ""
foreach elem $find_keyword {
        set port_name [lindex $elem [expr {[lsearch $elem "get_clocks"]+1}]]
	if {![string match $new_port_name $port_name]} {
        	set new_port_name $port_name
        	set delays_list [lsearch -all -inline $find_keyword [join [list "*" " " $port_name " " "*"] ""]]
        	set delay_value ""
        	foreach new_elem $delays_list {
        		set port_index [lsearch $new_elem "get_clocks"]
        		lappend delay_value [lindex $new_elem [expr {$port_index-1}]]
        	}
		puts -nonewline $tmp2_file "\nat $port_name $delay_value"
	}
}

close $tmp2_file
set tmp2_file [open /tmp/2 r]
puts -nonewline $timing_file [read $tmp2_file]
close $tmp2_file
```

*Screenshots*

*/tmp/2*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/bf48ccc1-c88f-418d-8c5f-c0733d99a65a)



*/tmp/3*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/3194d29b-396a-455e-8326-c3402b41faf7)

###### Converting 'set_clock_transition' constraints

Processes 'set_clock_transition' constraints part of SDC.

*Code*

```tcl
# Converting set_clock_transition constraints
# -------------------------------------------
set find_keyword [lsearch -all -inline $lines "set_clock_transition*"]
set tmp2_file [open /tmp/2 w]
set new_port_name ""
foreach elem $find_keyword {
        set port_name [lindex $elem [expr {[lsearch $elem "get_clocks"]+1}]]
        if {![string match $new_port_name $port_name]} {
		set new_port_name $port_name
		set delays_list [lsearch -all -inline $find_keyword [join [list "*" " " $port_name " " "*"] ""]]
        	set delay_value ""
        	foreach new_elem $delays_list {
        		set port_index [lsearch $new_elem "get_clocks"]
        		lappend delay_value [lindex $new_elem [expr {$port_index-1}]]
        	}
        	puts -nonewline $tmp2_file "\nslew $port_name $delay_value"
	}
}

close $tmp2_file
set tmp2_file [open /tmp/2 r]
puts -nonewline $timing_file [read $tmp2_file]
close $tmp2_file
```

*Screenshots*

*/tmp/2*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/f79988e7-6d93-47b1-bfd6-5f3fd53fcd4c)


*/tmp/3*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/a1b77860-8270-4471-b2a3-2c15745ce35f)


###### Converting 'set_input_delay' constraints

Processes 'set_input_delay' constraints part of SDC.

*Code*

```tcl
# Converting set_input_delay constraints
# --------------------------------------
set find_keyword [lsearch -all -inline $lines "set_input_delay*"]
set tmp2_file [open /tmp/2 w]
set new_port_name ""
foreach elem $find_keyword {
        set port_name [lindex $elem [expr {[lsearch $elem "get_ports"]+1}]]
        if {![string match $new_port_name $port_name]} {
                set new_port_name $port_name
        	set delays_list [lsearch -all -inline $find_keyword [join [list "*" " " $port_name " " "*"] ""]]
		set delay_value ""
        	foreach new_elem $delays_list {
        		set port_index [lsearch $new_elem "get_ports"]
        		lappend delay_value [lindex $new_elem [expr {$port_index-1}]]
        	}
        	puts -nonewline $tmp2_file "\nat $port_name $delay_value"
	}
}
close $tmp2_file
set tmp2_file [open /tmp/2 r]
puts -nonewline $timing_file [read $tmp2_file]
close $tmp2_file
```

*Screenshots*

*/tmp/2*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/fc114f66-e050-4ae1-bcda-f3030c93db72)


*/tmp/3*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/ec6e8736-91c2-4dec-98b6-3fd7ac0861e5)

###### Converting 'set_input_transition' constraints

Processes 'set_input_transition' constraints part of SDC.

*Code*

```tcl
# Converting set_input_transition constraints
# -------------------------------------------
set find_keyword [lsearch -all -inline $lines "set_input_transition*"]
set tmp2_file [open /tmp/2 w]
set new_port_name ""
foreach elem $find_keyword {
        set port_name [lindex $elem [expr {[lsearch $elem "get_ports"]+1}]]
        if {![string match $new_port_name $port_name]} {
                set new_port_name $port_name
        	set delays_list [lsearch -all -inline $find_keyword [join [list "*" " " $port_name " " "*"] ""]]
        	set delay_value ""
        	foreach new_elem $delays_list {
        		set port_index [lsearch $new_elem "get_ports"]
        		lappend delay_value [lindex $new_elem [expr {$port_index-1}]]
        	}
        	puts -nonewline $tmp2_file "\nslew $port_name $delay_value"
	}
}

close $tmp2_file
set tmp2_file [open /tmp/2 r]
puts -nonewline $timing_file [read $tmp2_file]
close $tmp2_file
```

*Screenshots*

*/tmp/2*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/f836a956-ef06-499e-9d2a-118306801fb6)


*/tmp/3*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/ca085ba4-de55-4014-9e8b-90acd02d93f0)


###### Converting 'set_output_delay' constraints

Processes 'set_output_delay' constraints part of SDC.

*Code*

```tcl
# Converting set_output_delay constraints
# ---------------------------------------
set find_keyword [lsearch -all -inline $lines "set_output_delay*"]
set tmp2_file [open /tmp/2 w]
set new_port_name ""
foreach elem $find_keyword {
        set port_name [lindex $elem [expr {[lsearch $elem "get_ports"]+1}]]
        if {![string match $new_port_name $port_name]} {
                set new_port_name $port_name
        	set delays_list [lsearch -all -inline $find_keyword [join [list "*" " " $port_name " " "*"] ""]]
        	set delay_value ""
        	foreach new_elem $delays_list {
        		set port_index [lsearch $new_elem "get_ports"]
        		lappend delay_value [lindex $new_elem [expr {$port_index-1}]]
        	}
        	puts -nonewline $tmp2_file "\nrat $port_name $delay_value"
	}
}

close $tmp2_file
set tmp2_file [open /tmp/2 r]
puts -nonewline $timing_file [read $tmp2_file]
close $tmp2_file
```

*Screenshots*

*/tmp/2*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/884f248a-32ef-492f-a3ea-7d8763be136a)


*/tmp/3*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/17393f00-8ab6-419e-85cb-249622a783cd)


###### Converting 'set_load' constraints

Processes 'set_load' constraints part of SDC. And with that, all SDC constarints are processed, so we close the /tmp/3 file containing all processed data for now.

*Code*

```tcl
# Converting set_load constraints
# -------------------------------
set find_keyword [lsearch -all -inline $lines "set_load*"]
set tmp2_file [open /tmp/2 w]
set new_port_name ""
foreach elem $find_keyword {
        set port_name [lindex $elem [expr {[lsearch $elem "get_ports"]+1}]]
        if {![string match $new_port_name $port_name]} {
                set new_port_name $port_name
        	set delays_list [lsearch -all -inline $find_keyword [join [list "*" " " $port_name " " "*" ] ""]]
        	set delay_value ""
        	foreach new_elem $delays_list {
        	set port_index [lsearch $new_elem "get_ports"]
        	lappend delay_value [lindex $new_elem [expr {$port_index-1}]]
        	}
        	puts -nonewline $timing_file "\nload $port_name $delay_value"
	}
}
close $tmp2_file
set tmp2_file [open /tmp/2 r]
puts -nonewline $timing_file  [read $tmp2_file]
close $tmp2_file

# Closing tmp file after writing constraints converted from generated SDC
close $timing_file
```

*Screenshots*


*/tmp/3*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/6579b1df-32f0-4b20-bd35-297025c163ab)


###### Expanding the bussed input and output ports

The /tmp/3 file contains bussed ports as <port_name>*, which is expanded to each bit, and single-bit port lines are untouched. This new content is dumped to .timing file, and then the proc exits by giving output the OpenTimer command to access this .timing file.

*Code*

```tcl
# Expanding the bussed input and output ports to it's individual bits and writing final .timing file for OpenTimer
set ot_timing_file [open $sdc_dirname/$sdc_filename.timing w]
set timing_file [open /tmp/3 r]
while { [gets $timing_file line] != -1 } {
        if {[regexp -all -- {\*} $line]} {
                set bussed [lindex [lindex [split $line "*"] 0] 1]
                set final_synth_netlist [open $sdc_dirname/$sdc_filename.final.synth.v r]
                while { [gets $final_synth_netlist line2] != -1 } {
                        if {[regexp -all -- $bussed $line2] && [regexp -all -- {input} $line2] && ![string match "" $line]} {

                        	puts -nonewline $ot_timing_file "\n[lindex [lindex [split $line "*"] 0 ] 0 ] [lindex [lindex [split $line2 ";"] 0 ] 1 ] [lindex [split $line "*"] 1 ]"

                        } elseif {[regexp -all -- $bussed $line2] && [regexp -all -- {output} $line2] && ![string match "" $line]} {

                        	puts -nonewline $ot_timing_file "\n[lindex [lindex [split $line "*"] 0 ] 0 ] [lindex [lindex [split $line2 ";"] 0 ] 1 ] [lindex [split $line "*"] 1 ]"

                        }
                }
        } else {
        	puts -nonewline $ot_timing_file  "\n$line"
        }
}
close $timing_file
puts "set_timing_fpath $sdc_dirname/$sdc_filename.timing"

}
```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/0c8a4cd2-0d6e-48ca-ab08-64c3c3d2ffa3)


*/tmp/3*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/76606c63-c173-4b3b-8c3c-aaee54290edc)

*openMSP430.timing*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/c6a209eb-c3ba-4bcc-a07a-e0f6df4c68b6)


#### Using the procs to write .conf

I have successfully written the code to use these procs on an application level and create some portion of the .conf configuration file required for the OpenTimer tool. The basic code of the same and screenshots of terminal and .conf are shown below.

*Code*

```tcl
############################################# Calling procs needed to generate .timing file ###################################################
## Editing .synth.v to be usable by Opentimer
# ------------------------------------------
# Preparation of .conf for OpenTimer STA
# --------------------------------------
# Procs used below \/
puts "\nInfo: Timing Analysis Started...."
puts "\nInfo: Initializing number of threads, libraries, sdc, verilog netlist path..."
puts " Invoking required procs"
puts "reopenStdout.proc \nset_multi_cpu_usage,proc \nread_lib.proc \nread_verilog.proc \nread_sdc.prc"
source /home/vsduser/vsdsynth/procs/reopenStdout.proc
source /home/vsduser/vsdsynth/procs/set_multi_cpu_usage.proc
source /home/vsduser/vsdsynth/procs/read_lib.proc
source /home/vsduser/vsdsynth/procs/read_verilog.proc
source /home/vsduser/vsdsynth/procs/read_sdc.proc
# Writing command required for OpenTimer tool to .conf file by closing and redirecting 'stdout' to a file
reopenStdout $Output_Directory/$Design_Name.conf
set_multi_cpu_usage -localCpu 4
read_lib -early $Early_Library_Path
read_lib -late $Late_Library_Path
read_verilog $Output_Directory/$Design_Name.final.synth.v
read_sdc $Output_Directory/$Design_Name.sdc
# Reopening 'stdout' to bring back screen log
reopenStdout /dev/tty
# Closing .conf file opened by 'reopenStdout' proc
#close $Output_Directory/$Design_Name.conf
#puts "closed .conf and redirected to stdout"
```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/bcedffb1-c9ef-4484-b6d4-28aa9de0ad78)

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/051c9b4e-25ec-4f9a-8827-e5809a14a14d)

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/63a7496f-d602-4016-bf05-114dcf62fd92)


*openMSP430.conf*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/4ad13ac7-9af5-4506-a7a7-8d4aec65aac1)


#### Preparation of rest of .conf & .spef files for OpenTimer STA

I have successfully written the code to write .spef *with the current date and time in the spef code* and to append the rest of the portion of .conf file. The basic code of the same and screenshots of terminal, .conf and .spef are shown below.

*Code*

```tcl
################################################ SPEF and CONF creation #########################################################################

# Continue to write .conf and also write a .spef
# Writing .spef
set enable_prelayout_timing 1
if {$enable_prelayout_timing == 1} {
	puts "\nInfo: enable_prelayout_timing is $enable_prelayout_timing. Enabling zero-wire load parasitics"
	set spef_file [open $Output_Directory/$Design_Name.spef w]
	puts $spef_file "*SPEF \"IEEE 1481-1998\" "
	puts $spef_file "*DESIGN \"$Design_Name\" "
	puts $spef_file "*DATE \"[clock format [clock seconds] -format {%a %b %d %I:%M:%S %Y}]\" "
	puts $spef_file "*VENDOR \"TAU 2015 Contest\" "
	puts $spef_file "*PROGRAM \"Benchmark Parasitic Generator\" "
	puts $spef_file "*VERSION \"0.0\" "
	puts $spef_file "*DESIGN_FLOW \"NETLIST_TYPE_VERILOG\" "
	puts $spef_file "*DIVIDER / "
	puts $spef_file "*DELIMITER : "
	puts $spef_file "*BUS_DELIMITER \[ \] "
	puts $spef_file "*T_UNIT 1 PS "
	puts $spef_file "*C_UNIT 1 FF "
	puts $spef_file "*R_UNIT 1 KOHM "
	puts $spef_file "*L_UNIT 1 UH "
	close $spef_file
}

# Appending to .conf file
set conf_file [open $Output_Directory/$Design_Name.conf a]
puts $conf_file "set_spef_fpath $Output_Directory/$Design_Name.spef"
puts $conf_file "init_timer "
puts $conf_file "report_timer "
puts $conf_file "report_wns "
puts $conf_file "report_worst_paths -numPaths 10000 "
close $conf_file

```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/b1334d67-660a-43ae-b27e-ce9209c685cf)


*openMSP430.spef*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/c70532a4-85c0-42ea-bcdf-2275d51afacf)


*openMSP430.conf*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/8fc10454-7d04-4756-ab82-4d30cd882e59)


#### STA using OpenTimer

I have successfully written the code to run STA on OpenTimer and capture its runtime. The basic code of the same and screenshots of the terminal with several "puts" printing out the variables and user debug information are shown below.

*Code*

```tcl
################################# Starting Timing Analysis ##########################################################
#
#
# Running STA on OpenTimer and dumping log to .results and capturing runtime
set tcl_precision 3
set time_elapsed_in_us [time {exec /home/vsduser/OpenTimer-1.0.5/bin/OpenTimer < $Output_Directory/$Design_Name.conf >& $Output_Directory/$Design_Name.results}]
set time_elapsed_in_sec "[expr {[lindex $time_elapsed_in_us 0]/1000000}]sec"
puts "\nInfo: STA finished in $time_elapsed_in_sec seconds"
puts "\nInfo: Refer to $Output_Directory/$Design_Name.results for warnings and errors"
```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/c07c7094-7a60-4cf4-b542-53db64d5ca1a)


*openMSP430.results*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/753ad960-966d-49eb-9589-e6e2ab9b571f)

*Results*
![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/2a5e4df0-514c-4116-92f5-8c981dbe7e8a)


#### Data collection from .results file and other sources for QoR

I have successfully written the code to collect all required data for specific codes and *have also collected total .tcl script runtime*. The basic code of the same and screenshots of the terminal with several "puts" printing out the variables and user debug information are shown below.

*Code*

```tcl
#################################### RESULTS ########################################################################
#

# Find worst output violation
set worst_RAT_slack "-"
set report_file [open $Output_Directory/$Design_Name.results r]
set pattern {RAT}
while { [gets $report_file line] != -1 } {
	if {[regexp $pattern $line]} {
		set worst_RAT_slack "[expr {[lindex $line 3]/1000}]ns"
		break
	} else {
		continue
	}
}
close $report_file

# Find number of output violation
set report_file [open $Output_Directory/$Design_Name.results r]
set count 0
while { [gets $report_file line] != -1 } {
	incr count [regexp -all -- $pattern $line]
}
set Number_output_violations $count
close $report_file

# Find worst setup violation
set worst_negative_setup_slack "-"
set report_file [open $Output_Directory/$Design_Name.results r]
set pattern {Setup}
while { [gets $report_file line] != -1 } {
	if {[regexp $pattern $line]} {
		set worst_negative_setup_slack "[expr {[lindex $line 3]/1000}]ns"
		break
	} else {
		continue
	}
}
close $report_file

# Find number of setup violation
set report_file [open $Output_Directory/$Design_Name.results r]
set count 0
while { [gets $report_file line] != -1 } {
	incr count [regexp -all -- $pattern $line]
}
set Number_of_setup_violations $count
close $report_file

# Find worst hold violation
set worst_negative_hold_slack "-"
set report_file [open $Output_Directory/$Design_Name.results r]
set pattern {Hold}
while { [gets $report_file line] != -1 } {
	if {[regexp $pattern $line]} {
		set worst_negative_hold_slack "[expr {[lindex $line 3]/1000}]ns"
		break
	} else {
		continue
	}
}
close $report_file

# Find number of hold violation
set report_file [open $Output_Directory/$Design_Name.results r]
set count 0
while {[gets $report_file line] != -1} {
	incr count [regexp -all -- $pattern $line]
}
set Number_of_hold_violations $count
close $report_file

# Find number of instance
set pattern {Num of gates}
set report_file [open $Output_Directory/$Design_Name.results r]
while {[gets $report_file line] != -1} {
	if {[regexp -all -- $pattern $line]} {
		set Instance_count [lindex [join $line " "] 4 ]
		break
	} else {
		continue
	}
}
close $report_file

# Capturing end time of the script
set end_time [clock clicks -microseconds]

# Setting total script runtime to 'time_elapsed_in_sec' variable
set time_elapsed_in_sec "[expr {($end_time-$start_time)/1000000}]sec"
puts "\nInfo: Design Name = $Design_Name"
puts "\nInfo: Worst RAT slack = $worst_RAT_slack"
puts "\nInfo: Number of output violations = $Number_output_violations"
puts "\nInfo: Worst negative setup slack = $worst_negative_setup_slack"
puts "\nInfo: Number of setup violation = $Number_of_setup_violations"
puts "\nInfo: Worst Negative Hold Slack = $worst_negative_hold_slack"
puts "\nInfo: Number of Hold Violations = $Number_of_hold_violations"
puts "\nInfo: Number of Instances = $Instance_count"
puts "\nInfo: Time elapsed = $time_elapsed_in_sec"
```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/ee3793de-84e3-454d-b0e5-b545006415f3)


#### QoR (Quality of Results) Generation

I have successfully written the code for QoR generation. The basic code and screenshots of the terminal are shown below.

*Code*

```tcl
# Quality of Results (QoR) generation
puts "\n"
puts "                                                           ****PRELAYOUT TIMING RESULTS_SYNUI****\n"
set formatStr {%15s%14s%21s%16s%16s%15s%15s%15s%15s}
puts [format $formatStr "-----------" "-------" "--------------" "---------" "---------" "--------" "--------" "-------" "-------"]
puts [format $formatStr "Design Name" "Runtime" "Instance Count" "WNS Setup" "FEP Setup" "WNS Hold" "FEP Hold" "WNS RAT" "FEP RAT"]
puts [format $formatStr "-----------" "-------" "--------------" "---------" "---------" "--------" "--------" "-------" "-------"]
foreach design_name $Design_Name runtime $time_elapsed_in_sec instance_count $Instance_count wns_setup $worst_negative_setup_slack fep_setup $Number_of_setup_violations wns_hold $worst_negative_hold_slack fep_hold $Number_of_hold_violations wns_rat $worst_RAT_slack fep_rat $Number_output_violations {
	puts [format $formatStr $design_name $runtime $instance_count $wns_setup $fep_setup $wns_hold $fep_hold $wns_rat $fep_rat]
}
puts [format $formatStr "-----------" "-------" "--------------" "---------" "---------" "--------" "--------" "-------" "-------"]
puts "\n"

```

*Screenshots*

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/3b6545f6-0e5e-4f94-8be5-80b977ea1f0d)

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/ff039ac4-ce98-4f38-9abb-ab61b92a644e)

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/6f59d8b3-aa49-4d45-a0cd-2253783fbc4d)
![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/0563fa71-d9fc-4e0c-b034-fbfb976ab873)
![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/0f4493ad-1fdf-482e-99bb-2ae6ee9f8adf)

![image](https://github.com/Niharika-Kummithi/Synthesis_UI_using_TCL/assets/149615846/8d38ec9c-eeea-494c-9e0e-5e1f02dfb940)





