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

//------------------------------------------------------------------------------
// Title: Interface 
//------------------------------------------------------------------------------

// About: logger_if
// This is logger interface which has Clock as input.
// User need to pass Sampling Clock from top module
//
// | logger_if logger_if(clk);
// cb is clocking block present in logger interface.

interface logger_if (input logic clk);
  //blank interface
  logic dummy;

  clocking cb @(posedge clk);
    input dummy;
  endclocking :cb 

endinterface : logger_if
