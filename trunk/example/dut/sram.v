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

//SRAM Dummy Module
module sram(clk,
            addr,
            data,
            we_n,
            cs_n
           );

//Decalaration
input clk;
input [31:0] addr;
input cs_n;
input we_n; //0 - Write
            //1 - Read

inout [31:0] data;
reg [31:0] data_out;

bit [31:0] mem [0:1024];

//Implementation of WRITE Block
always@(posedge clk) begin //latch the data on posedge of we_n
  if(we_n == 1'b0 & cs_n == 1'b0) begin 
    mem[addr] = data;
    $display("Write :: Addr: %0h Data :%0h",addr,data);
  end
end

//READ
always @(posedge clk) begin
  if(we_n == 1'b1 & cs_n == 1'b0) begin
    data_out = mem[addr];
  end
end

assign data = we_n ? 32'hz : data_out; 

endmodule
