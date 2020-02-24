
localparam PAYLOAD_MAX_BITS = 4096;

task scemi_pipe_hdl_receive;
	input  integer pipe_id;
	input  integer bytes_per_element;
	input  integer num_elements;
	input  integer num_elements_valid;
	input  [PAYLOAD_MAX_BITS-1:0] data;
	input  eom;
	begin
end
endtask

function integer scemi_pipe_hdl_try_receive;
	input  integer pipe_id;
	input  integer byte_offset;
	input  integer bytes_per_element;	
	input  integer num_elements;
	input  [PAYLOAD_MAX_BITS-1:0] data;
	input  eom;
begin
end
endfunction

function integer scemi_pipe_hdl_can_receive;
	input integer pipe_id;
begin
end
endfunction

task scemi_pipe_hdl_send;
	input integer pipe_id;
	input integer bytes_per_element;
	input integer num_elements;
	input [PAYLOAD_MAX_BITS-1:0] data;
	input eom;
begin
end
endtask

task scemi_pipe_hdl_flush;
	input  integer pipe_id;
begin
end
endtask

function integer scemi_pipe_hdl_try_send;
	input integer pipe_id;
	input integer byte_offset;
	input integer bytes_per_element;	
	input integer num_elements;
	input [PAYLOAD_MAX_BITS-1:0] data;
	input eom ;
begin
end
endfunction

function integer scemi_pipe_hdl_can_send;
	input integer pipe_id;
begin
end
endfunction
