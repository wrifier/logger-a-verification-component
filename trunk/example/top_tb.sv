// Copyright 2014 Vinay Jain, India
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//-----------------------------------------------------------------
// Author : Vinay Jain
// Last Modification : 
// Email ID :  vinay.jain5@wipro.com
//
// Please report the bug with the subject line "Logger : Report Bug"
//----------------------------------------------------------------

`include "common_define.svh"
`include "uvm_pkg.sv"
typedef virtual logger_if logger_vif ;

module top_tb();

import top_package::*;
import uvm_pkg::*;

//Define the Memory Instance Hierarchical path
`define MEM_INST top_dut.sram_ins
//Derived class implementation.
`include "bd_mem_derived.svh"

wire [31:0] addr;
wire [31:0] data;
wire we_n;
//Declaration
logic clk = 1'b0;

//Interface
logger_if logger_if_t(clk);

//clock generation.
always #10 clk = ~clk;

//DUT Instance
top_dut dut (.clk(clk),
             .addr(addr),
             .we_n(we_n),
             .cs_n(cs_n),
             .data(data)
            );

//Set Logger interface
initial begin 
  #0ns;
  uvm_config_db#(virtual logger_if )::set(uvm_root::get(),"*","LOGGER_IF",logger_if);  
  run_test("");
end

//dump waves
initial begin
  $vcdpluson();
  $timeformat(-9, 3, "ns", 10);  
end

endmodule : top_tb




