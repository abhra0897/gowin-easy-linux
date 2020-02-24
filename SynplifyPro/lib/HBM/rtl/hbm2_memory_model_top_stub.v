//******************************************************************************
//   Copyright (C) 2018 Synopsys, Inc.
//   This IP and the associated documentation are confidential and
//   proprietary to Synopsys, Inc. Your use or disclosure of this IP is 
//   subject to the terms and conditions of a written license agreement 
//   between you, or your company, and Synopsys, Inc.
//*******************************************************************************
//   Title      : HBM2 Synthesisable Memory Model stub file
//   Project    : HBM2
//*******************************************************************************
//   Description: 
//*******************************************************************************
//   File       : hbm2_memory_model_top_stub.v
//   Created    : 2018/06/01 (YYYY/MM/DD)
//*******************************************************************************
//   $Id:  $
//   $Author: nakulm $
//   $Revision: #1 $
//   $DateTime:  $
//******************************************************************************/
`protect
`define MEMORY_TYPE 6
`define HBM


`timescale 1 ns / 1 ns
`default_nettype wire

//
//
// T_PHY_WRLAT  : Specifies the number of DFI PHY clock cycles between when
//                a write command is sent on the DFI control interface
//                and when the dfi_wrdata_en signal is asserted.
// T_PHY_RDLAT  : Specifies the maximum number of DFI PHY clock cycles allowed
//                from the assertion of the dfi_rddata_en signal to the assertion
//                of the dfi_rddata_valid signal.
// T_RDDATA_EN  : Specifies the number of DFI PHY clock cycles from the
//                assertion of a read command on the DFI to the assertion
//                of the dfi_rddata_en signal.

module hbm2_memory_model_top
   #(

   // Behavioural parameters
   parameter  integer MEM_WRITE_LATENCY                  = 20,
   parameter  integer MEM_READ_LATENCY                   = 23,
   parameter  integer MEM_BURST_LENGTH                   = 8,
   parameter  integer DFI_T_PHY_WRDATA                   = 2,
   parameter  integer DFI_T_PHY_WRLAT                    = 5,
   parameter  integer DFI_T_CTRL_DELAY                   = 3,

   // DFI width parameters
   parameter  integer DFI_ADDRESS_WIDTH                  = 37,
   parameter  integer DFI_BANK_WIDTH                     =  3,
   parameter  integer DFI_BANK_GROUP_WIDTH               =  4,
   parameter  integer DFI_CHIP_ID_WIDTH                  =  2,
   parameter  integer DFI_CHIP_SELECT_WIDTH              =  1,
   parameter  integer DFI_CONTROL_WIDTH                  =  1,
   parameter  integer DFI_DATA_ENABLE_WIDTH              =  4,
   parameter  integer DFI_DATA_WIDTH                     = 256,
   parameter  integer DFI_READ_DATA_VALID_WIDTH          =  4,
   parameter  integer DFI_DBI_WIDTH                      =  32,
   parameter  integer DFI_READ_LEVELING_MC_IF_WIDTH      =  1,
   parameter  integer DFI_READ_LEVELING_DELAY_WIDTH      =  1,
   parameter  integer DFI_READ_LEVELING_GATE_DELAY_WIDTH =  1,
   parameter  integer DFI_READ_LEVELING_PHY_IF_WIDTH     =  1,
   parameter  integer DFI_READ_LEVELING_RESPONSE_WIDTH   =  1,
   parameter  integer DFI_WRITE_LEVELING_DELAY_WIDTH     =  1,
   parameter  integer DFI_WRITE_LEVELING_MC_IF_WIDTH     =  1,
   parameter  integer DFI_WRITE_LEVELING_PHY_IF_WIDTH    =  1,
   parameter  integer DFI_WRITE_LEVELING_RESPONSE_WIDTH  =  1,
   parameter  integer DFI_READ_TRAINING_PHY_WIDTH        =  1,      // NEW
   parameter  integer DFI_WRITE_TRAINING_PHY_WIDTH       =  1,      // NEW
   parameter  integer DFI_CA_TRAINING_PHY_WIDTH          =  1,      // NEW
   parameter  integer DFI_CA_TRAINING_MC_WIDTH           =  1,      // NEW
   parameter  integer DFI_CA_TRAINING_RESPONSE_WIDTH     =  2,      // NEW
   parameter  integer DFI_LEVELING_PHY_WIDTH             =  1,      // NEW
   parameter  integer DFI_ERROR_WIDTH                    =  1,      // NEW
   parameter  integer MEM_BANK_WIDTH                     = DFI_BANK_WIDTH        >> 0,
   parameter  integer MEM_BANK_GROUP_WIDTH               = DFI_BANK_GROUP_WIDTH  >> 0,
   parameter  integer MEM_CHIP_SELECT_WIDTH              = DFI_CHIP_SELECT_WIDTH >> 0,
   parameter  integer MEM_CKE_WIDTH                      = MEM_CHIP_SELECT_WIDTH,
   parameter  integer MEM_CK_WIDTH                       = 1,
   parameter  integer MEM_DQS_WIDTH                      = 4,
   parameter  integer MEM_ODT_WIDTH                      = 1,
   parameter  integer MEM_DATA_WIDTH             = DFI_DATA_WIDTH >> 1,
   parameter  integer NOOF_MEMCONTROLLER                 = 1,
   parameter  integer MR4_SET                            = 20'h00003,
   parameter  integer NO_OF_PSEUDO_CHANNEL               = 16,
   parameter  integer FIFO_DEPTH                         = 8

  )


   (
   // INPUT & OUTPUT

   // system
   input                                               irstx,
   input                                               dfi_clk,
   input                                               mem_clk,

   // DFI Control Interface
   // DFI Control Interface channel 0
   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p0_ch0,
   input      [12-1:0] idfi_row_p0_ch0,   //HBM        
   input      [16-1:0] idfi_col_p0_ch0,   // HBM         
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p0_ch0,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p0_ch0,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p0_ch0,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p0_ch0,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p0_ch0,
   input           idfi_act_n_p0_ch0,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p0_ch0,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p0_ch0,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p0_ch0,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p0_ch0,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p0_ch0,

   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p1_ch0,
   input      [12-1:0] idfi_row_p1_ch0,   //HBM        
   input      [16-1:0] idfi_col_p1_ch0,   //HBM          
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p1_ch0,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p1_ch0,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p1_ch0,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p1_ch0,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p1_ch0,
   input                               idfi_act_n_p1_ch0,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p1_ch0,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p1_ch0,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p1_ch0,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p1_ch0,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p1_ch0,
   // DFI Write Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p0_ch0,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p0_ch0,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p0_ch0,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p0_ch0,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p0_ch0,            // HBM      DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p0_ch0,            // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p1_ch0,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p1_ch0,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p1_ch0,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p1_ch0,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p1_ch0,            // HBM       DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p1_ch0,            // HBM       DFI_DATA_WIDTH/32
   // DFI Read Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p0_ch0,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w0_ch0,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p0_ch0, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w0_ch0,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w0_ch0,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w0_ch0,    // NOT USED ON  , USED ON DDR4/LPDDR4
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w0_ch0,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w0_ch0,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w0_ch0,        // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p1_ch0,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w1_ch0,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p1_ch0, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w1_ch0,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w1_ch0,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w1_ch0,  // NOT USED ON  
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w1_ch0,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w1_ch0,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w1_ch0,        // HBM      DFI_DATA_WIDTH/32
   // DFI Update Interface
   input          idfi_ctrlupd_req_ch0,
   output         odfi_ctrlupd_ack_ch0,
   output         odfi_phyupd_req_ch0,
   output     [2-1:0]    odfi_phyupd_type_ch0,
   input         idfi_phyupd_ack_ch0,

   // DFI Status Interface
   output        odfi_aerr_a0_ch0,
   output        odfi_aerr_a1_ch0,
   output   [4-1:0] odfi_derr_e0_ch0,
   output   [4-1:0] odfi_derr_e1_ch0,
   input    [2-1:0] idfi_dram_clk_disable_ch0,
   input    [(DFI_DATA_WIDTH >> 3)-1:0] idfi_data_byte_disable_ch0, // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input    [2-1:0] idfi_freq_ratio_ch0,
   output   odfi_init_complete_ch0,
   input    idfi_init_start_ch0,
   output   odfi_parity_error_ch0,
   input    idfi_parity_in_p0_ch0,
   output   odfi_alert_n_a0_ch0,
   input    idfi_parity_in_p1_ch0,
   output   odfi_alert_n_a1_ch0,

   // DFI Training Interface // DDR3 and LPDDR2
   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_req_ch0,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_cs_ch0,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_en_ch0,
   output     [(DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0] odfi_rdlvl_resp_ch0,

   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_gate_req_ch0,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_gate_cs_ch0,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_gate_en_ch0,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_rdlvl_cs_ch0,

   output     [(DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0] odfi_wrlvl_req_ch0,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0] idfi_phy_wrlvl_cs_ch0,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_en_ch0,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_strobe_ch0,
   output     [(DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0] odfi_wrlvl_resp_ch0,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_wrlvl_cs_ch0,

   output     [(DFI_CA_TRAINING_PHY_WIDTH)-1:0] odfi_calvl_req_ch0,
   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phy_calvl_cs_ch0,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_en_ch0,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_capture_ch0,
   output     [(DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0] odfi_calvl_resp_ch0,

   input      [(DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] idfi_lvl_pattern_ch0, 
   input      [(DFI_LEVELING_PHY_WIDTH)-1:0] idfi_lvl_periodic_ch0,

   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] odfi_phylvl_req_cs_ch0, // DFI_RANK_WIDTH = DFI_CHIP_SELECT_WIDTH
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phylvl_ack_cs_ch0,

   // DFI Low Power Control Interface
   input               idfi_lp_ctrl_req_ch0,
   input               idfi_lp_data_req_ch0,
   input     [4-1 : 0]          idfi_lp_wakeup_ch0,     // Fixed width
   output              odfi_lp_ack_ch0,

   // ERROR I
   output     [(DFI_ERROR_WIDTH)-1:0] odfi_error_ch0, // SIZE ?
   output     [(DFI_ERROR_WIDTH*4)-1:0] odfi_error_info_ch0, // SIZE ?

   input      [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] idfi_rdlvl_load_ch0,
   output     [(2)-1:0] odfi_rdlvl_mode_ch0,
   output     [(2)-1:0] odfi_rdlvl_gate_mode_ch0,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_edge_ch0,
   input      [(DFI_READ_LEVELING_DELAY_WIDTH)-1:0] idfi_rdlvl_delay_X_ch0,
   input      [(DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0] idfi_rdlvl_gate_delay_X_ch0,

   input       [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_load_ch0,
   output      [(2)-1:0] odfi_wrlvl_mode_ch0,
   input       [(DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0] idfi_wrlvl_delay_X_ch0,

   // DFI Control Interface channel 1
   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p0_ch1,
   input      [12-1:0] idfi_row_p0_ch1,   //HBM        
   input      [16-1:0] idfi_col_p0_ch1,   // HBM         
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p0_ch1,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p0_ch1,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p0_ch1,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p0_ch1,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p0_ch1,
   input           idfi_act_n_p0_ch1,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p0_ch1,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p0_ch1,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p0_ch1,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p0_ch1,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p0_ch1,

   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p1_ch1,
   input      [12-1:0] idfi_row_p1_ch1,   //HBM        
   input      [16-1:0] idfi_col_p1_ch1,   //HBM          
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p1_ch1,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p1_ch1,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p1_ch1,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p1_ch1,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p1_ch1,
   input                               idfi_act_n_p1_ch1,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p1_ch1,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p1_ch1,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p1_ch1,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p1_ch1,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p1_ch1,
   // DFI Write Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p0_ch1,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p0_ch1,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p0_ch1,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p0_ch1,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p0_ch1,            // HBM      DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p0_ch1,            // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p1_ch1,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p1_ch1,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p1_ch1,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p1_ch1,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p1_ch1,            // HBM       DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p1_ch1,            // HBM       DFI_DATA_WIDTH/32
   // DFI Read Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p0_ch1,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w0_ch1,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p0_ch1, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w0_ch1,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w0_ch1,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w0_ch1,    // NOT USED ON  , USED ON DDR4/LPDDR4
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w0_ch1,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w0_ch1,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w0_ch1,        // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p1_ch1,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w1_ch1,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p1_ch1, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w1_ch1,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w1_ch1,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w1_ch1,  // NOT USED ON  
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w1_ch1,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w1_ch1,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w1_ch1,        // HBM      DFI_DATA_WIDTH/32
   // DFI Update Interface
   input          idfi_ctrlupd_req_ch1,
   output         odfi_ctrlupd_ack_ch1,
   output         odfi_phyupd_req_ch1,
   output     [2-1:0]    odfi_phyupd_type_ch1,
   input         idfi_phyupd_ack_ch1,

   // DFI Status Interface
   output        odfi_aerr_a0_ch1,
   output        odfi_aerr_a1_ch1,
   output   [4-1:0] odfi_derr_e0_ch1,
   output   [4-1:0] odfi_derr_e1_ch1,
   input    [2-1:0] idfi_dram_clk_disable_ch1,
   input    [(DFI_DATA_WIDTH >> 3)-1:0] idfi_data_byte_disable_ch1, // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input    [2-1:0] idfi_freq_ratio_ch1,
   output   odfi_init_complete_ch1,
   input    idfi_init_start_ch1,
   output   odfi_parity_error_ch1,
   input    idfi_parity_in_p0_ch1,
   output   odfi_alert_n_a0_ch1,
   input    idfi_parity_in_p1_ch1,
   output   odfi_alert_n_a1_ch1,

   // DFI Training Interface // DDR3 and LPDDR2
   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_req_ch1,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_cs_ch1,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_en_ch1,
   output     [(DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0] odfi_rdlvl_resp_ch1,

   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_gate_req_ch1,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_gate_cs_ch1,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_gate_en_ch1,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_rdlvl_cs_ch1,

   output     [(DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0] odfi_wrlvl_req_ch1,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0] idfi_phy_wrlvl_cs_ch1,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_en_ch1,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_strobe_ch1,
   output     [(DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0] odfi_wrlvl_resp_ch1,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_wrlvl_cs_ch1,

   output     [(DFI_CA_TRAINING_PHY_WIDTH)-1:0] odfi_calvl_req_ch1,
   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phy_calvl_cs_ch1,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_en_ch1,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_capture_ch1,
   output     [(DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0] odfi_calvl_resp_ch1,

   input      [(DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] idfi_lvl_pattern_ch1, 
   input      [(DFI_LEVELING_PHY_WIDTH)-1:0] idfi_lvl_periodic_ch1,

   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] odfi_phylvl_req_cs_ch1, // DFI_RANK_WIDTH = DFI_CHIP_SELECT_WIDTH
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phylvl_ack_cs_ch1,

   // DFI Low Power Control Interface
   input               idfi_lp_ctrl_req_ch1,
   input               idfi_lp_data_req_ch1,
   input     [4-1 : 0]          idfi_lp_wakeup_ch1,     // Fixed width
   output              odfi_lp_ack_ch1,

   // ERROR I
   output     [(DFI_ERROR_WIDTH)-1:0] odfi_error_ch1, // SIZE ?
   output     [(DFI_ERROR_WIDTH*4)-1:0] odfi_error_info_ch1, // SIZE ?

   input      [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] idfi_rdlvl_load_ch1,
   output     [(2)-1:0] odfi_rdlvl_mode_ch1,
   output     [(2)-1:0] odfi_rdlvl_gate_mode_ch1,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_edge_ch1,
   input      [(DFI_READ_LEVELING_DELAY_WIDTH)-1:0] idfi_rdlvl_delay_X_ch1,
   input      [(DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0] idfi_rdlvl_gate_delay_X_ch1,

   input       [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_load_ch1,
   output      [(2)-1:0] odfi_wrlvl_mode_ch1,
   input       [(DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0] idfi_wrlvl_delay_X_ch1,

   // DFI Control Interface channel 2
   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p0_ch2,
   input      [12-1:0] idfi_row_p0_ch2,   //HBM        
   input      [16-1:0] idfi_col_p0_ch2,   // HBM         
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p0_ch2,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p0_ch2,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p0_ch2,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p0_ch2,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p0_ch2,
   input           idfi_act_n_p0_ch2,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p0_ch2,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p0_ch2,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p0_ch2,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p0_ch2,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p0_ch2,

   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p1_ch2,
   input      [12-1:0] idfi_row_p1_ch2,   //HBM        
   input      [16-1:0] idfi_col_p1_ch2,   //HBM          
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p1_ch2,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p1_ch2,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p1_ch2,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p1_ch2,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p1_ch2,
   input                               idfi_act_n_p1_ch2,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p1_ch2,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p1_ch2,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p1_ch2,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p1_ch2,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p1_ch2,
   // DFI Write Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p0_ch2,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p0_ch2,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p0_ch2,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p0_ch2,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p0_ch2,            // HBM      DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p0_ch2,            // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p1_ch2,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p1_ch2,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p1_ch2,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p1_ch2,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p1_ch2,            // HBM       DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p1_ch2,            // HBM       DFI_DATA_WIDTH/32
   // DFI Read Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p0_ch2,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w0_ch2,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p0_ch2, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w0_ch2,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w0_ch2,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w0_ch2,    // NOT USED ON  , USED ON DDR4/LPDDR4
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w0_ch2,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w0_ch2,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w0_ch2,        // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p1_ch2,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w1_ch2,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p1_ch2, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w1_ch2,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w1_ch2,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w1_ch2,  // NOT USED ON  
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w1_ch2,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w1_ch2,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w1_ch2,        // HBM      DFI_DATA_WIDTH/32
   // DFI Update Interface
   input          idfi_ctrlupd_req_ch2,
   output         odfi_ctrlupd_ack_ch2,
   output         odfi_phyupd_req_ch2,
   output     [2-1:0]    odfi_phyupd_type_ch2,
   input         idfi_phyupd_ack_ch2,

   // DFI Status Interface
   output        odfi_aerr_a0_ch2,
   output        odfi_aerr_a1_ch2,
   output   [4-1:0] odfi_derr_e0_ch2,
   output   [4-1:0] odfi_derr_e1_ch2,
   input    [2-1:0] idfi_dram_clk_disable_ch2,
   input    [(DFI_DATA_WIDTH >> 3)-1:0] idfi_data_byte_disable_ch2, // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input    [2-1:0] idfi_freq_ratio_ch2,
   output   odfi_init_complete_ch2,
   input    idfi_init_start_ch2,
   output   odfi_parity_error_ch2,
   input    idfi_parity_in_p0_ch2,
   output   odfi_alert_n_a0_ch2,
   input    idfi_parity_in_p1_ch2,
   output   odfi_alert_n_a1_ch2,

   // DFI Training Interface // DDR3 and LPDDR2
   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_req_ch2,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_cs_ch2,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_en_ch2,
   output     [(DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0] odfi_rdlvl_resp_ch2,

   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_gate_req_ch2,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_gate_cs_ch2,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_gate_en_ch2,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_rdlvl_cs_ch2,

   output     [(DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0] odfi_wrlvl_req_ch2,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0] idfi_phy_wrlvl_cs_ch2,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_en_ch2,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_strobe_ch2,
   output     [(DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0] odfi_wrlvl_resp_ch2,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_wrlvl_cs_ch2,

   output     [(DFI_CA_TRAINING_PHY_WIDTH)-1:0] odfi_calvl_req_ch2,
   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phy_calvl_cs_ch2,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_en_ch2,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_capture_ch2,
   output     [(DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0] odfi_calvl_resp_ch2,

   input      [(DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] idfi_lvl_pattern_ch2, 
   input      [(DFI_LEVELING_PHY_WIDTH)-1:0] idfi_lvl_periodic_ch2,

   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] odfi_phylvl_req_cs_ch2, // DFI_RANK_WIDTH = DFI_CHIP_SELECT_WIDTH
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phylvl_ack_cs_ch2,

   // DFI Low Power Control Interface
   input               idfi_lp_ctrl_req_ch2,
   input               idfi_lp_data_req_ch2,
   input     [4-1 : 0]          idfi_lp_wakeup_ch2,     // Fixed width
   output              odfi_lp_ack_ch2,

   // ERROR I
   output     [(DFI_ERROR_WIDTH)-1:0] odfi_error_ch2, // SIZE ?
   output     [(DFI_ERROR_WIDTH*4)-1:0] odfi_error_info_ch2, // SIZE ?

   input      [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] idfi_rdlvl_load_ch2,
   output     [(2)-1:0] odfi_rdlvl_mode_ch2,
   output     [(2)-1:0] odfi_rdlvl_gate_mode_ch2,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_edge_ch2,
   input      [(DFI_READ_LEVELING_DELAY_WIDTH)-1:0] idfi_rdlvl_delay_X_ch2,
   input      [(DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0] idfi_rdlvl_gate_delay_X_ch2,

   input       [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_load_ch2,
   output      [(2)-1:0] odfi_wrlvl_mode_ch2,
   input       [(DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0] idfi_wrlvl_delay_X_ch2,

   // DFI Control Interface channel 3
   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p0_ch3,
   input      [12-1:0] idfi_row_p0_ch3,   //HBM        
   input      [16-1:0] idfi_col_p0_ch3,   // HBM         
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p0_ch3,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p0_ch3,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p0_ch3,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p0_ch3,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p0_ch3,
   input           idfi_act_n_p0_ch3,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p0_ch3,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p0_ch3,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p0_ch3,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p0_ch3,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p0_ch3,

   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p1_ch3,
   input      [12-1:0] idfi_row_p1_ch3,   //HBM        
   input      [16-1:0] idfi_col_p1_ch3,   //HBM          
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p1_ch3,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p1_ch3,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p1_ch3,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p1_ch3,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p1_ch3,
   input                               idfi_act_n_p1_ch3,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p1_ch3,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p1_ch3,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p1_ch3,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p1_ch3,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p1_ch3,
   // DFI Write Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p0_ch3,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p0_ch3,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p0_ch3,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p0_ch3,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p0_ch3,            // HBM      DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p0_ch3,            // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p1_ch3,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p1_ch3,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p1_ch3,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p1_ch3,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p1_ch3,            // HBM       DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p1_ch3,            // HBM       DFI_DATA_WIDTH/32
   // DFI Read Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p0_ch3,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w0_ch3,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p0_ch3, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w0_ch3,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w0_ch3,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w0_ch3,    // NOT USED ON  , USED ON DDR4/LPDDR4
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w0_ch3,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w0_ch3,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w0_ch3,        // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p1_ch3,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w1_ch3,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p1_ch3, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w1_ch3,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w1_ch3,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w1_ch3,  // NOT USED ON  
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w1_ch3,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w1_ch3,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w1_ch3,        // HBM      DFI_DATA_WIDTH/32
   // DFI Update Interface
   input          idfi_ctrlupd_req_ch3,
   output         odfi_ctrlupd_ack_ch3,
   output         odfi_phyupd_req_ch3,
   output     [2-1:0]    odfi_phyupd_type_ch3,
   input         idfi_phyupd_ack_ch3,

   // DFI Status Interface
   output        odfi_aerr_a0_ch3,
   output        odfi_aerr_a1_ch3,
   output   [4-1:0] odfi_derr_e0_ch3,
   output   [4-1:0] odfi_derr_e1_ch3,
   input    [2-1:0] idfi_dram_clk_disable_ch3,
   input    [(DFI_DATA_WIDTH >> 3)-1:0] idfi_data_byte_disable_ch3, // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input    [2-1:0] idfi_freq_ratio_ch3,
   output   odfi_init_complete_ch3,
   input    idfi_init_start_ch3,
   output   odfi_parity_error_ch3,
   input    idfi_parity_in_p0_ch3,
   output   odfi_alert_n_a0_ch3,
   input    idfi_parity_in_p1_ch3,
   output   odfi_alert_n_a1_ch3,

   // DFI Training Interface // DDR3 and LPDDR2
   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_req_ch3,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_cs_ch3,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_en_ch3,
   output     [(DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0] odfi_rdlvl_resp_ch3,

   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_gate_req_ch3,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_gate_cs_ch3,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_gate_en_ch3,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_rdlvl_cs_ch3,

   output     [(DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0] odfi_wrlvl_req_ch3,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0] idfi_phy_wrlvl_cs_ch3,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_en_ch3,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_strobe_ch3,
   output     [(DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0] odfi_wrlvl_resp_ch3,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_wrlvl_cs_ch3,

   output     [(DFI_CA_TRAINING_PHY_WIDTH)-1:0] odfi_calvl_req_ch3,
   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phy_calvl_cs_ch3,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_en_ch3,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_capture_ch3,
   output     [(DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0] odfi_calvl_resp_ch3,

   input      [(DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] idfi_lvl_pattern_ch3, 
   input      [(DFI_LEVELING_PHY_WIDTH)-1:0] idfi_lvl_periodic_ch3,

   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] odfi_phylvl_req_cs_ch3, // DFI_RANK_WIDTH = DFI_CHIP_SELECT_WIDTH
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phylvl_ack_cs_ch3,

   // DFI Low Power Control Interface
   input               idfi_lp_ctrl_req_ch3,
   input               idfi_lp_data_req_ch3,
   input     [4-1 : 0]          idfi_lp_wakeup_ch3,     // Fixed width
   output              odfi_lp_ack_ch3,

   // ERROR I
   output     [(DFI_ERROR_WIDTH)-1:0] odfi_error_ch3, // SIZE ?
   output     [(DFI_ERROR_WIDTH*4)-1:0] odfi_error_info_ch3, // SIZE ?

   input      [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] idfi_rdlvl_load_ch3,
   output     [(2)-1:0] odfi_rdlvl_mode_ch3,
   output     [(2)-1:0] odfi_rdlvl_gate_mode_ch3,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_edge_ch3,
   input      [(DFI_READ_LEVELING_DELAY_WIDTH)-1:0] idfi_rdlvl_delay_X_ch3,
   input      [(DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0] idfi_rdlvl_gate_delay_X_ch3,

   input       [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_load_ch3,
   output      [(2)-1:0] odfi_wrlvl_mode_ch3,
   input       [(DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0] idfi_wrlvl_delay_X_ch3,

   // DFI Control Interface channel 4
   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p0_ch4,
   input      [12-1:0] idfi_row_p0_ch4,   //HBM        
   input      [16-1:0] idfi_col_p0_ch4,   // HBM         
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p0_ch4,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p0_ch4,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p0_ch4,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p0_ch4,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p0_ch4,
   input           idfi_act_n_p0_ch4,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p0_ch4,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p0_ch4,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p0_ch4,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p0_ch4,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p0_ch4,

   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p1_ch4,
   input      [12-1:0] idfi_row_p1_ch4,   //HBM        
   input      [16-1:0] idfi_col_p1_ch4,   //HBM          
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p1_ch4,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p1_ch4,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p1_ch4,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p1_ch4,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p1_ch4,
   input                               idfi_act_n_p1_ch4,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p1_ch4,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p1_ch4,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p1_ch4,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p1_ch4,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p1_ch4,
   // DFI Write Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p0_ch4,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p0_ch4,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p0_ch4,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p0_ch4,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p0_ch4,            // HBM      DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p0_ch4,            // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p1_ch4,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p1_ch4,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p1_ch4,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p1_ch4,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p1_ch4,            // HBM       DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p1_ch4,            // HBM       DFI_DATA_WIDTH/32
   // DFI Read Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p0_ch4,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w0_ch4,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p0_ch4, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w0_ch4,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w0_ch4,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w0_ch4,    // NOT USED ON  , USED ON DDR4/LPDDR4
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w0_ch4,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w0_ch4,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w0_ch4,        // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p1_ch4,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w1_ch4,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p1_ch4, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w1_ch4,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w1_ch4,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w1_ch4,  // NOT USED ON  
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w1_ch4,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w1_ch4,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w1_ch4,        // HBM      DFI_DATA_WIDTH/32
   // DFI Update Interface
   input          idfi_ctrlupd_req_ch4,
   output         odfi_ctrlupd_ack_ch4,
   output         odfi_phyupd_req_ch4,
   output     [2-1:0]    odfi_phyupd_type_ch4,
   input         idfi_phyupd_ack_ch4,

   // DFI Status Interface
   output        odfi_aerr_a0_ch4,
   output        odfi_aerr_a1_ch4,
   output   [4-1:0] odfi_derr_e0_ch4,
   output   [4-1:0] odfi_derr_e1_ch4,
   input    [2-1:0] idfi_dram_clk_disable_ch4,
   input    [(DFI_DATA_WIDTH >> 3)-1:0] idfi_data_byte_disable_ch4, // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input    [2-1:0] idfi_freq_ratio_ch4,
   output   odfi_init_complete_ch4,
   input    idfi_init_start_ch4,
   output   odfi_parity_error_ch4,
   input    idfi_parity_in_p0_ch4,
   output   odfi_alert_n_a0_ch4,
   input    idfi_parity_in_p1_ch4,
   output   odfi_alert_n_a1_ch4,

   // DFI Training Interface // DDR3 and LPDDR2
   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_req_ch4,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_cs_ch4,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_en_ch4,
   output     [(DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0] odfi_rdlvl_resp_ch4,

   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_gate_req_ch4,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_gate_cs_ch4,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_gate_en_ch4,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_rdlvl_cs_ch4,

   output     [(DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0] odfi_wrlvl_req_ch4,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0] idfi_phy_wrlvl_cs_ch4,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_en_ch4,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_strobe_ch4,
   output     [(DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0] odfi_wrlvl_resp_ch4,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_wrlvl_cs_ch4,

   output     [(DFI_CA_TRAINING_PHY_WIDTH)-1:0] odfi_calvl_req_ch4,
   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phy_calvl_cs_ch4,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_en_ch4,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_capture_ch4,
   output     [(DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0] odfi_calvl_resp_ch4,

   input      [(DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] idfi_lvl_pattern_ch4, 
   input      [(DFI_LEVELING_PHY_WIDTH)-1:0] idfi_lvl_periodic_ch4,

   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] odfi_phylvl_req_cs_ch4, // DFI_RANK_WIDTH = DFI_CHIP_SELECT_WIDTH
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phylvl_ack_cs_ch4,

   // DFI Low Power Control Interface
   input               idfi_lp_ctrl_req_ch4,
   input               idfi_lp_data_req_ch4,
   input     [4-1 : 0]          idfi_lp_wakeup_ch4,     // Fixed width
   output              odfi_lp_ack_ch4,

   // ERROR I
   output     [(DFI_ERROR_WIDTH)-1:0] odfi_error_ch4, // SIZE ?
   output     [(DFI_ERROR_WIDTH*4)-1:0] odfi_error_info_ch4, // SIZE ?

   input      [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] idfi_rdlvl_load_ch4,
   output     [(2)-1:0] odfi_rdlvl_mode_ch4,
   output     [(2)-1:0] odfi_rdlvl_gate_mode_ch4,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_edge_ch4,
   input      [(DFI_READ_LEVELING_DELAY_WIDTH)-1:0] idfi_rdlvl_delay_X_ch4,
   input      [(DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0] idfi_rdlvl_gate_delay_X_ch4,

   input       [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_load_ch4,
   output      [(2)-1:0] odfi_wrlvl_mode_ch4,
   input       [(DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0] idfi_wrlvl_delay_X_ch4,

   // DFI Control Interface channel 5
   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p0_ch5,
   input      [12-1:0] idfi_row_p0_ch5,   //HBM        
   input      [16-1:0] idfi_col_p0_ch5,   // HBM         
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p0_ch5,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p0_ch5,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p0_ch5,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p0_ch5,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p0_ch5,
   input           idfi_act_n_p0_ch5,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p0_ch5,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p0_ch5,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p0_ch5,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p0_ch5,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p0_ch5,

   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p1_ch5,
   input      [12-1:0] idfi_row_p1_ch5,   //HBM        
   input      [16-1:0] idfi_col_p1_ch5,   //HBM          
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p1_ch5,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p1_ch5,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p1_ch5,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p1_ch5,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p1_ch5,
   input                               idfi_act_n_p1_ch5,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p1_ch5,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p1_ch5,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p1_ch5,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p1_ch5,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p1_ch5,
   // DFI Write Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p0_ch5,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p0_ch5,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p0_ch5,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p0_ch5,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p0_ch5,            // HBM      DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p0_ch5,            // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p1_ch5,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p1_ch5,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p1_ch5,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p1_ch5,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p1_ch5,            // HBM       DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p1_ch5,            // HBM       DFI_DATA_WIDTH/32
   // DFI Read Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p0_ch5,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w0_ch5,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p0_ch5, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w0_ch5,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w0_ch5,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w0_ch5,    // NOT USED ON  , USED ON DDR4/LPDDR4
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w0_ch5,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w0_ch5,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w0_ch5,        // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p1_ch5,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w1_ch5,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p1_ch5, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w1_ch5,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w1_ch5,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w1_ch5,  // NOT USED ON  
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w1_ch5,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w1_ch5,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w1_ch5,        // HBM      DFI_DATA_WIDTH/32
   // DFI Update Interface
   input          idfi_ctrlupd_req_ch5,
   output         odfi_ctrlupd_ack_ch5,
   output         odfi_phyupd_req_ch5,
   output     [2-1:0]    odfi_phyupd_type_ch5,
   input         idfi_phyupd_ack_ch5,

   // DFI Status Interface
   output        odfi_aerr_a0_ch5,
   output        odfi_aerr_a1_ch5,
   output   [4-1:0] odfi_derr_e0_ch5,
   output   [4-1:0] odfi_derr_e1_ch5,
   input    [2-1:0] idfi_dram_clk_disable_ch5,
   input    [(DFI_DATA_WIDTH >> 3)-1:0] idfi_data_byte_disable_ch5, // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input    [2-1:0] idfi_freq_ratio_ch5,
   output   odfi_init_complete_ch5,
   input    idfi_init_start_ch5,
   output   odfi_parity_error_ch5,
   input    idfi_parity_in_p0_ch5,
   output   odfi_alert_n_a0_ch5,
   input    idfi_parity_in_p1_ch5,
   output   odfi_alert_n_a1_ch5,

   // DFI Training Interface // DDR3 and LPDDR2
   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_req_ch5,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_cs_ch5,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_en_ch5,
   output     [(DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0] odfi_rdlvl_resp_ch5,

   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_gate_req_ch5,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_gate_cs_ch5,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_gate_en_ch5,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_rdlvl_cs_ch5,

   output     [(DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0] odfi_wrlvl_req_ch5,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0] idfi_phy_wrlvl_cs_ch5,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_en_ch5,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_strobe_ch5,
   output     [(DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0] odfi_wrlvl_resp_ch5,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_wrlvl_cs_ch5,

   output     [(DFI_CA_TRAINING_PHY_WIDTH)-1:0] odfi_calvl_req_ch5,
   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phy_calvl_cs_ch5,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_en_ch5,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_capture_ch5,
   output     [(DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0] odfi_calvl_resp_ch5,

   input      [(DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] idfi_lvl_pattern_ch5, 
   input      [(DFI_LEVELING_PHY_WIDTH)-1:0] idfi_lvl_periodic_ch5,

   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] odfi_phylvl_req_cs_ch5, // DFI_RANK_WIDTH = DFI_CHIP_SELECT_WIDTH
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phylvl_ack_cs_ch5,

   // DFI Low Power Control Interface
   input               idfi_lp_ctrl_req_ch5,
   input               idfi_lp_data_req_ch5,
   input     [4-1 : 0]          idfi_lp_wakeup_ch5,     // Fixed width
   output              odfi_lp_ack_ch5,

   // ERROR I
   output     [(DFI_ERROR_WIDTH)-1:0] odfi_error_ch5, // SIZE ?
   output     [(DFI_ERROR_WIDTH*4)-1:0] odfi_error_info_ch5, // SIZE ?

   input      [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] idfi_rdlvl_load_ch5,
   output     [(2)-1:0] odfi_rdlvl_mode_ch5,
   output     [(2)-1:0] odfi_rdlvl_gate_mode_ch5,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_edge_ch5,
   input      [(DFI_READ_LEVELING_DELAY_WIDTH)-1:0] idfi_rdlvl_delay_X_ch5,
   input      [(DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0] idfi_rdlvl_gate_delay_X_ch5,

   input       [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_load_ch5,
   output      [(2)-1:0] odfi_wrlvl_mode_ch5,
   input       [(DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0] idfi_wrlvl_delay_X_ch5,

   // DFI Control Interface channel 6
   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p0_ch6,
   input      [12-1:0] idfi_row_p0_ch6,   //HBM        
   input      [16-1:0] idfi_col_p0_ch6,   // HBM         
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p0_ch6,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p0_ch6,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p0_ch6,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p0_ch6,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p0_ch6,
   input           idfi_act_n_p0_ch6,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p0_ch6,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p0_ch6,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p0_ch6,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p0_ch6,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p0_ch6,

   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p1_ch6,
   input      [12-1:0] idfi_row_p1_ch6,   //HBM        
   input      [16-1:0] idfi_col_p1_ch6,   //HBM          
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p1_ch6,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p1_ch6,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p1_ch6,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p1_ch6,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p1_ch6,
   input                               idfi_act_n_p1_ch6,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p1_ch6,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p1_ch6,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p1_ch6,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p1_ch6,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p1_ch6,
   // DFI Write Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p0_ch6,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p0_ch6,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p0_ch6,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p0_ch6,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p0_ch6,            // HBM      DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p0_ch6,            // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p1_ch6,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p1_ch6,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p1_ch6,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p1_ch6,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p1_ch6,            // HBM       DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p1_ch6,            // HBM       DFI_DATA_WIDTH/32
   // DFI Read Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p0_ch6,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w0_ch6,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p0_ch6, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w0_ch6,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w0_ch6,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w0_ch6,    // NOT USED ON  , USED ON DDR4/LPDDR4
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w0_ch6,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w0_ch6,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w0_ch6,        // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p1_ch6,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w1_ch6,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p1_ch6, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w1_ch6,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w1_ch6,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w1_ch6,  // NOT USED ON  
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w1_ch6,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w1_ch6,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w1_ch6,        // HBM      DFI_DATA_WIDTH/32
   // DFI Update Interface
   input          idfi_ctrlupd_req_ch6,
   output         odfi_ctrlupd_ack_ch6,
   output         odfi_phyupd_req_ch6,
   output     [2-1:0]    odfi_phyupd_type_ch6,
   input         idfi_phyupd_ack_ch6,

   // DFI Status Interface
   output        odfi_aerr_a0_ch6,
   output        odfi_aerr_a1_ch6,
   output   [4-1:0] odfi_derr_e0_ch6,
   output   [4-1:0] odfi_derr_e1_ch6,
   input    [2-1:0] idfi_dram_clk_disable_ch6,
   input    [(DFI_DATA_WIDTH >> 3)-1:0] idfi_data_byte_disable_ch6, // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input    [2-1:0] idfi_freq_ratio_ch6,
   output   odfi_init_complete_ch6,
   input    idfi_init_start_ch6,
   output   odfi_parity_error_ch6,
   input    idfi_parity_in_p0_ch6,
   output   odfi_alert_n_a0_ch6,
   input    idfi_parity_in_p1_ch6,
   output   odfi_alert_n_a1_ch6,

   // DFI Training Interface // DDR3 and LPDDR2
   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_req_ch6,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_cs_ch6,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_en_ch6,
   output     [(DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0] odfi_rdlvl_resp_ch6,

   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_gate_req_ch6,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_gate_cs_ch6,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_gate_en_ch6,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_rdlvl_cs_ch6,

   output     [(DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0] odfi_wrlvl_req_ch6,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0] idfi_phy_wrlvl_cs_ch6,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_en_ch6,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_strobe_ch6,
   output     [(DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0] odfi_wrlvl_resp_ch6,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_wrlvl_cs_ch6,

   output     [(DFI_CA_TRAINING_PHY_WIDTH)-1:0] odfi_calvl_req_ch6,
   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phy_calvl_cs_ch6,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_en_ch6,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_capture_ch6,
   output     [(DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0] odfi_calvl_resp_ch6,

   input      [(DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] idfi_lvl_pattern_ch6, 
   input      [(DFI_LEVELING_PHY_WIDTH)-1:0] idfi_lvl_periodic_ch6,

   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] odfi_phylvl_req_cs_ch6, // DFI_RANK_WIDTH = DFI_CHIP_SELECT_WIDTH
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phylvl_ack_cs_ch6,

   // DFI Low Power Control Interface
   input               idfi_lp_ctrl_req_ch6,
   input               idfi_lp_data_req_ch6,
   input     [4-1 : 0]          idfi_lp_wakeup_ch6,     // Fixed width
   output              odfi_lp_ack_ch6,

   // ERROR I
   output     [(DFI_ERROR_WIDTH)-1:0] odfi_error_ch6, // SIZE ?
   output     [(DFI_ERROR_WIDTH*4)-1:0] odfi_error_info_ch6, // SIZE ?

   input      [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] idfi_rdlvl_load_ch6,
   output     [(2)-1:0] odfi_rdlvl_mode_ch6,
   output     [(2)-1:0] odfi_rdlvl_gate_mode_ch6,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_edge_ch6,
   input      [(DFI_READ_LEVELING_DELAY_WIDTH)-1:0] idfi_rdlvl_delay_X_ch6,
   input      [(DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0] idfi_rdlvl_gate_delay_X_ch6,

   input       [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_load_ch6,
   output      [(2)-1:0] odfi_wrlvl_mode_ch6,
   input       [(DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0] idfi_wrlvl_delay_X_ch6,

   // DFI Control Interface channel 7
   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p0_ch7,
   input      [12-1:0] idfi_row_p0_ch7,   //HBM        
   input      [16-1:0] idfi_col_p0_ch7,   // HBM         
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p0_ch7,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p0_ch7,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p0_ch7,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p0_ch7,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p0_ch7,
   input           idfi_act_n_p0_ch7,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p0_ch7,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p0_ch7,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p0_ch7,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p0_ch7,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p0_ch7,

   input      [DFI_ADDRESS_WIDTH-1:0] idfi_address_p1_ch7,
   input      [12-1:0] idfi_row_p1_ch7,   //HBM        
   input      [16-1:0] idfi_col_p1_ch7,   //HBM          
   input      [DFI_BANK_WIDTH-1:0] idfi_bank_p1_ch7,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_ras_n_p1_ch7,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_cas_n_p1_ch7,
   input      [DFI_CONTROL_WIDTH-1:0] idfi_we_n_p1_ch7,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cs_p1_ch7,
   input                               idfi_act_n_p1_ch7,
   input      [DFI_BANK_GROUP_WIDTH-1:0] idfi_bg_p1_ch7,
   input      [DFI_CHIP_ID_WIDTH-1:0] idfi_cid_p1_ch7,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_cke_p1_ch7,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_odt_p1_ch7,
   input      [DFI_CHIP_SELECT_WIDTH-1:0] idfi_reset_n_p1_ch7,
   // DFI Write Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p0_ch7,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p0_ch7,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p0_ch7,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p0_ch7,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p0_ch7,            // HBM      DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p0_ch7,            // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_wrdata_en_p1_ch7,
   input      [DFI_DATA_WIDTH-1:0] idfi_wrdata_p1_ch7,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_wrdata_cs_p1_ch7,
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wrdata_mask_p1_ch7,       // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input      [(DFI_DATA_WIDTH >> 3)-1:0] idfi_wr_dbi_p1_ch7,            // HBM       DFI_DATA_WIDTH/8
   input      [(DFI_DATA_WIDTH >> 5)-1:0] idfi_wr_par_p1_ch7,            // HBM       DFI_DATA_WIDTH/32
   // DFI Read Data Interface
   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p0_ch7,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w0_ch7,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p0_ch7, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w0_ch7,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w0_ch7,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w0_ch7,    // NOT USED ON  , USED ON DDR4/LPDDR4
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w0_ch7,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w0_ch7,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w0_ch7,        // HBM      DFI_DATA_WIDTH/32

   input      [DFI_DATA_ENABLE_WIDTH-1:0] idfi_rddata_en_p1_ch7,         // all bits are identical per phase
   output     [DFI_DATA_WIDTH-1:0] odfi_rddata_w1_ch7,
   input      [(DFI_CHIP_SELECT_WIDTH*DFI_DATA_ENABLE_WIDTH)-1:0] idfi_rddata_cs_p1_ch7, 
   output reg [DFI_READ_DATA_VALID_WIDTH-1:0] odfi_rddata_valid_w1_ch7,
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_dnv_w1_ch7,        // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3,
   output     [DFI_DBI_WIDTH-1:0] odfi_rddata_dbi_w1_ch7,  // NOT USED ON  
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rddata_cb_w1_ch7,     // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 3)-1:0] odfi_rd_dbi_w1_ch7,        // HBM      DFI_DATA_WIDTH/8
   output     [(DFI_DATA_WIDTH >> 5)-1:0] odfi_rd_par_w1_ch7,        // HBM      DFI_DATA_WIDTH/32
   // DFI Update Interface
   input          idfi_ctrlupd_req_ch7,
   output         odfi_ctrlupd_ack_ch7,
   output         odfi_phyupd_req_ch7,
   output     [2-1:0]    odfi_phyupd_type_ch7,
   input         idfi_phyupd_ack_ch7,

   // DFI Status Interface
   output        odfi_aerr_a0_ch7,
   output        odfi_aerr_a1_ch7,
   output   [4-1:0] odfi_derr_e0_ch7,
   output   [4-1:0] odfi_derr_e1_ch7,
   input    [2-1:0] idfi_dram_clk_disable_ch7,
   input    [(DFI_DATA_WIDTH >> 3)-1:0] idfi_data_byte_disable_ch7, // localparam DFI_DATA_WORDS    = DFI_DATA_WIDTH >> 3
   input    [2-1:0] idfi_freq_ratio_ch7,
   output   odfi_init_complete_ch7,
   input    idfi_init_start_ch7,
   output   odfi_parity_error_ch7,
   input    idfi_parity_in_p0_ch7,
   output   odfi_alert_n_a0_ch7,
   input    idfi_parity_in_p1_ch7,
   output   odfi_alert_n_a1_ch7,

   // DFI Training Interface // DDR3 and LPDDR2
   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_req_ch7,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_cs_ch7,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_en_ch7,
   output     [(DFI_READ_LEVELING_RESPONSE_WIDTH)-1:0] odfi_rdlvl_resp_ch7,

   output     [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] odfi_rdlvl_gate_req_ch7,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_READ_TRAINING_PHY_WIDTH)-1:0] odfi_phy_rdlvl_gate_cs_ch7,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_gate_en_ch7,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_rdlvl_cs_ch7,

   output     [(DFI_WRITE_LEVELING_PHY_IF_WIDTH)-1:0] odfi_wrlvl_req_ch7,
   output     [(DFI_CHIP_SELECT_WIDTH*DFI_WRITE_TRAINING_PHY_WIDTH)-1:0] idfi_phy_wrlvl_cs_ch7,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_en_ch7,
   input      [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_strobe_ch7,
   output     [(DFI_WRITE_LEVELING_RESPONSE_WIDTH)-1:0] odfi_wrlvl_resp_ch7,
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_wrlvl_cs_ch7,

   output     [(DFI_CA_TRAINING_PHY_WIDTH)-1:0] odfi_calvl_req_ch7,
   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phy_calvl_cs_ch7,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_en_ch7,
   input      [(DFI_CA_TRAINING_MC_WIDTH)-1:0] idfi_calvl_capture_ch7,
   output     [(DFI_CA_TRAINING_RESPONSE_WIDTH)-1:0] odfi_calvl_resp_ch7,

   input      [(DFI_READ_TRAINING_PHY_WIDTH*4)-1:0] idfi_lvl_pattern_ch7, 
   input      [(DFI_LEVELING_PHY_WIDTH)-1:0] idfi_lvl_periodic_ch7,

   output     [(DFI_CHIP_SELECT_WIDTH)-1:0] odfi_phylvl_req_cs_ch7, // DFI_RANK_WIDTH = DFI_CHIP_SELECT_WIDTH
   input      [(DFI_CHIP_SELECT_WIDTH)-1:0] idfi_phylvl_ack_cs_ch7,

   // DFI Low Power Control Interface
   input               idfi_lp_ctrl_req_ch7,
   input               idfi_lp_data_req_ch7,
   input     [4-1 : 0]          idfi_lp_wakeup_ch7,     // Fixed width
   output              odfi_lp_ack_ch7,

   // ERROR I
   output     [(DFI_ERROR_WIDTH)-1:0] odfi_error_ch7, // SIZE ?
   output     [(DFI_ERROR_WIDTH*4)-1:0] odfi_error_info_ch7, // SIZE ?

   input      [(DFI_READ_LEVELING_PHY_IF_WIDTH)-1:0] idfi_rdlvl_load_ch7,
   output     [(2)-1:0] odfi_rdlvl_mode_ch7,
   output     [(2)-1:0] odfi_rdlvl_gate_mode_ch7,
   input      [(DFI_READ_LEVELING_MC_IF_WIDTH)-1:0] idfi_rdlvl_edge_ch7,
   input      [(DFI_READ_LEVELING_DELAY_WIDTH)-1:0] idfi_rdlvl_delay_X_ch7,
   input      [(DFI_READ_LEVELING_GATE_DELAY_WIDTH)-1:0] idfi_rdlvl_gate_delay_X_ch7,

   input       [(DFI_WRITE_LEVELING_MC_IF_WIDTH)-1:0] idfi_wrlvl_load_ch7,
   output      [(2)-1:0] odfi_wrlvl_mode_ch7,
   input       [(DFI_WRITE_LEVELING_DELAY_WIDTH)-1:0] idfi_wrlvl_delay_X_ch7,


   // Ports for DDR3 memory module via HAPS HT3
    input                 c0_sys_clk_p,
    input                 c0_sys_clk_n,

    output [16:0]         c0_ddr4_addr,
    output [1:0]          c0_ddr4_ba,
    output [1:0]          c0_ddr4_bg,
    output                c0_ddr4_act_n,
    output [1:0]          c0_ddr4_cke,
    output [1:0]          c0_ddr4_odt,
    output [1:0]          c0_ddr4_cs_n,
    output [1:0]          c0_ddr4_ck_p,
    output [1:0]          c0_ddr4_ck_n,
    output                c0_ddr4_reset_n,
    output                c0_ddr4_parity,
    output [8:0]          c0_ddr4_dm_dbi,
    inout  [71:0]         c0_ddr4_dq,
    inout  [8:0]          c0_ddr4_dqs_p,
    inout  [8:0]          c0_ddr4_dqs_n,

    output                c0_init_calib_complete,
    output                c0_ddr4_sys_clk_valid,
    output                c0_ddr4_ui_clk_sync_rst,

    output                dbg_clk,
    output wire [511:0]   dbg_bus
   
   );


endmodule
