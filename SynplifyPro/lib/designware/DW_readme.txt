Synplicity Synopsys(R) DesignWare(R) Components  version 3.1   08/08

COMPATIBLE WITH:

  Synplify Premier 8.8 & Certify 8.8 onwards.


INTRODUCTION:

The Synplicity tools listed above support Synopsys(R) DesignWare(R)
components through VHDL or Verilog component instantiation or through 
Verilog function inferencing.

Models have been created for a number of the Synopsys(R) DesignWare(R)
components. These models extract the functionality of the component,
but not its implementation. The Synplicity technology mappers are used
to synthesize the model to the most appropriate implementation.

This version of Synplicity Synopsys(R) Designware(R) Components are 
implemented in such a way that for both VHDL and Verilog component 
instantiation, the tool synthesizes the verilog RTL of that component.


If a model has not been defined for a Synopsys(R) DesignWare(R)
component, an error message is generated.


COMPONENT INSTANTIATION SUPPORT IN THIS RELEASE ( Total 125 ):

Verilog and VHDL:

  DW_8b10b_dec
  DW_8b10b_enc
  DW_addsub_dx
  DW_asymfifo_s1_df
  DW_asymfifo_s1_sf
  DW_asymfifo_s2_sf
  DW_asymfifoctl_s1_df
  DW_asymfifoctl_s1_sf
  DW_asymfifoctl_s2_sf
  DW_bc_1
  DW_bc_2
  DW_bc_3
  DW_bc_4
  DW_bc_5
  DW_bc_7
  DW_bc_8
  DW_bc_9
  DW_bc_10
  DW_bin2gray
  DW_cmp_dx
  DW_cntr_gray
  DW_crc_p
  DW_div
  DW_div_pipe
  DW_div_rem
  DW_div_seq
  DW_ecc
  DW_fifo_s1_df
  DW_fifo_s1_sf
  DW_fifo_s2_sf
  DW_fifoctl_s1_df
  DW_fifoctl_s1_sf
  DW_fifoctl_s2_sf
  DW_fp_addsub
  DW_fp_div
  DW_fp_flt2i
  DW_fp_i2flt
  DW_fp_mult
  DW_gray2bin
  DW_inc_gray
  DW_inv_sqrt
  DW_lbsh
  DW_lzd
  DW_minmax
  DW_mult_dx
  DW_mult_pipe
  DW_norm
  DW_norm_rnd
  DW_piped_mac
  DW_prod_sum_pipe
  DW_rash
  DW_rbsh
  DW_ram_2r_w_a_dff
  DW_ram_2r_w_a_lat
  DW_ram_2r_w_s_dff
  DW_ram_2r_w_s_lat
  DW_ram_r_w_a_dff
  DW_ram_r_w_a_lat
  DW_ram_r_w_s_dff
  DW_ram_r_w_s_lat
  DW_ram_rw_a_dff
  DW_ram_rw_a_lat
  DW_ram_rw_s_dff
  DW_ram_rw_s_lat
  DW_shifter
  DW_sqrt
  DW_sqrt_pipe
  DW_square
  DW_squarep
  DW_stack
  DW_stackctl
  DW_tap
  DW_ver_mod
  DW_vhd_mod
  DW01_absval
  DW01_add
  DW01_addsub
  DW01_ash
  DW01_binenc
  DW01_bsh
  DW01_cmp2
  DW01_cmp6
  DW01_csa
  DW01_dec
  DW01_decode
  DW01_inc
  DW01_incdec
  DW01_mux_any
  DW01_prienc
  DW01_satrnd
  DW01_sub
  DW02_cos
  DW02_divide
  DW02_mac
  DW02_mult
  DW02_mult_2_stage
  DW02_mult_3_stage
  DW02_mult_4_stage
  DW02_mult_5_stage
  DW02_mult_6_stage
  DW02_multp
  DW02_prod_sum
  DW02_prod_sum1
  DW02_rem
  DW02_sin
  DW02_sincos
  DW02_sqrt
  DW02_sum
  DW02_tree
  DW03_bictr_dcnto
  DW03_bictr_decode
  DW03_bictr_scnto
  DW03_cntr_gray
  DW03_lfsr_dcnto
  DW03_lfsr_load
  DW03_lfsr_scnto
  DW03_lfsr_updn
  DW03_pipe_reg
  DW03_reg_s_pl
  DW03_shftreg
  DW03_updn_ctr
  DW04_crc32
  DW04_par_gen
  DW04_shad_reg
  DW04_sync



VERILOG FUNCTION INFERENCING SUPPORT (Total 29):  

  DW01_absval_function
  DW01_ash_function
  DW01_binenc_function
  DW01_bsh_function
  DW01_decode_function
  DW01_prienc_function
  DW02_divide_function
  DW02_mac_function
  DW02_mult_function
  DW02_rem_function
  DW02_sqrt_function
  DW02_sum_function
  DW_div_function
  DW_dp_absval_function
  DW_dp_blend_function
  DW_dp_count_ones_function
  DW_dp_rnd_function
  DW_dp_rndsat_function
  DW_dp_sat_function
  DW_dp_sign_select_function
  DW_dp_simd_add_function
  DW_dp_simd_addc_function
  DW_dp_simd_mult_function
  DW_minmax_function
  DW_shifter_function
  DW_sqrt_function
  DW_square_function
  DW_ver_mod_function
  DW_vhd_mod_function
  



Note: Please see the Synplicity Manual or Help document for additional information.
