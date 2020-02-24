//$Header: //synplicity/map610devqscm/thirdparty/generic_technology/gtech.v#1 $
//--------------------------------------------------------------------------------------------------
//
// Title       : gtech.v
// Design      : GTECH
// Author      : Harish M K
// Company     : Synplicity Software Pvt. Ltd.
//
//-------------------------------------------------------------------------------------------------
//
// Description : This generic technology library contains common logic elements.
//
//-------------------------------------------------------------------------------------------------
`timescale 1ns / 10ps

module GTECH_NOT ( A, Z );
	input  A;
	output Z;
	
	assign Z = ~A;
	
endmodule

module GTECH_BUF ( A, Z );
	input  A;
	output Z;
	
	assign Z = A;
	
endmodule

module GTECH_AND2 ( A, B, Z );
	input  A;
	input  B;
	output Z;
	
	assign Z = A & B;
	
endmodule

module GTECH_AND3 ( A, B, C, Z );
	input  A;
	input  B;
	input  C;
	output Z;
	
	assign Z = A & B & C;
	
endmodule

module GTECH_AND4 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = A & B & C & D;
	
endmodule

module GTECH_AND5 ( A, B, C, D, E, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	input  E;
	output Z;
	
	assign Z = A & B & C & D & E;
	
endmodule  

module GTECH_AND8 ( A, B, C, D, E, F, G, H, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	input  E;
	input  F;
	input  G;
	input  H;
	output Z;
	
	assign Z = A & B & C & D & E & F & G & H;
	
endmodule  

module GTECH_NAND2 ( A, B, Z );
	input  A;
	input  B;
	output Z;
	
	assign Z = ~(A & B);
	
endmodule

module GTECH_NAND3 ( A, B, C, Z );
	input  A;
	input  B;
	input  C;
	output Z;
	
	assign Z = ~(A & B & C);
	
endmodule

module GTECH_NAND4 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = ~(A & B & C & D);
	
endmodule

module GTECH_NAND5 ( A, B, C, D, E, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	input  E;
	output Z;
	
	assign Z = ~(A & B & C & D & E);
	
endmodule  

module GTECH_NAND8 ( A, B, C, D, E, F, G, H, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	input  E;
	input  F;
	input  G;
	input  H;
	output Z;
	
	assign Z = ~(A & B & C & D & E & F & G & H);
	
endmodule 

module GTECH_OR2 ( A, B, Z );
	input  A;
	input  B;
	output Z;
	
	assign Z = A | B;
	
endmodule

module GTECH_OR3 ( A, B, C, Z );
	input  A;
	input  B;
	input  C;
	output Z;
	
	assign Z = A | B | C;
	
endmodule

module GTECH_OR4 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = A | B | C | D;
	
endmodule

module GTECH_OR5 ( A, B, C, D, E, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	input  E;
	output Z;
	
	assign Z = A | B | C | D | E;
	
endmodule  

module GTECH_OR8 ( A, B, C, D, E, F, G, H, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	input  E;
	input  F;
	input  G;
	input  H;
	output Z;
	
	assign Z = A | B | C | D | E | F | G | H;
	
endmodule 

module GTECH_NOR2 ( A, B, Z );
	input  A;
	input  B;
	output Z;
	
	assign Z = ~(A | B);
	
endmodule

module GTECH_NOR3 ( A, B, C, Z );
	input  A;
	input  B;
	input  C;
	output Z;
	
	assign Z = ~(A | B | C);
	
endmodule

module GTECH_NOR4 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = ~(A | B | C | D);
	
endmodule

module GTECH_NOR5 ( A, B, C, D, E, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	input  E;
	output Z;
	
	assign Z = ~(A | B | C | D | E);
	
endmodule  

module GTECH_NOR8 ( A, B, C, D, E, F, G, H, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	input  E;
	input  F;
	input  G;
	input  H;
	output Z;
	
	assign Z = ~(A | B | C | D | E | F | G | H);
	
endmodule 

module GTECH_XOR2 ( A, B, Z );
	input  A;
	input  B;
	output Z;
	
	assign Z = A ^ B;
	
endmodule

module GTECH_XOR3 ( A, B, C, Z );
	input  A;
	input  B;
	input  C;
	output Z;
	
	assign Z = A ^ B ^ C;
	
endmodule

module GTECH_XOR4 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = A ^ B ^ C ^ D;
	
endmodule

module GTECH_XNOR2 ( A, B, Z );
	input  A;
	input  B;
	output Z;
	
	assign Z = ~(A ^ B);
	
endmodule

module GTECH_XNOR3 ( A, B, C, Z );
	input  A;
	input  B;
	input  C;
	output Z;
	
	assign Z = ~(A ^ B ^ C);
	
endmodule

module GTECH_XNOR4 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = ~(A ^ B ^ C ^ D);
	
endmodule	 

module GTECH_AND_NOT ( A, B, Z );
	input  A;
	input  B;
	output Z;
	
	assign Z = A & ~B;
	
endmodule

module GTECH_OR_NOT ( A, B, Z );
	input  A;
	input  B;
	output Z;
	
	assign Z = A | ~B;
	
endmodule

module GTECH_AO21 ( A, B, C, Z );
	input  A;
	input  B;
	input  C;
	output Z;
	
	assign Z = (A & B) | C;
	
endmodule

module GTECH_AO22 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = (A & B) | (C & D);
	
endmodule  

module GTECH_AOI21 ( A, B, C, Z );
	input  A;
	input  B;
	input  C;
	output Z;
	
	assign Z = ~((A & B) | C);
	
endmodule

module GTECH_AOI22 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = ~((A & B) | (C & D));
	
endmodule  

module GTECH_AOI222 ( A, B, C, D, E, F, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	input  E;
	input  F;
	output Z;
	
	assign Z = ~((A & B) | (C & D) | (E & F));
	
endmodule  

module GTECH_AOI2N2 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = ~((A & B) | ~(C | D));
	
endmodule

module GTECH_OA21 ( A, B, C, Z );
	input  A;
	input  B;
	input  C;
	output Z;
	
	assign Z = (A | B) & C;
	
endmodule

module GTECH_OA22 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = (A | B) & (C | D);
	
endmodule  

module GTECH_OAI21 ( A, B, C, Z );
	input  A;
	input  B;
	input  C;
	output Z;
	
	assign Z = ~((A | B) & C);
	
endmodule

module GTECH_OAI22 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = ~((A | B) & (C | D));
	
endmodule  

module GTECH_OAI2N2 ( A, B, C, D, Z );
	input  A;
	input  B;
	input  C;
	input  D;
	output Z;
	
	assign Z = ~((A | B) & ~(C & D));
	
endmodule

module GTECH_MAJ23 ( A, B, C, Z );
	input A;
	input B;
	input C;
	output Z;
	
	assign Z = (A & B)|( B & C )|(C & A );
	
endmodule	

module GTECH_MUX2 ( A, B, S, Z );
	input  A;
	input  B;
	input  S;
	output Z;
	
	assign Z = ( A & ~S) | ( B & S );
	
endmodule

module GTECH_MUXI2 ( A, B, S, Z );
	input  A;
	input  B;
	input  S;
	output Z;
	
	assign Z = ( ~A & ~S ) | ( ~B & S );
	
endmodule

module GTECH_MUX4 ( D0, D1, D2, D3, A, B, Z );
	input  D0;
	input  D1;
	input  D2;
	input  D3; 	
	input  A;
	input  B;
	output Z;
	
	assign Z = ( ~A & ~B & D0 ) | ( ~B & A & D1 ) | ( B & ~A & D2 ) | ( B & A & D3 );
	
endmodule

module GTECH_MUX8 ( D0, D1, D2, D3, D4, D5, D6, D7, A, B, C, Z );
	input  D0;
	input  D1;
	input  D2;
	input  D3; 	
	input  D4;
	input  D5;
	input  D6;
	input  D7; 	
	input  A;
	input  B;
	input  C;
	output Z;
	wire N1, N2;		  
	
	GTECH_MUX4 U1 ( .D0(D0), .D1(D1), .D2(D2), .D3(D3), .A(A), .B(B), .Z(N1) ); 
	GTECH_MUX4 U2 ( .D0(D4), .D1(D5), .D2(D6), .D3(D7), .A(A), .B(B), .Z(N2) ); 
    GTECH_MUX2 U3( .A(N1), .B(N2), .S(C), .Z(Z) );	
	
endmodule

module GTECH_ADD_AB ( A, B, S, COUT );
	input  A;
	input  B;
	output S;
	output COUT;
	
	assign S = A ^ B;
	assign COUT = A & B;

endmodule

module GTECH_ADD_ABC ( A, B, C, S, COUT );
	input  A;
	input  B;
	input  C;
	output S;
	output COUT;
	
	assign S = A ^ B ^ C;
	assign COUT = (A & B ) | (B & C) | (C & A);

endmodule

module GTECH_TBUF ( A, E, Z );
	input  A;
	input  E;
	output Z;
	
	bufif1( Z, A, E );

endmodule

module GTECH_INBUF ( PAD_IN, DATA_IN );
	input  PAD_IN;
	output DATA_IN;
	
	wire DATA_IN;	 
	
	buf (DATA_IN, PAD_IN);

endmodule

module GTECH_OUTBUF ( DATA_OUT, OE, PAD_OUT );
	input  DATA_OUT;
	input  OE;
	output PAD_OUT;
	wire PAD_OUT; 
	
	bufif1(PAD_OUT, DATA_OUT, OE );
	
endmodule

module GTECH_INOUTBUF ( DATA_OUT, OE, PAD_INOUT, DATA_IN );
	input  DATA_OUT;
	input  OE;
	output DATA_IN;
	inout  PAD_INOUT;
	
	wire PAD_INOUT;
	
	buf (DATA_IN,PAD_INOUT);  
	bufif1 (PAD_INOUT, DATA_OUT, OE);
		
endmodule 

module GTECH_FD1 ( D, CP, Q, QN );
	input  D;
	input  CP;
	output Q;
	output QN; 
	
	reg  Q;
	reg  QN;
	
	always @ ( posedge CP )
		begin
			Q <= D;
			QN <= ~D;
		end	  
	
endmodule

module GTECH_FD14 ( D0, D1, D2, D3, CP, Q0, Q1, Q2, Q3, QN0, QN1, QN2, QN3 );
	input  D0;
	input  D1;
	input  D2;
	input  D3;
	input  CP;
	output Q0;
	output Q1;
	output Q2;
	output Q3;
	output QN0;
	output QN1;
	output QN2;
	output QN3;
	
	reg Q0;
	reg Q1;
	reg Q2;
	reg Q3;
	reg QN0;
	reg QN1;
	reg QN2;
	reg QN3;	
	
	always @ ( posedge CP )
		begin
			Q0  <= D0;
			QN0 <= ~D0;
			Q1  <= D1;
			QN1 <= ~D1;
			Q2  <= D2;
			QN2 <= ~D2;
			Q3  <= D3;
			QN3 <= ~D3;
		end	  
	
endmodule

module GTECH_FD18 ( D0, D1, D2, D3, D4, D5, D6, D7, CP, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, QN0, QN1, QN2, QN3, QN4, QN5, QN6, QN7 );
	input  D0;
	input  D1;
	input  D2;
	input  D3;
	input  D4;
	input  D5;
	input  D6;
	input  D7;
	input  CP;
	output Q0;
	output Q1;
	output Q2;
	output Q3;
	output Q4;
	output Q5;
	output Q6;
	output Q7;
	output QN0;
	output QN1;
	output QN2;
	output QN3;
	output QN4;
	output QN5;
	output QN6;
	output QN7;
	
	reg Q0;
	reg Q1;
	reg Q2;
	reg Q3;
	reg Q4;
	reg Q5;
	reg Q6;
	reg Q7;
	reg QN0;
	reg QN1;
	reg QN2;
	reg QN3;	
	reg QN4;
	reg QN5;
	reg QN6;
	reg QN7;	
	
	always @ ( posedge CP )
		begin
			Q0  <= D0;
			QN0 <= ~D0;
			Q1  <= D1;
			QN1 <= ~D1;
			Q2  <= D2;
			QN2 <= ~D2;
			Q3  <= D3;
			QN3 <= ~D3;
			Q4  <= D4;
			QN4 <= ~D4;
			Q5  <= D5;
			QN5 <= ~D5;
			Q6  <= D6;
			QN6 <= ~D6;
			Q7  <= D7;
			QN7 <= ~D7;
		end	  
	
endmodule
	
module GTECH_FD1S ( D, TI, TE, CP, Q, QN );
	input  D;
	input  TI;
	input  TE;
	input  CP;
	output Q;
	output QN;							
	
	reg Q;
	reg QN;	
	wire d_in;
	
	assign d_in = TE ? TI : D;
	
	always @( posedge CP )
		begin
			Q <= d_in;
			QN <= ~d_in;
		end
		
endmodule	

module GTECH_FD2 ( D, CD, CP, Q, QN );
	input  D;
	input  CD;
	input  CP;
	output Q;
	output QN;							
	
	reg Q;
	reg QN;	
	
	always @( posedge CP or negedge CD )
		if ( !CD )
			begin
				Q <= 1'b0;
				QN <= 1'b1;
			end
		else
			begin
				Q <= D;
				QN <= ~D;
			end
		
endmodule	

module GTECH_FD24 ( D0, D1, D2, D3, CP, CD, Q0, Q1, Q2, Q3, QN0, QN1, QN2, QN3 );
	input  D0;
	input  D1;
	input  D2;
	input  D3;
	input  CP;
	input  CD;
	output Q0;
	output Q1;
	output Q2;
	output Q3;
	output QN0;
	output QN1;
	output QN2;
	output QN3;
	
	reg Q0;
	reg Q1;
	reg Q2;
	reg Q3;
	reg QN0;
	reg QN1;
	reg QN2;
	reg QN3;	
	
	always @ ( posedge CP or negedge CD )
		if ( !CD )
			begin
				Q0  <= 0;
				QN0 <= 1;
				Q1  <= 0;
				QN1 <= 1;
				Q2  <= 0;
				QN2 <= 1;
				Q3  <= 0;
				QN3 <= 1;				
			end
		else
			begin
				Q0  <= D0;
				QN0 <= ~D0;
				Q1  <= D1;
				QN1 <= ~D1;
				Q2  <= D2;
				QN2 <= ~D2;
				Q3  <= D3;
				QN3 <= ~D3;
			end	  
	
endmodule
		
module GTECH_FD28 ( D0, D1, D2, D3, D4, D5, D6, D7, CP, CD, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, QN0, QN1, QN2, QN3, QN4, QN5, QN6, QN7 );
	input  D0;
	input  D1;
	input  D2;
	input  D3;
	input  D4;
	input  D5;
	input  D6;
	input  D7;
	input  CP;
	input  CD;
	output Q0;
	output Q1;
	output Q2;
	output Q3;
	output Q4;
	output Q5;
	output Q6;
	output Q7;
	output QN0;
	output QN1;
	output QN2;
	output QN3;
	output QN4;
	output QN5;
	output QN6;
	output QN7;
	
	reg Q0;
	reg Q1;
	reg Q2;
	reg Q3;
	reg Q4;
	reg Q5;
	reg Q6;
	reg Q7;
	reg QN0;
	reg QN1;
	reg QN2;
	reg QN3;	
	reg QN4;
	reg QN5;
	reg QN6;
	reg QN7;	
	
	always @ ( posedge CP or negedge CD )
		if ( !CD )
			begin
			Q0  <= 0;
			QN0 <= 1;
			Q1  <= 0;
			QN1 <= 1;
			Q2  <= 0;
			QN2 <= 1;
			Q3  <= 0;
			QN3 <= 1;
			Q4  <= 0;
			QN4 <= 1;
			Q5  <= 0;
			QN5 <= 1;
			Q6  <= 0;
			QN6 <= 1;
			Q7  <= 0;
			QN7 <= 1;		
			end	
		else
			begin            
				Q0  <= D0;   
				QN0 <= ~D0;  
				Q1  <= D1;   
				QN1 <= ~D1;  
				Q2  <= D2;   
				QN2 <= ~D2;  
				Q3  <= D3;   
				QN3 <= ~D3;  
				Q4  <= D4;   
				QN4 <= ~D4;  
				Q5  <= D5;   
				QN5 <= ~D5;  
				Q6  <= D6;   
				QN6 <= ~D6;  
				Q7  <= D7;   
				QN7 <= ~D7;  
			end
	
endmodule
	
module GTECH_FD2S ( D, TI, TE, CP, CD, Q, QN );
	input  D;
	input  TI;
	input  TE;
	input  CP;
	input  CD;
	output Q;
	output QN;							
	
	reg Q;
	reg QN;	
	wire d_in;
	
	assign d_in = TE ? TI : D;
	
	always @( posedge CP or negedge CD )
		if ( !CD )
			begin
				Q <= 1'b0;
				QN <= 1'b1;
			end
		else	
			begin
				Q <= d_in;
				QN <= ~d_in;
			end
		
endmodule

module GTECH_FD3 ( D, CD, SD, CP, Q, QN );
	input  D;
	input  CD;
	input  SD;
	input  CP;
	output Q;
	output QN;							
	
	reg Q;
	reg QN;	
	
	always @( posedge CP or negedge CD or negedge SD )
		case ( {CD,SD} )
			2'b00: begin
				Q <= 1'b0;
				QN <= 1'b0;
			end
			2'b01:begin
				Q <= 1'b0;
				QN <= 1'b1;
			end
			2'b10:begin
				Q <= 1'b1;
				QN <= 1'b0;
			end			  
			2'b11:begin
				Q <= D;
				QN <= ~D;
			end	  
		endcase	
		
endmodule	

module GTECH_FD34 ( D0, D1, D2, D3, CP, CD, SD, Q0, Q1, Q2, Q3, QN0, QN1, QN2, QN3 );
	input  D0;
	input  D1;
	input  D2;
	input  D3;
	input  CP;
	input  CD;
	input  SD;
	output Q0;
	output Q1;
	output Q2;
	output Q3;
	output QN0;
	output QN1;
	output QN2;
	output QN3;
	
	reg Q0;
	reg Q1;
	reg Q2;
	reg Q3;
	reg QN0;
	reg QN1;
	reg QN2;
	reg QN3;	
	
	always @ ( posedge CP or negedge CD or negedge SD )
		case ({CD, SD})
			2'b00:
			begin
				Q0  <= 0;
				QN0 <= 0;
				Q1  <= 0;
				QN1 <= 0;
				Q2  <= 0;
				QN2 <= 0;
				Q3  <= 0;
				QN3 <= 0;				
			end	  		
			2'b01:
			begin
				Q0  <= 0;
				QN0 <= 1;
				Q1  <= 0;
				QN1 <= 1;
				Q2  <= 0;
				QN2 <= 1;
				Q3  <= 0;
				QN3 <= 1;				
			end	  
			2'b10:
			begin
				Q0  <= 1;
				QN0 <= 0;
				Q1  <= 1;
				QN1 <= 0;
				Q2  <= 1;
				QN2 <= 0;
				Q3  <= 1;
				QN3 <= 0;				
			end	
			2'b11:		
			begin
				Q0  <= D0;
				QN0 <= ~D0;
				Q1  <= D1;
				QN1 <= ~D1;
				Q2  <= D2;
				QN2 <= ~D2;
				Q3  <= D3;
				QN3 <= ~D3;
			end	
		endcase
		
endmodule
		
module GTECH_FD38 ( D0, D1, D2, D3, D4, D5, D6, D7, CP, CD, SD, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, QN0, QN1, QN2, QN3, QN4, QN5, QN6, QN7 );
	input  D0;
	input  D1;
	input  D2;
	input  D3;
	input  D4;
	input  D5;
	input  D6;
	input  D7;
	input  CP;
	input  CD;
	input  SD;
	output Q0;
	output Q1;
	output Q2;
	output Q3;
	output Q4;
	output Q5;
	output Q6;
	output Q7;
	output QN0;
	output QN1;
	output QN2;
	output QN3;
	output QN4;
	output QN5;
	output QN6;
	output QN7;
	
	reg Q0;
	reg Q1;
	reg Q2;
	reg Q3;
	reg Q4;
	reg Q5;
	reg Q6;
	reg Q7;
	reg QN0;
	reg QN1;
	reg QN2;
	reg QN3;	
	reg QN4;
	reg QN5;
	reg QN6;
	reg QN7;	
	
	always @ ( posedge CP or negedge CD or negedge SD )
		case ({CD, SD})
			2'b00:
			begin
				Q0  <= 0;
			    QN0 <= 0;
				Q1  <= 0;
				QN1 <= 0;
				Q2  <= 0;
				QN2 <= 0;
				Q3  <= 0;
				QN3 <= 0;
				Q4  <= 0;
				QN4 <= 0;
				Q5  <= 0;
				QN5 <= 0;
				Q6  <= 0;
				QN6 <= 0;
				Q7  <= 0;
				QN7 <= 0;
			end	  		
			2'b01:
			begin
				Q0  <= 0;
				QN0 <= 1;
				Q1  <= 0;
				QN1 <= 1;
				Q2  <= 0;
				QN2 <= 1;
				Q3  <= 0;
				QN3 <= 1;
				Q4  <= 0;
				QN4 <= 1;
				Q5  <= 0;
				QN5 <= 1;
				Q6  <= 0;
				QN6 <= 1;
				Q7  <= 0;
				QN7 <= 1; 
			end
			2'b10:
			begin 
				Q0  <= 1;
				QN0 <= 0;
				Q1  <= 1;
				QN1 <= 0;
				Q2  <= 1;
				QN2 <= 0;
				Q3  <= 1;
				QN3 <= 0;
				Q4  <= 1;
				QN4 <= 0;
				Q5  <= 1;
				QN5 <= 0;
				Q6  <= 1;
				QN6 <= 0;
				Q7  <= 1;				
				QN7 <= 0; 
			end
			2'b11:		
			begin
				Q0  <= D0;  
				QN0 <= ~D0; 
				Q1  <= D1;  
				QN1 <= ~D1; 
				Q2  <= D2;  
				QN2 <= ~D2; 
				Q3  <= D3;  
				QN3 <= ~D3; 
				Q4  <= D4;  
				QN4 <= ~D4; 
				Q5  <= D5;  
				QN5 <= ~D5; 
				Q6  <= D6;  
				QN6 <= ~D6; 
				Q7  <= D7;  
				QN7 <= ~D7; 			
			end	
		endcase
	
endmodule
	
module GTECH_FD3S ( D, TI, TE, CP, CD, SD, Q, QN );
	input  D;
	input  TI;
	input  TE;
	input  CP;
	input  CD;
	input  SD;
	output Q;
	output QN;							
	
	reg Q;
	reg QN;	
	wire d_in;
	
	assign d_in = TE ? TI : D;
	
	always @( posedge CP or negedge CD or negedge SD )
		case ( {CD,SD} )
			2'b00: begin
				Q <= 1'b0;
				QN <= 1'b0;
			end
			2'b01:begin
				Q <= 1'b0;
				QN <= 1'b1;
			end
			2'b10:begin
				Q <= 1'b1;
				QN <= 1'b0;
			end			  
			2'b11:begin
				Q <= d_in;
				QN <= ~d_in;
			end	  
		endcase	
		
endmodule	

module GTECH_FD4 ( D, SD, CP, Q, QN );
	input  D;
	input  SD;
	input  CP;
	output Q;
	output QN;							
	
	reg Q;
	reg QN;	
	
	always @( posedge CP or negedge SD )
		if ( !SD )
			begin
				Q <= 1'b1;
				QN <= 1'b0;
			end	
		else
			begin
				Q <= D;
				QN <= ~D;
			end
		
endmodule	

module GTECH_FD44 ( D0, D1, D2, D3, CP, SD, Q0, Q1, Q2, Q3, QN0, QN1, QN2, QN3 );
	input  D0;
	input  D1;
	input  D2;
	input  D3;
	input  CP;
	input  SD;
	output Q0;
	output Q1;
	output Q2;
	output Q3;
	output QN0;
	output QN1;
	output QN2;
	output QN3;
	
	reg Q0;
	reg Q1;
	reg Q2;
	reg Q3;
	reg QN0;
	reg QN1;
	reg QN2;
	reg QN3;	
	
	always @ ( posedge CP or negedge SD )
		if ( !SD )
			begin
				Q0  <= 1;
				QN0 <= 0;
				Q1  <= 1;
				QN1 <= 0;
				Q2  <= 1;
				QN2 <= 0;
				Q3  <= 1;
				QN3 <= 0;				
			end
		else
			begin
				Q0  <= D0;
				QN0 <= ~D0;
				Q1  <= D1;
				QN1 <= ~D1;
				Q2  <= D2;
				QN2 <= ~D2;
				Q3  <= D3;
				QN3 <= ~D3;
			end	  
	
endmodule
		
module GTECH_FD48 ( D0, D1, D2, D3, D4, D5, D6, D7, CP, SD, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, QN0, QN1, QN2, QN3, QN4, QN5, QN6, QN7 );
	input  D0;
	input  D1;
	input  D2;
	input  D3;
	input  D4;
	input  D5;
	input  D6;
	input  D7;
	input  CP;
	input  SD;
	output Q0;
	output Q1;
	output Q2;
	output Q3;
	output Q4;
	output Q5;
	output Q6;
	output Q7;
	output QN0;
	output QN1;
	output QN2;
	output QN3;
	output QN4;
	output QN5;
	output QN6;
	output QN7;
	
	reg Q0;
	reg Q1;
	reg Q2;
	reg Q3;
	reg Q4;
	reg Q5;
	reg Q6;
	reg Q7;
	reg QN0;
	reg QN1;
	reg QN2;
	reg QN3;	
	reg QN4;
	reg QN5;
	reg QN6;
	reg QN7;	
	
	always @ ( posedge CP or negedge SD )
		if ( !SD )
			begin
				Q0  <= 1;
				QN0 <= 0;
				Q1  <= 1;
				QN1 <= 0;
				Q2  <= 1;
				QN2 <= 0;
				Q3  <= 1;
				QN3 <= 0;
				Q4  <= 1;
				QN4 <= 0;
				Q5  <= 1;
				QN5 <= 0;
				Q6  <= 1;
				QN6 <= 0;
				Q7  <= 1;
				QN7 <= 0;
			end	
		else
			begin            
				Q0  <= D0;   
				QN0 <= ~D0;  
				Q1  <= D1;   
				QN1 <= ~D1;  
				Q2  <= D2;   
				QN2 <= ~D2;  
				Q3  <= D3;   
				QN3 <= ~D3;  
				Q4  <= D4;   
				QN4 <= ~D4;  
				Q5  <= D5;   
				QN5 <= ~D5;  
				Q6  <= D6;   
				QN6 <= ~D6;  
				Q7  <= D7;   
				QN7 <= ~D7;  
			end
	
endmodule
	
module GTECH_FD4S ( D, TI, TE, CP, SD, Q, QN );
	input  D;
	input  TI;
	input  TE;
	input  CP;
	input  SD;
	output Q;
	output QN;							
	
	reg Q;
	reg QN;	
	wire d_in;
	
	assign d_in = TE ? TI : D;
	
	always @( posedge CP or negedge SD )
		if ( !SD )
			begin
				Q <= 1'b1;
				QN <= 1'b0;
			end
		else	
			begin
				Q <= d_in;
				QN <= ~d_in;
			end
		
endmodule	

module GTECH_FJK1 ( J, K, CP, Q, QN );
	input  J;
	input  K;
	input  CP;
	output Q;
	output QN;
	
	wire d_in;
	reg Q;
	reg QN;
	
	assign d_in = ( J & QN ) | ( ~K & Q );
	

	
	always @ ( posedge CP )
		begin
			Q <= d_in;
			QN <= ~d_in;
		end	
		
endmodule		

module GTECH_FJK1S ( J, K, TI, TE, CP, Q, QN );
	input  J;
	input  K;
	input  TI;
	input  TE;
	input  CP;
	output Q;
	output QN;
	
	wire d_in;
	wire d_int;
	reg Q;
	reg QN;
	
	assign d_in = ( J & QN ) | ( ~K & Q );
	assign d_int = TE ? TI : d_in;	
	
	always @ ( posedge CP )
		begin
			Q <= d_int;
			QN <= ~d_int;
		end	
		
endmodule

module GTECH_FJK2 ( J, K, CP, CD, Q, QN );
	input  J;
	input  K;
	input  CP;
	input  CD;
	output Q;
	output QN;
	
	wire d_in;
	reg Q;
	reg QN;
	
	assign d_in = ( J & QN ) | ( ~K & Q );
		
	always @ ( posedge CP or negedge CD )
		if (!CD)
			begin
				Q <= 0;
				QN <= 1;
			end
		else
			begin
				Q <= d_in;
				QN <= ~d_in;
			end	
		
endmodule 

module GTECH_FJK2S ( J, K, TI, TE, CD, CP, Q, QN );
	input  J;
	input  K;
	input  TI;
	input  TE;
	input  CD;
	input  CP;
	output Q;
	output QN;
	
	wire d_in;
	wire d_int;
	reg Q;
	reg QN;
	
	assign d_in = ( J & QN ) | ( ~K & Q );
	assign d_int = TE ? TI : d_in;	
	
	always @ ( posedge CP or negedge CD )
		if ( !CD )
			begin
				Q <= 0;
				QN <= 1;
			end
		else
			begin
				Q <= d_int;
				QN <= ~d_int;
			end	
		
endmodule	

module GTECH_FJK3 ( J, K, CP, CD, SD, Q, QN );
	input  J;
	input  K;
	input  CP;
	input  CD;
	input  SD;
	output Q;
	output QN;
	
	wire d_in;
	reg Q;
	reg QN;
	
	assign d_in = ( J & QN ) | ( ~K & Q );
		
	always @ ( posedge CP or negedge CD or negedge SD ) 
		case ({CD,SD})
			2'b00: begin
				Q <= 0;
				QN <= 0;
			end
			2'b01: begin
				Q <= 0;
				QN <= 1;
			end
			2'b10: begin
				Q <= 1;
				QN <= 0;
			end
			2'b11: begin
				Q <= d_in;
				QN <= ~d_in;
			end
		endcase	
		
endmodule 

module GTECH_FJK3S ( J, K, TI, TE, CD, SD, CP, Q, QN );
	input  J;
	input  K;
	input  TI;
	input  TE;
	input  CD;
	input  SD;
	input  CP;
	output Q;
	output QN;
	
	wire d_in;
	wire d_int;
	reg Q;
	reg QN;
	
	assign d_in = ( J & QN ) | ( ~K & Q );
	assign d_int = TE ? TI : d_in;	
	
	always @ ( posedge CP or negedge CD or negedge SD ) 
		case ({CD,SD})
			2'b00: begin
				Q <= 0;
				QN <= 0;
			end
			2'b01: begin
				Q <= 0;
				QN <= 1;
			end
			2'b10: begin
				Q <= 1;
				QN <= 0;
			end
			2'b11: begin
				Q <= d_int;
				QN <= ~d_int;
			end
		endcase	
		
endmodule  

module GTECH_LD1 ( D, G, Q, QN );
	input  D;
	input  G;
	output Q;
	output QN;
	
	reg Q;
	reg QN;
	
	always @ ( G or D )	
		if ( G )
			begin
				Q = D;
				QN = ~D;
			end	
		
endmodule		

module GTECH_LD2 ( D, GN, Q, QN );
	input  D;
	input  GN;
	output Q;
	output QN;
	
	reg Q;
	reg QN;
	
	always @ ( GN or D )	
		if ( ~GN )
			begin
				Q = D;
				QN = ~D;
			end	
		
endmodule	

module GTECH_LD2_1 ( D, GN, Q );
	input  D;
	input  GN;
	output Q;
	
	reg Q;
	
	always @ ( GN or D )	
		if ( ~GN )
			Q = D;
		
endmodule

module GTECH_LD3 ( D, G, CD, Q, QN );
	input  D;
	input  G;
	input  CD;
	output Q;
	output QN;
	
	reg Q;
	reg QN;
	
	always @ ( G or CD or D )
		if ( CD )
			begin
				if ( G )
					begin
						Q = D;
						QN = ~D;
					end
			end
		else
			begin
				Q = 0;
				QN = 1;
			end	
		
endmodule	

module GTECH_LD4 ( D, GN, CD, Q, QN );
	input  D;
	input  GN;
	input  CD;
	output Q;
	output QN;
	
	reg Q;
	reg QN;
	
	always @ ( GN or CD or D )
		if ( CD )
			begin
				if ( ~GN )
					begin
						Q = D;
						QN = ~D;
					end
			end
		else
			begin
				Q = 0;
				QN = 1;
			end	
		
endmodule		

module GTECH_LD4_1 ( D, GN, CD, Q );
	input  D;
	input  GN;
	input  CD;
	output Q;
	
	reg Q;
	
	always @ ( GN or CD or D)
		if ( CD )
			begin
				if ( ~GN )
					Q = D;
			end
		else
			Q = 0;
		
endmodule

module GTECH_LSR0 ( S, R, Q, QN );
	input  S;
	input  R;
	output Q;
	output QN;

	wire QN = ~( ~S | Q );
	wire Q = ~( ~R | QN );
		
endmodule

module GTECH_ONE ( Z );
	output Z;
	
      assign Z = 1'b1;
endmodule

module GTECH_ZERO ( Z );
	output Z;
	
	assign Z = 1'b0;
endmodule
