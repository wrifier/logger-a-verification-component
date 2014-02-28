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
// Last Modification : 28-Feb-2014
// Email ID :  vinay.jain5@wipro.com
//
// Please report the bug with the subject line "Logger : Report Bug"
//-----------------------------------------------------------------
#include <stdarg.h>
#include "logger_macro.h"

#define LOGGER  ((volatile int *)LOGGER_ADDR)
#define LOGGER_DATA ((volatile int *)(LOGGER_ADDR - 0x4))

void sendToLoggerV(int bit, va_list ap)
{
    int i, value;
    
    for (i = 0; ; ++i)
    {
        value = va_arg(ap, int);
        if (value == -1)
            break;
            
        LOGGER_DATA[-i] = value;
    }
    *LOGGER |= 1 << bit;
}

void sendToLogger(int bit, ...)
{
    va_list ap;
    va_start(ap,bit);
    sendToLoggerV(bit, ap);
    va_end(ap);
}
