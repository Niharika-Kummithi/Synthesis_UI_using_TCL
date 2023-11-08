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

puts "\nInfo: Running synthesis"
# Main synthesis error handling
# Running main synthesis in yosys by dumping logs to the log directory and catching execution message
if { [catch {exec yosys -s $Output_Directory/$Design_Name.ys >& $Output_Directory/$Design_Name.synthesis.log} msg] } {
	puts "\nError: Synthesis failed due to errors. Please refer to log $Output_Directory/$Design_Name.synthesis.log for errors. Exiting...."
	exit
} else {
	puts "\nInfo: Synthesis finished successfully"
}
puts "\nInfo: Please refer to log $Output_Directory/$Design_Name.synthesis.log"

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


################################# Starting Timing Analysis ##########################################################
#
#
# Running STA on OpenTimer and dumping log to .results and capturing runtime
set tcl_precision 3
set time_elapsed_in_us [time {exec /home/vsduser/OpenTimer-1.0.5/bin/OpenTimer < $Output_Directory/$Design_Name.conf >& $Output_Directory/$Design_Name.results}]
set time_elapsed_in_sec "[expr {[lindex $time_elapsed_in_us 0]/1000000}]sec"
puts "\nInfo: STA finished in $time_elapsed_in_sec seconds"
puts "\nInfo: Refer to $Output_Directory/$Design_Name.results for warnings and errors"


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
