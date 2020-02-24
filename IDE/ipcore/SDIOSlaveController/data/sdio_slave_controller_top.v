
`include "define.vh"
`include "static_macro_define.vh"

module `module_name (
    input sdio_clk,
    input clk_2mhz,
    input rstn,

    input sdio_cmd_in,
    output sdio_cmd_out,
    output sdio_cmd_oen,
        
    input sdio_dat0_in,
    output sdio_dat0_out,
    output sdio_dat0_oen,

    input sdio_dat1_in,
    output sdio_dat1_out,
    output sdio_dat1_oen,

    input sdio_dat2_in,
    output sdio_dat2_out,
    output sdio_dat2_oen,

    input sdio_dat3_in,
    output sdio_dat3_out,
    output sdio_dat3_oen,

    output cmd52_rst,
    output fun1_ioe,
    input fun1_interrupt,
    input fun1_ior,

    input cpu_rst,
    input cpu_clk,
    input slv_cpu_cs,
    input slv_cpu_op,
    input [7:0] slv_cpu_addr, 
    input [31:0] slv_cpu_wr_data,
    input [3:0] slv_cpu_byte_en,
    output [31:0] slv_cpu_rd_data,
    output slv_cpu_ack,
    output slv_cpu_err,

    output          sdio_cmd52_cs,
    output          sdio_cmd52_r_w,
    output          sdio_cmd52_fn_num,
    output          sdio_cmd52_raw,
    output [16:0]   sdio_cmd52_addr,
    output [7:0]    sdio_cmd52_wr_data,
    input [7:0]     sdio_cmd52_rd_data,
    input           sdio_cmd52_ack,

    output          sdio_cmd53_wr_en,
    output          sdio_cmd53_rd_en,
    output          sdio_cmd53_fn_num,
    output [16:0]   sdio_cmd53_addr,
    output [11:0]   sdio_cmd53_len,
    output          sdio_cmd53_op_code,

    output          sdio_cmd53_wr_valid,
    output [7:0]    sdio_cmd53_wr_data,
    output          sdio_cmd53_wr_end,
    output          sdio_cmd53_wr_ok,
    output          sdio_cmd53_wr_abort,

    input           sdio_cmd53_rd_valid,
    input [7:0]     sdio_cmd53_rd_data,
    output          sdio_cmd53_rd_ready,
    output          sdio_cmd53_rd_end,
    output          sdio_cmd53_rd_abort,

    input           sdio_buffer_full,

    output          sdio_tuning_start,
    input [3:0]     sdio_tuning_data,
    input           sdio_tuning_end
);



`getname(sdio_slave_ctrl,`module_name) u_sdio_slave_ctrl(
    .clk(sdio_clk),
    .clk_2mhz(clk_2mhz),
    .rstn(rstn),

    .sdio_cmd_in(sdio_cmd_in),
    .sdio_cmd_out(sdio_cmd_out),
    .sdio_cmd_oen(sdio_cmd_oen),
    
    .sdio_dat0_in(sdio_dat0_in),
    .sdio_dat0_out(sdio_dat0_out),
    .sdio_dat0_oen(sdio_dat0_oen),
    
    .sdio_dat1_in(sdio_dat1_in),
    .sdio_dat1_out(sdio_dat1_out),
    .sdio_dat1_oen(sdio_dat1_oen),
    
    .sdio_dat2_in(sdio_dat2_in),
    .sdio_dat2_out(sdio_dat2_out),
    .sdio_dat2_oen(sdio_dat2_oen),
    
    .sdio_dat3_in(sdio_dat3_in),
    .sdio_dat3_out(sdio_dat3_out),
    .sdio_dat3_oen(sdio_dat3_oen),

    .cmd52_rst(cmd52_rst),
    .fun1_ioe(fun1_ioe),
    .fun1_interrupt(fun1_interrupt),
    .fun1_ior(fun1_ior),

    .cpu_rst(cpu_rst),
    .cpu_clk(cpu_clk),
    .slv_cpu_cs(slv_cpu_cs),
    .slv_cpu_op(slv_cpu_op),
    .slv_cpu_addr(slv_cpu_addr), 
    .slv_cpu_wr_data(slv_cpu_wr_data),
    .slv_cpu_byte_en(slv_cpu_byte_en),
    .slv_cpu_rd_data(slv_cpu_rd_data),
    .slv_cpu_ack(slv_cpu_ack),
    .slv_cpu_err(slv_cpu_err),

    .sdio_cmd52_cs(sdio_cmd52_cs),
    .sdio_cmd52_r_w(sdio_cmd52_r_w),
    .sdio_cmd52_fn_num(sdio_cmd52_fn_num),
    .sdio_cmd52_raw(sdio_cmd52_raw),
    .sdio_cmd52_addr(sdio_cmd52_addr),
    .sdio_cmd52_wr_data(sdio_cmd52_wr_data),
    .sdio_cmd52_rd_data(sdio_cmd52_rd_data),
    .sdio_cmd52_ack(sdio_cmd52_ack),

    .sdio_cmd53_wr_en(sdio_cmd53_wr_en),
    .sdio_cmd53_rd_en(sdio_cmd53_rd_en),
    .sdio_cmd53_fn_num(sdio_cmd53_fn_num),
    .sdio_cmd53_addr(sdio_cmd53_addr),
    .sdio_cmd53_len(sdio_cmd53_len),
    .sdio_cmd53_op_code(sdio_cmd53_op_code),

    .sdio_cmd53_wr_valid(sdio_cmd53_wr_valid),
    .sdio_cmd53_wr_data(sdio_cmd53_wr_data),
    .sdio_cmd53_wr_end(sdio_cmd53_wr_end),
    .sdio_cmd53_wr_ok(sdio_cmd53_wr_ok),
    .sdio_cmd53_wr_abort(sdio_cmd53_wr_abort),

    .sdio_cmd53_rd_valid(sdio_cmd53_rd_valid),
    .sdio_cmd53_rd_data(sdio_cmd53_rd_data),
    .sdio_cmd53_rd_ready(sdio_cmd53_rd_ready),
    .sdio_cmd53_rd_end(sdio_cmd53_rd_end),
    .sdio_cmd53_rd_abort(sdio_cmd53_rd_abort),

    .sdio_buffer_full(sdio_buffer_full),

    .sdio_tuning_start(sdio_tuning_start),
    .sdio_tuning_data(sdio_tuning_data),
    .sdio_tuning_end(sdio_tuning_end)
);


endmodule
