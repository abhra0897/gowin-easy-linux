//
// Copyright (c) 1995 by Synplicity, Inc.
// You may distribute freely, as long as this header remains attached.
//
//Verilog created by Synplicity(tm), Inc.
//Created from KISS source .

module kiss_fsm(bbara_in,bbara_out,reset,clock);
output [1:0] bbara_out;
input [3:0] bbara_in;
input reset,clock;

// Clock signal is: clock
reg [1:0] outsigs;
wire [3:0] insigs;
assign insigs = bbara_in;
assign bbara_out = outsigs;

// Use parameters for state definitions, this lets you redefine the
// state values in the level of hierarchy above, if necessary.
parameter st0=4'd0, st1=4'd1, st4=4'd2, st2=4'd3, st3=4'd4, st7=4'd5, st5=4'd6,
                st6=4'd7, st8=4'd8, st9=4'd9;
//Width of state reg is: 4
reg [3:0] kiss_state;

        always @(posedge clock or posedge reset) begin: statereg
                if(reset)
                        // Always have a means to reset your state machine
                        kiss_state = st0;
                else begin: fsm
                        // The following casez statement is a case on a 4 bit value(kiss_state)
                        // thus there are 16 possible state values. See the comment
                        // preceding the "default" label in this casez statement
                        case (kiss_state)
                        st0:
                                // This inner casex statement does not require a default statement
                                // All  possible conditions are covered.
                                // There are 16 possible conditions for insigs
                                //  because insigs is 4 bits wide
                                // The first 3 labels cover12 of the 16
                                // The 4th covers 1, 
                                // The 5th covers 2.
                                // The 6th covers 1, for a total of 16/16
                                casex(insigs)
                                        4'b??01:        kiss_state=st0;         //1
                                        4'b??10:        kiss_state=st0; //2
                                        4'b??00:        kiss_state=st0; //3
                                        4'b0011:        kiss_state=st0; //4
                                        4'b?111:        kiss_state=st1; //5
                                        4'b1011:        kiss_state=st4; //6
                                endcase
                        st1:
                                // Why use a casex vs a case statement?
                                // This will make your behavioral simulation 
                                // behave more like the hardware.
                                // The inputs in hardware will take on
                                // either a 1 or a 0 value.
                                // In behavioral simulation, before the inputs
                                // are driven, they may be 1,0 or x. 
                                // In the first case label (4'b??01),  we
                                // really do not care what the values of the
                                // high orders insig bits are, just that the low
                                // order nibble is "01".
                                casex(insigs)
                                        4'b??01:        kiss_state=st1;
                                        4'b??10:        kiss_state=st1;
                                        4'b??00:        kiss_state=st1;
                                        4'b0011:        kiss_state=st0;
                                        4'b?111:        kiss_state=st2;
                                        4'b1011:        kiss_state=st4;
                                endcase
                        st4:
                                casex(insigs)
                                        4'b??01:        kiss_state=st4;
                                        4'b??10:        kiss_state=st4;
                                        4'b??00:        kiss_state=st4;
                                        4'b0011:        kiss_state=st0;
                                        4'b?111:        kiss_state=st1;
                                        4'b1011:        kiss_state=st5;
                                endcase
                        st2:
                                casex(insigs)
                                        4'b??01:        kiss_state=st2;
                                        4'b??10:        kiss_state=st2;
                                        4'b??00:        kiss_state=st2;
                                        4'b0011:        kiss_state=st1;
                                        4'b?111:        kiss_state=st3;
                                        4'b1011:        kiss_state=st4;
                                endcase
                        st3:
                                casex(insigs)
                                        4'b??01:        kiss_state=st3;
                                        4'b??10:        kiss_state=st3;
                                        4'b??00:        kiss_state=st3;
                                        4'b0011:        kiss_state=st7;
                                        4'b?111:        kiss_state=st3;
                                        4'b1011:        kiss_state=st4;
                                endcase
                        st7:
                                casex(insigs)
                                        4'b??01:        kiss_state=st7;
                                        4'b??10:        kiss_state=st7;
                                        4'b??00:        kiss_state=st7;
                                        4'b0011:        kiss_state=st8;
                                        4'b?111:        kiss_state=st1;
                                        4'b1011:        kiss_state=st4;
                                endcase
                        st5:
                                casex(insigs)
                                        4'b??01:        kiss_state=st5;
                                        4'b??10:        kiss_state=st5;
                                        4'b??00:        kiss_state=st5;
                                        4'b0011:        kiss_state=st4;
                                        4'b?111:        kiss_state=st1;
                                        4'b1011:        kiss_state=st6;
                                endcase
                        st6:
                                casex(insigs)
                                        4'b??01:        kiss_state=st6;
                                        4'b??10:        kiss_state=st6;
                                        4'b??00:        kiss_state=st6;
                                        4'b0011:        kiss_state=st7;
                                        4'b?111:        kiss_state=st1;
                                        4'b1011:        kiss_state=st6;
                                endcase
                        st8:
                                casex(insigs)
                                        4'b??01:        kiss_state=st8;
                                        4'b??10:        kiss_state=st8;
                                        4'b??00:        kiss_state=st8;
                                        4'b0011:        kiss_state=st9;
                                        4'b?111:        kiss_state=st1;
                                        4'b1011:        kiss_state=st4;
                                endcase
                        st9:
                                casex(insigs)
                                        4'b??01:        kiss_state=st9;
                                        4'b??10:        kiss_state=st9;
                                        4'b??00:        kiss_state=st9;
                                        4'b0011:        kiss_state=st0;
                                        4'b?111:        kiss_state=st1;
                                        4'b1011:        kiss_state=st4;
                                endcase
                        // This default statement is desired.
                        // Only 10 of the possible 16 states have been enumerated.
                        // This helps to define the case as full, i.e. these are the  only legal 
                        // states, anything else is an error.
                        default:
                                kiss_state = 'bx;
                        endcase
                end //fsm

        end //statereg

        // Using labels ( in this case, the label is "outputs")
        // is helpful to match up begin-end statements
        // the matching end statement includes a comment
        // that references the label, see " end //outputs" below.
        always @(insigs or kiss_state) begin: outputs
                begin: fsmoutputs
                        casez (kiss_state)
                        st0:
                                casex(insigs)
                                        4'b??01:        outsigs = 'b00;
                                        4'b??10:        outsigs = 'b00;
                                        4'b??00:        outsigs = 'b00;
                                        4'b0011:        outsigs = 'b00;
                                        4'b?111:        outsigs = 'b00;
                                        4'b1011:        outsigs = 'b00;
                                endcase
                        st1:
                                casex(insigs)
                                        4'b??01:        outsigs = 'b00;
                                        4'b??10:        outsigs = 'b00;
                                        4'b??00:        outsigs = 'b00;
                                        4'b0011:        outsigs = 'b00;
                                        4'b?111:        outsigs = 'b00;
                                        4'b1011:        outsigs = 'b00;
                                endcase
                        st4:
                                casex(insigs)
                                        4'b??01:        outsigs = 'b00;
                                        4'b??10:        outsigs = 'b00;
                                        4'b??00:        outsigs = 'b00;
                                        4'b0011:        outsigs = 'b00;
                                        4'b?111:        outsigs = 'b00;
                                        4'b1011:        outsigs = 'b00;
                                endcase
                        st2:
                                casex(insigs)
                                        4'b??01:        outsigs = 'b00;
                                        4'b??10:        outsigs = 'b00;
                                        4'b??00:        outsigs = 'b00;
                                        4'b0011:        outsigs = 'b00;
                                        4'b?111:        outsigs = 'b00;
                                        4'b1011:        outsigs = 'b00;
                                endcase
                        st3:
                                casex(insigs)
                                        4'b??01:        outsigs = 'b10;
                                        4'b??10:        outsigs = 'b10;
                                        4'b??00:        outsigs = 'b10;
                                        4'b0011:        outsigs = 'b00;
                                        4'b?111:        outsigs = 'b10;
                                        4'b1011:        outsigs = 'b00;
                                endcase
                        st7:
                                casex(insigs)
                                        4'b??01:        outsigs = 'b00;
                                        4'b??10:        outsigs = 'b00;
                                        4'b??00:        outsigs = 'b00;
                                        4'b0011:        outsigs = 'b00;
                                        4'b?111:        outsigs = 'b00;
                                        4'b1011:        outsigs = 'b00;
                                endcase
                        st5:
                                casex(insigs)
                                        4'b??01:        outsigs = 'b00;
                                        4'b??10:        outsigs = 'b00;
                                        4'b??00:        outsigs = 'b00;
                                        4'b0011:        outsigs = 'b00;
                                        4'b?111:        outsigs = 'b00;
                                        4'b1011:        outsigs = 'b00;
                                endcase
                        st6:
                                casex(insigs)
                                        4'b??01:        outsigs = 'b01;
                                        4'b??10:        outsigs = 'b01;
                                        4'b??00:        outsigs = 'b01;
                                        4'b0011:        outsigs = 'b00;
                                        4'b?111:        outsigs = 'b00;
                                        4'b1011:        outsigs = 'b01;
                                endcase
                        st8:
                                casex(insigs)
                                        4'b??01:        outsigs = 'b00;
                                        4'b??10:        outsigs = 'b00;
                                        4'b??00:        outsigs = 'b00;
                                        4'b0011:        outsigs = 'b00;
                                        4'b?111:        outsigs = 'b00;
                                        4'b1011:        outsigs = 'b00;
                                endcase
                        st9:
                                casex(insigs)
                                        4'b??01:        outsigs = 'b00;
                                        4'b??10:        outsigs = 'b00;
                                        4'b??00:        outsigs = 'b00;
                                        4'b0011:        outsigs = 'b00;
                                        4'b?111:        outsigs = 'b00;
                                        4'b1011:        outsigs = 'b00;
                                endcase
                        default:
                                outsigs = 'bx;
                        endcase
                end //fsmoutputs
        end //outputs

endmodule


