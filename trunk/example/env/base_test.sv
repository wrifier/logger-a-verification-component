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

class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  // Logger Specif Defines
  // This define can be different for each testcase
  `define LOGGER_HANDSHAKE_ADDR 32'h3FC
  `define LOGGER_DATA_ADDR      32'h3F8
  `define FIRST_MSG             1
  `define DATA_SEQ              2
  `define HANDSHAKE_WITH_DATA   3
  `define FINISH                4

  // Declaration
  logger_base logger;
  bit done;
  
  // Class Counstructor
  function new(string name ,uvm_component parent);
    super.new(name,parent);
    logger =  new("Logger",parent);
  endfunction : new

  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    logger.init(`LOGGER_HANDSHAKE_ADDR); // Initilization of logger block 
  endfunction : build_phase
  
  // Main Phase
  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this,"Start of main Phase");
    wait (done == 1'b1);
    phase.drop_objection(this,"Main Phase finished");          
  endtask : main_phase

  //Run Phase
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this,"Run phase started");
    #10;
    `uvm_info(get_type_name(),"Into Run Phase",UVM_LOW)
    
    // This is dummy process where we tried to show two treads i.e CM3 execution 
    // and SV testcase runs concurrently in Soc verification Env.
    fork 
      cm3_process();
      sv_process();
    join

    //End of main phase.
    done = 1;
    phase.drop_objection(this,"Run Phase finished");          
  endtask : run_phase

  // This is dummy cm3 task. In real application this task should be taken care
  // by Processor present in SoC.
  virtual task cm3_process();
    int data;

    //CASE:- 1
    //Basic User Info after Write/read/instruction execution has been prfomed.
    // In C code user should use LOGGER_UPDATE_BIT method to update logger bit.
    // Ex. LOGGER_UPDATE_BIT(1) OR LOGGER_UPDATE_BIT(<define>)
    #10; // some processor process is ongoing.
    data = 1  << `FIRST_MSG;
    logger.bd_access.bd_access_write(`LOGGER_HANDSHAKE_ADDR,data); //User-specific message can be write in SV testcase.         
    
    //CASE:- 2
    // SV testcase is waiting for C testcase handshake
    // before performing perticuar seq/read/write/
    #50; //another processor process is ongoing
    data = 1 << `DATA_SEQ;
    logger.bd_access.bd_access_write(`LOGGER_HANDSHAKE_ADDR,data); // Also can be used for handshake between C & SV test.      

    #50;
    //CASE:- 3
    // Case where C testcase would pass Data with handshake, on that specific data SV will take the call.
    // User can use LOGGER_UPDATE_DATA macro in C testcase.
    // Ex- LOGGER_UPDATE_DATA(<bit>,<data>,...)
    data = 1 << `HANDSHAKE_WITH_DATA;
    logger.bd_access.bd_access_write(`LOGGER_HANDSHAKE_ADDR,data); // Also can be used for handshake between C & SV test.      
    data = 32'hdeadbeef;
    logger.bd_access.bd_access_write(`LOGGER_DATA_ADDR,data); // Also can be used for handshake between C & SV test.   

    //Case:4 Processer will wait until SV perform Priority/sequence to proceed further.
    // i.e Block the next instruction till handshake received from SV Test.
    // In Real Soc Enviornment User needs to used in-build C macro to hold the state.LOGGER_HOLD_STATE();

    //FINISH the simulation.
    #50;
    data = 1 << `FINISH;
    logger.bd_access.bd_access_write(`LOGGER_HANDSHAKE_ADDR,data); // Also can be used for handshake between C & SV test. 
  endtask : cm3_process
  
  // This task in not neccessary in case you have different SV testcase for each 
  // C testcase.
  // This Logger Implemetation recommeded different SV testcases for each C testcase.
  virtual task automatic sv_process();
    int data;
    bit [31:0] rd_data [];

    //CASE:- 1
    //Basic User Info after Write/read/instruction execution has been perfomed.
    logger.wait_for_state(`FIRST_MSG); //User can use SV define for better readable code.
    `uvm_info(get_type_name(),$psprintf("First Write/read/instruction has been executed"),UVM_LOW)
    
    //CASE:- 2
    // SV testcase is waiting for C testcase handshake
    // before performing perticuar seq/read/write/
    `uvm_info(get_type_name(),$psprintf("Waiting for C testcase to Pass handshake to SV testcase"),UVM_LOW)
    logger.wait_for_state(`DATA_SEQ); //User can use SV define for better readable code.
    `uvm_info(get_type_name(),$psprintf("SV testcase got the access can be perform any perticular seq/operation"),UVM_LOW)

    //CASE:- 3
    // SV testcase will wait for handshake from C testcase and check what data has been passed by C testcase
    logger.get_data_with_state(`HANDSHAKE_WITH_DATA,rd_data); //User can use SV define for better readable code.
    `uvm_info(get_type_name(),$psprintf("Handshake Received from C testcase with Data : %0h",rd_data[0]),UVM_LOW)   
    
    //Case:4 Release the state so C testcase can resume
    //logger.release_state();  //Commented as this scenario will be more get clear in actual Env.

    logger.wait_for_state(`FINISH); //User can use SV define for better readable code.       
    `uvm_info(get_type_name(),$psprintf("C Simulation is completed."),UVM_LOW)
  endtask : sv_process
  
endclass : base_test
