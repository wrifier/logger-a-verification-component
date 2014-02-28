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
//-----------------------------------------------------------------

//------------------------------------------------------------------------------
// Title: Logger Base Class
//  
// This Section describe Logger Base Class and its Method used for Logger Block.
//------------------------------------------------------------------------------

`include "logger_define.svh"
//-----------------------------------------------------------------
// CLASS : logger_Base
// 
// This is Base class for logger which extended from <uvm_component>
// This class has implementaion of logger method.
//-----------------------------------------------------------------

class logger_base extends uvm_component;

  //Virtual logger interface.
  virtual logger_if logger_vif;

  //abstract class instance for back-door mem access
  logger_bd_mem_access_pkg::logger_bd_mem_access bd_access;
  uvm_object obj;

  // Declaration
  bit [(`ADDRESS_WIDTH -1):0] s_addr; // default state address
  bit [(`ADDRESS_WIDTH -1):0] d_addr;

  //----------------------------------------------------------------------------
  // Group: Class Constructor
  //----------------------------------------------------------------------------
  // Function: new
  //
  // Create the initializes an instance of this class using
  // normal constructor arguments for <uvm_component> : 
  //
  // ~name~   is the name of the instance
  //
  // ~parent~ is handle of the hierarchical parent, if any.
  //
  function new (string name, uvm_component parent);
    super.new(name,parent);	
  endfunction : new
  
  //----------------------------------------------------------------------------
  // Group: Phasing
  //----------------------------------------------------------------------------
  // Function: build_phase
  //
  // The <uvm_build_phase> phase implementation method.
  //
  // MEM_BD - String name for config DB method which get object of Derived class
  //
  // LOGGER_IF - String name for config DB method which get virtual interface handle.
  //
  function void build_phase(uvm_phase phase);
    // Get derived bd mem access class
    if(!(uvm_config_db#(uvm_object)::get(uvm_root::get(),"","MEM_BD",obj))) begin
      `uvm_fatal(get_type_name(),"Derived class of Back-door access is not set.")
    end

    // Check if Received derived class is compatable with parent abstract class.
    if(!$cast(bd_access,obj)) begin
      `uvm_fatal(get_type_name(),"Derived class of Back-door memory access is not compatable with abstract class")
    end

    // get the logger interface.
    if(!(uvm_config_db#(virtual logger_if)::get(uvm_root::get(),"","LOGGER_IF",logger_vif))) begin
      `uvm_fatal(get_type_name(),"Virtual Logger interface is not set.")		
    end
  endfunction : build_phase




  //----------------------------------------------------------------------------
  // Group: Base Class Library
  //----------------------------------------------------------------------------
  // Function: init
  //
  // This function initialize the logger block.
  // User need to pass the address <saddr> of Default Memory location which would be 
  // shared by C code and SV code.
  //
  //
  // *`ADDRESS_WIDTH* is by default 32, can be change by passing _+define+ADDRESS_WIDTH=<width>_ during compilation.
  //
  // *Arguments :*
  //
  //    saddr - Shared Memory address location for logger.
  //
  function init(bit [(`ADDRESS_WIDTH -1):0] saddr);		
    s_addr = saddr;         //
    d_addr = (saddr -'h4);  //
    bd_access.bd_access_write(s_addr,32'h0); // init to 0 when this task get called.
    bd_access.bd_access_write(d_addr,32'h0); // init to 0 when this task get called.      
    `uvm_info(get_type_name(),$psprintf("%0h Address is set as base_address for Logger Handshake",s_addr),UVM_LOW)
  endfunction: init




  // Function: wait_for_state
  //
  // This task waits for particular state which is set from C testcase. 
  // 
  //  *Arguments :*
  //
  //  id - ID which is passed during C macro
  //  | C Code - 
  //  |
  //  | UPDATE_LOGGER_BIT(1)
  //  |
  //  | sv Code -
  //  |
  //  | logger_inst.wait_for_state(1)
  //  | <print your message here.>
  // 
  // See more details in _example_
  task automatic wait_for_state(int s);
    bit[(`DATA_WIDTH-1):0] rd_data;

    //Throw fatal error if user try to access Reserve bit.
      if(s == 31) begin
        `uvm_fatal(get_type_name(),"Reserve bit 31 is tried to Access. This bit is reserved for Logger implementation")
      end

      while(rd_data[s] != 1'b1) begin
        rd_data = bd_access.bd_access_read(s_addr);
        @(logger_vif.cb); // wait for posedge of clk before accessing memory.
        `uvm_info(get_type_name(),$psprintf("DBG : Address :%0h Data :%h Bit position : %0b",s_addr,rd_data,s),UVM_HIGH)
      end
      `uvm_info(get_type_name(),$psprintf("Wait_for_state for bit %0h finished",s),UVM_HIGH)
  endtask : wait_for_state



  // Function: get_data_with_state
  //
  // This task wait for perticular state with user data at the output <ret_data>.
  // It is used to passed the user data with information from C world to SV world.
  // 
  // *Arguments :*
  //
  // id - ID which is passed during C macro
  // ret_data - Its a dynamic array which contains userdata which passed from C world macro UPDATE_LOGGER_DATA(id,....)
  //
  // | C World -
  // |       int data1,data2;
  // |       .
  // |       .
  // |       UPDATE_LOGGER_DATA(1,data1,data2);  
  // |
  // | SV world -
  // |
  // |     bit[(`DATA_WIDTH-1):0] data[];
  // |       .
  // |       .
  // |     logger_inst.get_data_with_state(1,data);
  // |     <print data[0] and data[1] here.>
  // 
  //  data[0] <- data1
  //
  //  data[1] <- data2
  task automatic get_data_with_state(input int s,output bit[(`DATA_WIDTH-1):0] ret_data[] );
    bit[(`DATA_WIDTH-1):0] rd_data;
    int j = 0;
    bit [(`ADDRESS_WIDTH -1):0] loc_addr;

    //support upto 4 arguments.
    ret_data = new[3] ;
    //Throw fatal error if user try to access Reserve bit.
    if(s == 31) begin
      `uvm_fatal(get_type_name(),"Reserve bit 31 is tried to Access. This bit is reserved for Logger implementation")
    end
    while(rd_data[s] != 1'b1) begin
      rd_data = bd_access.bd_access_read(s_addr);
      @(logger_vif.cb); // wait for posedge of clk before accessing memory.
      //`uvm_info(get_type_name(),$psprintf("DBG : Address :%0h Data :%h Bit position : %0b",s_addr,rd_data,s),UVM_LOW)
    end

    loc_addr = d_addr;

    for(int i=0 ; i < ret_data.size();i++) begin 
      ret_data[i] = bd_access.bd_access_read(loc_addr);
      `uvm_info(get_type_name(),$psprintf(" DBG : Address : %0h finished with Data : %0h",loc_addr,ret_data[i]),UVM_HIGH)
      //clear the data after read.
      bd_access.bd_access_write(loc_addr,32'h0);
      //Move to next reserved data address[Word aligned]
      loc_addr = (loc_addr - 'h4);
    end
    `uvm_info(get_type_name(),$psprintf("Wait_for_state for bit %0h finished with Data : %0h",s,ret_data[0]),UVM_HIGH)
  endtask 
    
  // Function: release_state
  //
  // This task is used to release the C executaion which is hold by user with LOGGER_HOLD_STATE() Macro in C world.
  // 
  // | 
  // | C world - 
  // |        .
  // |        .
  // |        LOGGER_HOLD_STATE();
  // |        statement0;
  // |
  // | SV World : 
  // |        .
  // |        .
  // |        logger_inst.release_state()
  //
  // after calling LOGGER_HOLD_STATE() macro in C world, C execution will be put on hold untill release_state() from SV world 
  // will call.
  task automatic release_state();
    bit [(`DATA_WIDTH-1):0] w_data ;
    bit [(`DATA_WIDTH-1):0] data ;
    bit [(`DATA_WIDTH-1):0] l_data ;
    bit [(`DATA_WIDTH-1):0] rd_data ;

    data = 1 << 31; //31st bit
    //Read modify write Logger base address contain.
    rd_data = bd_access.bd_access_read(s_addr); 
    l_data = (~data) & rd_data;
    w_data = data | l_data;

    bd_access.bd_access_write(s_addr,w_data);
    `uvm_info(get_type_name(),"Holding state State is released. C Testcase will resume Now",UVM_LOW)
  endtask : release_state

  // Function: readcheck
  //
  // This task is used to read and check the read value with expected value and print information
  // in SV world if read value and expected value are same else throw <UVM_ERROR> in SV world.
  // 
  // | C world - 
  // |         .
  // |         .
  // |         READCHECK(Base_Address, Offset_address, Expected data); //1st call <--|
  // |         READCHECK(Base_Address, Offset_address, Expected data); //2nd call  <-|---|
  // |         .                                                                     |   |
  // |         .                                                                     |   |
  // |                                                                               |   |
  // | SV world -                                                                    |   |
  // |         .                                                                     |   |
  // |         .                                                                     |   |
  // |         logger_inst.readcheck(); //1st call ----------------------------------|   |
  // |         logger_inst.readcheck(); //2nd call --------------------------------------|            
  // |         .
  // |         .
  // 
  // For each <READCHECK> macro call in C world needs <readcheck> method to be called.
  task automatic readcheck();        
    bit [(`DATA_WIDTH-1):0] ret_data1;
    bit [(`DATA_WIDTH-1):0] ret_data2;
    bit [(`DATA_WIDTH-1):0] rd_data ;
    bit [(`ADDRESS_WIDTH -1):0] loc_addr;
    bit [(`DATA_WIDTH-1):0] loc_data ;


   while(rd_data[30] != 1'b1) begin
     rd_data = bd_access.bd_access_read(s_addr);
     @(logger_vif.cb); // wait for posedge of clk before accessing memory.
   end

   ret_data1 = bd_access.bd_access_read(d_addr);   //Expected Data
   
   loc_addr = (d_addr - 'h4);
   ret_data2 = bd_access.bd_access_read(loc_addr); //On Address
   
   //Error or Okay response
   if (rd_data[29] == 1'b1) begin
     `uvm_error(get_type_name(),$psprintf("Data readout is incorrectly. Expected data=%0h Actual Data =%0h",ret_data1,ret_data2))
   end
   else begin
     `uvm_info(get_type_name(),$psprintf("Data readout correctly with Actual data=%0h from Address %0h",ret_data1,ret_data2),UVM_LOW)
   end

   // Clear the 30th & 29th using Read-modify-write.
   rd_data[30:29] = 2'b00;
   loc_data = rd_data;
   bd_access.bd_access_write(s_addr,loc_data);

   // Clear the data register
   bd_access.bd_access_write(d_addr,32'h0);
   bd_access.bd_access_write(loc_addr,32'h0);

   //Resume the C testcase.
   release_state();
 endtask : readcheck 

endclass

