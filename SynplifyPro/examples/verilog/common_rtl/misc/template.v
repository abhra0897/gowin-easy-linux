module top_module_name(port_list);
// port declarations go here
/* wire, reg, integer declarations,user task 
and user function declarations go here*/

/* describe hardware with one or more: continuous assignments, 
always blocks, module instantiations and gate instantiations */

// continuous assignment statement:
wire result_signal;
assign result_signal = expression;

// always block:
always @(event_expression)
begin	
  // procedural assignments  
  // if and case statements  
  // while, repeat, and for loops  
  // user task and user function calls
end

// module instantiation:
module_name instance_name (port_list);

// gate instantiation:
gate_name (port_list);

endmodule
