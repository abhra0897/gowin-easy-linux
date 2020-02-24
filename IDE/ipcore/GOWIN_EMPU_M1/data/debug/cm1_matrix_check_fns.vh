//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM limited.
//
//            (C) COPYRIGHT 2007-2008 ARM limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2008-04-26 16:17:24 +0100 (Sat, 26 Apr 2008) $
//
//      Revision            : $Revision: 81524 $
//
//      Release Information : Cortex-M1-AT470-r1p0-00rel0
//-----------------------------------------------------------------------------

// Address decode(for debugger)
function [1:0] addr_decode_d;
    input [31:0] addr;
    input [3:0] itcmsize;
    input [3:0] dtcmsize;
    input [1:0] itcmen;

    reg [1:0]   out; // 0 for Debug PPB, 1 for System PPB and 2 for Ext
    
    begin
      out = 2'b00; // default to Debug PPB
      casez (addr)
            
        32'b000?_????_????_????_????_????_????_????: // Code region
          begin
            case (itcmsize)
              4'b0000: out[1] = 1'b1;          // 0k
              4'b0001: out[1] = |addr[27:10];  // 1k
              4'b0010: out[1] = |addr[27:11];  // 2k
              4'b0011: out[1] = |addr[27:12];  // 4k
              4'b0100: out[1] = |addr[27:13];  // 8k
              4'b0101: out[1] = |addr[27:14];  // 16k
              4'b0110: out[1] = |addr[27:15];  // 32k
              4'b0111: out[1] = |addr[27:16];  // 64k
              4'b1000: out[1] = |addr[27:17];  // 128k
              4'b1001: out[1] = |addr[27:18];  // 256k
              4'b1010: out[1] = |addr[27:19];  // 512k
              4'b1011: out[1] = |addr[27:20];  // 1M
              default: out[1] = 1'bx;
            endcase
            // Factor in TCM enable bits
            out[1] = out[1] | (~(addr[28] ? itcmen[1] : itcmen[0]));
          end
        32'b001?_????_????_????_????_????_????_????: // SRAM
          begin
            case (dtcmsize)
              4'b0000: out[1] = 1'b1;          // 0k
              4'b0001: out[1] = |addr[27:10];  // 1k
              4'b0010: out[1] = |addr[27:11];  // 2k
              4'b0011: out[1] = |addr[27:12];  // 4k
              4'b0100: out[1] = |addr[27:13];  // 8k
              4'b0101: out[1] = |addr[27:14];  // 16k
              4'b0110: out[1] = |addr[27:15];  // 32k
              4'b0111: out[1] = |addr[27:16];  // 64k
              4'b1000: out[1] = |addr[27:17];  // 128k
              4'b1001: out[1] = |addr[27:18];  // 256k
              4'b1010: out[1] = |addr[27:19];  // 512k
              4'b1011: out[1] = |addr[27:20];  // 1M
              default: out[1] = 1'bx;
            endcase
            out[1] = out[1] | addr[28];
          end
        32'b010?_????_????_????_????_????_????_????: out[1] = 1'b1; // Peripheral
        32'b011?_????_????_????_????_????_????_????: out[1] = 1'b1; // RAM
        32'b100?_????_????_????_????_????_????_????: out[1] = 1'b1; // RAM
        32'b101?_????_????_????_????_????_????_????: out[1] = 1'b1; // Device
        32'b110?_????_????_????_????_????_????_????: out[1] = 1'b1; // Device
        32'b111?_????_????_????_????_????_????_????: out[0] = (//   // System PPB 
                                                               (addr[31:12] == 20'hE000E) & // SCS space
                                                               // but exclude the following 
                                                               // (they go to the Debug PPB instead)
                                                               ~((addr[11:2] == 10'b1101_0000_00) | // CPUID (debug copy)
                                                                 (addr[11:2] == 10'b1101_0011_00) | // DFSR
                                                                 
                                                                 (addr[11:2] == 10'b1101_1111_00) | // DHCSR
                                                                 (addr[11:2] == 10'b1101_1111_01) | // DCRSR
                                                                 (addr[11:2] == 10'b1101_1111_10) | // DCRDR
                                                                 (addr[11:2] == 10'b1101_1111_11)   // DEMCR
                                                                 ));
      endcase
      addr_decode_d = out;
    end
    
endfunction // addr_decode_d

// Address decode (for Core)
function [1:0] addr_decode_c;
    input [31:0] addr;
    
    reg [1:0]    out; // 0 for Debug PPB, 1 for System PPB and 2 for Ext
    
    begin
      out = 2'b01; // default to System PPB
      case (addr[31:29] == {3{1'b1}})
        1'b0:    out = 2'b10;
        1'b1:    out = 2'b01;
        default: out = 2'bxx;
      endcase
      addr_decode_c = out;
    end
endfunction // addr_decode_d







