// ==============0ooo===================================================0ooo===========
// =  Copyright (C) 2014-2019 Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// ====================================================================================
// 
//  __      __      __
//  \ \    /  \    / /   [File name   ] csc_top.v
//   \ \  / /\ \  / /    [Description ] Color Space Convertor
//    \ \/ /  \ \/ /     [Timestamp   ] Friday May 17 14:00:30 2019
//     \  /    \  /      [version     ] 1.0.0
//      \/      \/
//
// ==============0ooo===================================================0ooo==========
// Code Revision History :
// ----------------------------------------------------------------------------------
// Ver:    |  Author    | Mod. Date    | Changes Made:
// ----------------------------------------------------------------------------------
// V1.0    | Caojie     | 05/17/19     | Initial version 
// ----------------------------------------------------------------------------------
// ==============0ooo===================================================0ooo==========

`include "top_define.v"
`include "static_macro_define.v"
`include "csc_defines.v"

module `module_name 
(
	I_rst_n     , //reset signal, low active                     
	I_clk       ,
	I_din0      ,
	I_din1      ,
	I_din2      ,
	I_dinvalid  ,
	O_dout0     ,
	O_dout1     ,
	O_dout2     ,
	O_doutvalid 
);

//==============================================================
parameter COEF_WIDTH            = `DEF_COEF_WIDTH           ; //11~18，1bit符号，2bit整数，其余为小数位
parameter IN_DATA_WIDTH         = `DEF_IN_DATA_WIDTH        ; //8/10/12
parameter OUT_DATA_WIDTH        = `DEF_OUT_DATA_WIDTH       ; //8/10/12

//========================================================================
//计算系数选择
`ifdef COLOR_MODEL_1
	parameter A0             = `COLOR_MODEL_1_A0      ;
	parameter B0             = `COLOR_MODEL_1_B0      ;
	parameter C0             = `COLOR_MODEL_1_C0      ;
	parameter A1             = `COLOR_MODEL_1_A1      ;
	parameter B1             = `COLOR_MODEL_1_B1      ;
	parameter C1             = `COLOR_MODEL_1_C1      ;
	parameter A2             = `COLOR_MODEL_1_A2      ;
	parameter B2             = `COLOR_MODEL_1_B2      ;
	parameter C2             = `COLOR_MODEL_1_C2      ;
	parameter S0             = `COLOR_MODEL_1_S0      ;
	parameter S1             = `COLOR_MODEL_1_S1      ;
	parameter S2             = `COLOR_MODEL_1_S2      ;
	parameter OUT0_MAX_VALUE = `COLOR_MODEL_1_OUT0_MAX;
	parameter OUT0_MIN_VALUE = `COLOR_MODEL_1_OUT0_MIN;
	parameter OUT1_MAX_VALUE = `COLOR_MODEL_1_OUT1_MAX;
	parameter OUT1_MIN_VALUE = `COLOR_MODEL_1_OUT1_MIN;
	parameter OUT2_MAX_VALUE = `COLOR_MODEL_1_OUT2_MAX;
	parameter OUT2_MIN_VALUE = `COLOR_MODEL_1_OUT2_MIN;
	parameter IN0_DATA_TYPE  = `COLOR_MODEL_1_IN0_TYPE ;     
	parameter IN1_DATA_TYPE  = `COLOR_MODEL_1_IN1_TYPE ;      
	parameter IN2_DATA_TYPE  = `COLOR_MODEL_1_IN2_TYPE ;     
	parameter OUT0_DATA_TYPE = `COLOR_MODEL_1_OUT0_TYPE;      
	parameter OUT1_DATA_TYPE = `COLOR_MODEL_1_OUT1_TYPE;     
	parameter OUT2_DATA_TYPE = `COLOR_MODEL_1_OUT2_TYPE;      
`else
	`ifdef COLOR_MODEL_2
		parameter A0             = `COLOR_MODEL_2_A0      ;
		parameter B0             = `COLOR_MODEL_2_B0      ;
		parameter C0             = `COLOR_MODEL_2_C0      ;
		parameter A1             = `COLOR_MODEL_2_A1      ;
		parameter B1             = `COLOR_MODEL_2_B1      ;
		parameter C1             = `COLOR_MODEL_2_C1      ;
		parameter A2             = `COLOR_MODEL_2_A2      ;
		parameter B2             = `COLOR_MODEL_2_B2      ;
		parameter C2             = `COLOR_MODEL_2_C2      ;
		parameter S0             = `COLOR_MODEL_2_S0      ;
		parameter S1             = `COLOR_MODEL_2_S1      ;
		parameter S2             = `COLOR_MODEL_2_S2      ;
		parameter OUT0_MAX_VALUE = `COLOR_MODEL_2_OUT0_MAX;
		parameter OUT0_MIN_VALUE = `COLOR_MODEL_2_OUT0_MIN;
		parameter OUT1_MAX_VALUE = `COLOR_MODEL_2_OUT1_MAX;
		parameter OUT1_MIN_VALUE = `COLOR_MODEL_2_OUT1_MIN;
		parameter OUT2_MAX_VALUE = `COLOR_MODEL_2_OUT2_MAX;
		parameter OUT2_MIN_VALUE = `COLOR_MODEL_2_OUT2_MIN;
		parameter IN0_DATA_TYPE  = `COLOR_MODEL_2_IN0_TYPE ;     
		parameter IN1_DATA_TYPE  = `COLOR_MODEL_2_IN1_TYPE ;      
		parameter IN2_DATA_TYPE  = `COLOR_MODEL_2_IN2_TYPE ;     
		parameter OUT0_DATA_TYPE = `COLOR_MODEL_2_OUT0_TYPE;      
		parameter OUT1_DATA_TYPE = `COLOR_MODEL_2_OUT1_TYPE;     
		parameter OUT2_DATA_TYPE = `COLOR_MODEL_2_OUT2_TYPE; 
	`else
		`ifdef COLOR_MODEL_3
			parameter A0             = `COLOR_MODEL_3_A0      ;
			parameter B0             = `COLOR_MODEL_3_B0      ;
			parameter C0             = `COLOR_MODEL_3_C0      ;
			parameter A1             = `COLOR_MODEL_3_A1      ;
			parameter B1             = `COLOR_MODEL_3_B1      ;
			parameter C1             = `COLOR_MODEL_3_C1      ;
			parameter A2             = `COLOR_MODEL_3_A2      ;
			parameter B2             = `COLOR_MODEL_3_B2      ;
			parameter C2             = `COLOR_MODEL_3_C2      ;
			parameter S0             = `COLOR_MODEL_3_S0      ;
			parameter S1             = `COLOR_MODEL_3_S1      ;
			parameter S2             = `COLOR_MODEL_3_S2      ;
			parameter OUT0_MAX_VALUE = `COLOR_MODEL_3_OUT0_MAX;
			parameter OUT0_MIN_VALUE = `COLOR_MODEL_3_OUT0_MIN;
			parameter OUT1_MAX_VALUE = `COLOR_MODEL_3_OUT1_MAX;
			parameter OUT1_MIN_VALUE = `COLOR_MODEL_3_OUT1_MIN;
			parameter OUT2_MAX_VALUE = `COLOR_MODEL_3_OUT2_MAX;
			parameter OUT2_MIN_VALUE = `COLOR_MODEL_3_OUT2_MIN;
			parameter IN0_DATA_TYPE  = `COLOR_MODEL_3_IN0_TYPE ;     
			parameter IN1_DATA_TYPE  = `COLOR_MODEL_3_IN1_TYPE ;      
			parameter IN2_DATA_TYPE  = `COLOR_MODEL_3_IN2_TYPE ;     
			parameter OUT0_DATA_TYPE = `COLOR_MODEL_3_OUT0_TYPE;      
			parameter OUT1_DATA_TYPE = `COLOR_MODEL_3_OUT1_TYPE;     
			parameter OUT2_DATA_TYPE = `COLOR_MODEL_3_OUT2_TYPE;  
		`else
			`ifdef COLOR_MODEL_4
				parameter A0             = `COLOR_MODEL_4_A0      ;
				parameter B0             = `COLOR_MODEL_4_B0      ;
				parameter C0             = `COLOR_MODEL_4_C0      ;
				parameter A1             = `COLOR_MODEL_4_A1      ;
				parameter B1             = `COLOR_MODEL_4_B1      ;
				parameter C1             = `COLOR_MODEL_4_C1      ;
				parameter A2             = `COLOR_MODEL_4_A2      ;
				parameter B2             = `COLOR_MODEL_4_B2      ;
				parameter C2             = `COLOR_MODEL_4_C2      ;
				parameter S0             = `COLOR_MODEL_4_S0      ;
				parameter S1             = `COLOR_MODEL_4_S1      ;
				parameter S2             = `COLOR_MODEL_4_S2      ;
				parameter OUT0_MAX_VALUE = `COLOR_MODEL_4_OUT0_MAX;
				parameter OUT0_MIN_VALUE = `COLOR_MODEL_4_OUT0_MIN;
				parameter OUT1_MAX_VALUE = `COLOR_MODEL_4_OUT1_MAX;
				parameter OUT1_MIN_VALUE = `COLOR_MODEL_4_OUT1_MIN;
				parameter OUT2_MAX_VALUE = `COLOR_MODEL_4_OUT2_MAX;
				parameter OUT2_MIN_VALUE = `COLOR_MODEL_4_OUT2_MIN;
				parameter IN0_DATA_TYPE  = `COLOR_MODEL_4_IN0_TYPE ;     
				parameter IN1_DATA_TYPE  = `COLOR_MODEL_4_IN1_TYPE ;      
				parameter IN2_DATA_TYPE  = `COLOR_MODEL_4_IN2_TYPE ;     
				parameter OUT0_DATA_TYPE = `COLOR_MODEL_4_OUT0_TYPE;      
				parameter OUT1_DATA_TYPE = `COLOR_MODEL_4_OUT1_TYPE;     
				parameter OUT2_DATA_TYPE = `COLOR_MODEL_4_OUT2_TYPE; 
			`else
				`ifdef COLOR_MODEL_5
					parameter A0             = `COLOR_MODEL_5_A0      ;
					parameter B0             = `COLOR_MODEL_5_B0      ;
					parameter C0             = `COLOR_MODEL_5_C0      ;
					parameter A1             = `COLOR_MODEL_5_A1      ;
					parameter B1             = `COLOR_MODEL_5_B1      ;
					parameter C1             = `COLOR_MODEL_5_C1      ;
					parameter A2             = `COLOR_MODEL_5_A2      ;
					parameter B2             = `COLOR_MODEL_5_B2      ;
					parameter C2             = `COLOR_MODEL_5_C2      ;
					parameter S0             = `COLOR_MODEL_5_S0      ;
					parameter S1             = `COLOR_MODEL_5_S1      ;
					parameter S2             = `COLOR_MODEL_5_S2      ;
					parameter OUT0_MAX_VALUE = `COLOR_MODEL_5_OUT0_MAX;
					parameter OUT0_MIN_VALUE = `COLOR_MODEL_5_OUT0_MIN;
					parameter OUT1_MAX_VALUE = `COLOR_MODEL_5_OUT1_MAX;
					parameter OUT1_MIN_VALUE = `COLOR_MODEL_5_OUT1_MIN;
					parameter OUT2_MAX_VALUE = `COLOR_MODEL_5_OUT2_MAX;
					parameter OUT2_MIN_VALUE = `COLOR_MODEL_5_OUT2_MIN;
					parameter IN0_DATA_TYPE  = `COLOR_MODEL_5_IN0_TYPE ;     
					parameter IN1_DATA_TYPE  = `COLOR_MODEL_5_IN1_TYPE ;      
					parameter IN2_DATA_TYPE  = `COLOR_MODEL_5_IN2_TYPE ;     
					parameter OUT0_DATA_TYPE = `COLOR_MODEL_5_OUT0_TYPE;      
					parameter OUT1_DATA_TYPE = `COLOR_MODEL_5_OUT1_TYPE;     
					parameter OUT2_DATA_TYPE = `COLOR_MODEL_5_OUT2_TYPE;  
				`else
					`ifdef COLOR_MODEL_6
						parameter A0             = `COLOR_MODEL_6_A0      ;
						parameter B0             = `COLOR_MODEL_6_B0      ;
						parameter C0             = `COLOR_MODEL_6_C0      ;
						parameter A1             = `COLOR_MODEL_6_A1      ;
						parameter B1             = `COLOR_MODEL_6_B1      ;
						parameter C1             = `COLOR_MODEL_6_C1      ;
						parameter A2             = `COLOR_MODEL_6_A2      ;
						parameter B2             = `COLOR_MODEL_6_B2      ;
						parameter C2             = `COLOR_MODEL_6_C2      ;
						parameter S0             = `COLOR_MODEL_6_S0      ;
						parameter S1             = `COLOR_MODEL_6_S1      ;
						parameter S2             = `COLOR_MODEL_6_S2      ;
						parameter OUT0_MAX_VALUE = `COLOR_MODEL_6_OUT0_MAX;
						parameter OUT0_MIN_VALUE = `COLOR_MODEL_6_OUT0_MIN;
						parameter OUT1_MAX_VALUE = `COLOR_MODEL_6_OUT1_MAX;
						parameter OUT1_MIN_VALUE = `COLOR_MODEL_6_OUT1_MIN;
						parameter OUT2_MAX_VALUE = `COLOR_MODEL_6_OUT2_MAX;
						parameter OUT2_MIN_VALUE = `COLOR_MODEL_6_OUT2_MIN;
						parameter IN0_DATA_TYPE  = `COLOR_MODEL_6_IN0_TYPE ;     
						parameter IN1_DATA_TYPE  = `COLOR_MODEL_6_IN1_TYPE ;      
						parameter IN2_DATA_TYPE  = `COLOR_MODEL_6_IN2_TYPE ;     
						parameter OUT0_DATA_TYPE = `COLOR_MODEL_6_OUT0_TYPE;      
						parameter OUT1_DATA_TYPE = `COLOR_MODEL_6_OUT1_TYPE;     
						parameter OUT2_DATA_TYPE = `COLOR_MODEL_6_OUT2_TYPE;    
					`else
						`ifdef COLOR_MODEL_7
							parameter A0             = `COLOR_MODEL_7_A0      ;
							parameter B0             = `COLOR_MODEL_7_B0      ;
							parameter C0             = `COLOR_MODEL_7_C0      ;
							parameter A1             = `COLOR_MODEL_7_A1      ;
							parameter B1             = `COLOR_MODEL_7_B1      ;
							parameter C1             = `COLOR_MODEL_7_C1      ;
							parameter A2             = `COLOR_MODEL_7_A2      ;
							parameter B2             = `COLOR_MODEL_7_B2      ;
							parameter C2             = `COLOR_MODEL_7_C2      ;
							parameter S0             = `COLOR_MODEL_7_S0      ;
							parameter S1             = `COLOR_MODEL_7_S1      ;
							parameter S2             = `COLOR_MODEL_7_S2      ;
							parameter OUT0_MAX_VALUE = `COLOR_MODEL_7_OUT0_MAX;
							parameter OUT0_MIN_VALUE = `COLOR_MODEL_7_OUT0_MIN;
							parameter OUT1_MAX_VALUE = `COLOR_MODEL_7_OUT1_MAX;
							parameter OUT1_MIN_VALUE = `COLOR_MODEL_7_OUT1_MIN;
							parameter OUT2_MAX_VALUE = `COLOR_MODEL_7_OUT2_MAX;
							parameter OUT2_MIN_VALUE = `COLOR_MODEL_7_OUT2_MIN;
							parameter IN0_DATA_TYPE  = `COLOR_MODEL_7_IN0_TYPE ;     
							parameter IN1_DATA_TYPE  = `COLOR_MODEL_7_IN1_TYPE ;      
							parameter IN2_DATA_TYPE  = `COLOR_MODEL_7_IN2_TYPE ;     
							parameter OUT0_DATA_TYPE = `COLOR_MODEL_7_OUT0_TYPE;      
							parameter OUT1_DATA_TYPE = `COLOR_MODEL_7_OUT1_TYPE;     
							parameter OUT2_DATA_TYPE = `COLOR_MODEL_7_OUT2_TYPE; 
						`else
							`ifdef COLOR_MODEL_8
								parameter A0             = `COLOR_MODEL_8_A0      ;
								parameter B0             = `COLOR_MODEL_8_B0      ;
								parameter C0             = `COLOR_MODEL_8_C0      ;
								parameter A1             = `COLOR_MODEL_8_A1      ;
								parameter B1             = `COLOR_MODEL_8_B1      ;
								parameter C1             = `COLOR_MODEL_8_C1      ;
								parameter A2             = `COLOR_MODEL_8_A2      ;
								parameter B2             = `COLOR_MODEL_8_B2      ;
								parameter C2             = `COLOR_MODEL_8_C2      ;
								parameter S0             = `COLOR_MODEL_8_S0      ;
								parameter S1             = `COLOR_MODEL_8_S1      ;
								parameter S2             = `COLOR_MODEL_8_S2      ;
								parameter OUT0_MAX_VALUE = `COLOR_MODEL_8_OUT0_MAX;
								parameter OUT0_MIN_VALUE = `COLOR_MODEL_8_OUT0_MIN;
								parameter OUT1_MAX_VALUE = `COLOR_MODEL_8_OUT1_MAX;
								parameter OUT1_MIN_VALUE = `COLOR_MODEL_8_OUT1_MIN;
								parameter OUT2_MAX_VALUE = `COLOR_MODEL_8_OUT2_MAX;
								parameter OUT2_MIN_VALUE = `COLOR_MODEL_8_OUT2_MIN;
								parameter IN0_DATA_TYPE  = `COLOR_MODEL_8_IN0_TYPE ;     
								parameter IN1_DATA_TYPE  = `COLOR_MODEL_8_IN1_TYPE ;      
								parameter IN2_DATA_TYPE  = `COLOR_MODEL_8_IN2_TYPE ;     
								parameter OUT0_DATA_TYPE = `COLOR_MODEL_8_OUT0_TYPE;      
								parameter OUT1_DATA_TYPE = `COLOR_MODEL_8_OUT1_TYPE;     
								parameter OUT2_DATA_TYPE = `COLOR_MODEL_8_OUT2_TYPE; 
							`else
								`ifdef COLOR_MODEL_9
									parameter A0             = `COLOR_MODEL_9_A0      ;
									parameter B0             = `COLOR_MODEL_9_B0      ;
									parameter C0             = `COLOR_MODEL_9_C0      ;
									parameter A1             = `COLOR_MODEL_9_A1      ;
									parameter B1             = `COLOR_MODEL_9_B1      ;
									parameter C1             = `COLOR_MODEL_9_C1      ;
									parameter A2             = `COLOR_MODEL_9_A2      ;
									parameter B2             = `COLOR_MODEL_9_B2      ;
									parameter C2             = `COLOR_MODEL_9_C2      ;
									parameter S0             = `COLOR_MODEL_9_S0      ;
									parameter S1             = `COLOR_MODEL_9_S1      ;
									parameter S2             = `COLOR_MODEL_9_S2      ;
									parameter OUT0_MAX_VALUE = `COLOR_MODEL_9_OUT0_MAX;
									parameter OUT0_MIN_VALUE = `COLOR_MODEL_9_OUT0_MIN;
									parameter OUT1_MAX_VALUE = `COLOR_MODEL_9_OUT1_MAX;
									parameter OUT1_MIN_VALUE = `COLOR_MODEL_9_OUT1_MIN; 
									parameter OUT2_MAX_VALUE = `COLOR_MODEL_9_OUT2_MAX;
									parameter OUT2_MIN_VALUE = `COLOR_MODEL_9_OUT2_MIN;
									parameter IN0_DATA_TYPE  = `COLOR_MODEL_9_IN0_TYPE ;     
									parameter IN1_DATA_TYPE  = `COLOR_MODEL_9_IN1_TYPE ;      
									parameter IN2_DATA_TYPE  = `COLOR_MODEL_9_IN2_TYPE ;     
									parameter OUT0_DATA_TYPE = `COLOR_MODEL_9_OUT0_TYPE;      
									parameter OUT1_DATA_TYPE = `COLOR_MODEL_9_OUT1_TYPE;   
									parameter OUT2_DATA_TYPE = `COLOR_MODEL_9_OUT2_TYPE;
								`else
									`ifdef COLOR_MODEL_10
										parameter A0             = `COLOR_MODEL_10_A0      ;
										parameter B0             = `COLOR_MODEL_10_B0      ;
										parameter C0             = `COLOR_MODEL_10_C0      ;
										parameter A1             = `COLOR_MODEL_10_A1      ;
										parameter B1             = `COLOR_MODEL_10_B1      ;
										parameter C1             = `COLOR_MODEL_10_C1      ;
										parameter A2             = `COLOR_MODEL_10_A2      ;
										parameter B2             = `COLOR_MODEL_10_B2      ;
										parameter C2             = `COLOR_MODEL_10_C2      ;
										parameter S0             = `COLOR_MODEL_10_S0      ;
										parameter S1             = `COLOR_MODEL_10_S1      ;
										parameter S2             = `COLOR_MODEL_10_S2      ;
										parameter OUT0_MAX_VALUE = `COLOR_MODEL_10_OUT0_MAX;
										parameter OUT0_MIN_VALUE = `COLOR_MODEL_10_OUT0_MIN;
										parameter OUT1_MAX_VALUE = `COLOR_MODEL_10_OUT1_MAX;
										parameter OUT1_MIN_VALUE = `COLOR_MODEL_10_OUT1_MIN;
										parameter OUT2_MAX_VALUE = `COLOR_MODEL_10_OUT2_MAX;
										parameter OUT2_MIN_VALUE = `COLOR_MODEL_10_OUT2_MIN;
										parameter IN0_DATA_TYPE  = `COLOR_MODEL_10_IN0_TYPE ;     
										parameter IN1_DATA_TYPE  = `COLOR_MODEL_10_IN1_TYPE ;    
										parameter IN2_DATA_TYPE  = `COLOR_MODEL_10_IN2_TYPE ;   
										parameter OUT0_DATA_TYPE = `COLOR_MODEL_10_OUT0_TYPE;      
										parameter OUT1_DATA_TYPE = `COLOR_MODEL_10_OUT1_TYPE;     
										parameter OUT2_DATA_TYPE = `COLOR_MODEL_10_OUT2_TYPE; 
									`else
										`ifdef COLOR_MODEL_11
											parameter A0             = `COLOR_MODEL_11_A0      ;
											parameter B0             = `COLOR_MODEL_11_B0      ;
											parameter C0             = `COLOR_MODEL_11_C0      ;
											parameter A1             = `COLOR_MODEL_11_A1      ;
											parameter B1             = `COLOR_MODEL_11_B1      ;
											parameter C1             = `COLOR_MODEL_11_C1      ;
											parameter A2             = `COLOR_MODEL_11_A2      ;
											parameter B2             = `COLOR_MODEL_11_B2      ;
											parameter C2             = `COLOR_MODEL_11_C2      ;
											parameter S0             = `COLOR_MODEL_11_S0      ;
											parameter S1             = `COLOR_MODEL_11_S1      ;
											parameter S2             = `COLOR_MODEL_11_S2      ;
											parameter OUT0_MAX_VALUE = `COLOR_MODEL_11_OUT0_MAX;
											parameter OUT0_MIN_VALUE = `COLOR_MODEL_11_OUT0_MIN;
											parameter OUT1_MAX_VALUE = `COLOR_MODEL_11_OUT1_MAX;
											parameter OUT1_MIN_VALUE = `COLOR_MODEL_11_OUT1_MIN;
											parameter OUT2_MAX_VALUE = `COLOR_MODEL_11_OUT2_MAX;
											parameter OUT2_MIN_VALUE = `COLOR_MODEL_11_OUT2_MIN;
											parameter IN0_DATA_TYPE  = `COLOR_MODEL_11_IN0_TYPE ;    
											parameter IN1_DATA_TYPE  = `COLOR_MODEL_11_IN1_TYPE ;     
											parameter IN2_DATA_TYPE  = `COLOR_MODEL_11_IN2_TYPE ;    
											parameter OUT0_DATA_TYPE = `COLOR_MODEL_11_OUT0_TYPE;     
											parameter OUT1_DATA_TYPE = `COLOR_MODEL_11_OUT1_TYPE;  
											parameter OUT2_DATA_TYPE = `COLOR_MODEL_11_OUT2_TYPE;
										`else
											`ifdef COLOR_MODEL_12
												parameter A0             = `COLOR_MODEL_12_A0      ;
												parameter B0             = `COLOR_MODEL_12_B0      ;
												parameter C0             = `COLOR_MODEL_12_C0      ;
												parameter A1             = `COLOR_MODEL_12_A1      ;
												parameter B1             = `COLOR_MODEL_12_B1      ;
												parameter C1             = `COLOR_MODEL_12_C1      ;
												parameter A2             = `COLOR_MODEL_12_A2      ;
												parameter B2             = `COLOR_MODEL_12_B2      ;
												parameter C2             = `COLOR_MODEL_12_C2      ;
												parameter S0             = `COLOR_MODEL_12_S0      ;
												parameter S1             = `COLOR_MODEL_12_S1      ;
												parameter S2             = `COLOR_MODEL_12_S2      ;
												parameter OUT0_MAX_VALUE = `COLOR_MODEL_12_OUT0_MAX;
												parameter OUT0_MIN_VALUE = `COLOR_MODEL_12_OUT0_MIN;
												parameter OUT1_MAX_VALUE = `COLOR_MODEL_12_OUT1_MAX;
												parameter OUT1_MIN_VALUE = `COLOR_MODEL_12_OUT1_MIN;
												parameter OUT2_MAX_VALUE = `COLOR_MODEL_12_OUT2_MAX;
												parameter OUT2_MIN_VALUE = `COLOR_MODEL_12_OUT2_MIN;
												parameter IN0_DATA_TYPE  = `COLOR_MODEL_12_IN0_TYPE ;     
												parameter IN1_DATA_TYPE  = `COLOR_MODEL_12_IN1_TYPE ;    
												parameter IN2_DATA_TYPE  = `COLOR_MODEL_12_IN2_TYPE ;   
												parameter OUT0_DATA_TYPE = `COLOR_MODEL_12_OUT0_TYPE;      
												parameter OUT1_DATA_TYPE = `COLOR_MODEL_12_OUT1_TYPE;     
												parameter OUT2_DATA_TYPE = `COLOR_MODEL_12_OUT2_TYPE;  
											`else
												`ifdef CUSTOM
													parameter A0             = `CUSTOM_A0      ;
													parameter B0             = `CUSTOM_B0      ;
													parameter C0             = `CUSTOM_C0      ;
													parameter A1             = `CUSTOM_A1      ;
													parameter B1             = `CUSTOM_B1      ;
													parameter C1             = `CUSTOM_C1      ;
													parameter A2             = `CUSTOM_A2      ;
													parameter B2             = `CUSTOM_B2      ;
													parameter C2             = `CUSTOM_C2      ;
													parameter S0             = `CUSTOM_S0      ;                         
													parameter S1             = `CUSTOM_S1      ;                         
													parameter S2             = `CUSTOM_S2      ; 
													parameter OUT0_MAX_VALUE = `CUSTOM_OUT0_MAX; 
													parameter OUT0_MIN_VALUE = `CUSTOM_OUT0_MIN; 
													parameter OUT1_MAX_VALUE = `CUSTOM_OUT1_MAX; 
													parameter OUT1_MIN_VALUE = `CUSTOM_OUT1_MIN; 
													parameter OUT2_MAX_VALUE = `CUSTOM_OUT2_MAX; 
													parameter OUT2_MIN_VALUE = `CUSTOM_OUT2_MIN;
													parameter IN0_DATA_TYPE  = `CUSTOM_IN0_TYPE ;     
													parameter IN1_DATA_TYPE  = `CUSTOM_IN1_TYPE ;      
													parameter IN2_DATA_TYPE  = `CUSTOM_IN2_TYPE ;     
													parameter OUT0_DATA_TYPE = `CUSTOM_OUT0_TYPE;      
													parameter OUT1_DATA_TYPE = `CUSTOM_OUT1_TYPE;     
													parameter OUT2_DATA_TYPE = `CUSTOM_OUT2_TYPE; 
												`endif
											`endif
										`endif
									`endif
								`endif
							`endif
						`endif
					`endif
				`endif
			`endif
		`endif
	`endif
`endif 

//==============================================================
input                            I_rst_n     ; //reset signal, low active                     
input                            I_clk       ;
input      [IN_DATA_WIDTH-1:0]   I_din0      ;
input      [IN_DATA_WIDTH-1:0]   I_din1      ;
input      [IN_DATA_WIDTH-1:0]   I_din2      ;
input                            I_dinvalid  ;
output     [OUT_DATA_WIDTH-1:0]  O_dout0     ;
output     [OUT_DATA_WIDTH-1:0]  O_dout1     ;
output     [OUT_DATA_WIDTH-1:0]  O_dout2     ;
output                           O_doutvalid ;

//==============================================================
`getname(csc_wrapper,`module_name) #
(
	.IN0_DATA_TYPE         (IN0_DATA_TYPE        ), 
	.IN1_DATA_TYPE         (IN1_DATA_TYPE        ),
	.IN2_DATA_TYPE         (IN2_DATA_TYPE        ),
	.IN_DATA_WIDTH         (IN_DATA_WIDTH        ), 
	.OUT0_DATA_TYPE        (OUT0_DATA_TYPE       ),
	.OUT1_DATA_TYPE        (OUT1_DATA_TYPE       ),
	.OUT2_DATA_TYPE        (OUT2_DATA_TYPE       ), 
	.OUT_DATA_WIDTH        (OUT_DATA_WIDTH       ), 
	.COEF_WIDTH            (COEF_WIDTH           ),
	.A0                    (A0                   ), 
	.B0                    (B0                   ), 
	.C0                    (C0                   ), 
	.A1                    (A1                   ), 
	.B1                    (B1                   ), 
	.C1                    (C1                   ), 
	.A2                    (A2                   ), 
	.B2                    (B2                   ), 
	.C2                    (C2                   ), 
	.S0                    (S0                   ), 
	.S1                    (S1                   ),
	.S2                    (S2                   ), 
	.OUT0_MAX_VALUE        (OUT0_MAX_VALUE       ), 
	.OUT0_MIN_VALUE        (OUT0_MIN_VALUE       ), 
	.OUT1_MAX_VALUE        (OUT1_MAX_VALUE       ), 
	.OUT1_MIN_VALUE        (OUT1_MIN_VALUE       ),  
	.OUT2_MAX_VALUE        (OUT2_MAX_VALUE       ), 
	.OUT2_MIN_VALUE        (OUT2_MIN_VALUE       )   
) 
csc_wrapper_inst
(
    .I_rst_n     (I_rst_n    ), //reset signal, low active                     
	.I_clk       (I_clk      ),
	.I_din0      (I_din0     ),
	.I_din1      (I_din1     ),
	.I_din2      (I_din2     ),
	.I_dinvalid  (I_dinvalid ),
	.O_dout0     (O_dout0    ),
	.O_dout1     (O_dout1    ),
	.O_dout2     (O_dout2    ),
	.O_doutvalid (O_doutvalid)
);

endmodule


