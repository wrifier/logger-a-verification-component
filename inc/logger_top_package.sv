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

`include "logger_if.sv"
`include "logger_bd_access_pkg.sv"
package logger_top_package;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "sv_macros.sv"
 
  `include "logger_base.sv"
endpackage 
