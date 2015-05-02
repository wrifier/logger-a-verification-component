Logger is verification component and data object based on System Verilog – UVM methodology.
This component provides handshake mechanism between C code running on processor and top level SV/UVM testcases in SoC verification.

Major Challenge in verifying SoC while running C Code on processor
 Synchronization and Handshake between SV/UVM testcase and C code running on processor
 Printing Debug messages from C code.

Most of time we need synchronization or handshake from C testcase to perform some required action in SV/UVM testcase and vice versa. We used SV events or UVM events in Pure SV environment for synchronization or handshake between communications of two components. But C doesn’t not provide such implementation in its library.

Also it’s not possible to print debugging messages from your C code as function from 'stdio.h’ eg. Printf would not understandable to processor.

To overcome these challenges we introduced the logger block.