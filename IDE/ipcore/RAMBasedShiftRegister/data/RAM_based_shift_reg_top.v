
`include "shift_reg_name.v"
`include "shift_reg_define.v"
`timescale 1ns / 1ps

module  `module_name_RAM_shift(
                 clk,
                 Reset,
                 Din,
              `ifdef ADDR_LOSSLESS
                 ADDR,
              `endif
              `ifdef ADDR_LOSSLY
                 ADDR,
              `endif
              `ifdef SET_SET
                 SSET,
              `endif
              `ifdef SET_CLEAR
                 SCLR,
              `endif
                 Q
                );
             
              `include "shift_reg_parameter.v"
               parameter   ASIZE  =  $clog2(WDEPTH);

               input                clk;
               input                Reset;
               input  [DSIZE-1:0]   Din; 
               `ifdef ADDR_LOSSLESS
               input  [ASIZE-1:0]   ADDR;
               `endif
               `ifdef ADDR_LOSSLY
               input  [ASIZE-1:0]   ADDR;
              `endif
              `ifdef SET_SET
               input                SSET;
              `endif
              `ifdef SET_CLEAR
               input                SCLR;
              `endif
               output [DSIZE-1:0]     Q;

////////////////////////////////////////////////////     
        `getname(RAM_based_shift_reg,`module_name_RAM_shift) u_RAM_based_shift_reg(
                 .clk(clk),
                 .Reset(Reset),
                 .Din(Din),
              `ifdef ADDR_LOSSLESS
                 .ADDR(ADDR),
              `endif
              `ifdef ADDR_LOSSLY
                 .ADDR(ADDR),
              `endif
              `ifdef SET_SET
                 .SSET(SSET),
              `endif
              `ifdef SET_CLEAR
                 .SCLR(SCLR),
              `endif
                 .Q(Q)
                );  

 endmodule
