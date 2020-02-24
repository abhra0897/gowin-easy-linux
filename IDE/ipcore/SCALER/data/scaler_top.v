// ==============0ooo===================================================0ooo===========
// =  Copyright (C) 2014-2019 Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// ====================================================================================
// 
//  __      __      __
//  \ \    /  \    / /   [File name   ] scaler_top.v
//   \ \  / /\ \  / /    [Description ] Video scaler
//    \ \/ /  \ \/ /     [Timestamp   ] Friday May 23 14:00:30 2019
//     \  /    \  /      [version     ] 1.2
//      \/      \/
//
// ==============0ooo===================================================0ooo===========
// Code Revision History :
// ----------------------------------------------------------------------------------
// Ver:    |  Author    | Mod. Date    | Changes Made:
// ----------------------------------------------------------------------------------
// V1.0    | Caojie     | 05/23/19     | Initial version 
// ----------------------------------------------------------------------------------
// V1.1    | Caojie     | 11/07/19     | Updated for core version 1.1
// ----------------------------------------------------------------------------------
// V1.2    | Caojie     | 20/12/19     | Updated for core version 1.2
// ==============0ooo===================================================0ooo===========

`include "top_define.v"
`include "static_macro_define.v"
`include "scaler_defines.v"

module `module_name
( 
	I_reset			,//high active
	I_sysclk		,
	I_param_update	,//parameters update enable, high active
	I_vin_hsize		,//input horizontal resolution 
	I_vin_vsize		,//input vertical resolution
	I_vout_hsize	,//output horizontal resolution
	I_vout_vsize	,//output vertical resolution
	I_hor_skfactor	,//shrink factor£¬unsigned fixed£¬8bit integer£¬16bit fraction£¬(vin_hor/vout_hor)*(2^16)-1
	I_ver_skfactor	,//shrink factor£¬unsigned fixed£¬8bit integer£¬16bit fraction£¬(vin_ver/vout_ver)*(2^16)-1
	I_vin_clk		,
`ifdef MEMORY
	I_vin_ref_vs	,//positive polarity +
	I_vin_ref_de	,
	O_vin_vs_req	,//vs for getting data from buffer //positive polarity +
	O_vin_de_req	,//de for getting data from buffer
	I_buff_ready    ,//buffer ready
	I_up_down_sel	,//0:scaler up£» 1:scaler down
`endif
`ifdef LIVE
	I_vin_vs_cpl	,//positive polarity +
`endif
	I_vin_de_cpl	,
`ifdef YC444
	I_vin_data0_cpl	,//r  y
	I_vin_data1_cpl	,//g  cb
	I_vin_data2_cpl	,//b  cr
	O_vout0_data	,//r  y
	O_vout1_data	,//g  cb
	O_vout2_data	,//b  cr
`endif
`ifdef YC422
	I_vin_data0_cpl	,//y
	I_vin_data1_cpl	,//c
	O_vout0_data	,//y
	O_vout1_data	,//c
`endif
`ifdef SINGLE
	I_vin_data0_cpl	,//y
	O_vout0_data	,//y
`endif
	I_vout_clk		,
	O_vout_vs		,//positive polarity +
	O_vout_de	
);

//==============================================================================
parameter COEF_WIDTH          = `DEF_COEF_WIDTH       ;//coefficient width, 9~16, for bicubic
parameter DATA_WIDTH          = `DEF_DATA_WIDTH       ;//picture data width, 8/10/12
parameter FILTER_TAPS         = `DEF_TAPS 		      ;//Filter taps, 4/6
parameter FILTER_PHASES       = `DEF_PHASES 	      ;//Filter phases, 8,16,32,64
parameter PARAM_DYNAMIC_CTRL  = `DEF_DYNAMIC_CTRL     ;//"Yes" or "No"
parameter FIX_INPUT_WIDTH     = `DEF_FIX_INPUT_WIDTH  ;//1024
parameter FIX_INPUT_HEIGHT    = `DEF_FIX_INPUT_HEIGHT ;//768 
parameter FIX_OUTPUT_WIDTH    = `DEF_FIX_OUTPUT_WIDTH ;//1024
parameter FIX_OUTPUT_HEIGHT   = `DEF_FIX_OUTPUT_HEIGHT;//768 
    
//==============================================================================
	input			            I_reset			;//high active                                                                    
	input			            I_sysclk		;                                                                                 
	input			            I_param_update	;//parameters update enable, high active                                          
	input	[11:0] 	        	I_vin_hsize		;//input horizontal resolution                                                    
	input	[11:0] 	        	I_vin_vsize		;//input vertical resolution                                                      
	input	[11:0] 	        	I_vout_hsize	;//output horizontal resolution                                                   
	input	[11:0] 	        	I_vout_vsize	;//output vertical resolution                                                     
	input	[23:0] 	        	I_hor_skfactor	;//shrink factor£¬unsigned fixed£¬8bit integer£¬16bit fraction£¬(vin_hor/vout_hor)*(2^16)-1
	input	[23:0] 	        	I_ver_skfactor	;//shrink factor£¬unsigned fixed£¬8bit integer£¬16bit fraction£¬(vin_ver/vout_ver)*(2^16)-1
	input			            I_vin_clk		;
`ifdef MEMORY
	input			            I_vin_ref_vs	;//positive polarity +                                  
	input			            I_vin_ref_de	;                                                       
	output			            O_vin_vs_req	;//vs for getting data from buffer //positive polarity +
	output			            O_vin_de_req	;//de for getting data from buffer                      
	input                       I_buff_ready    ;//buffer ready                                         
	input			            I_up_down_sel	;//0:scaler up£» 1:scaler down                          
`endif
`ifdef LIVE
	input			            I_vin_vs_cpl	;//positive polarity +
`endif
	input			            I_vin_de_cpl	;
`ifdef YC444
	input	[DATA_WIDTH-1:0] 	I_vin_data0_cpl	;//r  y 
	input	[DATA_WIDTH-1:0] 	I_vin_data1_cpl	;//g  cb
	input	[DATA_WIDTH-1:0] 	I_vin_data2_cpl	;//b  cr
	output  [DATA_WIDTH-1:0] 	O_vout0_data	;//r  y 
	output  [DATA_WIDTH-1:0] 	O_vout1_data	;//g  cb
	output  [DATA_WIDTH-1:0] 	O_vout2_data	;//b  cr
`endif
`ifdef YC422
	input	[DATA_WIDTH-1:0] 	I_vin_data0_cpl	;//y
	input	[DATA_WIDTH-1:0] 	I_vin_data1_cpl	;//c
	output  [DATA_WIDTH-1:0] 	O_vout0_data	;//y
	output  [DATA_WIDTH-1:0] 	O_vout1_data	;//c
`endif
`ifdef SINGLE
	input	[DATA_WIDTH-1:0] 	I_vin_data0_cpl	;//y
	output  [DATA_WIDTH-1:0] 	O_vout0_data	;//y
`endif
	input			            I_vout_clk		;
	output			            O_vout_vs		;//positive polarity +
	output			            O_vout_de		;
		
//=========================================================================================
`getname(scaler_wrapper,`module_name) #
(	
	.COEF_WIDTH          (COEF_WIDTH        ),//coefficient width, 9~16, for bicubic 
	.DATA_WIDTH          (DATA_WIDTH        ),//picture data width, 8/10/12          
    .FILTER_TAPS         (FILTER_TAPS       ),//Filter taps, 4/6                     
    .FILTER_PHASES       (FILTER_PHASES     ),//Filter phases, 8,16,32,64            
    .PARAM_DYNAMIC_CTRL  (PARAM_DYNAMIC_CTRL),//"Yes" or "No"                        
    .FIX_INPUT_WIDTH     (FIX_INPUT_WIDTH   ),//1024                                 
    .FIX_INPUT_HEIGHT    (FIX_INPUT_HEIGHT  ),//768                                  
    .FIX_OUTPUT_WIDTH    (FIX_OUTPUT_WIDTH  ),//1024                                 
    .FIX_OUTPUT_HEIGHT   (FIX_OUTPUT_HEIGHT ) //768                                  
)
scaler_wrapper_inst
( 
	.I_reset			(I_reset		),//high active                                                                    
	.I_sysclk			(I_sysclk		),                                                                                 
	.I_param_update		(I_param_update	),//parameters update enable, high active                                          
	.I_vin_hsize		(I_vin_hsize	),//input horizontal resolution                                                    
	.I_vin_vsize		(I_vin_vsize	),//input vertical resolution                                                      
	.I_vout_hsize		(I_vout_hsize	),//output horizontal resolution                                                   
	.I_vout_vsize		(I_vout_vsize	),//output vertical resolution                                                     
	.I_hor_skfactor		(I_hor_skfactor	),//shrink factor£¬unsigned fixed£¬8bit integer£¬16bit fraction£¬(vin_hor/vout_hor)*(2^16)-1
	.I_ver_skfactor		(I_ver_skfactor	),//shrink factor£¬unsigned fixed£¬8bit integer£¬16bit fraction£¬(vin_ver/vout_ver)*(2^16)-1
	.I_vin_clk			(I_vin_clk		),
`ifdef MEMORY
	.I_vin_ref_vs		(I_vin_ref_vs	),//positive polarity +
	.I_vin_ref_de		(I_vin_ref_de	),
	.O_vin_vs_req		(O_vin_vs_req	),//vs for getting data from buffer //positive polarity +
	.O_vin_de_req		(O_vin_de_req	),//de for getting data from buffer                      
	.I_buff_ready   	(I_buff_ready   ),//buffer ready                                         
	.I_up_down_sel		(I_up_down_sel	),//0:scaler up£» 1:scaler down                          
`endif
`ifdef LIVE
	.I_vin_vs_cpl		(I_vin_vs_cpl   ),//positive polarity +
`endif
	.I_vin_de_cpl		(I_vin_de_cpl	),
`ifdef YC444
	.I_vin_data0_cpl	(I_vin_data0_cpl),//r  y  
	.I_vin_data1_cpl	(I_vin_data1_cpl),//g  cb 
	.I_vin_data2_cpl	(I_vin_data2_cpl),//b  cr 
	.O_vout0_data		(O_vout0_data	),//r  y 
	.O_vout1_data		(O_vout1_data	),//g  cb
	.O_vout2_data		(O_vout2_data	),//b  cr
`endif
`ifdef YC422
	.I_vin_data0_cpl	(I_vin_data0_cpl),//y
	.I_vin_data1_cpl	(I_vin_data1_cpl),//c
	.O_vout0_data		(O_vout0_data	),//y
	.O_vout1_data		(O_vout1_data	),//c
`endif
`ifdef SINGLE
	.I_vin_data0_cpl	(I_vin_data0_cpl),//y
	.O_vout0_data		(O_vout0_data	),//y
`endif
	.I_vout_clk			(I_vout_clk		),
	.O_vout_vs			(O_vout_vs		),//positive polarity +
	.O_vout_de			(O_vout_de		)
);

	
endmodule

