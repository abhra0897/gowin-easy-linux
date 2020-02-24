# Copyright (C) 1994-2016 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.
# Define HTML links for srr reports
#
# usage: define_report_link  -id <tagid> -title <link title> -name <tag name> -level -- define HTML link for srr reports
#

define_report_link -id "Start of Compile"				-title "Compiler Report" -name "compilerReport" -level 0;
# Get above line for all the compiler run
#define_report_link -id "Synopsys HDL Compiler"			-title "Compiler Report" -name "compilerReport" -level 0;

define_report_link -id "Synopsys Pre-mapping Report"	-title "Pre-mapping Report" -name "mapperReport" -level 0;
define_report_link -id "Clock Summary"					-title "Clock Summary" -name "mapperReport" -level 1;

define_report_link -id "Synopsys Mapping Report"		-title "Mapper Report" -name "mapperReport" -level 0;

define_report_link -id "Synopsys Altera Technology Pre-mapping" -title "Pre-mapping Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Altera Technology Constraint Extraction" -title "Property Extraction" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Altera Technology"		-title "Mapper Report" -name "mapperReport" -level 0;

define_report_link -id "Synopsys Xilinx Technology Pre-mapping" -title "Pre-mapping Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Xilinx Technology Constraint Extraction" -title "Property Extraction" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Xilinx Technology"		-title "Mapper Report" -name "mapperReport" -level 0;

define_report_link -id "Synopsys Generic Technology Pre-mapping" -title "Pre-mapping Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Generic Technology"	-title "Mapper Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys CPLD Technology"		-title "Mapper Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Atmel FPGA Technology"	-title "Mapper Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys QuickLogic Technology"	-title "Mapper Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Actel Technology Pre-mapping" -title "Pre-mapping Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Actel Technology"		-title "Mapper Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Microsemi Technology Pre-mapping" -title "Pre-mapping Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Microsemi Technology"	-title "Mapper Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Proasic Technology"	-title "Mapper Report" -name "mapperReport" -level 0;

define_report_link -id "Synopsys Achronix Technology Pre-mapping" -title "Pre-mapping Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Achronix Technology"   -title "Mapper Report" -name "mapperReport" -level 0;

define_report_link -id "Synopsys Lattice Technology Pre-mapping"        -title "Pre-mapping Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Lattice Technology Mapper"	            -title "Mapper Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Lattice ORCA FPGA Technology Mapper"	-title "Mapper Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys Lattice FPGA Technology Mapper"	    -title "Mapper Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys SiliconBlue Technology Pre-mapping"    -title "Pre-mapping Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys SiliconBlue Technology Mapper"         -title "Mapper Report" -name "mapperReport" -level 0;
define_report_link -id "Synopsys SiliconBlue Technology"                -title "Mapper Report" -name "mapperReport" -level 0;

define_report_link -id "Summary of Compile Points :" -title "Compile Point Summary" -name "MapperReport" -level 1;

define_report_link -id "START OF CLOCK OPTIMIZATION REPORT"				-title "Clock Conversion" -name "clockReport" -level 0;
define_report_link -id "START OF TIMING REPORT"			-title "Timing Report" -name "timingReport" -level 0;
define_report_link -id "Performance Summary"		    -title "Performance Summary" -name "performanceSummary" -level 1;
define_report_link -id "Clock Relationships"		    -title "Clock Relationships" -name "clockRelationships" -level 1;
define_report_link -id "Interface Information"		    -title "Interface Information" -name "interfaceInfo" -level 1;
define_report_link -id "Input Ports:"			        -title "Input Ports" -name "inputPorts" -level 2;
define_report_link -id "Output Ports:"			        -title "Output Ports" -name "outputPorts" -level 2;
define_report_link -id "Detailed Report"			    -title "" -name "clockReport" -level 1;
define_report_link -id "Starting Points"		        -title "Starting Points with Worst Slack" -name "startingSlack" -level 2;
define_report_link -id "Ending Points"			        -title "Ending Points with Worst Slack" -name "endingSlack" -level 2;
define_report_link -id "Worst Path Information"			-title "Worst Path Information" -name worstPaths -level 2 -xprobelink "View Worst Path in Analyst";
define_report_link -id "Resource Usage"					-title "Resource Utilization" -name "resourceUsage" -level 0;
define_report_link -id "START OF AREA REPORT"			-title "Resource Utilization" -name "areaReport" -level 0;
define_report_link -id "Report for cell"				-title "Resource Utilization" -name "cellreport" -level 0;
define_report_link -id "@E:"							-title "Error in report!" -name "error" -level 1;
define_report_link -id "@E|"							-title "Error in report!" -name "error" -level 1;



define_report_file_link -par_only -title "Backannotation Report" <log>.srr 
define_report_file_link -title "Island Timing Report" <log>.tah 
define_report_file_link -title "Hierarchical Area Report (<view>)" rpt_*.areasrr 
define_report_file_link -title "Quartus Flow Report" <log>.flow.rpt 
define_report_file_link -title "Quartus Fit Report" <log>.fit.rpt 
define_report_file_link -title "Quartus Map Report" <log>.map.rpt 
define_report_file_link -title "Quartus Timing Report" <log>.tan.rpt 
define_report_file_link -title "Quartus Timing Report" <log>.sta.rpt 
define_report_file_link -title "Xilinx P&R Report" xflow_par.log 
define_report_file_link -title "Xilinx P&R Report" xflow.log 
define_report_file_link -title "Xilinx P&R Report" vivado.log 
define_report_file_link -title "Initial Placement Report" xflow_gp.log
define_report_file_link -title "Constraint Checker Report" <log>.cck
define_report_file_link -title "Congestion Estimate Report" <log>_congestion_est.rpt
define_report_file_link -par_only -title "Quartus P&R Report" quartus.log 
define_report_file_link -par_only -title "Xilinx Timing Report" <log>.twr
define_report_file_link -par_only -title "SBT P&R Report" sbt_par.log
