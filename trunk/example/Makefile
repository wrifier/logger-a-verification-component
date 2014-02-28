# Copyright 2014 Vinay Jain, India
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-----------------------------------------------------------------
# Author : Vinay Jain
# Last Modification : 
# Email ID :  vinay.jain5@wipro.com
#
# Please report the bug with the subject line "Logger : Report Bug"
#----------------------------------------------------------------

MAKE = /usr/bin/make
COMPILE_ENV_LOG = $(ROOT_DIR)/logs/compile.log

vcs_opts  = -ntb_opts uvm-1.1
vcs_opts += -full64 -timescale=1ns/1ps 
vcs_opts += -sverilog
vcs_opts += +v2k -v2005

INCDIR = $(ROOT_DIR)
INCDIR += $(ROOT_DIR)/env
INCDIR += $(ROOT_DIR)/dut
INCDIR += $(VCS_HOME)/etc/uvm-1.1/src 
INCDIR += $(ROOT_DIR)/../inc 
INCDIR += $(ROOT_DIR)/../src

INC_DIR = $(foreach INCDIR, $(INCDIR), +incdir+$(INCDIR))
TEST = 


compile : 
	mkdir -p $(ROOT_DIR)/logs
	@eval "vcs -sverilog +v2k -debug_all -lca -l ${COMPILE_ENV_LOG} ${INC_DIR} ${vcs_opts} -top top_tb -f file.list -o simv.vcs"

sim :
	@eval ./simv.vcs +UVM_TESTNAME=${TEST} -l logs/simulation.log

run : compile sim

clean :
	@rm -rf *csrc DVEfiles *vcs* vc_hdrs.h ucli.key *.vpd logs/*.log
