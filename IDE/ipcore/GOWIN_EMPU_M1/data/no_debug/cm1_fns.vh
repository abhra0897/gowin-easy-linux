//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM limited.
//
//            (C) COPYRIGHT 2006-2008 ARM limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2008-04-17 12:26:16 +0100 (Thu, 17 Apr 2008) $
//
//      Revision            : $Revision: 80952 $
//
//      Release Information : Cortex-M1-AT470-r1p0-00rel0
//-----------------------------------------------------------------------------
// Purpose :
//     Functions used within the Cortex-M1 core
//-----------------------------------------------------------------------------

// Reverse the order of bytes within a 32-bit word for be8 support

function [31:0] b_order;
  input        rev;
  input [31:0] w;

  b_order = rev ? {w[7:0], w[15:8], w[23:16], w[31:24]} : w[31:0];
endfunction
