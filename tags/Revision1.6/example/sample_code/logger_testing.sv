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
`define SRAM_ADDR 32'h2000FFEC

`define MSG_1	0
`define MSG_2	1
`define MSG_3	2
`define MSG_4	3
`define MSG_5	4
`define MSG_6	5
`define MSG_7	6
`define MSG_8	7
`define MSG_9	8
`define MSG_10	9
`define MSG_11	10
`define MSG_12	11
`define MSG_13	12
`define MSG_14	13
`define MSG_15	14
`define MSG_16	15
`define MSG_17	16
`define MSG_18	17
`define MSG_19	18
`define MSG_20	19
`define MSG_21	20
`define MSG_22	21
`define MSG_23	22
`define MSG_24	23
`define MSG_25	24
`define MSG_26	25
`define MSG_27	26
`define MSG_28	27
`define MSG_29	28
`define MSG_30	29

class logger_testing extends __base_test;
  `uvm_component_utils(logger_testing)

  logger_base logger;
  bit [31:0] rd_data [];

  function new (string name = "logger_testing", uvm_component parent);
   super.new(name,parent);
   logger = new ("logger",parent);
 endfunction : new

 function void build_phase (uvm_phase phase);
   super.build_phase(phase);
   logger.init(`SRAM_ADDR);
 endfunction : build_phase
  
 virtual task main_phase(uvm_phase phase);
   phase.raise_objection(this,"Start of Test");
   wait (test_done == 1'b1);
   phase.drop_objection(this,"End of Test");
 endtask

 virtual task run_phase(uvm_phase phase);
   
   logger.wait_for_state(`MSG_1);
   `uvm_info(get_type_name(),"SRAM Read/Write test...",UVM_LOW)
   
   logger.wait_for_state(`MSG_2);
   `uvm_info(get_type_name(),"Consecutive Write to SRAM0 ....",UVM_LOW)
   
   logger.get_data_with_state(`MSG_3,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM0 Adress : %h ",rd_data[0],rd_data[1]),UVM_LOW)
   
   logger.get_data_with_state(`MSG_4,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM0 Adress : %h ",rd_data[0],rd_data[1]),UVM_LOW)
   
   logger.get_data_with_state(`MSG_5,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM0 Adress : %h ",rd_data[0],rd_data[1]),UVM_LOW)
   
   logger.get_data_with_state(`MSG_6,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM0 Adress : %h ",rd_data[0],rd_data[1]),UVM_LOW)
   
   logger.get_data_with_state(`MSG_7,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM0 Adress : %h ",rd_data[0],rd_data[1]),UVM_LOW)

   logger.get_data_with_state(`MSG_8,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM0 Adress : %h ",rd_data[0],rd_data[1]),UVM_LOW)

   logger.get_data_with_state(`MSG_9,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM0 Adress : %h ",rd_data[0],rd_data[1]),UVM_LOW)
   
   logger.wait_for_state(`MSG_10);
   `uvm_info(get_type_name(),"Consecutive READ to SRAM0 ....",UVM_LOW)

   repeat (7) logger.readcheck();
   
   logger.wait_for_state(`MSG_11);
   `uvm_info(get_type_name(),"Consecutive WRITE to SRAM1 ....",UVM_LOW)
   
   logger.get_data_with_state(`MSG_12,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM1 Address : %h ",rd_data[0],rd_data[1]),UVM_LOW)

   logger.get_data_with_state(`MSG_13,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM1 Address : %h ",rd_data[0],rd_data[1]),UVM_LOW)
   
   logger.get_data_with_state(`MSG_14,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM1 Address : %h ",rd_data[0],rd_data[1]),UVM_LOW)

   logger.get_data_with_state(`MSG_15,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM1 Address : %h ",rd_data[0],rd_data[1]),UVM_LOW)

   logger.get_data_with_state(`MSG_16,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM1 Address : %h ",rd_data[0],rd_data[1]),UVM_LOW)

   logger.get_data_with_state(`MSG_17,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM1 Address : %h ",rd_data[0],rd_data[1]),UVM_LOW)

   logger.get_data_with_state(`MSG_18,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM1 Address : %h ",rd_data[0],rd_data[1]),UVM_LOW)

   logger.wait_for_state(`MSG_19);
   `uvm_info(get_type_name(),"Consecutive READ to SRAM1 ....",UVM_LOW)

   repeat (7) logger.readcheck();
   
   logger.wait_for_state(`MSG_20);
   `uvm_info(get_type_name(),"Consecutive Write to Consecutive locations of SRAM0 Data region ....",UVM_LOW)

   //Crossing range of 32. Re-initilization of logger.
   logger.init(`SRAM_ADDR);
   
   for(int i=0; i<15 ; i++) begin
     logger.get_data_with_state((`MSG_1+i),rd_data);
     `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM1 Address : %h ",rd_data[0],rd_data[1]),UVM_LOW)
   end
   
   logger.init(`SRAM_ADDR);

   logger.wait_for_state(`MSG_1);
   `uvm_info(get_type_name(),"Consecutive READ to Consecutive locations of SRAM0 Data region ....",UVM_LOW)
   
   repeat (15) logger.readcheck();

   logger.wait_for_state(`MSG_2);
   `uvm_info(get_type_name(),"Consecutive Write to Consecutive locations of SRAM1 Data region ....",UVM_LOW)
   
   logger.wait_for_state(`MSG_3);
   `uvm_info(get_type_name(),"Consecutive Read from Consecutive locations of SRAM1 Data region ....",UVM_LOW)
   
   repeat (15) logger.readcheck();

   logger.wait_for_state(`MSG_4);
   `uvm_info(get_type_name(),"32 bit Write to SRAM0 ....",UVM_LOW)

   logger.get_data_with_state(`MSG_5,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM1 Address : %h ",rd_data[0],rd_data[1]),UVM_LOW)
   logger.readcheck();
   
   logger.get_data_with_state(`MSG_6,rd_data);
   `uvm_info(get_type_name(),$psprintf("Writing Data %h to SRAM1 Address : %h ",rd_data[0],rd_data[1]),UVM_LOW)
   logger.readcheck();
   
   test_done = 1;
 endtask :run_phase

 endclass : logger_testing

