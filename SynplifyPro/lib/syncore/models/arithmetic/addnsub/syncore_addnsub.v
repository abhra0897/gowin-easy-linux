// -----------------------------------------------------------------------------
// ---
// ---                 (C) COPYRIGHT 2001-2010 SYNOPSYS, INC.
// ---                           ALL RIGHTS RESERVED
// ---
// --- This software and the associated documentation are confidential and
// --- proprietary to Synopsys, Inc.  Your use or disclosure of this
// --- software is subject to the terms and conditions of a written
// --- license agreement between you, or your company, and Synopsys, Inc.
// ---
// --- The entire notice above must be reproduced on all authorized copies.
// ---
// --- RCS information:
// ---    $Author$
// ---    $DateTime$
// ---    $Revision$
// ---    $Id$
// ---
// --- IP Description :This Module infers Generic Adder_Subtractor for Xilinx, 
//                     Altera, Actel Devices
// -----------------------------------------------------------------------------

`timescale 1ns/100ps

module Syncore_ADDnSUB 
				#(
					parameter	PORT_A_WIDTH 	= 18,
					parameter	PORT_B_WIDTH 	= 18,
					parameter	CONSTANT_PORT 	= 0,			//Can be 0, 1
					parameter	CONSTANT_VALUE 	= 0,
					parameter	PORT_OUT_WIDTH 	= 18,
					parameter 	ADD_N_SUB 		= "DYNAMIC", 	//Can be ADD, SUB, DYNAMIC
					parameter	RESET_TYPE 	= 0,			//Can be 0, 1
					parameter 	PORTA_PIPELINE_STAGE 	= 1, 	//Can be 0, 1
					parameter 	PORTB_PIPELINE_STAGE 	= 1, 	//Can be 0, 1
					parameter 	PORTOUT_PIPELINE_STAGE 	= 1 	//Can be 0, 1
				)

				( 	
					input 	PortClk,
					input 	[PORT_A_WIDTH-1 : 0] PortA, 
					input 	[PORT_B_WIDTH-1 : 0] PortB, 
					input 	PortCEA,
					input 	PortCEB,
					input 	PortCEOut, 
					input 	PortRSTA, 
					input 	PortRSTB,
					input 	PortRSTOut,
					input 	PortCarryIn, 
					input 	PortADDnSUB,
					
					output 	[PORT_OUT_WIDTH-1 : 0] PortOut 
				);

	reg 	[PORT_A_WIDTH-1 : 0] A;
	reg 	[PORT_B_WIDTH-1 : 0] B;
	reg  	[PORT_A_WIDTH-1 : 0] AValReg;
	reg  	[PORT_B_WIDTH-1 : 0] BValReg;
	reg  	[PORT_A_WIDTH-1 : 0] AValReg_asyn;
	reg  	[PORT_B_WIDTH-1 : 0] BValReg_asyn;
	
	reg  	[PORT_OUT_WIDTH-1 : 0] Out;
	reg  	[PORT_OUT_WIDTH-1 : 0] Out_reg;
	reg  	[PORT_OUT_WIDTH-1 : 0] Out_reg_asyn;
	

/****************************** A PORT ***************************************/ 

// Synchronous
	always @ (posedge PortClk)
	if (PortRSTA) 
		AValReg <= 'd0;
	else if (PortCEA)
		AValReg <= PortA;

//Asynchronous

	always @ (posedge PortClk or posedge PortRSTA) 
	if (PortRSTA) 
		AValReg_asyn <= 'd0;
	else if (PortCEA)
		AValReg_asyn <= PortA;

/*****************************************************************************/

/****************************** B PORT ***************************************/ 

// Synchronous
	always @ (posedge PortClk)
	if (PortRSTB) 
		BValReg <= 'd0;
	else if (PortCEB)
		BValReg <= PortB;

//Asynchronous

	always @ (posedge PortClk or posedge PortRSTB) 
	if (PortRSTB) 
		BValReg_asyn <= 'd0;
	else if (PortCEB)
		BValReg_asyn <= PortB;

/*****************************************************************************/

/************************** Output Pipeline stage  **************************/ 

// Synchronous
	always @ (posedge PortClk)
	if (PortRSTOut) 
		Out_reg <= 'd0;
	else if (PortCEOut)
		Out_reg <= Out;

//Asynchronous

	always @ (posedge PortClk or posedge PortRSTOut) 
	if (PortRSTOut) 
		Out_reg_asyn <= 'd0;
	else if (PortCEOut)
		Out_reg_asyn <= Out;

//Assignment

	always @ (*)
	begin
		A <= PORTA_PIPELINE_STAGE ? ( RESET_TYPE? AValReg_asyn : AValReg) : PortA;

		B <= CONSTANT_PORT ? CONSTANT_VALUE : (PORTB_PIPELINE_STAGE ? ( RESET_TYPE? BValReg_asyn : BValReg) : PortB );
	end

	assign PortOut = PORTOUT_PIPELINE_STAGE ? ( RESET_TYPE? Out_reg_asyn : Out_reg) : Out;
	

/*****************************************************************************/

/******************************** ADD/SUB ************************************/ 

	always @ (*)
	begin

		if ( ADD_N_SUB =="DYNAMIC" )
		begin
			if(PortADDnSUB)
	    	  	Out <= A - B - PortCarryIn;
	    	else 
			Out <= A + B + PortCarryIn;
	 	end
		else if (ADD_N_SUB =="SUB" )
			Out <= A - B - PortCarryIn;
	 	else 
			Out <= A + B + PortCarryIn;
	end

/*****************************************************************************/

endmodule

	
