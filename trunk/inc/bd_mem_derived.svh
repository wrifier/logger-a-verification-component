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

//----------------------------------------------------------------
// Title: Derived Class
//----------------------------------------------------------------

//----------------------------------------------------------------
// CLASS : bd_access
//
// This class is extended from abstract class <logger_bd_mem_access>.
// It include the implementation of back-door read/write access method.
class bd_access extends logger_bd_mem_access_pkg::logger_bd_mem_access;


  //----------------------------------------------------------------------------
  // Group: Virual Method Implementation 
  //----------------------------------------------------------------------------
  //
  // Function: bd_access_write 
  //
  // This is Implementation of pure virtual method prototype.
  // it will provide back-door write access to memory.
  // |
  // | bd_access_write(mem_addr,write_data);
  // |
  // <write_data> will be get written into <mem_addr> via back-door access to memory.
  // 
  // *Note : User need to provide Memory Hier. Path <MEM_INST> in top module.*
  function void bd_access_write (bit[(`ADDRESS_WIDTH-1):0] addr,bit [(`DATA_WIDTH-1):0] data);
    `MEM_INST.mem[addr[15:2]] = data;
    `uvm_info(get_type_name(),$psprintf("DBG : Write ADDR : %0h MEM_DATA : %0h",addr,`MEM_INST.mem[addr[15:2]]),UVM_HIGH)
    `uvm_info(get_type_name(),$psprintf("DBG : Write ADDR : %0h LOC_DATA : %0h",addr,data),UVM_HIGH)
  endfunction : bd_access_write

  
  //Function: bd_access_read
  // 
  // This is Implementation of pure virtual method prototype.it will provide back-door read access to memory.
  // |
  // | rd_data = bd_access_write(mem_addr);
  // |
  // it will return read data into <rd_data> from <mem_addr>.
  //
  // *Note : User need to provide Memory Hier. Path <MEM_INST> in top module.*
  function bit [(`DATA_WIDTH-1):0] bd_access_read (bit[(`ADDRESS_WIDTH-1):0] addr);
    bit [(`DATA_WIDTH-1):0] data;
    data = `MEM_INST.mem[addr[15:2]]; // Currently supported 32 bit memory only only
    `uvm_info(get_type_name(),$psprintf("DBG : READ ADDR : %0h READ_DATA : %0h",addr,data),UVM_HIGH)
    return data;    	
  endfunction : bd_access_read
  
endclass : bd_access

//set object of derived class from abstract class of backdoor memory access.
initial begin
  bd_access bd_access;
  bd_access = new();
  uvm_config_db#(uvm_object)::set(uvm_root::get(),"*","MEM_BD",bd_access);  
end

