// Asynchronous state machines (small ones)
// Do not give these designs to a synthesis tool because the
// optimizer will remove the gates you put in for hazard suppression.
//
// Synplify-Lite correctly gives a "Found combinational loop"
// error message for these designs to remind you that you should
// not design asynchronous state machines with a synthesis tool
// unless you explicitly instantiate technology primitives from
// your target library. (They are not optimized out of the netlist).

module async1 (out, g, d);
output out;
input g, d;

assign out = g & d | !g & out | d & out;

endmodule


module async2 (out, g, d);
output out;
input g, d;
reg out;

always @(g or d or out)
begin
	out = g & d | !g & out | d & out;
end

endmodule



