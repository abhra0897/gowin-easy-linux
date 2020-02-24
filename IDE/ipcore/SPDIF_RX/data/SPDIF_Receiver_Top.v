// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014-2019 Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] spdif_receiver_top.v
//   \ \  / /\ \  / /    [Description ] spdif_receiver_top 
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
`include "spdif_rx_defines.v"
`include "spdif_rx_name.v"

module `module_name_rx (
                        input       I_clk,
                        input       I_rst_n,
						input		I_spdif_rx_data,

						output 		[`SPDIF_DATA_WIDTH-1:0]	O_audio_d,
                        output       O_validity_bit,
                        output       O_user_bit,
                        output       O_chan_status_bit,
						output		 O_spdif_data_en,
						output		 O_block_start_flag,
						output		 O_sub_frame0_flag,
						output		 O_sub_frame1_flag,
						output		 O_parity_check_error,
						output		 O_lock_flag

);

/************************************************/

`getname(spdif_rx_top,`module_name_rx) u_spdif_rx_top(
.I_clk              (I_clk),
.I_rst_n            (I_rst_n),
.I_spdif_rx_data    (I_spdif_rx_data),

.O_audio_d           (O_audio_d),
.O_validity_bit      (O_validity_bit),
.O_user_bit          (O_user_bit),
.O_chan_status_bit   (O_chan_status_bit),
.O_spdif_data_en     (O_spdif_data_en),
.O_block_start_flag  (O_block_start_flag),
.O_sub_frame0_flag   (O_sub_frame0_flag),
.O_sub_frame1_flag   (O_sub_frame1_flag),
.O_parity_check_error(O_parity_check_error),
.O_lock_flag         (O_lock_flag),

.O_test_io()

);


endmodule
