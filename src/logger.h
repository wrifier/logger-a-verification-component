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
#include <stdio.h>
#include <stdarg.h>

//------------------------------------------------------------------------------
// Title: C Macros
// 
// C Macros will get use in C world Env.
//------------------------------------------------------------------------------

#define LOGGER_DATA_ADDR      (LOGGER_ADDR - 0x4)  // User should change this define as per application.
#define LOGGER_SECOND_DATA_ADDR      (LOGGER_ADDR - 0x8)  // User should change this define as per application.

//Stucture for logger base address.
typedef union {
  struct {
    unsigned bit0_30 : 31;
    unsigned bit_31  : 1;
  } bf;
} logger_t;

// address for <logger_t> structure.
#define logger_t (*((volatile logger_t*) LOGGER_ADDR))

//Macro: LOGGER_UPDATE_BIT
//
// This macro used to set respective <message_id> in C testcase.
//|
//| LOGGER_UPDATE_BIT(1);
//|
#define LOGGER_UPDATE_BIT(bit) {  \
  int *addr = (int *) LOGGER_ADDR ; \
  *addr |= 1 << bit; \
}

// Macro: LOGGER_HOLD_STATE
//
// This macro can be used to Hold the C testcase execution until SV/UVM testcase release the hold state.
// 
//|
//| LOGGER_HOLD_STATE();
//|
// *Note : Resevered 31st Bit for holding state *
#define LOGGER_HOLD_STATE() {  \
  while (logger_t.bf.bit_31 != 1) { \
  }\
  logger_t.bf.bit_31 &= 0; \
}

#define HW_READ(BASE_ADDR, OFFSET) (*((int volatile *)(BASE_ADDR + OFFSET)))

#define LOGGER_READCHECK(error_okay,exp_data,data_addr) {  \
  int *addr = (int *) LOGGER_ADDR ; \
  int *ldata = (int *) LOGGER_DATA_ADDR; \
  int *hdata = (int *) LOGGER_SECOND_DATA_ADDR; \
  *ldata |= exp_data ; \
  *hdata |= data_addr ;\
  if (error_okay == 1) { \
    *addr |= 1 << 29; \
  } \
  *addr |= 1 << 30; \
  LOGGER_HOLD_STATE() ;\
}

// Macro: READCHECK
// This macro can be used to check the expected data from specific address.
// Also Can be used as C checker to confirm Write operation is happened or not to perticular address.
//
//|
//| READCHECK(BASE_ADDR,OFFSET,exp_data);
//|
#define READCHECK(BASE_ADDR,OFFSET,exp_data) { \
  int act_data ; \
  int data1 ; \
  int data2 ; \
  act_data = HW_READ(BASE_ADDR,OFFSET) ;\
  data1 = act_data;  \
  data2 = (BASE_ADDR+OFFSET) ;\
  if (act_data == exp_data) { \
    LOGGER_READCHECK(0,data1,data2); \
  } \
  else { \
    LOGGER_READCHECK(1,exp_data,data1); \
  }  \
}

void sendToLoggerV(int bit , va_list ap);
void sendToLogger(int bit ,...);

// Macro: LOGGER_UPDATE_DATA
// This macro having one fixed argument which is message id and rest are variable arguments. 
// This macro is used to pass different set of data to SV testcase.
// |
// | 1. LOGGER_UPDATE_DATA(1,data1,data2);
// | 2. LOGGER_UPDATE_DATA(1,data1,data2,data3);
// |
#define LOGGER_UPDATE_DATA(bit, ...) sendToLogger(bit, __VA_ARGS__, -1)

