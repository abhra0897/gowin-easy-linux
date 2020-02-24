`ifndef duplicate_scemi_input_pipe_call
	`define duplicate_scemi_input_pipe_call 1
	interface scemi_input_pipe();

		parameter BYTES_PER_ELEMENT = 10;
		parameter PAYLOAD_MAX_ELEMENTS = 1;
		parameter BUFFER_MAX_ELEMENTS = 1;
		parameter VISIBILITY_MODE = 0; 
		parameter NOTIFICATION_THRESHOLD = BUFFER_MAX_ELEMENTS;
		localparam PAYLOAD_MAX_BITS = PAYLOAD_MAX_ELEMENTS * BYTES_PER_ELEMENT * 8;
	
		task receive(
			input int num_elements, 
			output int num_elements_valid,
			output bit [PAYLOAD_MAX_BITS-1:0] data,
			output bit eom ); 
		endtask
	
		function int try_receive(
			input int byte_offset, 
			input int num_elements,
			output bit [PAYLOAD_MAX_BITS-1:0] data,
			output bit eom ); 
		endfunction
	
		function int can_receive();
		endfunction
	
		modport receive_if( import receive, try_receive, can_receive );
	
	endinterface
`endif

`ifndef duplicate_scemi_output_pipe_call
	`define duplicate_scemi_output_pipe_call 1
	interface scemi_output_pipe();
	
		parameter BYTES_PER_ELEMENT = 1;
		parameter PAYLOAD_MAX_ELEMENTS = 1;
		parameter BUFFER_MAX_ELEMENTS = 1;
		parameter VISIBILITY_MODE = 0; 
		parameter NOTIFICATION_THRESHOLD = BUFFER_MAX_ELEMENTS;
		localparam PAYLOAD_MAX_BITS = PAYLOAD_MAX_ELEMENTS * BYTES_PER_ELEMENT * 8;

		task send(
			input int num_elements,
			input bit [PAYLOAD_MAX_BITS-1:0] data,
			input bit eom ); 
		endtask
	
		task flush;
		endtask
	
		function int try_send(
			input int byte_offset, 
			input int num_elements, 
			input bit [PAYLOAD_MAX_BITS-1:0] data,
			input bit eom ); 
		endfunction
	
		function int try_flush();
		endfunction
	
		function int can_send();
		endfunction
	
		modport send_if( import send, flush, try_send, can_send );
	
	endinterface
`endif