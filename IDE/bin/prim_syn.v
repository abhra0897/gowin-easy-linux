// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014-2017 Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] prim_syn.v
//   \ \  / /\ \  / /    [Description ] GW2A verilog functional synthesis library
//    \ \/ /  \ \/ /     [Timestamp   ] Fri May 25 11:00:30 2018
//     \  /    \  /      [version     ] 1.8.5
//      \/      \/       
//
// ===========Oooo==========================================Oooo========



`timescale 1ns / 1ps


module MUX2 (O, I0, I1, S0)  ;
input I0,I1;
input S0;
output O;
endmodule 

module MUX2_LUT5 (O, I0, I1, S0)  ;
input I0,I1;
input S0;
output O;
endmodule 

module MUX2_LUT6 (O, I0, I1, S0)  ;
input I0,I1;
input S0;
output O;
endmodule 

module MUX2_LUT7 (O, I0, I1, S0)  ;
input I0,I1;
input S0;
output O;
endmodule 

module MUX2_LUT8 (O, I0, I1, S0)  ;
input I0,I1;
input S0;
output O;
endmodule 

module MUX2_MUX8(O, I0, I1, S0)  ;
input I0,I1;
input S0;
output O;
endmodule 

module MUX2_MUX16(O, I0, I1, S0)  ;
input I0,I1;
input S0;
output O;
endmodule 

module MUX2_MUX32(O, I0, I1, S0)  ;
input I0,I1;
input S0;
output O;
endmodule 

module MUX4 (O, I0, I1, I2, I3, S0, S1)  ;
input I0, I1, I2, I3;
input S0, S1;
output O;
endmodule 

module MUX8 (O, I0, I1, I2, I3, I4, I5, I6, I7, S0, S1, S2)  ;
input I0, I1, I2, I3, I4, I5, I6, I7;
input S0, S1, S2;
output O;
endmodule 

module MUX16(O, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, S0, S1, S2, S3)  ;

input I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15;
input S0, S1, S2, S3;
output O;
endmodule

module MUX32(O, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15,I16, I17, I18, I19, I20, I21, I22, I23, I24, I25, I26, I27, I28, I29, I30,I31, S0, S1, S2, S3, S4)  ;
input I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, I16, I17, I18, I19, I20, I21, I22, I23, I24, I25, I26, I27, I28, I29, I30, I31;
input S0, S1, S2, S3, S4;
output O;
endmodule


module LUT1 (F, I0)  ;
parameter INIT = "";
input I0;
output F;
endmodule 

module LUT2 (F, I0, I1)  ;
parameter INIT = "";
input I0, I1;
output F;
endmodule 

module LUT3 (F, I0, I1, I2)  ;
parameter INIT = "";
input I0, I1, I2;
output F;
endmodule 

module LUT4 (F, I0, I1, I2, I3)  ;
parameter INIT = "";
input I0, I1, I2, I3;
output F;
endmodule 

module LUT5 (F, I0, I1, I2, I3, I4)  ;
parameter INIT = "";
input I0, I1, I2, I3, I4;
output F;
endmodule

module LUT6 (F, I0, I1, I2, I3, I4, I5)  ;
parameter INIT = "";
input I0, I1, I2, I3, I4, I5;
output F;
endmodule

module LUT7 (F, I0, I1, I2, I3, I4, I5, I6)  ;
parameter INIT = "";
input I0, I1, I2, I3, I4, I5, I6;
output F;
endmodule

module LUT8 (F, I0, I1, I2, I3, I4, I5, I6, I7)  ;
parameter INIT = "";
input I0, I1, I2, I3, I4, I5, I6, I7;
output F;
endmodule

module ALU (SUM, COUT, I0, I1, I3, CIN)  ;

input I0;
input I1;
input I3;
input CIN;
output SUM;
output COUT;

parameter ALU_MODE = "";

endmodule 


module DFF (Q, D, CLK)  ;
input D, CLK;
output Q;
parameter INIT = "";
endmodule 

module DFFE (Q, D, CLK, CE)  ;
input D, CLK, CE;
output Q;
parameter INIT = "";
endmodule 

module DFFS (Q, D, CLK, SET)  ;
input D, CLK, SET;
output Q;
parameter INIT = "";
endmodule 

module DFFSE (Q, D, CLK, CE, SET)  ;
input D, CLK, SET, CE;
output Q;
parameter INIT = "";
endmodule 

module DFFR (Q, D, CLK, RESET)  ;
input D, CLK, RESET;
output Q;
parameter INIT = "";
endmodule 

module DFFRE (Q, D, CLK, CE, RESET)  ;
input D, CLK, RESET, CE;
output Q;
parameter INIT = "";
endmodule 

module DFFP (Q, D, CLK, PRESET)  ;
input D, CLK, PRESET;
output Q;
parameter INIT = "";
endmodule 

module DFFPE (Q, D, CLK, CE, PRESET)  ;
input D, CLK, PRESET, CE;
output Q;
parameter INIT = "";
endmodule 

module DFFC (Q, D, CLK, CLEAR)  ;
input D, CLK, CLEAR;
output Q;
parameter INIT = "";
endmodule 

module DFFCE (Q, D, CLK, CE, CLEAR)  ;
input D, CLK, CLEAR, CE;
output Q;
parameter INIT = "";
endmodule 

module DFFN (Q, D, CLK)  ;
input D, CLK;
output Q;
parameter INIT = "";
endmodule 

module DFFNE (Q, D, CLK, CE)  ;
input D, CLK, CE;
output Q;
parameter INIT = "";
endmodule 

module DFFNS (Q, D, CLK, SET)  ;
input D, CLK, SET;
output Q;
parameter INIT = "";
endmodule 

module DFFNSE (Q, D, CLK, CE, SET)  ;
input D, CLK, SET, CE;
output Q;
parameter INIT = "";
endmodule 

module DFFNR (Q, D, CLK, RESET)  ;
input D, CLK, RESET;
output Q;
parameter INIT = "";
endmodule 

module DFFNRE (Q, D, CLK, CE, RESET)  ;
input D, CLK, RESET, CE;
output Q;
parameter INIT = "";
endmodule 

module DFFNP (Q, D, CLK, PRESET)  ;
input D, CLK, PRESET;
output Q;
parameter INIT = "";
endmodule 

module DFFNPE (Q, D, CLK, CE, PRESET)  ;
input D, CLK, PRESET, CE;
output Q;
parameter INIT = "";
endmodule 

module DFFNC (Q, D, CLK, CLEAR)  ;
input D, CLK, CLEAR;
output Q;
parameter INIT = "";
endmodule 

module DFFNCE (Q, D, CLK, CE, CLEAR)  ;
input D, CLK, CLEAR, CE;
output Q;
parameter INIT = "";
endmodule 

module DL (Q, D, G)  ;
input D, G;
output Q;
parameter INIT = "";
endmodule 

module DLE (Q, D, G, CE)  ;
input D, G, CE;
output Q;
parameter INIT = "";
endmodule 

module DLC (Q, D, G, CLEAR)  ;
input D, G, CLEAR;
output Q;
parameter INIT = "";
endmodule 

module DLCE (Q, D, G, CE, CLEAR)  ;
input D, G, CLEAR, CE;
output Q;
parameter INIT = "";
endmodule 

module DLP (Q, D, G, PRESET)  ;
input D, G, PRESET;
output Q;
parameter INIT = "";
endmodule 

module DLPE (Q, D, G, CE, PRESET)  ;
input D, G, PRESET, CE;
output Q;
parameter INIT = "";
endmodule 

module DLN (Q, D, G)  ;
input D, G;
output Q;
parameter INIT = "";
endmodule 

module DLNE (Q, D, G, CE)  ;
input D, G, CE;
output Q;
parameter INIT = "";
endmodule 

module DLNC (Q, D, G, CLEAR)  ;
input D, G, CLEAR;
output Q;
parameter INIT = "";
endmodule 

module DLNCE (Q, D, G, CE, CLEAR)  ;
input D, G, CLEAR, CE;
output Q;
parameter INIT = "";
endmodule 

module DLNP (Q, D, G, PRESET)  ;
input D, G, PRESET;
output Q;
parameter INIT = "";
endmodule 

module DLNPE (Q, D, G, CE, PRESET)  ;
input D, G, PRESET, CE;
output Q;
parameter INIT = "";
endmodule 

module INV (O, I)  ;
input  I;
output O;
endmodule 

module IBUF (O, I)  ;
input  I;
output O;
endmodule 

module OBUF (O, I)  ;
input  I;
output O;
endmodule 

module TBUF (O, I, OEN)  ;
input I, OEN;
output O;
endmodule 

module IOBUF (O, IO, I, OEN)  ;
input I,OEN;
output O;
inout IO;
endmodule 

module IDDR(Q0, Q1, D, CLK)  ;
input D;
input CLK;
output Q0;
output Q1;
parameter Q0_INIT = "";
parameter Q1_INIT = "";
endmodule 

module IDDRC(Q0, Q1, D, CLK, CLEAR)  ;
input D;
input CLK;
input CLEAR;
output Q0;
output Q1;
parameter Q0_INIT = "";
parameter Q1_INIT = "";
endmodule 

module IDDR_MEM (Q0, Q1, D, WADDR, RADDR, PCLK, ICLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
input D, ICLK, PCLK;
input [2:0] WADDR;
input [2:0] RADDR;
input RESET;
output  Q0,Q1;
endmodule 

module ODDR (Q0, Q1, D0, D1, TX, CLK)  ;
input D0;
input D1;
input TX;
input CLK;
output Q0;
output Q1;
parameter TXCLK_POL = "";
parameter INIT = "";
endmodule 

module ODDRC (Q0, Q1, D0, D1, TX, CLK, CLEAR)  ;
input D0, D1, TX, CLK, CLEAR;
output Q0, Q1;
parameter TXCLK_POL = "";
parameter INIT = "";
endmodule 

module ODDR_MEM (Q0, Q1, D0, D1, TX, PCLK, TCLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
parameter TCLK_SOURCE = "";
parameter TXCLK_POL = "";

input D0, D1;
input TX, PCLK, TCLK, RESET;
output  Q0, Q1;
endmodule 

module IDES4 (Q0, Q1, Q2, Q3, D, CALIB, PCLK, FCLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
input D, FCLK, PCLK, CALIB, RESET;
output Q0,Q1,Q2,Q3;
endmodule 

module IDES4_MEM (Q0, Q1, Q2, Q3, D, WADDR, RADDR, CALIB, PCLK, FCLK, ICLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
input D, ICLK, FCLK, PCLK;
input [2:0] WADDR;
input [2:0] RADDR;
input CALIB, RESET;
output Q0,Q1,Q2,Q3;
endmodule 

module IVIDEO (Q0, Q1, Q2, Q3, Q4, Q5, Q6, D, CALIB, PCLK, FCLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
input D, FCLK, PCLK, CALIB, RESET;
output Q0, Q1, Q2, Q3, Q4, Q5, Q6;
endmodule 

module IDES8 (Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, D, CALIB, PCLK, FCLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
input D, FCLK, PCLK, CALIB, RESET;
output Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;
endmodule 

module IDES8_MEM (Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, D, WADDR, RADDR, CALIB, PCLK, FCLK, ICLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
input D, ICLK, FCLK, PCLK;
input [2:0] WADDR;
input [2:0] RADDR;
input CALIB, RESET;
output  Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;
endmodule 

module IDES10 (Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, D, CALIB, PCLK, FCLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
input D, FCLK, PCLK, CALIB, RESET;
output Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9;
endmodule 

module IDES16 (Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, D, CALIB, PCLK, FCLK, RESET) ;

parameter GSREN = "";
parameter LSREN = "";

input D, FCLK, PCLK, CALIB,RESET;
output Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15;
endmodule 


module OSER4 (Q0, Q1, D0, D1, D2, D3, TX0, TX1, PCLK, FCLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
parameter HWL = "";
parameter TXCLK_POL = "";

input D3, D2, D1, D0;
input TX1, TX0;
input PCLK, FCLK, RESET;
output  Q0, Q1;
endmodule 

module OSER4_MEM (Q0, Q1, D0, D1, D2, D3, TX0, TX1, PCLK, FCLK, TCLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
parameter HWL = "";
parameter TCLK_SOURCE = "";
parameter TXCLK_POL = "";

input D0, D1, D2, D3;
input TX0, TX1;
input PCLK, FCLK, TCLK, RESET;
output  Q0,  Q1;
endmodule 

module OVIDEO (Q, D0, D1, D2, D3, D4, D5, D6, PCLK, FCLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
input D6, D5, D4, D3, D2, D1, D0;
input PCLK, FCLK, RESET;
output  Q;
endmodule 

module OSER8 (Q0, Q1, D0, D1, D2, D3, D4, D5, D6, D7, TX0, TX1, TX2, TX3, PCLK, FCLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
parameter HWL = "";
parameter TXCLK_POL = "";

input D0, D1, D2, D3, D4, D5, D6, D7;
input TX0, TX1, TX2, TX3;
input PCLK, FCLK, RESET;
output  Q0,  Q1;
endmodule 

module OSER8_MEM (Q0, Q1, D0, D1, D2, D3, D4, D5, D6, D7, TX0, TX1, TX2, TX3, PCLK, FCLK, TCLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
parameter HWL = "";
parameter TCLK_SOURCE = "";
parameter TXCLK_POL = "";

input D0, D1, D2, D3, D4, D5, D6, D7;
input TX0, TX1, TX2, TX3;
input PCLK, FCLK, TCLK, RESET;
output  Q0,  Q1;
endmodule 

module OSER10 (Q, D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, PCLK, FCLK, RESET)  ;
parameter GSREN = "";
parameter LSREN = "";
input D0, D1, D2, D3, D4, D5, D6, D7, D8, D9;
input PCLK, FCLK, RESET;
output  Q;
endmodule 

module OSER16 (Q, D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, PCLK, FCLK, RESET) ;

parameter GSREN = "";
parameter LSREN = "";

input D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15;
input PCLK, FCLK, RESET;
output  Q;
endmodule 

module IODELAY (DO, DF, DI, SDTAP, VALUE, SETN)  ;
parameter C_STATIC_DLY = "";
input DI;
input  SDTAP;
input  SETN;
input  VALUE;
output DF;
output DO;
endmodule 

module IEM (LAG, LEAD, D, CLK, MCLK, RESET)  ;
parameter WINSIZE = "";
parameter GSREN = "";
parameter LSREN = "";
input D, CLK, RESET, MCLK;
output LAG, LEAD;
endmodule 

module RAM16S1 (DO, DI, AD, WRE, CLK)  ;
input CLK;
input WRE;
input [3:0] AD;
input DI;
output DO;
parameter INIT_0 = "";
endmodule 

module RAM16S2 (DO, DI, AD, WRE, CLK)  ;
input CLK;
input WRE; 
input [3:0] AD;
input [1:0] DI;
output [1:0] DO;
parameter INIT_0 = "";
parameter INIT_1 = "";
endmodule 

module RAM16S4 (DO, DI, AD, WRE, CLK)  ;
input CLK;
input WRE; 
input [3:0] AD;
input [3:0] DI;
output [3:0] DO;
parameter INIT_0 = "";
parameter INIT_1 = "";
parameter INIT_2 = "";
parameter INIT_3 = "";
endmodule 

module RAM16SDP1 (DO, DI, WAD, RAD, WRE, CLK)  ;
input CLK;
input WRE;
input [3:0] WAD;
input DI;
input [3:0] RAD;
output DO;
parameter INIT_0 = "";
endmodule 

module RAM16SDP2 (DO, DI, WAD, RAD, WRE, CLK)  ;
input CLK;
input WRE; 
input [3:0] WAD;
input [1:0] DI;
input [3:0] RAD;
output [1:0] DO;
parameter INIT_0 = "";
parameter INIT_1 = "";
endmodule 

module RAM16SDP4 (DO, DI, WAD, RAD, WRE, CLK)  ;
input CLK;
input WRE;
input [3:0] WAD;
input [3:0] DI;
input [3:0] RAD;
output [3:0] DO;
parameter INIT_0 = "";
parameter INIT_1 = "";
parameter INIT_2 = "";
parameter INIT_3 = "";
endmodule 

module ROM16 (DO, AD)  ;
parameter INIT_0 = "";
input [3:0] AD;
output DO;
endmodule 

module SP (DO, DI, BLKSEL, AD, WRE, CLK, CE, OCE, RESET)  ;
parameter READ_MODE = "";
parameter WRITE_MODE = "";
parameter BIT_WIDTH = "";
parameter BLK_SEL = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLK, CE;
input OCE; 
input RESET; 
input WRE; 
input [13:0] AD;
input [31:0] DI;
input [2:0] BLKSEL;
output [31:0] DO;
endmodule 

module SPX9 (DO, DI, BLKSEL, AD, WRE, CLK, CE, OCE, RESET)  ;
parameter READ_MODE = "";
parameter WRITE_MODE = "";
parameter BIT_WIDTH = "";
parameter BLK_SEL = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLK, CE;
input OCE; 
input RESET; 
input WRE; 
input [13:0] AD;
input [2:0] BLKSEL;
input [35:0] DI;
output [35:0] DO;
endmodule 

module SDP (DO, DI, BLKSEL, ADA, ADB, WREA, WREB, CLKA, CLKB, CEA, CEB, OCE, RESETA, RESETB)  ;
parameter READ_MODE = "";
parameter BIT_WIDTH_0 = "";
parameter BIT_WIDTH_1 = "";
parameter BLK_SEL = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLKA, CEA, CLKB, CEB;
input OCE; 
input RESETA, RESETB; 
input WREA, WREB; 
input [13:0] ADA, ADB;
input [2:0] BLKSEL;
input [31:0] DI;
output [31:0] DO;
endmodule 

module SDPX9 (DO, DI, BLKSEL, ADA, ADB, WREA, WREB, CLKA, CLKB, CEA, CEB, OCE, RESETA, RESETB)  ;
parameter READ_MODE = "";
parameter BIT_WIDTH_0 = "";
parameter BIT_WIDTH_1 = "";
parameter BLK_SEL = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLKA, CEA, CLKB, CEB;
input OCE; 
input RESETA, RESETB; 
input WREA, WREB; 
input [13:0] ADA, ADB;
input [2:0] BLKSEL;
input [35:0] DI;
output [35:0] DO;
endmodule 

module DP (DOA, DOB, DIA, DIB, BLKSEL, ADA, ADB, WREA, WREB, CLKA, CLKB, CEA, CEB, OCEA, OCEB, RESETA, RESETB)  ;
parameter READ_MODE0 = "";
parameter READ_MODE1 = "";
parameter WRITE_MODE0 = "";
parameter WRITE_MODE1 = "";
parameter BIT_WIDTH_0 = "";
parameter BIT_WIDTH_1 = "";
parameter BLK_SEL = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLKA, CEA, CLKB, CEB;
input OCEA, OCEB; 
input RESETA, RESETB; 
input WREA, WREB; 
input [13:0] ADA, ADB;
input [2:0] BLKSEL;
input [15:0] DIA, DIB;
output [15:0] DOA, DOB;
endmodule 

module DPX9 (DOA, DOB, DIA, DIB, BLKSEL, ADA, ADB, WREA, WREB, CLKA, CLKB, CEA, CEB, OCEA, OCEB, RESETA, RESETB)  ;
parameter READ_MODE0 = "";
parameter READ_MODE1 = "";
parameter WRITE_MODE0 = "";
parameter WRITE_MODE1 = "";
parameter BIT_WIDTH_0 = "";
parameter BIT_WIDTH_1 = "";
parameter BLK_SEL = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLKA, CEA, CLKB, CEB;
input OCEA, OCEB; 
input RESETA, RESETB; 
input WREA, WREB; 
input [13:0] ADA, ADB;
input [2:0] BLKSEL;
input [17:0] DIA, DIB;
output [17:0] DOA, DOB;
endmodule 

module ROM (DO, BLKSEL, AD, WRE, CLK, CE, OCE, RESET)  ;
parameter READ_MODE = "";
parameter BIT_WIDTH = "";
parameter BLK_SEL = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";
input CLK, CE;
input OCE; 
input RESET; 
input WRE; 
input [13:0] AD;
input [2:0] BLKSEL;
output [31:0] DO;
endmodule 

module ROMX9 (DO, BLKSEL, AD, WRE, CLK, CE, OCE, RESET)  ;
parameter READ_MODE = "";
parameter BIT_WIDTH = "";
parameter BLK_SEL = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";
input CLK, CE;
input OCE; 
input RESET; 
input WRE; 
input [13:0] AD;
input [2:0] BLKSEL;
output [35:0] DO;
endmodule 


module PADD18 (DOUT, SO, SBO, A, B, SI, SBI, ASEL, CLK, CE, RESET) ;

input  [17:0] A;
input  [17:0] B;
input  ASEL;
input  CE,CLK,RESET;
input  [17:0] SI,SBI;
output [17:0] SO,SBO;
output [17:0] DOUT;

parameter AREG = "";
parameter BREG = "";
parameter ADD_SUB = "";
parameter PADD_RESET_MODE = "";
parameter BSEL_MODE = "";
parameter SOREG = "";


endmodule


module PADD9 (DOUT, SO, SBO, A, B, SI, SBI, ASEL, CLK, CE, RESET) ;

input  [8:0] A;
input  [8:0] B;
input  ASEL;
input  CE,CLK,RESET;
input  [8:0] SI,SBI;
output [8:0] SO,SBO;
output [8:0] DOUT;

parameter AREG = "";
parameter BREG = "";
parameter ADD_SUB = "";
parameter PADD_RESET_MODE = "";
parameter BSEL_MODE = "";
parameter SOREG = "";

endmodule


module MULT9X9 (DOUT, SOA, SOB, A, B, SIA, SIB, ASEL, BSEL, ASIGN, BSIGN, CLK, CE, RESET) ;

input  [8:0] A,SIA;
input  [8:0] B,SIB;
input  ASIGN,BSIGN;
input  ASEL,BSEL;
input  CE;
input  CLK;
input  RESET;
output [17:0] DOUT;
output [8:0] SOA,SOB;

parameter AREG = "";
parameter BREG = "";
parameter OUT_REG = "";
parameter PIPE_REG = "";
parameter ASIGN_REG = "";
parameter BSIGN_REG = "";
parameter SOA_REG = "";
parameter MULT_RESET_MODE = "";

endmodule


module MULT18X18 (DOUT, SOA, SOB, A, B, SIA, SIB, ASEL, BSEL, ASIGN, BSIGN, CLK, CE, RESET) ;

input  [17:0] A,SIA;
input  [17:0] B,SIB;
input  ASIGN,BSIGN;
input  ASEL,BSEL;
input  CE;
input  CLK;
input  RESET;
output [35:0] DOUT;
output [17:0] SOA,SOB;

parameter AREG = "";
parameter BREG = "";
parameter OUT_REG = "";
parameter PIPE_REG = "";
parameter ASIGN_REG = "";
parameter BSIGN_REG = "";
parameter SOA_REG = "";
parameter MULT_RESET_MODE = "";

endmodule



module MULT36X36 (DOUT, A, B, ASIGN, BSIGN, CLK, CE, RESET) ;

input  [35:0] A;
input  [35:0] B;
input  ASIGN,BSIGN;
input  CE;
input  CLK;
input  RESET;
output [71:0] DOUT;

parameter AREG = "";
parameter BREG = "";
parameter OUT0_REG = "";
parameter OUT1_REG = "";
parameter PIPE_REG = "";
parameter ASIGN_REG = "";
parameter BSIGN_REG = "";
parameter MULT_RESET_MODE = "";

endmodule


module MULTALU36X18 (DOUT, CASO, A, B, C, CASI, ACCLOAD, ASIGN, BSIGN, CLK, CE, RESET) ;

input  [17:0] A;
input  [35:0] B;
input  [53:0] C;
input  ASIGN,BSIGN,ACCLOAD;
input  CE;
input  CLK;
input  RESET;
input  [54:0] CASI;
output [53:0] DOUT;
output [54:0] CASO;

parameter AREG = "";
parameter BREG = "";
parameter CREG = "";
parameter OUT_REG = "";
parameter PIPE_REG = "";
parameter ASIGN_REG = "";
parameter BSIGN_REG = "";
parameter ACCLOAD_REG0 = "";
parameter ACCLOAD_REG1 = "";
parameter MULT_RESET_MODE = "";
parameter MULTALU36X18_MODE = "";
parameter C_ADD_SUB = "";

endmodule


module MULTADDALU18X18 (DOUT, CASO, SOA, SOB, A0, B0, A1, B1, C, SIA, SIB, CASI, ACCLOAD, ASEL, BSEL, ASIGN, BSIGN, CLK, CE, RESET) ;

input [17:0] A0;
input [17:0] B0;
input [17:0] A1;
input [17:0] B1;
input [53:0] C;
input [17:0] SIA, SIB;
input [1:0] ASIGN, BSIGN;
input [1:0] ASEL, BSEL;
input [54:0] CASI;
input CE;
input CLK;
input RESET;
input ACCLOAD;
output [53:0] DOUT;
output [54:0] CASO;
output [17:0] SOA, SOB;

parameter A0REG = "";
parameter A1REG = "";
parameter B0REG = "";
parameter B1REG = "";
parameter CREG = "";
parameter PIPE0_REG = "";
parameter PIPE1_REG = "";
parameter OUT_REG = "";
parameter ASIGN0_REG = "";
parameter ASIGN1_REG = "";
parameter ACCLOAD_REG0 = "";
parameter ACCLOAD_REG1 = "";
parameter BSIGN0_REG = "";
parameter BSIGN1_REG = "";
parameter SOA_REG = "";
parameter B_ADD_SUB = "";
parameter C_ADD_SUB = "";
parameter MULTADDALU18X18_MODE = "";
parameter MULT_RESET_MODE = "";

endmodule


module MULTALU18X18 (DOUT, CASO, A, B, C, D, CASI, ACCLOAD, ASIGN, BSIGN, DSIGN, CLK, CE, RESET) ;
input [17:0] A, B;
input CLK,CE,RESET;
input ASIGN, BSIGN;
input ACCLOAD,DSIGN;
input [53:0] C,D;
input [54:0] CASI;
output [53:0] DOUT;
output [54:0] CASO;

parameter AREG = "";
parameter BREG = "";
parameter CREG = "";
parameter DREG = "";
parameter DSIGN_REG = "";
parameter ASIGN_REG = "";
parameter BSIGN_REG = "";
parameter ACCLOAD_REG0 = "";
parameter ACCLOAD_REG1 = "";
parameter MULT_RESET_MODE = "";
parameter PIPE_REG = "";
parameter OUT_REG = "";
parameter B_ADD_SUB = "";
parameter C_ADD_SUB = "";
parameter MULTALU18X18_MODE = "";

endmodule


module ALU54D (DOUT, CASO, A, B, CASI, ACCLOAD, ASIGN, BSIGN, CLK, CE, RESET) ;
input [53:0] A, B;
input ASIGN,BSIGN;
input ACCLOAD;
input [54:0] CASI;
input CLK, CE, RESET;
output [53:0] DOUT;
output [54:0] CASO;

parameter AREG = "";
parameter BREG = "";
parameter ASIGN_REG = "";
parameter BSIGN_REG = "";
parameter ACCLOAD_REG = "";
parameter OUT_REG = "";
parameter B_ADD_SUB = "";
parameter C_ADD_SUB = "";
parameter ALUD_MODE = "";
parameter ALU_RESET_MODE = "";

endmodule



module PLL (CLKOUT, CLKOUTP, CLKOUTD, CLKOUTD3, LOCK, CLKIN, CLKFB, FBDSEL, IDSEL, ODSEL, DUTYDA, PSDA, FDLY, RESET, RESET_P, RESET_I, RESET_S);
input CLKIN;
input CLKFB;
input RESET; 
input RESET_P; 
input RESET_I;
input RESET_S;
input [5:0] FBDSEL; 
input [5:0] IDSEL;
input [5:0] ODSEL;
input [3:0] PSDA,FDLY; 
input [3:0] DUTYDA; 

output CLKOUT;
output LOCK;
output CLKOUTP;
output CLKOUTD;
output CLKOUTD3;

parameter FCLKIN = "";
parameter DYN_IDIV_SEL = "";
parameter IDIV_SEL = "";
parameter DYN_FBDIV_SEL = "";
parameter FBDIV_SEL = "";
parameter DYN_ODIV_SEL = "";
parameter ODIV_SEL = "";

parameter PSDA_SEL = "";
parameter DYN_DA_EN = "";
parameter DUTYDA_SEL = "";

parameter CLKOUT_FT_DIR = "";
parameter CLKOUTP_FT_DIR = "";
parameter CLKOUT_DLY_STEP = "";
parameter CLKOUTP_DLY_STEP = "";

parameter CLKFB_SEL = "";
parameter CLKOUT_BYPASS = "";
parameter CLKOUTP_BYPASS = "";
parameter CLKOUTD_BYPASS = "";
parameter DYN_SDIV_SEL = "";
parameter CLKOUTD_SRC = "";
parameter CLKOUTD3_SRC = "";
parameter DEVICE = "";

endmodule

module BUFG (O, I)  ;
output O;
input I;
endmodule 

module BUFS (O, I)  ;
output O;
input I;
endmodule 

module GND (G)  ;
output G;
endmodule

module VCC (V)  ;
output V;
endmodule

module GSR (GSRI)  ;
input GSRI;
endmodule 

module OSC ( OSCOUT)  ;
parameter FREQ_DIV = "";
parameter DEVICE = "";
output OSCOUT;
endmodule

module OSCF (OSCOUT, OSCOUT30M, OSCEN)  ;
parameter FREQ_DIV = "";
output OSCOUT,OSCOUT30M;
input OSCEN;
endmodule



module OSCZ (OSCOUT, OSCEN) ;
parameter FREQ_DIV = "";
output OSCOUT;
input OSCEN;
endmodule


module TLVDS_IBUF (O, I, IB)  ;
output O;
input  I, IB;
endmodule

module TLVDS_OBUF (O, OB, I)  ;
output O, OB;
input  I;
endmodule

module TLVDS_TBUF (O, OB, I, OEN)  ;
output O, OB;
input  I, OEN;
endmodule

module TLVDS_IOBUF (O, IO, IOB, I, OEN)  ;
output   O;
inout IO, IOB;
input I, OEN;
endmodule


module ELVDS_IBUF (O, I, IB)  ;
output O;
input  I, IB;
endmodule

module ELVDS_OBUF (O, OB, I)  ;
output O, OB;
input  I;
endmodule

module ELVDS_TBUF (O, OB, I, OEN)  ;
output O, OB;
input  I, OEN;
endmodule

module ELVDS_IOBUF (O, IO, IOB, I, OEN)  ;
output   O;
inout IO, IOB;
input I, OEN;
endmodule

module MIPI_IBUF (OH, OL, OB, IO, IOB, I, IB, OEN, OENB, HSREN) ;
output OH, OL, OB;
inout IO, IOB;
input  I, IB;
input OEN, OENB;
input HSREN;
endmodule

module MIPI_IBUF_HS (OH, I, IB); 
output OH;
input  I, IB;
endmodule

module MIPI_IBUF_LP (OL, OB, I, IB) ; 
output OL;
output OB;
input  I;
input IB;

endmodule


module MIPI_OBUF (O, OB, I, IB, MODESEL) ;
output O, OB;
input  I, IB, MODESEL;
endmodule


module I3C_IOBUF (O, IO, I, MODESEL);
output O;
inout IO;
input  I, MODESEL;

endmodule


module DLL (STEP, LOCK, UPDNCNTL, STOP, CLKIN, RESET) ;

input CLKIN;
input STOP;
input UPDNCNTL;
input RESET;

output [7:0]STEP;
output LOCK;

parameter DLL_FORCE = "";
parameter CODESCAL = "";
parameter SCAL_EN = "";
parameter DIV_SEL = "";

endmodule



module CLKDIV(CLKOUT, CALIB, HCLKIN, RESETN) ; 

input HCLKIN;
input RESETN;
input CALIB;
output CLKOUT;

parameter DIV_MODE = "";
parameter GSREN = "";

endmodule


module DHCEN (CLKOUT, CLKIN, CE) ;
input CLKIN,CE;
output CLKOUT;

endmodule


module DQS(DQSR90, DQSW0, DQSW270, RPOINT, WPOINT, RVALID, RBURST, RFLAG, WFLAG, DQSIN, DLLSTEP, WSTEP, READ, RLOADN, RMOVE, RDIR, WLOADN, WMOVE, WDIR, HOLD, RCLKSEL, PCLK, FCLK, RESET) ;
input DQSIN,PCLK,FCLK,RESET;
input [3:0] READ;
input [2:0] RCLKSEL;
input [7:0] DLLSTEP;
input [7:0] WSTEP;
input RLOADN, RMOVE, RDIR, WLOADN, WMOVE, WDIR, HOLD;
output DQSR90, DQSW0, DQSW270; 
output [2:0] RPOINT, WPOINT;
output RVALID,RBURST, RFLAG, WFLAG;

parameter FIFO_MODE_SEL = "";
parameter RD_PNTR = "";
parameter DQS_MODE = "";
parameter HWL = "";
parameter GSREN = "";


endmodule    


module DLLDLY (CLKOUT, FLAG, DLLSTEP, LOADN, MOVE, DIR, CLKIN)  ;

input CLKIN;
input [7:0] DLLSTEP;
input DIR,LOADN,MOVE;
output CLKOUT;
output FLAG;

parameter DLL_INSEL = "";
parameter DLY_SIGN = "";
parameter DLY_ADJ = "";

endmodule


module FLASH96K (DOUT, DIN, RA, CA, PA, SEQ, MODE, RMODE, WMODE, RBYTESEL, WBYTESEL, PW, ACLK, PE, OE, RESET) ;
input [5:0] RA,CA,PA;
input [3:0] MODE;
input [1:0] SEQ;
input ACLK,PW,RESET,PE,OE;
input [1:0] RMODE,WMODE;
input [1:0] RBYTESEL,WBYTESEL;
input [31:0] DIN;
output [31:0] DOUT;

endmodule


module FLASH256K (DOUT, DIN, XADR, YADR, XE, YE, SE, ERASE, PROG, NVSTR) ;
input[6:0]XADR;
input[5:0]YADR;
input XE,YE,SE;
input ERASE,PROG,NVSTR;
input [31:0] DIN;
output [31:0] DOUT;

endmodule


module FLASH608K (DOUT, DIN, XADR, YADR, XE, YE, SE, ERASE, PROG, NVSTR) ;
input[8:0]XADR;
input[5:0]YADR;
input XE,YE,SE;
input ERASE,PROG,NVSTR;
input [31:0] DIN;
output reg [31:0] DOUT;

endmodule


module DCS (CLKOUT, CLK0, CLK1, CLK2, CLK3, CLKSEL, SELFORCE) ;
input CLK0, CLK1, CLK2, CLK3, SELFORCE;
input [3:0] CLKSEL;
output CLKOUT;

parameter DCS_MODE = "";

endmodule


module DQCE(CLKOUT, CLKIN, CE) ;
input CLKIN;
input CE;
output CLKOUT;

endmodule


module FLASH128K (DOUT, TBIT, DIN, ADDR, PCLK, CS, AE, OE, PROG, SERA, MASE, NVSTR, IFREN, RESETN);
input [31:0] DIN;
input [14:0] ADDR;
input CS,AE,OE;
input PCLK;
input PROG, SERA, MASE;
input NVSTR;
input IFREN;
input RESETN;
output [31:0] DOUT;
output TBIT;

endmodule


module MCU (

  input            FCLK,                      
  input            PORESETN,                  
  input            SYSRESETN,                 
  input            RTCSRCCLK,                 
  output  [15:0]   IOEXPOUTPUTO,              
  output  [15:0]   IOEXPOUTPUTENO,            
  input   [15:0]   IOEXPINPUTI,               
  output           UART0TXDO,                 
  output           UART1TXDO,                 
  output           UART0BAUDTICK,             
  output           UART1BAUDTICK,             
  input            UART0RXDI,                 
  input            UART1RXDI,                 
  output           INTMONITOR,                
  
  
  
  output             MTXHRESETN,            
  output  [12:0]     SRAM0ADDR,             
  output  [3:0]      SRAM0WREN,             
  output  [31:0]     SRAM0WDATA,            
  output             SRAM0CS,               
  input   [31:0]     SRAM0RDATA,            
  
  
  
  
  output              TARGFLASH0HSEL,         
  output  [28:0]      TARGFLASH0HADDR,        
  output   [1:0]      TARGFLASH0HTRANS,       
  output              TARGFLASH0HWRITE,       
  output   [2:0]      TARGFLASH0HSIZE,        
  output   [2:0]      TARGFLASH0HBURST,       
  output   [3:0]      TARGFLASH0HPROT,        
  output   [1:0]      TARGFLASH0MEMATTR,
  output              TARGFLASH0EXREQ,
  output   [3:0]      TARGFLASH0HMASTER,
  output  [31:0]      TARGFLASH0HWDATA,       
  output              TARGFLASH0HMASTLOCK,    
  output              TARGFLASH0HREADYMUX,    
  output              TARGFLASH0HAUSER,       
  output   [3:0]      TARGFLASH0HWUSER,       
  input   [31:0]      TARGFLASH0HRDATA,       
  input    [2:0]      TARGFLASH0HRUSER,       
  input               TARGFLASH0HRESP,        
  input               TARGFLASH0EXRESP,       
  input               TARGFLASH0HREADYOUT,    
  
  output              TARGEXP0HSEL,           
  output  [31:0]      TARGEXP0HADDR,          
  output   [1:0]      TARGEXP0HTRANS,         
  output              TARGEXP0HWRITE,         
  output   [2:0]      TARGEXP0HSIZE,          
  output   [2:0]      TARGEXP0HBURST,         
  output   [3:0]      TARGEXP0HPROT,          
  output   [1:0]      TARGEXP0MEMATTR,
  output              TARGEXP0EXREQ,
  output   [3:0]      TARGEXP0HMASTER,
  output  [31:0]      TARGEXP0HWDATA,         
  output              TARGEXP0HMASTLOCK,      
  output              TARGEXP0HREADYMUX,      
  output              TARGEXP0HAUSER,         
  output   [3:0]      TARGEXP0HWUSER,         
  input   [31:0]      TARGEXP0HRDATA,         
  input               TARGEXP0HREADYOUT,      
  input               TARGEXP0HRESP,          
  input               TARGEXP0EXRESP,
  input    [2:0]      TARGEXP0HRUSER,         
  
  
  
  output  [31:0]      INITEXP0HRDATA,         
  output              INITEXP0HREADY,         
  output              INITEXP0HRESP,          
  output              INITEXP0EXRESP,
  output  [2:0]       INITEXP0HRUSER,         
  input               INITEXP0HSEL,           
  input   [31:0]      INITEXP0HADDR,          
  input    [1:0]      INITEXP0HTRANS,         
  input               INITEXP0HWRITE,         
  input    [2:0]      INITEXP0HSIZE,          
  input    [2:0]      INITEXP0HBURST,         
  input    [3:0]      INITEXP0HPROT,          
  input    [1:0]      INITEXP0MEMATTR,
  input               INITEXP0EXREQ,
  input    [3:0]      INITEXP0HMASTER,
  input   [31:0]      INITEXP0HWDATA,         
  input               INITEXP0HMASTLOCK,      
  input               INITEXP0HAUSER,         
  input    [3:0]      INITEXP0HWUSER,         
  
  output  [3:0]       APBTARGEXP2PSTRB,       
  output  [2:0]       APBTARGEXP2PPROT,       
  output              APBTARGEXP2PSEL,        
  output              APBTARGEXP2PENABLE,     
  output  [11:0]      APBTARGEXP2PADDR,       
  output              APBTARGEXP2PWRITE,      
  output  [31:0]      APBTARGEXP2PWDATA,      
  input    [31:0]     APBTARGEXP2PRDATA,      
  input               APBTARGEXP2PREADY,      
  input               APBTARGEXP2PSLVERR,     
  
  
  
  
  input   [3:0]       MTXREMAP,               
  
  
  
  
  
  output               DAPSWDO,               
  output               DAPSWDOEN,             
  output               DAPTDO,                
  output               DAPJTAGNSW,            
  output               DAPNTDOEN,             
  input                DAPSWDITMS,            
  input                DAPTDI,                
  input                DAPNTRST,              
  input                DAPSWCLKTCK,           
  
  output  [3:0]        TPIUTRACEDATA,         
  output               TPIUTRACESWO,          
  output               TPIUTRACECLK,          
  input                FLASHERR,             
  input                FLASHINT              

 );

 
endmodule


module USB20_PHY(

                DATAOUT,    
                TXREADY,    
                RXACTIVE,   
                RXVLD,      
                RXVLDH,     
                CLK,         
                RXERROR,     
                DP,          
                DM,          
                LINESTATE,   

                DATAIN,    
                TXVLD,     
                TXVLDH,    
                RESET,     
                SUSPENDM,  
                XCVRSEL,   
                TERMSEL,   
                OPMODE,    


                HOSTDIS,    
                IDDIG,     
                ADPPRB,    
                ADPSNS,    
                SESSVLD,    
                VBUSVLD,    
                RXDP,      
                RXDM,      
                RXRCV,     

                IDPULLUP,   
                DPPD,       
                DMPD,       
                CHARGVBUS,  
                DISCHARGVBUS, 
                TXBITSTUFFEN, 
                TXBITSTUFFENH,
                TXENN,      
                TXDAT,           
                TXSE0,           
                FSLSSERIAL, 


                LBKERR,


                CLKRDY,  



                INTCLK, 


                ID,  
                VBUS, 
                REXT,
                XIN,  
                XOUT, 
                CLK480PAD,
                TEST, 

		        SCANOUT1, 
		        SCANOUT2, 
                SCANOUT3, 
		        SCANOUT4, 
		        SCANOUT5, 
                SCANOUT6, 
				SCANCLK, 
				SCANEN,  
				SCANMODE,  
                TRESETN, 
		        SCANIN1,  
		        SCANIN2, 
		        SCANIN3, 
		        SCANIN4, 
		        SCANIN5, 
		        SCANIN6

);

parameter DATABUS16_8 = "";
parameter ADP_PRBEN = "";
parameter TEST_MODE = "";
parameter HSDRV1 = "";
parameter HSDRV0 = "";
parameter CLK_SEL = "";
parameter M = "";
parameter N = "";
parameter C = "";
parameter FOC_LOCK = "";


input   [15:0]  DATAIN;
input   TXVLD;
input   TXVLDH;
input   RESET;
input   SUSPENDM;
input   [1:0]   XCVRSEL;
input   TERMSEL;
input   [1:0]   OPMODE;

output  [15:0]  DATAOUT;
output  TXREADY;
output  RXACTIVE;
output  RXVLD;
output  RXVLDH;
output  CLK;      
output  RXERROR;
inout   DP;
inout   DM;
output  [1:0]   LINESTATE;

input   IDPULLUP;
input   DPPD;
input   DMPD;
input   CHARGVBUS;
input   DISCHARGVBUS;
input   TXBITSTUFFEN;
input   TXBITSTUFFENH;
input   TXENN;
input   TXDAT;
input   TXSE0;
input   FSLSSERIAL;

output  HOSTDIS;
output  IDDIG;
output  ADPPRB;
output  ADPSNS;
output  SESSVLD;
output  VBUSVLD;
output  RXDP;
output  RXDM;
output  RXRCV;

output  LBKERR;

output  CLKRDY;





input   INTCLK;

inout   ID;
inout   VBUS;
inout   REXT;
input   XIN;
inout   XOUT;

input	TEST;
output	CLK480PAD;

input        SCANCLK; 
input        SCANEN; 
input        SCANMODE; 
input        TRESETN; 
input        SCANIN1; 
output       SCANOUT1; 
input        SCANIN2; 
output       SCANOUT2; 
input        SCANIN3; 
output       SCANOUT3; 
input        SCANIN4; 
output       SCANOUT4; 
input        SCANIN5; 
output       SCANOUT5; 
input        SCANIN6; 
output       SCANOUT6; 

endmodule


module ADC(
    ADOUT,	    
    EOC,	    
    CLK,	    
    PD, 	    
    SOC,	    
    SEL,  	    
    CH, 	    
    VREF	    
    );

parameter VREF_EN = "";
parameter VREF_SEL = "";


    output  [11:0]  ADOUT;
    output  EOC;

    input   CLK;
    input   PD;
    input   SOC;
    input   [2:0]   SEL;
    input   [7:0]   CH;
    input   VREF;

endmodule

module SPMI (
	CLK	,
	CLKEXT,
	CE	,
	RESETN	,
	ENEXT,
	LOCRESET,
	PA	,
	SA	,
	CA	,
	ADDRI	,
	DATAI	,
	ADDRO	,
	DATAO	,
	STATE	,
	CMD	,
	SDATA,
	SCLK
);

parameter FUNCTION_CTRL = "";
parameter MSID_CLKSEL = "";
parameter RESPOND_DELAY = "";
parameter SCLK_NORMAL_PERIOD = "";
parameter SCLK_LOW_PERIOD = "";
parameter CLK_FREQ = "";
parameter SHUTDOWN_BY_ENABLE = "";


input	CLKEXT, ENEXT;
inout	SDATA, 	SCLK;


input 	CLK, CE, RESETN, LOCRESET;
input 	PA, SA, CA;
input	[3:0] 	ADDRI;
input	[7:0] 	DATAI;

output 	[3:0] 	ADDRO;
output 	[7:0] 	DATAO;
output 	[15:0] 	STATE;
output	[3:0]	CMD;

endmodule

module SPMI_DEBUG_GOWIN (
	CLK	,
	CLKEXT,
	CE	,
	RESETN	,
	ENEXT,
	LOCRESET,
	PA	,
	SA	,
	CA	,
	ADDRI	,
	DATAI	,
	ADDRO	,
	DATAO	,
	STATE	,
	CMD	,
	SDATA,
	SCLK,
    DEBUG    
);

parameter FUNCTION_CTRL = "";
parameter MSID_CLKSEL = "";
parameter RESPOND_DELAY = "";
parameter SCLK_NORMAL_PERIOD = "";
parameter SCLK_LOW_PERIOD = "";
parameter CLK_FREQ = "";
parameter SHUTDOWN_BY_ENABLE = "";


parameter DEBUG_SETTING = "";


input	CLKEXT, ENEXT;
inout	SDATA, 	SCLK;


input 	CLK, CE, RESETN, LOCRESET;
input 	PA, SA, CA;
input	[3:0] 	ADDRI;
input	[7:0] 	DATAI;

output 	[3:0] 	ADDRO;
output 	[7:0] 	DATAO;
output 	[15:0] 	STATE;
output	[3:0]	CMD;


output	[10:0] DEBUG;

endmodule

module I3C (
	AAC,        
	AAO,        
	AAS,        
	ACC,        
	ACKHS,      
	ACKLS,      
	ACO,        
	ACS,        
	ADDRS,      
	CE,         
	CLK,        
	CMC,        
	CMO,        
	CMS,        
	DI,         
	DO,         
	DOBUF,      
	LGYC,       
	LGYO,       
	LGYS,       
	PARITYERROR,
	RECVDHS,    
	RECVDLS,    
	RESET,      
	SCLI,       
	SCLO,       
	SCLOEN,     
	SCLPULLO,   
	SCLPULLOEN, 
	SDAI,       
	SDAO,       
	SDAOEN,     
	SDAPULLO,   
	SDAPULLOEN, 
	SENDAHS,    
	SENDALS,    
	SENDDHS,    
	SENDDLS,    
	SIC,        
	SIO,        
	STRTC,      
	STRTO,      
	STRTS,      
	STATE,      
	STRTHDS,    
	STOPC,      
	STOPO,      
	STOPS,      
	
	STOPSUS,     
	STOPHDS      

);

parameter ADDRESS = "";

input 	LGYS, CMS, ACS, AAS, STOPS, STRTS;
output 	LGYO, CMO, ACO, AAO, SIO, STOPO, STRTO;
input 	LGYC, CMC, ACC, AAC, SIC, STOPC, STRTC;

input	STRTHDS, SENDAHS, SENDALS, ACKHS;
input	ACKLS, STOPSUS, STOPHDS, SENDDHS;
input	SENDDLS, RECVDHS, RECVDLS, ADDRS;

output	PARITYERROR;
input 	[7:0] DI;
output 	[7:0] DOBUF;
output 	[7:0] DO;
output 	[7:0] STATE;

input	SDAI, SCLI;
output	SDAO, SCLO;
output	SDAOEN, SCLOEN;

output	SDAPULLO, SCLPULLO;
output	SDAPULLOEN, SCLPULLOEN;

input 	CE, RESET, CLK;


endmodule
module DSP56_12X12SUM (DOUT, CASO, A0, B0, A1, B1, CASI, ACCLOAD, ADDSUB, CLK, CE, RESET);

parameter A0REG_CLK = "";
parameter A0REG_CE = "";
parameter A0REG_RESET = "";

parameter A1REG_CLK = "";
parameter A1REG_CE = "";
parameter A1REG_RESET = "";

parameter B0REG_CLK = "";
parameter B0REG_CE = "";
parameter B0REG_RESET = "";

parameter B1REG_CLK = "";
parameter B1REG_CE = "";
parameter B1REG_RESET = "";

parameter ACCLOAD_IREG_CLK = "";
parameter ACCLOAD_IREG_CE = "";
parameter ACCLOAD_IREG_RESET = "";

parameter ADDSUB0_IREG_CLK = "";
parameter ADDSUB0_IREG_CE = "";
parameter ADDSUB0_IREG_RESET = "";

parameter ADDSUB1_IREG_CLK = "";
parameter ADDSUB1_IREG_CE = "";
parameter ADDSUB1_IREG_RESET = "";

parameter PREG0_CLK = "";
parameter PREG0_CE = "";
parameter PREG0_RESET = "";

parameter PREG1_CLK = "";
parameter PREG1_CE = "";
parameter PREG1_RESET = "";

parameter FB_PREG = "";

parameter ACCLOAD_PREG_CLK = "";
parameter ACCLOAD_PREG_CE = "";
parameter ACCLOAD_PREG_RESET = "";

parameter ADDSUB0_PREG_CLK = "";
parameter ADDSUB0_PREG_CE = "";
parameter ADDSUB0_PREG_RESET = "";

parameter ADDSUB1_PREG_CLK = "";
parameter ADDSUB1_PREG_CE = "";
parameter ADDSUB1_PREG_RESET = "";

parameter OREG_CLK = "";
parameter OREG_CE = "";
parameter OREG_RESET = "";

parameter MULT_RESET_MODE = "";
parameter PRE_LOAD = "";
parameter CASI_EN = "";

output [55:0] DOUT, CASO;
input  [11:0] A0, B0, A1, B1;
input  [55:0] CASI;
input  ACCLOAD;
input  [1:0] ADDSUB;
input  [1:0] CLK, CE, RESET;

endmodule

module DSP56_27X18 (DOUT, CASO, SOA, A, B, C, SIA, CASI, ASEL, ACCLOAD, ADDSUB, CLK, CE, RESET);

parameter AREG_CLK = "";
parameter AREG_CE = "";
parameter AREG_RESET = "";

parameter BREG_CLK = "";
parameter BREG_CE = "";
parameter BREG_RESET = "";

parameter CREG_CLK = "";
parameter CREG_CE = "";
parameter CREG_RESET = "";

parameter ADDSUB_IREG_CLK = "";
parameter ADDSUB_IREG_CE = "";
parameter ADDSUB_IREG_RESET = "";

parameter ACCLOAD_IREG_CLK = "";
parameter ACCLOAD_IREG_CE = "";
parameter ACCLOAD_IREG_RESET = "";

parameter PREG_CLK = "";
parameter PREG_CE = "";
parameter PREG_RESET = "";

parameter ADDSUB_PREG_CLK = "";
parameter ADDSUB_PREG_CE = "";
parameter ADDSUB_PREG_RESET = "";

parameter ACCLOAD_PREG_CLK = "";
parameter ACCLOAD_PREG_CE = "";
parameter ACCLOAD_PREG_RESET = "";

parameter FB_PREG = "";
parameter SOA_PREG = "";

parameter OREG_CLK = "";
parameter OREG_CE = "";
parameter OREG_RESET = ""; 

parameter MULT_RESET_MODE = "";
parameter CASI_EN = "";
parameter PRE_LOAD = "";
parameter PADD_EN = "";
parameter PADD_ADDSUB = "";

output [55:0] DOUT, CASO;
output [26:0] SOA;
input  [26:0] A, SIA;
input  [17:0] B;
input  [25:0] C;
input  [55:0] CASI;
input  ACCLOAD, ASEL;
input  ADDSUB;
input  [1:0] CLK, CE, RESET;

endmodule

module DSP56_12X12 (DOUT, A, B, CLK, CE, RESET);

parameter AREG_CLK = "";
parameter AREG_CE = "";
parameter AREG_RESET = "";

parameter BREG_CLK = "";
parameter BREG_CE = "";
parameter BREG_RESET = "";

parameter PREG_CLK = "";
parameter PREG_CE = "";
parameter PREG_RESET = "";

parameter OREG_CLK = "";
parameter OREG_CE = "";
parameter OREG_RESET = "";

parameter MULT_RESET_MODE = "";

output [23:0] DOUT;
input  [11:0] A, B;
input  [1:0] CLK, CE, RESET;

endmodule

module DSP56_27X36 (DOUT, A, B, C, CLK, CE, RESET);

parameter AREG_CLK = "";
parameter AREG_CE = "";
parameter AREG_RESET = "";

parameter BREG_CLK = "";
parameter BREG_CE = "";
parameter BREG_RESET = "";

parameter CREG_CLK = "";
parameter CREG_CE = "";
parameter CREG_RESET = "";

parameter PREG_CLK = "";
parameter PREG_CE = "";
parameter PREG_RESET = "";

parameter OREG_CLK = "";
parameter OREG_CE = "";
parameter OREG_RESET = "";

parameter MULT_RESET_MODE = "";
parameter PADD_EN = "";
parameter PADD_ADDSUB = "";
output [62:0] DOUT;
input  [26:0] A;
input  [35:0] B;
input  [25:0] C;
input  [1:0] CLK, CE, RESET;

endmodule

module BANDGAP( BGEN );
input BGEN;

endmodule

module OSCH (OSCOUT);
parameter  FREQ_DIV = ""; 
output OSCOUT;
endmodule

module FLASH64KZ (DOUT, DIN, XADR, YADR, XE, YE, SE, ERASE, PROG, NVSTR);
input[4:0]XADR;
input[5:0]YADR;
input XE,YE,SE;
input ERASE,PROG,NVSTR;
input [31:0] DIN;
output reg [31:0] DOUT;
endmodule

module rSDP (DO, DI, BLKSEL, ADA, ADB, CLKA, CLKB, CEA, CEB, OCE, RESETA, RESETB);
parameter READ_MODE = ""; 
parameter BIT_WIDTH_0 = ""; 
parameter BIT_WIDTH_1 = ""; 
parameter BLK_SEL = "";
parameter RESET_MODE = ""; 
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLKA, CEA, CLKB, CEB;
input OCE; 
input RESETA, RESETB; 
input [13:0] ADA, ADB;
input [2:0] BLKSEL;
input [31:0] DI;
output [31:0] DO;
endmodule 

module rSDPX9 (DO, DI, BLKSEL, ADA, ADB, CLKA, CLKB, CEA, CEB, OCE, RESETA, RESETB);
parameter READ_MODE = ""; 
parameter BIT_WIDTH_0 = ""; 
parameter BIT_WIDTH_1 = ""; 
parameter BLK_SEL = "";
parameter RESET_MODE = ""; 
parameter INIT_RAM_00 = ""; 
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLKA, CEA, CLKB, CEB;
input OCE; 
input RESETA, RESETB; 
input [13:0] ADA, ADB;
input [2:0] BLKSEL;
input [35:0] DI;
output [35:0] DO;
endmodule 

module rROM (DO, BLKSEL, AD, CLK, CE, OCE, RESET);
parameter READ_MODE = ""; 
parameter BIT_WIDTH = ""; 
parameter BLK_SEL = "";
parameter RESET_MODE = ""; 
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";
input CLK, CE;
input OCE; 
input RESET; 
input [13:0] AD;
input [2:0] BLKSEL;
output [31:0] DO;
endmodule 

module rROMX9 (DO, BLKSEL, AD, CLK, CE, OCE, RESET);
parameter READ_MODE = ""; 
parameter BIT_WIDTH = ""; 
parameter BLK_SEL = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = ""; 
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";
input CLK, CE;
input OCE; 
input RESET; 
input [13:0] AD;
input [2:0] BLKSEL;
output [35:0] DO;
endmodule

module EMCU (
input            FCLK,                      
input            PORESETN,                  
input            SYSRESETN,                 
input            RTCSRCCLK,                 
output  [15:0]   IOEXPOUTPUTO,               
output  [15:0]   IOEXPOUTPUTENO,            
input   [15:0]   IOEXPINPUTI,                
output           UART0TXDO,                 
output           UART1TXDO,                 
output           UART0BAUDTICK,             
output           UART1BAUDTICK,             
input            UART0RXDI,                  
input            UART1RXDI,                 
output           INTMONITOR,                
output             MTXHRESETN,            
output  [12:0]     SRAM0ADDR,             
output  [3:0]      SRAM0WREN,             
output  [31:0]     SRAM0WDATA,            
output             SRAM0CS,               
input   [31:0]     SRAM0RDATA,            
output              TARGFLASH0HSEL,         
output  [28:0]      TARGFLASH0HADDR,        
output   [1:0]      TARGFLASH0HTRANS,       
output   [2:0]      TARGFLASH0HSIZE,        
output   [2:0]      TARGFLASH0HBURST,       
output              TARGFLASH0HREADYMUX,    
input   [31:0]      TARGFLASH0HRDATA,       
input    [2:0]      TARGFLASH0HRUSER,       
input               TARGFLASH0HRESP,        
input               TARGFLASH0EXRESP,       
input               TARGFLASH0HREADYOUT,    
output              TARGEXP0HSEL,           
output  [31:0]      TARGEXP0HADDR,          
output   [1:0]      TARGEXP0HTRANS,         
output              TARGEXP0HWRITE,         
output   [2:0]      TARGEXP0HSIZE,          
output   [2:0]      TARGEXP0HBURST,         
output   [3:0]      TARGEXP0HPROT,          
output   [1:0]      TARGEXP0MEMATTR,
output              TARGEXP0EXREQ,
output   [3:0]      TARGEXP0HMASTER,
output  [31:0]      TARGEXP0HWDATA,         
output              TARGEXP0HMASTLOCK,      
output              TARGEXP0HREADYMUX,      
output              TARGEXP0HAUSER,         
output   [3:0]      TARGEXP0HWUSER,         
input   [31:0]      TARGEXP0HRDATA,         
input               TARGEXP0HREADYOUT,      
input               TARGEXP0HRESP,          
input               TARGEXP0EXRESP,
input    [2:0]      TARGEXP0HRUSER,         
output  [31:0]      INITEXP0HRDATA,         
output              INITEXP0HREADY,         
output              INITEXP0HRESP,          
output              INITEXP0EXRESP,
output  [2:0]       INITEXP0HRUSER,         
input               INITEXP0HSEL,           
input   [31:0]      INITEXP0HADDR,          
input    [1:0]      INITEXP0HTRANS,         
input               INITEXP0HWRITE,         
input    [2:0]      INITEXP0HSIZE,          
input    [2:0]      INITEXP0HBURST,         
input    [3:0]      INITEXP0HPROT,          
input    [1:0]      INITEXP0MEMATTR,
input               INITEXP0EXREQ,
input    [3:0]      INITEXP0HMASTER,
input   [31:0]      INITEXP0HWDATA,         
input               INITEXP0HMASTLOCK,      
input               INITEXP0HAUSER,         
input    [3:0]      INITEXP0HWUSER,         
output  [3:0]       APBTARGEXP2PSTRB,       
output  [2:0]       APBTARGEXP2PPROT,       
output              APBTARGEXP2PSEL,        
output              APBTARGEXP2PENABLE,     
output  [11:0]      APBTARGEXP2PADDR,       
output              APBTARGEXP2PWRITE,      
output  [31:0]      APBTARGEXP2PWDATA,      
input    [31:0]     APBTARGEXP2PRDATA,      
input               APBTARGEXP2PREADY,      
input               APBTARGEXP2PSLVERR,     
input   [3:0]       MTXREMAP,               
output               DAPTDO,                
output               DAPJTAGNSW,            
output               DAPNTDOEN,             
input                DAPSWDITMS,            
input                DAPTDI,                
input                DAPNTRST,              
input                DAPSWCLKTCK,           
output  [3:0]        TPIUTRACEDATA,         
output               TPIUTRACECLK,          
input   [4:0]        GPINT,                  
input                FLASHERR,              
input                FLASHINT               
 );
endmodule

module PLLVR (CLKOUT, CLKOUTP, CLKOUTD, CLKOUTD3, LOCK, CLKIN, CLKFB, FBDSEL, IDSEL, ODSEL, DUTYDA, PSDA, FDLY, RESET, RESET_P, VREN);
input CLKIN;
input CLKFB;
input RESET; 
input RESET_P; 
input [5:0] FBDSEL; 
input [5:0] IDSEL;
input [5:0] ODSEL;
input [3:0] PSDA,FDLY; 
input [3:0] DUTYDA; 
input VREN;

output CLKOUT;
output LOCK;
output CLKOUTP;
output CLKOUTD;
output CLKOUTD3;

parameter FCLKIN = "";
parameter DYN_IDIV_SEL = "";
parameter IDIV_SEL = "";
parameter DYN_FBDIV_SEL = "";
parameter FBDIV_SEL = "";
parameter DYN_ODIV_SEL = "";
parameter ODIV_SEL = "";

parameter PSDA_SEL = "";
parameter DYN_DA_EN = "";
parameter DUTYDA_SEL = "";

parameter CLKOUT_FT_DIR = "";
parameter CLKOUTP_FT_DIR = "";
parameter CLKOUT_DLY_STEP = "";
parameter CLKOUTP_DLY_STEP = "";

parameter CLKFB_SEL = "";
parameter CLKOUT_BYPASS = "";
parameter CLKOUTP_BYPASS = "";
parameter CLKOUTD_BYPASS = "";
parameter DYN_SDIV_SEL = "";
parameter CLKOUTD_SRC = "";
parameter CLKOUTD3_SRC = "";
parameter DEVICE = "";

endmodule

module rPLL (CLKOUT, CLKOUTP, CLKOUTD, CLKOUTD3, LOCK, CLKIN, CLKFB, FBDSEL, IDSEL, ODSEL, DUTYDA, PSDA, FDLY, RESET, RESET_P);
input CLKIN;
input CLKFB;
input RESET; 
input RESET_P; 
input [5:0] FBDSEL; 
input [5:0] IDSEL;
input [5:0] ODSEL;
input [3:0] PSDA,FDLY; 
input [3:0] DUTYDA; 

output CLKOUT;
output LOCK;
output CLKOUTP;
output CLKOUTD;
output CLKOUTD3;

parameter FCLKIN = "";
parameter DYN_IDIV_SEL = "";
parameter IDIV_SEL = "";
parameter DYN_FBDIV_SEL = "";
parameter FBDIV_SEL = "";
parameter DYN_ODIV_SEL = "";
parameter ODIV_SEL = "";

parameter PSDA_SEL = "";
parameter DYN_DA_EN = "";
parameter DUTYDA_SEL = "";

parameter CLKOUT_FT_DIR = "";
parameter CLKOUTP_FT_DIR = "";
parameter CLKOUT_DLY_STEP = "";
parameter CLKOUTP_DLY_STEP = "";

parameter CLKFB_SEL = "";
parameter CLKOUT_BYPASS = "";
parameter CLKOUTP_BYPASS = "";
parameter CLKOUTD_BYPASS = "";
parameter DYN_SDIV_SEL = "";
parameter CLKOUTD_SRC = "";
parameter CLKOUTD3_SRC = "";
parameter DEVICE = "";

endmodule

module IODELAYA (DO, DF, DI, SDTAP, VALUE, SETN)  ;
parameter C_STATIC_DLY = "";
input DI;
input  SDTAP;
input  SETN;
input  VALUE;
output DF;
output DO;
endmodule

module CLKDIV2(CLKOUT, HCLKIN, RESETN) ; 

input HCLKIN;
input RESETN;
output CLKOUT;

parameter GSREN = "";
endmodule

module SDPB (DO, DI, BLKSELA, BLKSELB, ADA, ADB, CLKA, CLKB, CEA, CEB, OCE, RESETA, RESETB)  ;
parameter READ_MODE = "";
parameter BIT_WIDTH_0 = "";
parameter BIT_WIDTH_1 = "";
parameter BLK_SEL_0 = "";
parameter BLK_SEL_1 = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLKA, CEA, CLKB, CEB;
input OCE; 
input RESETA, RESETB; 
input [13:0] ADA, ADB;
input [2:0] BLKSELA,BLKSELB;
input [31:0] DI;
output [31:0] DO;
endmodule 

module SDPX9B (DO, DI, BLKSELA, BLKSELB, ADA, ADB, CLKA, CLKB, CEA, CEB, OCE, RESETA, RESETB)  ;
parameter READ_MODE = "";
parameter BIT_WIDTH_0 = "";
parameter BIT_WIDTH_1 = "";
parameter BLK_SEL_0 = "";
parameter BLK_SEL_1 = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLKA, CEA, CLKB, CEB;
input OCE; 
input RESETA, RESETB; 
input [13:0] ADA, ADB;
input [2:0] BLKSELA, BLKSELB;
input [35:0] DI;
output [35:0] DO;
endmodule 

module DPB (DOA, DOB, DIA, DIB, BLKSELA, BLKSELB, ADA, ADB, WREA, WREB, CLKA, CLKB, CEA, CEB, OCEA, OCEB, RESETA, RESETB)  ;
parameter READ_MODE0 = "";
parameter READ_MODE1 = "";
parameter WRITE_MODE0 = "";
parameter WRITE_MODE1 = "";
parameter BIT_WIDTH_0 = "";
parameter BIT_WIDTH_1 = "";
parameter BLK_SEL_0 = "";
parameter BLK_SEL_1 = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLKA, CEA, CLKB, CEB;
input OCEA, OCEB; 
input RESETA, RESETB; 
input WREA, WREB; 
input [13:0] ADA, ADB;
input [2:0] BLKSELA, BLKSELB;
input [15:0] DIA, DIB;
output [15:0] DOA, DOB;
endmodule 

module DPX9B (DOA, DOB, DIA, DIB, BLKSELA, BLKSELB, ADA, ADB, WREA, WREB, CLKA, CLKB, CEA, CEB, OCEA, OCEB, RESETA, RESETB)  ;
parameter READ_MODE0 = "";
parameter READ_MODE1 = "";
parameter WRITE_MODE0 = "";
parameter WRITE_MODE1 = "";
parameter BIT_WIDTH_0 = "";
parameter BIT_WIDTH_1 = "";
parameter BLK_SEL_0 = "";
parameter BLK_SEL_1 = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";

input CLKA, CEA, CLKB, CEB;
input OCEA, OCEB; 
input RESETA, RESETB; 
input WREA, WREB; 
input [13:0] ADA, ADB;
input [2:0] BLKSELA, BLKSELB;
input [17:0] DIA, DIB;
output [17:0] DOA, DOB;
endmodule

module pROM (DO, AD, CLK, CE, OCE, RESET)  ;
parameter READ_MODE = "";
parameter BIT_WIDTH = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";
input CLK, CE;
input OCE; 
input RESET; 
input [13:0] AD;
output [31:0] DO;
endmodule

module pROMX9 (DO, AD, CLK, CE, OCE, RESET)  ;
parameter READ_MODE = "";
parameter BIT_WIDTH = "";
parameter RESET_MODE = "";
parameter INIT_RAM_00 = "";
parameter INIT_RAM_01 = "";
parameter INIT_RAM_02 = "";
parameter INIT_RAM_03 = "";
parameter INIT_RAM_04 = "";
parameter INIT_RAM_05 = "";
parameter INIT_RAM_06 = "";
parameter INIT_RAM_07 = "";
parameter INIT_RAM_08 = "";
parameter INIT_RAM_09 = "";
parameter INIT_RAM_0A = "";
parameter INIT_RAM_0B = "";
parameter INIT_RAM_0C = "";
parameter INIT_RAM_0D = "";
parameter INIT_RAM_0E = "";
parameter INIT_RAM_0F = "";
parameter INIT_RAM_10 = "";
parameter INIT_RAM_11 = "";
parameter INIT_RAM_12 = "";
parameter INIT_RAM_13 = "";
parameter INIT_RAM_14 = "";
parameter INIT_RAM_15 = "";
parameter INIT_RAM_16 = "";
parameter INIT_RAM_17 = "";
parameter INIT_RAM_18 = "";
parameter INIT_RAM_19 = "";
parameter INIT_RAM_1A = "";
parameter INIT_RAM_1B = "";
parameter INIT_RAM_1C = "";
parameter INIT_RAM_1D = "";
parameter INIT_RAM_1E = "";
parameter INIT_RAM_1F = "";
parameter INIT_RAM_20 = "";
parameter INIT_RAM_21 = "";
parameter INIT_RAM_22 = "";
parameter INIT_RAM_23 = "";
parameter INIT_RAM_24 = "";
parameter INIT_RAM_25 = "";
parameter INIT_RAM_26 = "";
parameter INIT_RAM_27 = "";
parameter INIT_RAM_28 = "";
parameter INIT_RAM_29 = "";
parameter INIT_RAM_2A = "";
parameter INIT_RAM_2B = "";
parameter INIT_RAM_2C = "";
parameter INIT_RAM_2D = "";
parameter INIT_RAM_2E = "";
parameter INIT_RAM_2F = "";
parameter INIT_RAM_30 = "";
parameter INIT_RAM_31 = "";
parameter INIT_RAM_32 = "";
parameter INIT_RAM_33 = "";
parameter INIT_RAM_34 = "";
parameter INIT_RAM_35 = "";
parameter INIT_RAM_36 = "";
parameter INIT_RAM_37 = "";
parameter INIT_RAM_38 = "";
parameter INIT_RAM_39 = "";
parameter INIT_RAM_3A = "";
parameter INIT_RAM_3B = "";
parameter INIT_RAM_3C = "";
parameter INIT_RAM_3D = "";
parameter INIT_RAM_3E = "";
parameter INIT_RAM_3F = "";
input CLK, CE;
input OCE; 
input RESET; 
input [13:0] AD;
output [35:0] DO;
endmodule

module FLASH64K (DOUT, DIN, XADR, YADR, XE, YE, SE, ERASE, PROG, NVSTR, SLEEP);
input[4:0] XADR;
input[5:0] YADR;
input XE,YE,SE;
input ERASE,PROG,NVSTR;
input [31:0] DIN;
input SLEEP;
output reg [31:0] DOUT;
endmodule
