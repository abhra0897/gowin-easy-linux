//******************************************************************************
//   Copyright (C) 2018 Synopsys, Inc.
//   This IP and the associated documentation are confidential and
//   proprietary to Synopsys, Inc. Your use or disclosure of this IP is 
//   subject to the terms and conditions of a written license agreement 
//   between you, or your company, and Synopsys, Inc.
//*******************************************************************************
//   Title      : HBM2 Synthesisable Memory Model instance file
//   Project    : HBM2
//*******************************************************************************
//   Description: 
//*******************************************************************************
//   File       : hbm2_memory_model_top_inst.v
//   Created    : 2018/06/01 (YYYY/MM/DD)
//*******************************************************************************
//   $Id:  $
//   $Author: nakulm $
//   $Revision: #1 $
//   $DateTime:  $
//******************************************************************************/

//ddr4 signals
wire         ddr_mmcm_locked;

wire dfi_cmn_clk;
wire           dfi_cmn_rst_n;

assign dfi_cmn_clk = ACLK;


////////////////////////////////Reset Synchronizer////////////////////////////////////////

  RESETsync_dly #(1) u_reset_sync1 (
   .CLK(ACLK),
   .RESET(SYS_RESET_N),
   .O(dfi_cmn_rst_n)
  );



////////////////////////////////HBM2 memory model instantiation////////////////////////////////////////
hbm2_memory_model_top #(
    // Behavioural parameters
    .MEM_WRITE_LATENCY                  (20),
    .MEM_READ_LATENCY                   (23),
    .MEM_BURST_LENGTH                   (8),
    .DFI_T_PHY_WRDATA                   (2),
    .DFI_T_PHY_WRLAT                    (5),
    .DFI_T_CTRL_DELAY                   (3),

    // DFI width parameters
    .DFI_CHIP_SELECT_WIDTH              (1),
    .DFI_DATA_ENABLE_WIDTH              (4),
    .DFI_DBI_WIDTH                      (32),
    .MR4_SET                            (20'h00003),
    .NO_OF_PSEUDO_CHANNEL               (16),
    .NOOF_MEMCONTROLLER                 (1) 
                                                  
) u_hbm2_model (
    // system
    .irstx                      (dfi_cmn_rst_n), 
    .dfi_clk                    (dfi_cmn_clk),    
    .mem_clk                    (MEM_CLK),    

    // DFI Control Interface channel 0
    .idfi_address_p0_ch0            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p0_ch0                (dfi_row_p0_ch0),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p0_ch0                (dfi_col_p0_ch0),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p0_ch0               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p0_ch0              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p0_ch0              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p0_ch0               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p0_ch0                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p0_ch0              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1 :0]
    .idfi_bg_p0_ch0                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p0_ch0                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p0_ch0                (dfi_cke_p0_ch0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p0_ch0                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p0_ch0            (dfi_reset_n_p0_ch0),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .idfi_address_p1_ch0            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p1_ch0                (dfi_row_p1_ch0),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p1_ch0                (dfi_col_p1_ch0),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p1_ch0               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p1_ch0              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p1_ch0              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p1_ch0               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p1_ch0                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p1_ch0              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1:0]
    .idfi_bg_p1_ch0                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p1_ch0                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p1_ch0                (dfi_cke_p1_ch0),        //input  [ (NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p1_ch0                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p1_ch0            (dfi_reset_n_p1_ch0),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    // DFI Write Data Interface
    .idfi_wrdata_en_p0_ch0          (dfi_wrdata_en_p0_ch0),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p0_ch0             (dfi_wrdata_p0_ch0),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p0_ch0          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p0_ch0        (dfi_wrdata_mask_p0_ch0), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p0_ch0             (dfi_wr_dbi_p0_ch0),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p0_ch0             (dfi_wr_par_p0_ch0),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_wrdata_en_p1_ch0          (dfi_wrdata_en_p1_ch0),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p1_ch0             (dfi_wrdata_p1_ch0),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p1_ch0          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p1_ch0        (dfi_wrdata_mask_p1_ch0), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p1_ch0             (dfi_wr_dbi_p1_ch0),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p1_ch0             (dfi_wr_par_p1_ch0),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Read Data Interface
    .idfi_rddata_en_p0_ch0          (dfi_rddata_en_p0_ch0),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w0_ch0             (dfi_rddata_w0_ch0),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p0_ch0          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w0_ch0       (dfi_rddata_valid_w0_ch0),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w0_ch0         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w0_ch0         (dfi_rddata_dbi_w0_ch0),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w0_ch0          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w0_ch0             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w0_ch0             (dfi_rd_par_w0_ch0),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_rddata_en_p1_ch0          (dfi_rddata_en_p1_ch0),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w1_ch0             (dfi_rddata_w1_ch0),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p1_ch0          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w1_ch0       (dfi_rddata_valid_w1_ch0),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w1_ch0         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w1_ch0         (dfi_rddata_dbi_w1_ch0),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w1_ch0          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w1_ch0             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w1_ch0             (dfi_rd_par_w1_ch0),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Update Interface
    .idfi_ctrlupd_req_ch0           (dfi_ctrlupd_req_ch0),   //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_ctrlupd_ack_ch0           (dfi_ctrlupd_ack_ch0),   //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_req_ch0           (dfi_phyupd_req_ch0),    //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_type_ch0           (dfi_phyupd_type_ch0),   //output [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_phyupd_ack_ch0           (dfi_phyupd_ack_ch0),    //input  [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Status Interface
    .odfi_aerr_a0_ch0               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_aerr_a1_ch0               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_derr_e0_ch0               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .odfi_derr_e1_ch0               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .idfi_dram_clk_disable_ch0      (16'd0),    //input  [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_data_byte_disable_ch0     (256'd0),                 
    .idfi_freq_ratio_ch0            (16'd0),                 
    .odfi_init_complete_ch0         (dfi_init_complete_ch0), //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_init_start_ch0            (dfi_init_start_ch0),    //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_parity_error_ch0          (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p0_ch0          (8'd0),   
    .odfi_alert_n_a0_ch0            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p1_ch0          (8'd0),   
    .odfi_alert_n_a1_ch0            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Training Interface // DDR3 and LPDDR2
    .odfi_rdlvl_req_ch0             (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_cs_ch0          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_en_ch0              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_rdlvl_resp_ch0            (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0]

    .odfi_rdlvl_gate_req_ch0        (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_gate_cs_ch0     (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_gate_en_ch0         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_cs_ch0              (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_wrlvl_req_ch0             (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0]
    .idfi_phy_wrlvl_cs_ch0          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0]
    .idfi_wrlvl_en_ch0              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_wrlvl_strobe_ch0          (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_resp_ch0            (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0]
    .idfi_wrlvl_cs_ch0            (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_calvl_req_ch0             (),                 //output [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_PHY_WIDTH)-1:0]
    .idfi_phy_calvl_cs_ch0          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_calvl_en_ch0              (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .idfi_calvl_capture_ch0         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .odfi_calvl_resp_ch0            (),                 //output [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0]

    .idfi_lvl_pattern_ch0         (32'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] 
    .idfi_lvl_periodic_ch0         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_LEVELING_PHY_WIDTH)-1:0]

    .odfi_phylvl_req_cs_ch0         (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_phylvl_ack_cs_ch0         (16'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]

    // DFI Low Power Control Interface
    .idfi_lp_ctrl_req_ch0           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_data_req_ch0           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_wakeup_ch0           (32'd0),     //input  [NOOF_MEMCONTROLLER*3 : 0]
    .odfi_lp_ack_ch0           (),        //output [NOOF_MEMCONTROLLER-1 : 0]

    // ERROR Interface
    .odfi_error_ch0                 (),          //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH)-1:0]
    .odfi_error_info_ch0            (),      //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH*4)-1:0]

    .idfi_rdlvl_load_ch0            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_rdlvl_mode_ch0            (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .odfi_rdlvl_gate_mode_ch0       (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .idfi_rdlvl_edge_ch0            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_delay_X_ch0         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_DELAY_WIDTH)-1:0]
    .idfi_rdlvl_gate_delay_X_ch0    (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0]

    .idfi_wrlvl_load_ch0            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_mode_ch0            (),                 //output [NOOF_MEMCONTROLLER *  1:0]
    .idfi_wrlvl_delay_X_ch0         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0]

    // DFI Control Interface channel 1
    .idfi_address_p0_ch1            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p0_ch1                (dfi_row_p0_ch1),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p0_ch1                (dfi_col_p0_ch1),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p0_ch1               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p0_ch1              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p0_ch1              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p0_ch1               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p0_ch1                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p0_ch1              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1 :0]
    .idfi_bg_p0_ch1                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p0_ch1                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p0_ch1                (dfi_cke_p0_ch1),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p0_ch1                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p0_ch1            (dfi_reset_n_p0_ch1),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .idfi_address_p1_ch1            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p1_ch1                (dfi_row_p1_ch1),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p1_ch1                (dfi_col_p1_ch1),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p1_ch1               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p1_ch1              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p1_ch1              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p1_ch1               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p1_ch1                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p1_ch1              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1:0]
    .idfi_bg_p1_ch1                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p1_ch1                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p1_ch1                (dfi_cke_p1_ch1),        //input  [ (NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p1_ch1                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p1_ch1            (dfi_reset_n_p1_ch1),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    // DFI Write Data Interface
    .idfi_wrdata_en_p0_ch1          (dfi_wrdata_en_p0_ch1),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p0_ch1             (dfi_wrdata_p0_ch1),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p0_ch1          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p0_ch1        (dfi_wrdata_mask_p0_ch1), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p0_ch1             (dfi_wr_dbi_p0_ch1),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p0_ch1             (dfi_wr_par_p0_ch1),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_wrdata_en_p1_ch1          (dfi_wrdata_en_p1_ch1),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p1_ch1             (dfi_wrdata_p1_ch1),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p1_ch1          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p1_ch1        (dfi_wrdata_mask_p1_ch1), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p1_ch1             (dfi_wr_dbi_p1_ch1),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p1_ch1             (dfi_wr_par_p1_ch1),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Read Data Interface
    .idfi_rddata_en_p0_ch1          (dfi_rddata_en_p0_ch1),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w0_ch1             (dfi_rddata_w0_ch1),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p0_ch1          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w0_ch1       (dfi_rddata_valid_w0_ch1),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w0_ch1         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w0_ch1         (dfi_rddata_dbi_w0_ch1),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w0_ch1          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w0_ch1             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w0_ch1             (dfi_rd_par_w0_ch1),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_rddata_en_p1_ch1          (dfi_rddata_en_p1_ch1),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w1_ch1             (dfi_rddata_w1_ch1),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p1_ch1          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w1_ch1       (dfi_rddata_valid_w1_ch1),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w1_ch1         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w1_ch1         (dfi_rddata_dbi_w1_ch1),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w1_ch1          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w1_ch1             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w1_ch1             (dfi_rd_par_w1_ch1),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Update Interface
    .idfi_ctrlupd_req_ch1           (dfi_ctrlupd_req_ch1),   //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_ctrlupd_ack_ch1           (dfi_ctrlupd_ack_ch1),   //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_req_ch1           (dfi_phyupd_req_ch1),    //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_type_ch1           (dfi_phyupd_type_ch1),   //output [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_phyupd_ack_ch1           (dfi_phyupd_ack_ch1),    //input  [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Status Interface
    .odfi_aerr_a0_ch1               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_aerr_a1_ch1               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_derr_e0_ch1               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .odfi_derr_e1_ch1               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .idfi_dram_clk_disable_ch1      (16'd0),    //input  [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_data_byte_disable_ch1     (256'd0),                 
    .idfi_freq_ratio_ch1            (16'd0),                 
    .odfi_init_complete_ch1         (dfi_init_complete_ch1), //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_init_start_ch1            (dfi_init_start_ch1),    //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_parity_error_ch1          (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p0_ch1          (8'd0),   
    .odfi_alert_n_a0_ch1            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p1_ch1          (8'd0),   
    .odfi_alert_n_a1_ch1            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Training Interface // DDR3 and LPDDR2
    .odfi_rdlvl_req_ch1             (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_cs_ch1          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_en_ch1              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_rdlvl_resp_ch1            (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0]

    .odfi_rdlvl_gate_req_ch1        (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_gate_cs_ch1     (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_gate_en_ch1         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_cs_ch1              (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_wrlvl_req_ch1             (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0]
    .idfi_phy_wrlvl_cs_ch1          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0]
    .idfi_wrlvl_en_ch1              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_wrlvl_strobe_ch1          (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_resp_ch1            (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0]
    .idfi_wrlvl_cs_ch1            (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_calvl_req_ch1             (),                 //output [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_PHY_WIDTH)-1:0]
    .idfi_phy_calvl_cs_ch1          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_calvl_en_ch1              (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .idfi_calvl_capture_ch1         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .odfi_calvl_resp_ch1            (),                 //output [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0]

    .idfi_lvl_pattern_ch1         (32'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] 
    .idfi_lvl_periodic_ch1         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_LEVELING_PHY_WIDTH)-1:0]

    .odfi_phylvl_req_cs_ch1         (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_phylvl_ack_cs_ch1         (16'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]

    // DFI Low Power Control Interface
    .idfi_lp_ctrl_req_ch1           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_data_req_ch1           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_wakeup_ch1           (32'd0),     //input  [NOOF_MEMCONTROLLER*3 : 0]
    .odfi_lp_ack_ch1           (),        //output [NOOF_MEMCONTROLLER-1 : 0]

    // ERROR Interface
    .odfi_error_ch1                 (),          //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH)-1:0]
    .odfi_error_info_ch1            (),      //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH*4)-1:0]

    .idfi_rdlvl_load_ch1            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_rdlvl_mode_ch1            (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .odfi_rdlvl_gate_mode_ch1       (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .idfi_rdlvl_edge_ch1            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_delay_X_ch1         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_DELAY_WIDTH)-1:0]
    .idfi_rdlvl_gate_delay_X_ch1    (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0]

    .idfi_wrlvl_load_ch1            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_mode_ch1            (),                 //output [NOOF_MEMCONTROLLER *  1:0]
    .idfi_wrlvl_delay_X_ch1         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0]

    // DFI Control Interface channel 2
    .idfi_address_p0_ch2            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p0_ch2                (dfi_row_p0_ch2),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p0_ch2                (dfi_col_p0_ch2),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p0_ch2               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p0_ch2              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p0_ch2              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p0_ch2               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p0_ch2                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p0_ch2              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1 :0]
    .idfi_bg_p0_ch2                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p0_ch2                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p0_ch2                (dfi_cke_p0_ch2),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p0_ch2                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p0_ch2            (dfi_reset_n_p0_ch2),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .idfi_address_p1_ch2            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p1_ch2                (dfi_row_p1_ch2),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p1_ch2                (dfi_col_p1_ch2),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p1_ch2               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p1_ch2              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p1_ch2              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p1_ch2               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p1_ch2                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p1_ch2              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1:0]
    .idfi_bg_p1_ch2                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p1_ch2                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p1_ch2                (dfi_cke_p1_ch2),        //input  [ (NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p1_ch2                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p1_ch2            (dfi_reset_n_p1_ch2),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    // DFI Write Data Interface
    .idfi_wrdata_en_p0_ch2          (dfi_wrdata_en_p0_ch2),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p0_ch2             (dfi_wrdata_p0_ch2),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p0_ch2          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p0_ch2        (dfi_wrdata_mask_p0_ch2), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p0_ch2             (dfi_wr_dbi_p0_ch2),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p0_ch2             (dfi_wr_par_p0_ch2),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_wrdata_en_p1_ch2          (dfi_wrdata_en_p1_ch2),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p1_ch2             (dfi_wrdata_p1_ch2),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p1_ch2          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p1_ch2        (dfi_wrdata_mask_p1_ch2), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p1_ch2             (dfi_wr_dbi_p1_ch2),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p1_ch2             (dfi_wr_par_p1_ch2),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Read Data Interface
    .idfi_rddata_en_p0_ch2          (dfi_rddata_en_p0_ch2),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w0_ch2             (dfi_rddata_w0_ch2),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p0_ch2          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w0_ch2       (dfi_rddata_valid_w0_ch2),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w0_ch2         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w0_ch2         (dfi_rddata_dbi_w0_ch2),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w0_ch2          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w0_ch2             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w0_ch2             (dfi_rd_par_w0_ch2),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_rddata_en_p1_ch2          (dfi_rddata_en_p1_ch2),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w1_ch2             (dfi_rddata_w1_ch2),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p1_ch2          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w1_ch2       (dfi_rddata_valid_w1_ch2),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w1_ch2         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w1_ch2         (dfi_rddata_dbi_w1_ch2),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w1_ch2          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w1_ch2             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w1_ch2             (dfi_rd_par_w1_ch2),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Update Interface
    .idfi_ctrlupd_req_ch2           (dfi_ctrlupd_req_ch2),   //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_ctrlupd_ack_ch2           (dfi_ctrlupd_ack_ch2),   //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_req_ch2           (dfi_phyupd_req_ch2),    //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_type_ch2           (dfi_phyupd_type_ch2),   //output [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_phyupd_ack_ch2           (dfi_phyupd_ack_ch2),    //input  [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Status Interface
    .odfi_aerr_a0_ch2               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_aerr_a1_ch2               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_derr_e0_ch2               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .odfi_derr_e1_ch2               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .idfi_dram_clk_disable_ch2      (16'd0),    //input  [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_data_byte_disable_ch2     (256'd0),                 
    .idfi_freq_ratio_ch2            (16'd0),                 
    .odfi_init_complete_ch2         (dfi_init_complete_ch2), //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_init_start_ch2            (dfi_init_start_ch2),    //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_parity_error_ch2          (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p0_ch2          (8'd0),   
    .odfi_alert_n_a0_ch2            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p1_ch2          (8'd0),   
    .odfi_alert_n_a1_ch2            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Training Interface // DDR3 and LPDDR2
    .odfi_rdlvl_req_ch2             (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_cs_ch2          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_en_ch2              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_rdlvl_resp_ch2            (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0]

    .odfi_rdlvl_gate_req_ch2        (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_gate_cs_ch2     (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_gate_en_ch2         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_cs_ch2              (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_wrlvl_req_ch2             (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0]
    .idfi_phy_wrlvl_cs_ch2          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0]
    .idfi_wrlvl_en_ch2              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_wrlvl_strobe_ch2          (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_resp_ch2            (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0]
    .idfi_wrlvl_cs_ch2            (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_calvl_req_ch2             (),                 //output [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_PHY_WIDTH)-1:0]
    .idfi_phy_calvl_cs_ch2          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_calvl_en_ch2              (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .idfi_calvl_capture_ch2         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .odfi_calvl_resp_ch2            (),                 //output [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0]

    .idfi_lvl_pattern_ch2         (32'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] 
    .idfi_lvl_periodic_ch2         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_LEVELING_PHY_WIDTH)-1:0]

    .odfi_phylvl_req_cs_ch2         (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_phylvl_ack_cs_ch2         (16'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]

    // DFI Low Power Control Interface
    .idfi_lp_ctrl_req_ch2           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_data_req_ch2           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_wakeup_ch2           (32'd0),     //input  [NOOF_MEMCONTROLLER*3 : 0]
    .odfi_lp_ack_ch2           (),        //output [NOOF_MEMCONTROLLER-1 : 0]

    // ERROR Interface
    .odfi_error_ch2                 (),          //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH)-1:0]
    .odfi_error_info_ch2            (),      //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH*4)-1:0]

    .idfi_rdlvl_load_ch2            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_rdlvl_mode_ch2            (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .odfi_rdlvl_gate_mode_ch2       (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .idfi_rdlvl_edge_ch2            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_delay_X_ch2         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_DELAY_WIDTH)-1:0]
    .idfi_rdlvl_gate_delay_X_ch2    (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0]

    .idfi_wrlvl_load_ch2            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_mode_ch2            (),                 //output [NOOF_MEMCONTROLLER *  1:0]
    .idfi_wrlvl_delay_X_ch2         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0]

    // DFI Control Interface channel 3
    .idfi_address_p0_ch3            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p0_ch3                (dfi_row_p0_ch3),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p0_ch3                (dfi_col_p0_ch3),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p0_ch3               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p0_ch3              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p0_ch3              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p0_ch3               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p0_ch3                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p0_ch3              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1 :0]
    .idfi_bg_p0_ch3                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p0_ch3                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p0_ch3                (dfi_cke_p0_ch3),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p0_ch3                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p0_ch3            (dfi_reset_n_p0_ch3),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .idfi_address_p1_ch3            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p1_ch3                (dfi_row_p1_ch3),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p1_ch3                (dfi_col_p1_ch3),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p1_ch3               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p1_ch3              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p1_ch3              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p1_ch3               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p1_ch3                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p1_ch3              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1:0]
    .idfi_bg_p1_ch3                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p1_ch3                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p1_ch3                (dfi_cke_p1_ch3),        //input  [ (NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p1_ch3                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p1_ch3            (dfi_reset_n_p1_ch3),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    // DFI Write Data Interface
    .idfi_wrdata_en_p0_ch3          (dfi_wrdata_en_p0_ch3),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p0_ch3             (dfi_wrdata_p0_ch3),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p0_ch3          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p0_ch3        (dfi_wrdata_mask_p0_ch3), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p0_ch3             (dfi_wr_dbi_p0_ch3),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p0_ch3             (dfi_wr_par_p0_ch3),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_wrdata_en_p1_ch3          (dfi_wrdata_en_p1_ch3),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p1_ch3             (dfi_wrdata_p1_ch3),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p1_ch3          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p1_ch3        (dfi_wrdata_mask_p1_ch3), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p1_ch3             (dfi_wr_dbi_p1_ch3),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p1_ch3             (dfi_wr_par_p1_ch3),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Read Data Interface
    .idfi_rddata_en_p0_ch3          (dfi_rddata_en_p0_ch3),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w0_ch3             (dfi_rddata_w0_ch3),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p0_ch3          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w0_ch3       (dfi_rddata_valid_w0_ch3),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w0_ch3         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w0_ch3         (dfi_rddata_dbi_w0_ch3),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w0_ch3          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w0_ch3             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w0_ch3             (dfi_rd_par_w0_ch3),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_rddata_en_p1_ch3          (dfi_rddata_en_p1_ch3),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w1_ch3             (dfi_rddata_w1_ch3),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p1_ch3          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w1_ch3       (dfi_rddata_valid_w1_ch3),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w1_ch3         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w1_ch3         (dfi_rddata_dbi_w1_ch3),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w1_ch3          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w1_ch3             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w1_ch3             (dfi_rd_par_w1_ch3),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Update Interface
    .idfi_ctrlupd_req_ch3           (dfi_ctrlupd_req_ch3),   //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_ctrlupd_ack_ch3           (dfi_ctrlupd_ack_ch3),   //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_req_ch3           (dfi_phyupd_req_ch3),    //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_type_ch3           (dfi_phyupd_type_ch3),   //output [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_phyupd_ack_ch3           (dfi_phyupd_ack_ch3),    //input  [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Status Interface
    .odfi_aerr_a0_ch3               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_aerr_a1_ch3               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_derr_e0_ch3               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .odfi_derr_e1_ch3               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .idfi_dram_clk_disable_ch3      (16'd0),    //input  [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_data_byte_disable_ch3     (256'd0),                 
    .idfi_freq_ratio_ch3            (16'd0),                 
    .odfi_init_complete_ch3         (dfi_init_complete_ch3), //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_init_start_ch3            (dfi_init_start_ch3),    //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_parity_error_ch3          (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p0_ch3          (8'd0),   
    .odfi_alert_n_a0_ch3            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p1_ch3          (8'd0),   
    .odfi_alert_n_a1_ch3            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Training Interface // DDR3 and LPDDR2
    .odfi_rdlvl_req_ch3             (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_cs_ch3          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_en_ch3              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_rdlvl_resp_ch3            (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0]

    .odfi_rdlvl_gate_req_ch3        (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_gate_cs_ch3     (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_gate_en_ch3         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_cs_ch3              (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_wrlvl_req_ch3             (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0]
    .idfi_phy_wrlvl_cs_ch3          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0]
    .idfi_wrlvl_en_ch3              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_wrlvl_strobe_ch3          (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_resp_ch3            (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0]
    .idfi_wrlvl_cs_ch3            (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_calvl_req_ch3             (),                 //output [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_PHY_WIDTH)-1:0]
    .idfi_phy_calvl_cs_ch3          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_calvl_en_ch3              (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .idfi_calvl_capture_ch3         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .odfi_calvl_resp_ch3            (),                 //output [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0]

    .idfi_lvl_pattern_ch3         (32'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] 
    .idfi_lvl_periodic_ch3         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_LEVELING_PHY_WIDTH)-1:0]

    .odfi_phylvl_req_cs_ch3         (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_phylvl_ack_cs_ch3         (16'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]

    // DFI Low Power Control Interface
    .idfi_lp_ctrl_req_ch3           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_data_req_ch3           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_wakeup_ch3           (32'd0),     //input  [NOOF_MEMCONTROLLER*3 : 0]
    .odfi_lp_ack_ch3           (),        //output [NOOF_MEMCONTROLLER-1 : 0]

    // ERROR Interface
    .odfi_error_ch3                 (),          //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH)-1:0]
    .odfi_error_info_ch3            (),      //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH*4)-1:0]

    .idfi_rdlvl_load_ch3            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_rdlvl_mode_ch3            (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .odfi_rdlvl_gate_mode_ch3       (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .idfi_rdlvl_edge_ch3            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_delay_X_ch3         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_DELAY_WIDTH)-1:0]
    .idfi_rdlvl_gate_delay_X_ch3    (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0]

    .idfi_wrlvl_load_ch3            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_mode_ch3            (),                 //output [NOOF_MEMCONTROLLER *  1:0]
    .idfi_wrlvl_delay_X_ch3         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0]

    // DFI Control Interface channel 4
    .idfi_address_p0_ch4            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p0_ch4                (dfi_row_p0_ch4),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p0_ch4                (dfi_col_p0_ch4),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p0_ch4               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p0_ch4              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p0_ch4              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p0_ch4               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p0_ch4                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p0_ch4              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1 :0]
    .idfi_bg_p0_ch4                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p0_ch4                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p0_ch4                (dfi_cke_p0_ch4),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p0_ch4                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p0_ch4            (dfi_reset_n_p0_ch4),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .idfi_address_p1_ch4            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p1_ch4                (dfi_row_p1_ch4),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p1_ch4                (dfi_col_p1_ch4),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p1_ch4               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p1_ch4              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p1_ch4              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p1_ch4               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p1_ch4                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p1_ch4              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1:0]
    .idfi_bg_p1_ch4                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p1_ch4                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p1_ch4                (dfi_cke_p1_ch4),        //input  [ (NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p1_ch4                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p1_ch4            (dfi_reset_n_p1_ch4),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    // DFI Write Data Interface
    .idfi_wrdata_en_p0_ch4          (dfi_wrdata_en_p0_ch4),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p0_ch4             (dfi_wrdata_p0_ch4),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p0_ch4          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p0_ch4        (dfi_wrdata_mask_p0_ch4), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p0_ch4             (dfi_wr_dbi_p0_ch4),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p0_ch4             (dfi_wr_par_p0_ch4),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_wrdata_en_p1_ch4          (dfi_wrdata_en_p1_ch4),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p1_ch4             (dfi_wrdata_p1_ch4),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p1_ch4          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p1_ch4        (dfi_wrdata_mask_p1_ch4), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p1_ch4             (dfi_wr_dbi_p1_ch4),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p1_ch4             (dfi_wr_par_p1_ch4),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Read Data Interface
    .idfi_rddata_en_p0_ch4          (dfi_rddata_en_p0_ch4),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w0_ch4             (dfi_rddata_w0_ch4),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p0_ch4          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w0_ch4       (dfi_rddata_valid_w0_ch4),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w0_ch4         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w0_ch4         (dfi_rddata_dbi_w0_ch4),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w0_ch4          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w0_ch4             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w0_ch4             (dfi_rd_par_w0_ch4),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_rddata_en_p1_ch4          (dfi_rddata_en_p1_ch4),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w1_ch4             (dfi_rddata_w1_ch4),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p1_ch4          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w1_ch4       (dfi_rddata_valid_w1_ch4),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w1_ch4         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w1_ch4         (dfi_rddata_dbi_w1_ch4),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w1_ch4          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w1_ch4             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w1_ch4             (dfi_rd_par_w1_ch4),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Update Interface
    .idfi_ctrlupd_req_ch4           (dfi_ctrlupd_req_ch4),   //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_ctrlupd_ack_ch4           (dfi_ctrlupd_ack_ch4),   //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_req_ch4           (dfi_phyupd_req_ch4),    //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_type_ch4           (dfi_phyupd_type_ch4),   //output [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_phyupd_ack_ch4           (dfi_phyupd_ack_ch4),    //input  [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Status Interface
    .odfi_aerr_a0_ch4               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_aerr_a1_ch4               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_derr_e0_ch4               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .odfi_derr_e1_ch4               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .idfi_dram_clk_disable_ch4      (16'd0),    //input  [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_data_byte_disable_ch4     (256'd0),                 
    .idfi_freq_ratio_ch4            (16'd0),                 
    .odfi_init_complete_ch4         (dfi_init_complete_ch4), //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_init_start_ch4            (dfi_init_start_ch4),    //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_parity_error_ch4          (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p0_ch4          (8'd0),   
    .odfi_alert_n_a0_ch4            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p1_ch4          (8'd0),   
    .odfi_alert_n_a1_ch4            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Training Interface // DDR3 and LPDDR2
    .odfi_rdlvl_req_ch4             (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_cs_ch4          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_en_ch4              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_rdlvl_resp_ch4            (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0]

    .odfi_rdlvl_gate_req_ch4        (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_gate_cs_ch4     (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_gate_en_ch4         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_cs_ch4              (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_wrlvl_req_ch4             (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0]
    .idfi_phy_wrlvl_cs_ch4          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0]
    .idfi_wrlvl_en_ch4              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_wrlvl_strobe_ch4          (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_resp_ch4            (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0]
    .idfi_wrlvl_cs_ch4            (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_calvl_req_ch4             (),                 //output [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_PHY_WIDTH)-1:0]
    .idfi_phy_calvl_cs_ch4          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_calvl_en_ch4              (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .idfi_calvl_capture_ch4         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .odfi_calvl_resp_ch4            (),                 //output [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0]

    .idfi_lvl_pattern_ch4         (32'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] 
    .idfi_lvl_periodic_ch4         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_LEVELING_PHY_WIDTH)-1:0]

    .odfi_phylvl_req_cs_ch4         (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_phylvl_ack_cs_ch4         (16'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]

    // DFI Low Power Control Interface
    .idfi_lp_ctrl_req_ch4           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_data_req_ch4           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_wakeup_ch4           (32'd0),     //input  [NOOF_MEMCONTROLLER*3 : 0]
    .odfi_lp_ack_ch4           (),        //output [NOOF_MEMCONTROLLER-1 : 0]

    // ERROR Interface
    .odfi_error_ch4                 (),          //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH)-1:0]
    .odfi_error_info_ch4            (),      //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH*4)-1:0]

    .idfi_rdlvl_load_ch4            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_rdlvl_mode_ch4            (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .odfi_rdlvl_gate_mode_ch4       (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .idfi_rdlvl_edge_ch4            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_delay_X_ch4         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_DELAY_WIDTH)-1:0]
    .idfi_rdlvl_gate_delay_X_ch4    (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0]

    .idfi_wrlvl_load_ch4            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_mode_ch4            (),                 //output [NOOF_MEMCONTROLLER *  1:0]
    .idfi_wrlvl_delay_X_ch4         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0]

    // DFI Control Interface channel 5
    .idfi_address_p0_ch5            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p0_ch5                (dfi_row_p0_ch5),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p0_ch5                (dfi_col_p0_ch5),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p0_ch5               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p0_ch5              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p0_ch5              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p0_ch5               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p0_ch5                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p0_ch5              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1 :0]
    .idfi_bg_p0_ch5                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p0_ch5                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p0_ch5                (dfi_cke_p0_ch5),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p0_ch5                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p0_ch5            (dfi_reset_n_p0_ch5),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .idfi_address_p1_ch5            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p1_ch5                (dfi_row_p1_ch5),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p1_ch5                (dfi_col_p1_ch5),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p1_ch5               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p1_ch5              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p1_ch5              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p1_ch5               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p1_ch5                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p1_ch5              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1:0]
    .idfi_bg_p1_ch5                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p1_ch5                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p1_ch5                (dfi_cke_p1_ch5),        //input  [ (NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p1_ch5                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p1_ch5            (dfi_reset_n_p1_ch5),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    // DFI Write Data Interface
    .idfi_wrdata_en_p0_ch5          (dfi_wrdata_en_p0_ch5),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p0_ch5             (dfi_wrdata_p0_ch5),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p0_ch5          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p0_ch5        (dfi_wrdata_mask_p0_ch5), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p0_ch5             (dfi_wr_dbi_p0_ch5),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p0_ch5             (dfi_wr_par_p0_ch5),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_wrdata_en_p1_ch5          (dfi_wrdata_en_p1_ch5),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p1_ch5             (dfi_wrdata_p1_ch5),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p1_ch5          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p1_ch5        (dfi_wrdata_mask_p1_ch5), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p1_ch5             (dfi_wr_dbi_p1_ch5),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p1_ch5             (dfi_wr_par_p1_ch5),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Read Data Interface
    .idfi_rddata_en_p0_ch5          (dfi_rddata_en_p0_ch5),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w0_ch5             (dfi_rddata_w0_ch5),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p0_ch5          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w0_ch5       (dfi_rddata_valid_w0_ch5),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w0_ch5         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w0_ch5         (dfi_rddata_dbi_w0_ch5),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w0_ch5          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w0_ch5             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w0_ch5             (dfi_rd_par_w0_ch5),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_rddata_en_p1_ch5          (dfi_rddata_en_p1_ch5),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w1_ch5             (dfi_rddata_w1_ch5),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p1_ch5          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w1_ch5       (dfi_rddata_valid_w1_ch5),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w1_ch5         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w1_ch5         (dfi_rddata_dbi_w1_ch5),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w1_ch5          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w1_ch5             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w1_ch5             (dfi_rd_par_w1_ch5),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Update Interface
    .idfi_ctrlupd_req_ch5           (dfi_ctrlupd_req_ch5),   //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_ctrlupd_ack_ch5           (dfi_ctrlupd_ack_ch5),   //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_req_ch5           (dfi_phyupd_req_ch5),    //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_type_ch5           (dfi_phyupd_type_ch5),   //output [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_phyupd_ack_ch5           (dfi_phyupd_ack_ch5),    //input  [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Status Interface
    .odfi_aerr_a0_ch5               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_aerr_a1_ch5               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_derr_e0_ch5               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .odfi_derr_e1_ch5               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .idfi_dram_clk_disable_ch5      (16'd0),    //input  [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_data_byte_disable_ch5     (256'd0),                 
    .idfi_freq_ratio_ch5            (16'd0),                 
    .odfi_init_complete_ch5         (dfi_init_complete_ch5), //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_init_start_ch5            (dfi_init_start_ch5),    //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_parity_error_ch5          (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p0_ch5          (8'd0),   
    .odfi_alert_n_a0_ch5            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p1_ch5          (8'd0),   
    .odfi_alert_n_a1_ch5            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Training Interface // DDR3 and LPDDR2
    .odfi_rdlvl_req_ch5             (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_cs_ch5          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_en_ch5              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_rdlvl_resp_ch5            (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0]

    .odfi_rdlvl_gate_req_ch5        (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_gate_cs_ch5     (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_gate_en_ch5         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_cs_ch5              (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_wrlvl_req_ch5             (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0]
    .idfi_phy_wrlvl_cs_ch5          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0]
    .idfi_wrlvl_en_ch5              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_wrlvl_strobe_ch5          (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_resp_ch5            (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0]
    .idfi_wrlvl_cs_ch5            (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_calvl_req_ch5             (),                 //output [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_PHY_WIDTH)-1:0]
    .idfi_phy_calvl_cs_ch5          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_calvl_en_ch5              (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .idfi_calvl_capture_ch5         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .odfi_calvl_resp_ch5            (),                 //output [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0]

    .idfi_lvl_pattern_ch5         (32'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] 
    .idfi_lvl_periodic_ch5         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_LEVELING_PHY_WIDTH)-1:0]

    .odfi_phylvl_req_cs_ch5         (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_phylvl_ack_cs_ch5         (16'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]

    // DFI Low Power Control Interface
    .idfi_lp_ctrl_req_ch5           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_data_req_ch5           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_wakeup_ch5           (32'd0),     //input  [NOOF_MEMCONTROLLER*3 : 0]
    .odfi_lp_ack_ch5           (),        //output [NOOF_MEMCONTROLLER-1 : 0]

    // ERROR Interface
    .odfi_error_ch5                 (),          //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH)-1:0]
    .odfi_error_info_ch5            (),      //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH*4)-1:0]

    .idfi_rdlvl_load_ch5            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_rdlvl_mode_ch5            (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .odfi_rdlvl_gate_mode_ch5       (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .idfi_rdlvl_edge_ch5            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_delay_X_ch5         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_DELAY_WIDTH)-1:0]
    .idfi_rdlvl_gate_delay_X_ch5    (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0]

    .idfi_wrlvl_load_ch5            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_mode_ch5            (),                 //output [NOOF_MEMCONTROLLER *  1:0]
    .idfi_wrlvl_delay_X_ch5         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0]

    // DFI Control Interface channel 6
    .idfi_address_p0_ch6            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p0_ch6                (dfi_row_p0_ch6),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p0_ch6                (dfi_col_p0_ch6),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p0_ch6               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p0_ch6              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p0_ch6              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p0_ch6               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p0_ch6                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p0_ch6              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1 :0]
    .idfi_bg_p0_ch6                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p0_ch6                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p0_ch6                (dfi_cke_p0_ch6),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p0_ch6                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p0_ch6            (dfi_reset_n_p0_ch6),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .idfi_address_p1_ch6            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p1_ch6                (dfi_row_p1_ch6),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p1_ch6                (dfi_col_p1_ch6),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p1_ch6               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p1_ch6              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p1_ch6              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p1_ch6               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p1_ch6                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p1_ch6              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1:0]
    .idfi_bg_p1_ch6                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p1_ch6                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p1_ch6                (dfi_cke_p1_ch6),        //input  [ (NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p1_ch6                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p1_ch6            (dfi_reset_n_p1_ch6),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    // DFI Write Data Interface
    .idfi_wrdata_en_p0_ch6          (dfi_wrdata_en_p0_ch6),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p0_ch6             (dfi_wrdata_p0_ch6),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p0_ch6          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p0_ch6        (dfi_wrdata_mask_p0_ch6), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p0_ch6             (dfi_wr_dbi_p0_ch6),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p0_ch6             (dfi_wr_par_p0_ch6),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_wrdata_en_p1_ch6          (dfi_wrdata_en_p1_ch6),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p1_ch6             (dfi_wrdata_p1_ch6),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p1_ch6          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p1_ch6        (dfi_wrdata_mask_p1_ch6), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p1_ch6             (dfi_wr_dbi_p1_ch6),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p1_ch6             (dfi_wr_par_p1_ch6),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Read Data Interface
    .idfi_rddata_en_p0_ch6          (dfi_rddata_en_p0_ch6),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w0_ch6             (dfi_rddata_w0_ch6),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p0_ch6          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w0_ch6       (dfi_rddata_valid_w0_ch6),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w0_ch6         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w0_ch6         (dfi_rddata_dbi_w0_ch6),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w0_ch6          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w0_ch6             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w0_ch6             (dfi_rd_par_w0_ch6),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_rddata_en_p1_ch6          (dfi_rddata_en_p1_ch6),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w1_ch6             (dfi_rddata_w1_ch6),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p1_ch6          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w1_ch6       (dfi_rddata_valid_w1_ch6),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w1_ch6         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w1_ch6         (dfi_rddata_dbi_w1_ch6),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w1_ch6          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w1_ch6             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w1_ch6             (dfi_rd_par_w1_ch6),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Update Interface
    .idfi_ctrlupd_req_ch6           (dfi_ctrlupd_req_ch6),   //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_ctrlupd_ack_ch6           (dfi_ctrlupd_ack_ch6),   //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_req_ch6           (dfi_phyupd_req_ch6),    //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_type_ch6           (dfi_phyupd_type_ch6),   //output [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_phyupd_ack_ch6           (dfi_phyupd_ack_ch6),    //input  [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Status Interface
    .odfi_aerr_a0_ch6               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_aerr_a1_ch6               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_derr_e0_ch6               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .odfi_derr_e1_ch6               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .idfi_dram_clk_disable_ch6      (16'd0),    //input  [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_data_byte_disable_ch6     (256'd0),                 
    .idfi_freq_ratio_ch6            (16'd0),                 
    .odfi_init_complete_ch6         (dfi_init_complete_ch6), //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_init_start_ch6            (dfi_init_start_ch6),    //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_parity_error_ch6          (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p0_ch6          (8'd0),   
    .odfi_alert_n_a0_ch6            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p1_ch6          (8'd0),   
    .odfi_alert_n_a1_ch6            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Training Interface // DDR3 and LPDDR2
    .odfi_rdlvl_req_ch6             (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_cs_ch6          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_en_ch6              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_rdlvl_resp_ch6            (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0]

    .odfi_rdlvl_gate_req_ch6        (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_gate_cs_ch6     (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_gate_en_ch6         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_cs_ch6              (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_wrlvl_req_ch6             (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0]
    .idfi_phy_wrlvl_cs_ch6          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0]
    .idfi_wrlvl_en_ch6              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_wrlvl_strobe_ch6          (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_resp_ch6            (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0]
    .idfi_wrlvl_cs_ch6            (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_calvl_req_ch6             (),                 //output [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_PHY_WIDTH)-1:0]
    .idfi_phy_calvl_cs_ch6          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_calvl_en_ch6              (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .idfi_calvl_capture_ch6         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .odfi_calvl_resp_ch6            (),                 //output [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0]

    .idfi_lvl_pattern_ch6         (32'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] 
    .idfi_lvl_periodic_ch6         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_LEVELING_PHY_WIDTH)-1:0]

    .odfi_phylvl_req_cs_ch6         (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_phylvl_ack_cs_ch6         (16'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]

    // DFI Low Power Control Interface
    .idfi_lp_ctrl_req_ch6           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_data_req_ch6           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_wakeup_ch6           (32'd0),     //input  [NOOF_MEMCONTROLLER*3 : 0]
    .odfi_lp_ack_ch6           (),        //output [NOOF_MEMCONTROLLER-1 : 0]

    // ERROR Interface
    .odfi_error_ch6                 (),          //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH)-1:0]
    .odfi_error_info_ch6            (),      //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH*4)-1:0]

    .idfi_rdlvl_load_ch6            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_rdlvl_mode_ch6            (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .odfi_rdlvl_gate_mode_ch6       (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .idfi_rdlvl_edge_ch6            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_delay_X_ch6         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_DELAY_WIDTH)-1:0]
    .idfi_rdlvl_gate_delay_X_ch6    (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0]

    .idfi_wrlvl_load_ch6            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_mode_ch6            (),                 //output [NOOF_MEMCONTROLLER *  1:0]
    .idfi_wrlvl_delay_X_ch6         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0]

    // DFI Control Interface channel 7
    .idfi_address_p0_ch7            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p0_ch7                (dfi_row_p0_ch7),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p0_ch7                (dfi_col_p0_ch7),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p0_ch7               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p0_ch7              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p0_ch7              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p0_ch7               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p0_ch7                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p0_ch7              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1 :0]
    .idfi_bg_p0_ch7                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p0_ch7                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p0_ch7                (dfi_cke_p0_ch7),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p0_ch7                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p0_ch7            (dfi_reset_n_p0_ch7),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .idfi_address_p1_ch7            (296'd0),    //input  [ (NOOF_MEMCONTROLLER * DFI_ADDRESS_WIDTH)-1:0]
    .idfi_row_p1_ch7                (dfi_row_p1_ch7),                 //input  [  NOOF_MEMCONTROLLER * 11:0]           
    .idfi_col_p1_ch7                (dfi_col_p1_ch7),                 //input  [  NOOF_MEMCONTROLLER * 15:0]           
    .idfi_bank_p1_ch7               (24'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_WIDTH)-1:0]
    .idfi_ras_n_p1_ch7              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cas_n_p1_ch7              (8'd0),       //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_we_n_p1_ch7               (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CONTROL_WIDTH)-1:0]
    .idfi_cs_p1_ch7                 (8'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_act_n_p1_ch7              (8'd0),       //input  [  NOOF_MEMCONTROLLER-1:0]
    .idfi_bg_p1_ch7                 (32'd0),         //input  [ (NOOF_MEMCONTROLLER * DFI_BANK_GROUP_WIDTH)-1:0]
    .idfi_cid_p1_ch7                (16'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_ID_WIDTH)-1:0]
    .idfi_cke_p1_ch7                (dfi_cke_p1_ch7),        //input  [ (NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_odt_p1_ch7                (8'd0),        //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_reset_n_p1_ch7            (dfi_reset_n_p1_ch7),     //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    // DFI Write Data Interface
    .idfi_wrdata_en_p0_ch7          (dfi_wrdata_en_p0_ch7),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p0_ch7             (dfi_wrdata_p0_ch7),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p0_ch7          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p0_ch7        (dfi_wrdata_mask_p0_ch7), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p0_ch7             (dfi_wr_dbi_p0_ch7),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p0_ch7             (dfi_wr_par_p0_ch7),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_wrdata_en_p1_ch7          (dfi_wrdata_en_p1_ch7),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_p1_ch7             (dfi_wrdata_p1_ch7),     //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_wrdata_cs_p1_ch7          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0]
    .idfi_wrdata_mask_p1_ch7        (dfi_wrdata_mask_p1_ch7), //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_dbi_p1_ch7             (dfi_wr_dbi_p1_ch7),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .idfi_wr_par_p1_ch7             (dfi_wr_par_p1_ch7),                 //input  [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Read Data Interface
    .idfi_rddata_en_p0_ch7          (dfi_rddata_en_p0_ch7),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w0_ch7             (dfi_rddata_w0_ch7),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p0_ch7          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w0_ch7       (dfi_rddata_valid_w0_ch7),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w0_ch7         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w0_ch7         (dfi_rddata_dbi_w0_ch7),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w0_ch7          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w0_ch7             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w0_ch7             (dfi_rd_par_w0_ch7),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]

    .idfi_rddata_en_p1_ch7          (dfi_rddata_en_p1_ch7),   //input  [ (NOOF_MEMCONTROLLER * DFI_DATA_ENABLE_WIDTH)-1:0]
    .odfi_rddata_w1_ch7             (dfi_rddata_w1_ch7),     //output [ (NOOF_MEMCONTROLLER * DFI_DATA_WIDTH)-1:0]
    .idfi_rddata_cs_p1_ch7          (16'd0),   //input  [ (NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] 
    .odfi_rddata_valid_w1_ch7       (dfi_rddata_valid_w1_ch7),//output [ (NOOF_MEMCONTROLLER * DFI_READ_DATA_VALID_WIDTH)-1:0]
    .odfi_rddata_dnv_w1_ch7         (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rddata_dbi_w1_ch7         (dfi_rddata_dbi_w1_ch7),  //output [ (NOOF_MEMCONTROLLER * DFI_DBI_WIDTH)-1:0]
    .odfi_rddata_cb_w1_ch7          (/*Not used, HMB */),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_dbi_w1_ch7             (),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 3))-1:0]
    .odfi_rd_par_w1_ch7             (dfi_rd_par_w1_ch7),                 //output [ (NOOF_MEMCONTROLLER * (DFI_DATA_WIDTH >> 5))-1:0]
    // DFI Update Interface
    .idfi_ctrlupd_req_ch7           (dfi_ctrlupd_req_ch7),   //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_ctrlupd_ack_ch7           (dfi_ctrlupd_ack_ch7),   //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_req_ch7           (dfi_phyupd_req_ch7),    //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_phyupd_type_ch7           (dfi_phyupd_type_ch7),   //output [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_phyupd_ack_ch7           (dfi_phyupd_ack_ch7),    //input  [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Status Interface
    .odfi_aerr_a0_ch7               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_aerr_a1_ch7               (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_derr_e0_ch7               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .odfi_derr_e1_ch7               (),                 //output [  NOOF_MEMCONTROLLER * 3:0]
    .idfi_dram_clk_disable_ch7      (16'd0),    //input  [  NOOF_MEMCONTROLLER * 1:0]
    .idfi_data_byte_disable_ch7     (256'd0),                 
    .idfi_freq_ratio_ch7            (16'd0),                 
    .odfi_init_complete_ch7         (dfi_init_complete_ch7), //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_init_start_ch7            (dfi_init_start_ch7),    //input  [  NOOF_MEMCONTROLLER-1 : 0]
    .odfi_parity_error_ch7          (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p0_ch7          (8'd0),   
    .odfi_alert_n_a0_ch7            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]
    .idfi_parity_in_p1_ch7          (8'd0),   
    .odfi_alert_n_a1_ch7            (),                 //output [  NOOF_MEMCONTROLLER-1 : 0]

    // DFI Training Interface // DDR3 and LPDDR2
    .odfi_rdlvl_req_ch7             (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_cs_ch7          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_en_ch7              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_rdlvl_resp_ch7            (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0]

    .odfi_rdlvl_gate_req_ch7        (),                 //output [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_phy_rdlvl_gate_cs_ch7     (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0]
    .idfi_rdlvl_gate_en_ch7         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_cs_ch7              (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_wrlvl_req_ch7             (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0]
    .idfi_phy_wrlvl_cs_ch7          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0]
    .idfi_wrlvl_en_ch7              (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_wrlvl_strobe_ch7          (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_resp_ch7            (),                 //output [(NOOF_MEMCONTROLLER * DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0]
    .idfi_wrlvl_cs_ch7            (16'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]

    .odfi_calvl_req_ch7             (),                 //output [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_PHY_WIDTH)-1:0]
    .idfi_phy_calvl_cs_ch7          (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_calvl_en_ch7              (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .idfi_calvl_capture_ch7         (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_CA_TRAINING_MC_WIDTH)-1:0]
    .odfi_calvl_resp_ch7            (),                 //output [(NOOF_MEMCONTROLLER *  DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0]

    .idfi_lvl_pattern_ch7         (32'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] 
    .idfi_lvl_periodic_ch7         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_LEVELING_PHY_WIDTH)-1:0]

    .odfi_phylvl_req_cs_ch7         (),                 //output [(NOOF_MEMCONTROLLER * DFI_CHIP_SELECT_WIDTH)-1:0]
    .idfi_phylvl_ack_cs_ch7         (16'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_CHIP_SELECT_WIDTH)-1:0]

    // DFI Low Power Control Interface
    .idfi_lp_ctrl_req_ch7           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_data_req_ch7           (8'd0),    //input  [NOOF_MEMCONTROLLER-1 : 0]
    .idfi_lp_wakeup_ch7           (32'd0),     //input  [NOOF_MEMCONTROLLER*3 : 0]
    .odfi_lp_ack_ch7           (),        //output [NOOF_MEMCONTROLLER-1 : 0]

    // ERROR Interface
    .odfi_error_ch7                 (),          //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH)-1:0]
    .odfi_error_info_ch7            (),      //output [(NOOF_MEMCONTROLLER *  DFI_ERROR_WIDTH*4)-1:0]

    .idfi_rdlvl_load_ch7            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0]
    .odfi_rdlvl_mode_ch7            (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .odfi_rdlvl_gate_mode_ch7       (),                 //output [ NOOF_MEMCONTROLLER *  1:0]
    .idfi_rdlvl_edge_ch7            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_MC_IF_WIDTH)-1:0]
    .idfi_rdlvl_delay_X_ch7         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_READ_LEVELING_DELAY_WIDTH)-1:0]
    .idfi_rdlvl_gate_delay_X_ch7    (8'd0),                 //input  [(NOOF_MEMCONTROLLER * DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0]

    .idfi_wrlvl_load_ch7            (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0]
    .odfi_wrlvl_mode_ch7            (),                 //output [NOOF_MEMCONTROLLER *  1:0]
    .idfi_wrlvl_delay_X_ch7         (8'd0),                 //input  [(NOOF_MEMCONTROLLER *  DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0]


    // Ports for DDR3 memory module via HAPS HT3
    .c0_sys_clk_p               (DDR4_REF_CLK_P),   //input 
    .c0_sys_clk_n               (DDR4_REF_CLK_N),   //input 

    .c0_ddr4_addr               (DDR4_A),           //output [16:0]
    .c0_ddr4_ba                 (DDR4_BA),          //output [1:0]
    .c0_ddr4_bg                 (DDR4_BG),          //output [1:0]
    .c0_ddr4_act_n              (DDR4_ACT_N),       //output
    .c0_ddr4_cke                (DDR4_CKE),         //output [1:0]
    .c0_ddr4_odt                (DDR4_ODT),         //output [1:0]
    .c0_ddr4_cs_n               (DDR4_CS_N),        //output [1:0]
    .c0_ddr4_ck_p               (DDR4_CK_P),        //output [1:0]
    .c0_ddr4_ck_n               (DDR4_CK_N),        //output [1:0]
    .c0_ddr4_reset_n            (DDR4_RESET_N),     //output 
    .c0_ddr4_parity             (DDR4_PARITY),      //output 
    .c0_ddr4_dm_dbi             (DDR4_DM_DBI),      //output [8:0]
    .c0_ddr4_dq                 (DDR4_DQ),          //inout  [71:0]
    .c0_ddr4_dqs_p              (DDR4_DQS_P),       //inout  [8:0]
    .c0_ddr4_dqs_n              (DDR4_DQS_N),       //inout  [8:0]

    .c0_init_calib_complete     (ddr_init_complete),  //output 
    .c0_ddr4_sys_clk_valid      (/*not connected internally*/),    //output 
    .c0_ddr4_ui_clk_sync_rst    (ddr_mmcm_locked),         //This will be the ~mmcm_locked //output 

    .dbg_clk                    (),    //output
    .dbg_bus                    ()     //output [1:0]

) ;
