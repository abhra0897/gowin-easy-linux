// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014-2019 Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] spdif_transmitter_top.v
//   \ \  / /\ \  / /    [Description ] spdif_transmitter_top 
//    \ \/ /  \ \/ /     [Timestamp   ] Monday April 8 10:00:30 2019
//     \  /    \  /      [version     ] 1.0.0
//      \/      \/       
//
// ===========Oooo==========================================Oooo========
// Code Revision History :
// --------------------------------------------------------------------
// Ver: | Author |Mod. Date |Changes Made:
// V1.0 | XXX    |04/8/19  |Initial version
// ===========Oooo==========================================Oooo========
`timescale 1 ns / 100 ps
`include "spdif_tx_defines.v"
`include "spdif_tx_name.v"

module `module_name_tx (
                        input       I_clk,
                        input       I_rst_n,
						input 		[`SPDIF_DATA_WIDTH-1:0]	I_audio_d,
                        input       I_validity_bit,
                        input       I_user_bit,
                        input       I_chan_status_bit,

						output		O_audio_d_req,
						output		O_validity_bit_req,
						output		O_user_bit_req,
						output		O_chan_status_bit_req,
						output		O_block_start_flag,
						output		O_sub_frame0_flag,
						output		O_sub_frame1_flag,

						output		O_Spdif_tx_data
);

/************************************************/
 `getname(spdif_tx_top,`module_name_tx) u_spdif_tx_top(
.I_clk               (I_clk),
.I_rst_n             (I_rst_n),
.I_audio_d           (I_audio_d),
.I_validity_bit      (I_validity_bit),
.I_user_bit          (I_user_bit),
.I_chan_status_bit   (I_chan_status_bit),

.O_audio_d_req       (O_audio_d_req),
.O_validity_bit_req  (O_validity_bit_req),
.O_user_bit_req      (O_user_bit_req),
.O_chan_status_bit_req (O_chan_status_bit_req),
.O_block_start_flag  (O_block_start_flag),
.O_sub_frame0_flag   (O_sub_frame0_flag),
.O_sub_frame1_flag   (O_sub_frame1_flag),
.O_Spdif_tx_data     (O_Spdif_tx_data),
.O_test_io()

);


endmodule

