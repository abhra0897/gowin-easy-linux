`include "define.v"
`include "static_macro_define.v"
module `module_name(
    clk,
    rstn,
    kill,
    tagI,
    tagO,
	req_ready,
    req_valid,
    resp_ready,
    resp_valid,
    func,
    op0,
    op1,
    res0,
    res1,
);
`include "parameter.v"
input clk;
input rstn;
input req_valid;
input [4:0] tagI;
input [3:0] func;
input [31:0] op0;
input [31:0] op1;
output req_ready;
input kill;
output resp_valid;
output [4:0] tagO;
output [31:0] res0;
output [31:0] res1;
input resp_ready;

`getname(integerMultiplyDivider,`module_name) u_mdu(
    .clk			(clk),
    .rstn			(rstn),
    .kill			(kill),
    .tagI			(tagI),
    .tagO			(tagO),
	.req_ready		(req_ready),
    .req_valid		(req_valid),
    .resp_ready		(resp_ready),
    .resp_valid		(resp_valid),
    .func			(func),
    .op0			(op0),
    .op1			(op1),
    .res0			(res0),
    .res1			(res1)
);
defparam u_mdu .MULTIPLIER = MULTIPLIER;
endmodule
