// PREP Benchmark 4, Large State Machine

/* PREP4 contains a large state machine

Copyright (c) 1994 Synplicity, Inc.
You may distribute freely, as long as this header remains attached. */

module prep4(O, I, CLK, RST);
output [7:0] O;
input [7:0] I;
input CLK, RST;
reg [7:0] O;
reg [15:0] state;

// state declarations
parameter st0 = 16'h0001, st1 = 16'h0002, 
	st2 = 16'h0004, st3 = 16'h0008, 
	st4 = 16'h0010, st5 = 16'h0020, 
	st6 = 16'h0040, st7 = 16'h0080, 
	st8 = 16'h0100, st9 = 16'h0200, 
	st10 = 16'h0400, st11 = 16'h0800, 
	st12 = 16'h1000, st13 = 16'h2000,
	st14 = 16'h4000, st15 = 16'h8000;

// state registers, state decode logic, reset logic
always @ (posedge CLK or posedge RST)
begin
	if (RST)  // reset
		state = st0;
	else begin
		case (state)
		st0:	if (I == 8'h00)
				state = st0;
			else if ((I == 8'h01) || (I == 8'h02) || (I == 8'h03))
				state = st1;
			else if (I > 8'h03 && I <= 8'h1f)
				state = st2;
			else if (I > 8'h1f && I <= 8'h3f)
				state = st3;
			else
				state = st4;
		st1:	if (I[1:0] == 2'b11)
				state = st0;
			else
				state = st3;
		st2:	state = st3;
		st3:	state = st5;
		st4:	if (I[0] || I[2] || I[4])
				state = st5;
			else 
				state = st6;
		st5:	if (! I[0])
				state = st5;
			else 
				state = st7;
		st6:	case (I[7:6])
			2'b00: state = st6;
			2'b01: state = st8;
			2'b10: state = st9;
			2'b11: state = st1;
			endcase
		st7:	case (I[7:6])
			2'b00: state = st3;
			2'b11: state = st4;
			default: state = st7;
			endcase
		st8:	if (I[4] ^ I[5])
				state = st11;
			else if (I[7])
				state = st1;
			else
				state = st8;
		st9:	if (I[0])
				state = st11;
			else
				state = st9;
		st10:	state = st1;
		st11:	if (I == 8'h40)
				state = st15;
			else 
				state = st8;
		st12:	if (I == 8'hff)
				state = st0;
			else 
				state = st12;
		st13:	if (I[5] ^ I[3] ^ I[1])
				state = st12;
			else 
				state = st14;
		st14:	if (I == 8'h00)
				state = st14;
			else if (I > 0 && I <= 8'h3f)
				state = st12;
			else
				state = st10;
		st15:	if (I[7])
				case (I[1:0])
				2'b00: state = st14;
				2'b01: state = st10;
				2'b10: state = st13;
				2'b11: state = st0;
				endcase
			else
				state = st15;
/* set current_state to 'bx (don't care) to tell Synplify-Lite that all used
states have been already been specified */
		default:	state = 'bx;
		endcase

	end

end

// the outputs are combinational based on the state
always @ (state)
begin
      case (state)
      st0: O = 8'h00;
      st1: O = 8'h06;
      st2: O = 8'h18;
      st3: O = 8'h60;
      st4: O = 8'h80;
      st5: O = 8'hf0;
      st6: O = 8'h1f;
      st7: O = 8'h3f;
      st8: O = 8'h7f;
      st9: O = 8'hff;
      st10: O = 8'hff;
      st11: O = 8'hff;
      st12: O = 8'hfd;
      st13: O = 8'hf7;
      st14: O = 8'hdf;
      st15: O = 8'h7f;
/* notice assignment of 8'hx in the default case 
which is a don't care for synthesis */
      default: O = 8'hx;
    endcase
end

endmodule
