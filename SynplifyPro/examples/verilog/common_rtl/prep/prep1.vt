//--------------------------------------------------------------------

`timescale 100 ps/100 ps
module test;

reg [7:0] ipd;
reg [23:0] id;
reg s0, s1, s_l,rst, clk;

wire [7:0] q;

prep1 inst1 (.CLK(clk),.RST( rst),.S_L( s_l), .S1(s1), .S0(s0),
	.d0( ipd), .d1( id[7:0]),  .d2(id[15:8]), .d3( id[23:16]), .Q( q));

parameter numvecs = 20; // actual number of vectors
reg [3:0] cntl        [0:numvecs-1];
reg [31:0] invec  [0:numvecs-1];
reg [7:0] outvec [0:numvecs-1];
integer i;
integer numerrors;

initial
begin
	// sequential test patterns entered at neg edge clk
	// s1, s0, rst, s_l;		 id[23:0], ipd[7:0];                q at next pos edge
	cntl[0] = 	4'b0010;	invec[0] =32'h0;     		 outvec[0] = 8'b0;
	cntl[1] = 	4'b0010;	invec[1] =32'h0;       		 outvec[1] = 8'b0;
	cntl[2] = 	4'b0010;	invec[2] =32'h11_22_aa_ff;       outvec[2] = 8'h00;   // turning rst off
	cntl[3] = 	4'b0100;	invec[3] =32'h11_22_aa_ff;       outvec[3] = 8'h00;
	cntl[4] = 	4'b1000;	invec[4] =32'h11_22_aa_ff;       outvec[4] = 8'haa;   // invec [3] comes out
	cntl[5] = 	4'b1100;	invec[5] =32'h11_22_aa_ff;       outvec[5] = 8'h22;   // invec [4] comes out
	cntl[6] = 	4'b1100;	invec[6] =32'hff_22_aa_ff;       outvec[6] = 8'h11;   // invec [5] comes out
	cntl[7] = 	4'b0000;	invec[7] =32'h11_22_aa_01;       outvec[7] = 8'hff;   // invec [6] comes out
	cntl[8] = 	4'b1100;	invec[8] =32'h01_22_aa_ff;       outvec[8] = 8'h01;   // invec [7] comes out
	cntl[9] = 	4'b1100;	invec[9] =32'hxx_22_aa_ff;       outvec[9] = 8'h01;   // invec [8] comes out
	cntl[10] = 	4'b1101;	invec[10] =32'h11_22_aa_ff;      outvec[10] = 8'b00000010;  // rotate 1
	cntl[11] = 	4'b1101;	invec[11] =32'h11_22_aa_ff;      outvec[11] = 8'b00000100;  // rotate 1
	cntl[12] = 	4'b1101;	invec[12] =32'h11_22_aa_ff;      outvec[12] = 8'b00001000;  // rotate 1
	cntl[13] = 	4'b1101;	invec[13] =32'h11_22_aa_ff;      outvec[13] = 8'b00010000;  // rotate 1
	cntl[14] = 	4'b1101;	invec[14] =32'h11_22_aa_ff;      outvec[14] = 8'b00100000;  // rotate 1
	cntl[15] = 	4'b1101;	invec[15] =32'h11_22_aa_ff;      outvec[15] = 8'b01000000;  // rotate 1
	cntl[16] = 	4'b1101;	invec[16] =32'h11_22_aa_ff;      outvec[16] = 8'b10000000;  // rotate 1
	cntl[17] = 	4'b1101;	invec[17] =32'h11_22_aa_ff;      outvec[17] = 8'b00000001;  // rotate 1
	cntl[18] = 	4'b1101;	invec[18] =32'h11_22_aa_ff;      outvec[18] = 8'b00000010;  // rotate 1
	cntl[19] = 	4'b1111;	invec[19] =32'h11_22_aa_ff;      outvec[19] = 8'b00000000;  // reset all bits

	
end

// set up clk with 1000 ns period
parameter clkper = 10000; //10000 = 1000 100ps units = 1000 ns period
initial clk = 1;

always 
begin
	#(clkper / 2)  clk = ~clk;
end
	

reg invec_temp;

initial
begin
	
	numerrors = 0;
	$display("\nBeginning Simulation..."); 

	//skip first rising edge
	@(posedge clk);
	for (i = 0; i <= numvecs-1; i = i + 1)
	begin
		@(negedge clk);
		// apply test pattern at neg edge
		{s1, s0, rst, s_l} = cntl[i];
		{id, ipd } = invec[i];
		@(posedge clk) #4500; //450 ns later
		// check result at posedge + 450 ns
		if ( q !== outvec[i] )
		begin
		   $display(    
		"\t\t ERROR pattern#%d t%d: s1,s0,rst,s_l=%b,%b,%b,%b  id, ipd = %h Expected q: %h;  Actual q: %h", 
		i, $stime, s1, s0, rst, s_l, invec[i],outvec[i], q);
			numerrors = numerrors + 1;
		end
	end
	if (numerrors == 0)
	   
		$display(
			  "Good!  End of Good Simulation.");
	else
		if (numerrors > 1)
	      
			$display(
			  "%0d ERRORS!  End of Faulty Simulation.",numerrors);
		else
			$display(
			 "1 ERROR!  End of Faulty Simulation."); 
	
	#1000 $finish; // after 100 ns later
end

endmodule
