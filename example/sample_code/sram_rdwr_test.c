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
#include <string.h>
#include <stdio.h>
#include "logger_macro.h"

#define MSG_1	0
#define MSG_2	1
#define MSG_3	2
#define MSG_4	3
#define MSG_5	4
#define MSG_6	5
#define MSG_7	6
#define MSG_8	7
#define MSG_9	8
#define MSG_10	9
#define MSG_11	10
#define MSG_12	11
#define MSG_13	12
#define MSG_14	13
#define MSG_15	14
#define MSG_16	15
#define MSG_17	16
#define MSG_18	17
#define MSG_19	18
#define MSG_20	19
#define MSG_21	20
#define MSG_22	21
#define MSG_23	22
#define MSG_24	23
#define MSG_25	24
#define MSG_26	25
#define MSG_27	26
#define MSG_28	27
#define MSG_29	28
#define MSG_30	29

#define DATA1 0x00000000
#define DATA2 0xA5A5
#define DATA3 0x0F
#define DATA4 0x55555555
#define DATA5 0xAAAAAAAA
#define DATA6 0x5A5A
#define DATA7 0xF0
#define DATA8 0xAA


int main(void)
{
//Configure 
  uint32_t ReadValue;
  uint32_t i,j;
  uint32_t offset;
  uint32_t data;
  uint32_t data_1;
  uint32_t data_array[14];
  unsigned int offset1;
  unsigned int offset2;
  int msg_id;
  int l_data;

  LOGGER_UPDATE_BIT(MSG_1);
  //Consecutive Write and Read to SRAM0
  LOGGER_UPDATE_BIT(MSG_2);

  LOGGER_UPDATE_DATA(MSG_3,DATA1,(SRAM0_SYSTEM_BASE_ADDR4+OFFSET1));
  HW_set_uint32(SRAM0_SYSTEM_BASE_ADDR4,OFFSET1,DATA1);
  
  
  LOGGER_UPDATE_DATA(MSG_4,DATA2,(SRAM0_SYSTEM_BASE_ADDR5+OFFSET2));
  HW_set_uint32(SRAM0_SYSTEM_BASE_ADDR5,OFFSET2,DATA2);

  LOGGER_UPDATE_DATA(MSG_5,DATA3,(SRAM0_SYSTEM_BASE_ADDR6+OFFSET1));
  HW_set_uint8(SRAM0_SYSTEM_BASE_ADDR6,OFFSET1,DATA3);

  LOGGER_UPDATE_DATA(MSG_6,DATA4,(SRAM0_SYSTEM_BASE_ADDR6+OFFSET3));
  HW_set_uint32(SRAM0_SYSTEM_BASE_ADDR6,OFFSET3,DATA4);

  LOGGER_UPDATE_DATA(MSG_7,DATA5,(SRAM0_SYSTEM_BASE_ADDR7+OFFSET3));
  HW_set_uint32(SRAM0_SYSTEM_BASE_ADDR7,OFFSET3,DATA5);

  LOGGER_UPDATE_DATA(MSG_8,DATA6,(SRAM0_SYSTEM_BASE_ADDR7+OFFSET4));
  HW_set_uint16(SRAM0_SYSTEM_BASE_ADDR7,OFFSET4,DATA6);

  LOGGER_UPDATE_DATA(MSG_9,DATA7,(SRAM0_SYSTEM_BASE_ADDR3+OFFSET1));
  HW_set_uint8(SRAM0_SYSTEM_BASE_ADDR3,OFFSET1,DATA7);

  LOGGER_UPDATE_BIT(MSG_10);
 // // Data Check is done by passing base address ,offset,expected data, and width.
 // //READCHECK(SRAM Base Address, Offset address, Expected data);

  READCHECK(SRAM0_SYSTEM_BASE_ADDR4,OFFSET1,DATA2); // Should throw Error
  READCHECK(SRAM0_SYSTEM_BASE_ADDR5,OFFSET2,DATA2);
  READCHECK(SRAM0_SYSTEM_BASE_ADDR6,OFFSET1,DATA3);
  READCHECK(SRAM0_SYSTEM_BASE_ADDR6,OFFSET3,DATA4);
  READCHECK(SRAM0_SYSTEM_BASE_ADDR7,OFFSET3,DATA5);
  READCHECK(SRAM0_SYSTEM_BASE_ADDR7,OFFSET4,DATA6);
  READCHECK(SRAM0_SYSTEM_BASE_ADDR3,OFFSET1,DATA7);

  LOGGER_UPDATE_BIT(MSG_11);
//  //Consecutive Write and Read to SRAM1
  LOGGER_UPDATE_DATA(MSG_12,DATA1,(SRAM1_SYSTEM_BASE_ADDR4+OFFSET1));
  HW_set_uint32(SRAM1_SYSTEM_BASE_ADDR4,OFFSET1,DATA1);
//  
  LOGGER_UPDATE_DATA(MSG_13,DATA2,(SRAM1_SYSTEM_BASE_ADDR5+OFFSET2));
  HW_set_uint16(SRAM1_SYSTEM_BASE_ADDR5,OFFSET2,DATA2);
//
  LOGGER_UPDATE_DATA(MSG_14,DATA3,(SRAM1_SYSTEM_BASE_ADDR6+OFFSET1));
  HW_set_uint8(SRAM1_SYSTEM_BASE_ADDR6,OFFSET1,DATA3);
//
  LOGGER_UPDATE_DATA(MSG_15,DATA4,(SRAM1_SYSTEM_BASE_ADDR6+OFFSET3));
  HW_set_uint32(SRAM1_SYSTEM_BASE_ADDR6,OFFSET3,DATA4);
//
  LOGGER_UPDATE_DATA(MSG_16,DATA5,(SRAM1_SYSTEM_BASE_ADDR7+OFFSET3));
  HW_set_uint32(SRAM1_SYSTEM_BASE_ADDR7,OFFSET3,DATA5);
//
  LOGGER_UPDATE_DATA(MSG_17,DATA6,(SRAM1_SYSTEM_BASE_ADDR7+OFFSET4));
  HW_set_uint16(SRAM1_SYSTEM_BASE_ADDR7,OFFSET4,DATA6);
//
  LOGGER_UPDATE_DATA(MSG_18,DATA7,(SRAM1_SYSTEM_BASE_ADDR3+OFFSET1));
  HW_set_uint8(SRAM1_SYSTEM_BASE_ADDR3,OFFSET1,DATA7);
//
  LOGGER_UPDATE_BIT(MSG_19);
//  // Data Check is done by passing base address ,offset,expected data, and width.
//  //READCHECK(SRAM Base Address, Offset address, Expected data);
//
  READCHECK(SRAM1_SYSTEM_BASE_ADDR4,OFFSET1,DATA1);
  READCHECK(SRAM1_SYSTEM_BASE_ADDR5,OFFSET2,DATA2);
  READCHECK(SRAM1_SYSTEM_BASE_ADDR6,OFFSET1,DATA3);
  READCHECK(SRAM1_SYSTEM_BASE_ADDR6,OFFSET3,DATA4);
  READCHECK(SRAM1_SYSTEM_BASE_ADDR7,OFFSET3,DATA5);
  READCHECK(SRAM1_SYSTEM_BASE_ADDR7,OFFSET4,DATA6);
  READCHECK(SRAM1_SYSTEM_BASE_ADDR3,OFFSET1,DATA7);
  
//  //Consecutive Write and Read to consecutive Data region locations of SRAM0

  LOGGER_UPDATE_BIT(MSG_20);
  j=0;
  for(i=0; i< 15 ; i++)
  {
    data_array[i]=1234+j;
    j=(j+1);
  }

  offset= 0x0;
  msg_id = MSG_1;
  for(j=0; j<15 ; j++)
  {
      l_data = data_array[j];
      LOGGER_UPDATE_DATA(msg_id,l_data,(SRAM0_SYSTEM_BASE_ADDR6+offset));
    HW_set_uint32(SRAM0_SYSTEM_BASE_ADDR6,offset,data_array[j]);
    offset = (offset + 0x4);
    msg_id = msg_id +1;
  }
  
  LOGGER_UPDATE_BIT(MSG_1);
  offset= 0x0;
  PrintStringF(INFO,"Consecutive Read from Consecutive locations of SRAM0 Data region ....");
  for(j=0; j<15 ; j++)
  {
    READCHECK(SRAM0_SYSTEM_BASE_ADDR6,offset,data_array[j]);
    offset = (offset + 0x4);
  }

//  //Consecutive Write and Read to consecutive Data region locations of SRAM1
  LOGGER_UPDATE_BIT(MSG_2);
  j=0;
  for(i=0; i< 15 ; i++)
  {
    data_array[i]=1234+j;
    j=(j+1);
  }

  offset= 0x0;
  for(j=0; j<15 ; j++)
  {
    HW_set_uint32(SRAM1_SYSTEM_BASE_ADDR6,offset,data_array[j]);
    offset = (offset + 0x4);
  }

  offset= 0x0;
  LOGGER_UPDATE_BIT(MSG_3);
  for(j=0; j<15 ; j++)
  {
    READCHECK(SRAM1_SYSTEM_BASE_ADDR6,offset,data_array[j]);
    offset = (offset + 0x4);
  }

  //Back to back Write and Read Access to SRAM0 Data Region

  LOGGER_UPDATE_BIT(MSG_4);
  LOGGER_UPDATE_DATA(MSG_5,DATA5,(SRAM0_SYSTEM_BASE_ADDR2+OFFSET6));
  HW_set_uint32(SRAM0_SYSTEM_BASE_ADDR2,OFFSET6,DATA5);
  READCHECK(SRAM0_SYSTEM_BASE_ADDR2,OFFSET6,DATA5);
//
  LOGGER_UPDATE_DATA(MSG_6,DATA5,(SRAM0_SYSTEM_BASE_ADDR1+OFFSET6));
  HW_set_uint32(SRAM0_SYSTEM_BASE_ADDR1,OFFSET6,DATA5);
  READCHECK(SRAM0_SYSTEM_BASE_ADDR1,OFFSET6,DATA5);

  // End of testcase.
  WRITE_LOGGER_SIM_STOP_REG(SIM_STOP);
  while (1){}; 

}
