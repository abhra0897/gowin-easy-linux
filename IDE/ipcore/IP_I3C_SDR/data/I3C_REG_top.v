`timescale      1 ns    / 1 ps

`include "define.v"

module `MODULE_NAME (
	LGYS, CMS, ACS, AAS, STOS, STAS,
	LGYO, CMO, ACO, AAO, SIO, STOO, STAO,
	LGYC, CMC, ACC, AAC, SIC, STOC, STAC,
	STA_HD_S,
	SEND_AD_HIGH_S,
	SEND_AD_LOW_S,
	ACK_HIGH_S,
	ACK_LOW_S,
	STO_HIGH_S,
	STO_LOW_S,
	SEND_DA_HIGH_S,
	SEND_DA_LOW_S,
	RCVE_DA_HIGH_S,
	RCVE_DA_LOW_S,
	ADDRESS_S,
	PARITYERROR,
	DI, DOBUF, DO, STATE,
	SCLH, SCLL,
	SDA, SCL, SDA_PULL, SCL_PULL,
	CE, RST, CLK
	`ifdef DEBUG_REG
	,dbg_ABTR
	`endif
);
	`ifdef DEBUG_REG
	output dbg_ABTR;
	`endif
    input 	LGYS, CMS, ACS, AAS, STOS, STAS;
    output 	LGYO, CMO, ACO, AAO, SIO, STOO, STAO;
    input 	LGYC, CMC, ACC, AAC, SIC, STOC, STAC;
    input	STA_HD_S,
        SEND_AD_HIGH_S,
        SEND_AD_LOW_S,
        ACK_HIGH_S,
        ACK_LOW_S,
        STO_HIGH_S,
        STO_LOW_S,
        SEND_DA_HIGH_S,
        SEND_DA_LOW_S,
        RCVE_DA_HIGH_S,
        RCVE_DA_LOW_S,
        ADDRESS_S;
    output	PARITYERROR;
    input 	[7:0] DI;
    output 	[7:0] DOBUF, DO, STATE;
    input 	[7:0] SCLH, SCLL;
    inout	SDA, SCL;
    output	SDA_PULL, SCL_PULL;
    input 	CE, RST, CLK;

    `getname(I3C_REG,`MODULE_NAME) u_i3c_top_inst(
        .LGYS(LGYS), .CMS(CMS), .ACS(ACS), .AAS(AAS), .STOS(STOS), .STAS(STAS),
        .LGYO(LGYO), .CMO(CMO), .ACO(ACO), .AAO(AAO), .SIO(SIO), .STOO(STOO), .STAO(STAO),
        .LGYC(LGYC), .CMC(CMC), .ACC(ACC), .AAC(AAC), .SIC(SIC), .STOC(STOC), .STAC(STAC),	
        .STA_HD_S(STA_HD_S),
        .SEND_AD_HIGH_S(SEND_AD_HIGH_S),
        .SEND_AD_LOW_S(SEND_AD_LOW_S),
        .ACK_HIGH_S(ACK_HIGH_S),
        .ACK_LOW_S(ACK_LOW_S),
        .STO_HIGH_S(STO_HIGH_S),
        .STO_LOW_S(STO_LOW_S),
        .SEND_DA_HIGH_S(SEND_DA_HIGH_S),
        .SEND_DA_LOW_S(SEND_DA_LOW_S),
        .RCVE_DA_HIGH_S(RCVE_DA_HIGH_S),
        .RCVE_DA_LOW_S(RCVE_DA_LOW_S),
        .ADDRESS_S(ADDRESS_S),
        .PARITYERROR(PARITYERROR),	
        .DI(DI), .DOBUF(DOBUF), .DO(DO), .STATE(STATE),
        .SCLH(SCLH), .SCLL(SCLL),
        .SDA(SDA), .SCL(SCL), .SDA_PULL(SDA_PULL), .SCL_PULL(SCL_PULL),
        .CE(CE), .RST(RST), .CLK(CLK)
        `ifdef DEBUG_REG
            ,.dbg_ABTR(dbg_ABTR)
        `endif
        );
        defparam u_i3c_top_inst.iregInterface.P_STA_HD_default 				= `STA_HD;
        defparam u_i3c_top_inst.iregInterface.P_SCL_LOW_default				= `SCL_LOW;
        defparam u_i3c_top_inst.iregInterface.P_SCL_HIGH_default			= `SCL_HIGH;
        defparam u_i3c_top_inst.iregInterface.P_CM_SEND_AD_SCL_HIGH_default	= `CM_SEND_AD_SCL_HIGH;
        defparam u_i3c_top_inst.iregInterface.P_CM_SEND_AD_SCL_LOW_default	= `CM_SEND_AD_SCL_LOW;
        defparam u_i3c_top_inst.iregInterface.P_CM_ACK_SCL_HIGH_default     = `CM_ACK_SCL_HIGH;
        defparam u_i3c_top_inst.iregInterface.P_CM_ACK_SCL_LOW_default      = `CM_ACK_SCL_LOW;
        defparam u_i3c_top_inst.iregInterface.P_CM_STO_SCL_HIGH_default     = `CM_STO_SCL_HIGH;
        defparam u_i3c_top_inst.iregInterface.P_CM_STO_SCL_LOW_default      = `CM_STO_SCL_LOW;
        defparam u_i3c_top_inst.iregInterface.P_CM_SEND_DA_SCL_HIGH_default	= `CM_SEND_DA_SCL_HIGH;
        defparam u_i3c_top_inst.iregInterface.P_CM_SEND_DA_SCL_LOW_default	= `CM_SEND_DA_SCL_LOW;
        defparam u_i3c_top_inst.iregInterface.P_CM_RCVE_DA_SCL_HIGH_default	= `CM_RCVE_DA_SCL_HIGH;
        defparam u_i3c_top_inst.iregInterface.P_CM_RCVE_DA_SCL_LOW_default	= `CM_RCVE_DA_SCL_LOW;
        defparam u_i3c_top_inst.iregInterface.P_SLAVE_STATIC_ADDRESS		= `SLAVE_STATIC_ADDRESS;
endmodule
