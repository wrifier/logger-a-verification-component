#!/usr/bin/perl
# -----------------------------------------------------------------------------
# Developed and maintain by Vinay Jain.				
# -----------------------------------------------------------------------------
# Please report the bug with the subject line "Logger : Report Bug"
# -----------------------------------------------------------------------------
# File name   : svv.pl
# Title       : SVV tool
# Project     : Logger
# Author      : Vinay jain
# Version     : $Revision: 1.3 $
# Description :
#  svv will take C source code as input and generate the system verilog testcase 
#  with same testcase name with sv extension at output. Also C code will get updated.
#
#  Please refer trunk/sample_example for more details about APIs to be used in 
#  C source code.
#
# Notes       : 
#  This tool was developed to generated SV-UVM testcases for logger purpose only.
# ------------------------------------------------------------------------------
use strict;
use Getopt::Long;

my $c_file;
my $sram_addr;
my $debug;
my $help;
my $base_test = 'uvm_test';

Getopt::Long::GetOptions(
			     'csrc|c=s'		=> \$c_file,
			     'sram_addr|s=s'	=> \$sram_addr,
			     'debug|d'		=> \$debug,
                             'base_test|b=s'    => \$base_test,
			     'help|h'		=> \$help
			   );
			   
			   
# ------------------------------------------------------------------------------
# Print help
# ------------------------------------------------------------------------------
if($help) {
	print_help();
	die;
	}

# ------------------------------------------------------------------------------
# Check for Logger Header in Source file. Terminate if not
# ------------------------------------------------------------------------------	

#Open the C source code in Read Mode.		     
open (C_FILE,"$c_file.c") or die "ERROR: Unable to open file $c_file.c for read!\n";
#Decalaration.
my @c_filea = <C_FILE>;
my $line;
my $header;

foreach $line(@c_filea) {
	if ($line =~ /logger_macro.h/) {
		$header = 1;
		print $line if($debug == 1);
	}
}

if(!$header) {
	die ("logger_macro.h is missing. Please include it and re-run");
}	
	
# ------------------------------------------------------------------------------
# File Handling
# ------------------------------------------------------------------------------	

#Open Dummy File to Create the copy of C Source code.
open (C_FILE1,">$c_file.cv") or die "ERROR: Unable to open file $c_file.c for write!\n";
#Open the SV testcase file in Write mode.
open (SV_FILE,">$c_file.sv") or die "ERROR: Unable to open file $c_file.sv for write!\n";

#Decalaration.
my $start;
my @argument;
my @uvm_info;
my @id_q;

foreach $line(@c_filea) {
	if ($line =~ /logger_macro.h/) {
		$header = 1;
		print $line if($debug == 1);
	}
}

if(!$header) {
	die ("logger_macro.h is missing. Please include it and re-run");
	}


# ------------------------------------------------------------------------------
# Parse the each line of C source code.
# ------------------------------------------------------------------------------
foreach $line(@c_filea) {
	#Find start of main in source code.
	if ($line =~ /main/) {
		print "Found Main. Proceding for parsing the code..\n" if($debug == 1);
		$start = 1;	
	}
	#Find end of main
	if ($line =~ /End of Main/) {
		$start = 0;
	}
	#Start parsing the code if you entered in main
	if($start == 1) {
		#Check for LOG_INFO Macro
		if($line =~/LOG_INFO/ ) {
			my ($all_args) = $line =~ /\((.+?)\)/;
			print "Found LOG_INFO Macro. Argumes to Macro are $all_args\n" if($debug == 1);
			#Split it by coma.
			@argument = split(',',$all_args);
			if($debug == 1) {
				print "$_ \n" for (@argument);
			}
			#Create the Syntax for SV.
			my $cmd = "`log_info\(`$argument[0],\$psprintf($argument[1]),$argument[2])";
			push @uvm_info,$cmd;
                        push @id_q,$argument[0];                        
		}
		#Check for LOG_DINFO Macro		
		if($line =~/LOG_DINFO/ ) {
			#Get the all the arguments of macro.
			my ($all_args) = $line =~ /\((.+)\)/;
			#Seprate out the Variable argument of data.
			my ($sub_args) = $all_args =~ /\((.+?)\)/;
			#Get the size of argument for calculation.
			my $size = @argument;
			#Debug Messages.
			print "all args : $all_args\n" if($debug == 1);
			print "sub all args : $sub_args\n" if($debug == 1);
			#Split it by coma
			my @sub_args = split(',',$sub_args);
			#Get the size for further calculation.
			my $s_size = @sub_args;
			#Veriable Decalaration.
			my $i;
			my $j=0;
			my $rd_cmd;
			#Create the Command with rd_data array(sv)
			for($i=$s_size-1 ; $i>0; $i--) {
				 $rd_cmd .= ",rd_data[$j]";
				 print "for $rd_cmd \n" if($debug == 1);
				 $j++;
				}
			#Final Argument.
			my $sub_argument = "$sub_args[0]$rd_cmd";
			print "size $s_size sub arg $sub_argument \n" if($debug == 1);
			#Split by coma
			@argument = split(',',$all_args);			
			if($debug == 1) {
				print "$_ \n" for (@argument);
			}
			#Get the size for further calculation.
			my $size = @argument;
			#Final Sv Command
			my $cmd = "`log_dinfo\(`$argument[0],\$psprintf($sub_argument),$argument[$size-1])";
			#Push each cmd into array
			push @uvm_info,$cmd;			
                        push @id_q,$argument[0];                        
		}
                if($line =~/READCHECK/ ) {
			#Create the Syntax for SV.
			my $cmd = "logger.readcheck();\n";
			#Push whole SV cmd into queue
			push @uvm_info,$cmd;			
		}
	}
}

# ------------------------------------------------------------------------------
# Rewrite the C file with Actual macro. And also keep user macro for 
# future reference.
# ------------------------------------------------------------------------------
my $cstop = 1;
my $idx = 0;
my $id;
my $idp = 1;
foreach $line (@c_filea) {
	
        #Check if ID are already defined or not
        foreach $id(@id_q) {
          if ($line =~ /define $id/) {
            $line = '';
          }
        }
      	#Find header file and define the ID in C code.
	if ($line =~ /logger_macro.h/) {
		foreach $id(@id_q) {
                  if($idx > 28) {
                    print STDOUT "[WARNING :: Messges are exceeding the limit.]"
                  }
                  else {
                    print C_FILE1 "#define $id $idx\n";
                    $idx = $idx+1
                  }
                }
	}

	#Find end of main
	if ($line =~ /End of Main/) {
		$cstop = 0;
	}
	#Check for LOG_INFO Macro
	if($line =~/LOG_INFO/ and $cstop == 1) {
		my ($all_args) = $line =~ /\((.+?)\)/;
		print "all args : $all_args\n" if($debug == 1);
		@argument = split(',',$all_args);
		if($debug == 1) {
			print "$_ \n" for (@argument);
			}
		my $cmd = "  LOGGER_UPDATE_BIT($argument[0]);\n";
		if($line =~ /\/\//) {
			print C_FILE1 $line;
		}
		else {
			print C_FILE1 "\/\/$line \n";
			print C_FILE1 $cmd;
		}
	}
	#Check for LOG_DINFO Macro		
	elsif($line =~/LOG_DINFO/ and $cstop == 1) {
		#Get the all the arguments of macro.
		my ($all_args) = $line =~ /\((.+)\)/;
		#Seprate out the Variable argument of data.
		my ($sub_args) = $all_args =~ /\((.+?)\)/;
		my @argument = split(',',$all_args);	
		#Get the size of argument for calculation.
		my $size = @argument;
		#Debug Messages.
		print "all args : $all_args\n" if($debug == 1);
		print "sub all args : $sub_args\n" if($debug == 1);
		#Split it by coma
		my @sub_args = split(',',$sub_args);
		#Get the size for further calculation.
		my $s_size = @sub_args;
		#Veriable Decalaration.
		my $i;
		my $rd_cmd;
		#Create the Command with rd_data array(sv)
		for($i=1 ; $i<$s_size; $i++) {
			 $rd_cmd .= ",$sub_args[$i]";
			 print "for $rd_cmd \n" if($debug == 1);
		}
		my $cmd = "  LOGGER_UPDATE_DATA($argument[0]$rd_cmd);";
		if($line =~ /\/\//) {
			print C_FILE1 $line;
		}
		else {
			print C_FILE1 "\/\/$line \n";
			print C_FILE1 "$cmd \n";
		}		
	}
	else {
		print C_FILE1 "$line";
	}
}

# ------------------------------------------------------------------------------
# Close Both C file to perform File operation.
# And Delete Source file and Replace it with New C src file.
# ------------------------------------------------------------------------------
close C_FILE;
close C_FILE1;
print "Deleting $c_file.c \n" if($debug == 1);
unlink "$c_file.c" or die "could not unlink the file";
rename  "$c_file.cv","$c_file.c";

# ------------------------------------------------------------------------------
# Start Writing into SV testcase.
# ------------------------------------------------------------------------------
my $idx = 0;
select SV_FILE;

#Logger SRAM Define 
print "\`define SRAM_ADDR 32\'h$sram_addr \n \n";

foreach $id(@id_q) {
  if($idx > 28) {
    print STDOUT "[WARNING :: Messges are exceeding the limit.] $idx \n";
  }
  else {
    print "`define $id $idx\n";
    $idx = $idx+1
  }
}

#Class Defination
print "class $c_file extends $base_test\; \n";
#Register to UVM registry
print "  `uvm_component_utils\($c_file\) \n";
print "\n";
#Veriable declarations.
print "  \/\/Declaration \n";
print "  logger_base logger;\n";
print "  bit [31:0] rd_data []; \n"; 
print "  bit test_done ;\n";
print "\n";
 
#Class constructor
print "  \/\/Class Constructor \n";
print "  function new \(string name \= \"$c_file\"\, uvm_component parent\)\; \n";
print "    super\.new\(name,parent\)\;\n";
print "    logger = new(\"logger\",parent);\n";
print "  endfunction \: new\n";
print "\n\n";

#Build Phase
print "  \/\/Build Phase \n";
print "  function void build_phase (uvm_phase phase); \n";
print "    super\.build_phase(phase);\n";
print "    logger\.init\(\`SRAM_ADDR)\;\n";
print "  endfunction \: build_phase\n";
print "\n\n";

#Main Phase
print "  \/\/Main Phase \n";
print "  virtual task main_phase(uvm_phase phase);\n";
print "     phase.raise_objection(this,\"Start of Test\");\n";
print "     wait (test_done == 1'b1);\n";
print "     phase.drop_objection(this,\"End of Test\");\n";
print "  endtask : main_phase \n";
print "\n\n";

#Run Phase
print "  \/\/Run Phase \n";
print "  virtual task run_phase(uvm_phase phase);\n";
print "    \/\/Logger APIs \n    $_ \n " for (@uvm_info);
print "\n";
print "    test_done = 1;\n";
print " endtask : run_phase \n";
print "\n\n";

#endclass
print "endclass : $c_file";

print STDOUT "System Verilog file Created...\n";

# ------------------------------------------------------------------------------
# Help Sub-routine
# ------------------------------------------------------------------------------
sub print_help {
	print <<EOM;
	
Usage : 
	ssv [-c/csrc <c source file>] [s/sram_addr<logger base address>] [d/debug <1/0>]
	
	-c/csrc 		Input C source code file
	
	-s/sram_addr		Logger base SRAM address which will be same through the application.
	
        -b/base_test		Base testcase name from which SV testcase suppose to be extend.By Default 
                                it will extend from uvm_test.
	
	-d/debug		To enable Debug Mode.
	
EOM
	
}
