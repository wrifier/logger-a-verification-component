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
// Title: Back-door Access Package
// 
// This package provide abstract class definitions for making back-door accessing 
// to memory. 
//------------------------------------------------------------------------------

`include "logger_define.svh"
package logger_bd_mem_access_pkg;
  // CLASS : logger_bd_mem_access
  // 
  // This is abstract class definition for making backdoor accessto memory. 
  // This class provide definition of back-door read function.
  virtual class logger_bd_mem_access extends uvm_pkg::uvm_object;
    
    //----------------------------------------------------------------------------
    // Group: Class Constructor
    //----------------------------------------------------------------------------
    // Function: new
    //  
    // Create the initializes an instance of this class using
    // normal constructor arguments for <uvm_component> : 
    // ~name~ is the name of the instance.
    //
    function new(string name = "");
      super.new(name);
    endfunction : new
    
    //----------------------------------------------------------------------------
    // Group: Virtual Methods
    //----------------------------------------------------------------------------  
    // Prototype of Virtual Method.
    //
    // Function: bd_access_read
    // 
    // Virtual function definition for READ ACCESS TO MEMORY.
    // It will return <read data> from <addr>.Implementation of this function is present 
    // in <bd_mem_derived.svh>.
    pure virtual function bit [(`DATA_WIDTH-1):0] bd_access_read (bit[(`ADDRESS_WIDTH-1):0] addr);
    
    // Function: bd_access_write
    // Virtual function definition for writ ACCESS TO MEMORY.
    // It will write the <data> to <addr> passed with this function.Implementation of this function is present 
    // in <bd_mem_derived.svh>.    
    pure virtual function void bd_access_write (bit[(`ADDRESS_WIDTH-1):0] addr,bit [(`DATA_WIDTH-1):0] data);

  endclass : logger_bd_mem_access

endpackage :logger_bd_mem_access_pkg
