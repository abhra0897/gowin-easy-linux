`include "triple_speed_mac_define.v"
`include "triple_speed_mac_name.v"

module `module_name (
    //RGMII IF
    `ifdef RGMII_IF
        input rgmii_rxc,
        input rgmii_rx_ctl,
        input [3:0] rgmii_rxd,

        input gtx_clk,
        output rgmii_txc,
        output rgmii_tx_ctl,
        output [3:0] rgmii_txd,
        input speedis1000,//0:10/100M, 1:1000M
        input speedis10,//0:100M, 1:10M
    `endif
   
    //GMII IF
    `ifdef GMII_IF
        input gmii_rx_clk,
        input gmii_rx_dv,
        input [7:0] gmii_rxd,
        input gmii_rx_er,
        input   gtx_clk,
        output  gmii_gtx_clk,         
        output [7:0] gmii_txd,        
        output   gmii_tx_en,          
        output   gmii_tx_er,          
    `endif
    
    //MII IF
    `ifdef MII_IF
        input   mii_rx_clk,       
        input [3:0] mii_rxd,      
        input   mii_rx_dv,        
        input   mii_rx_er,        
        input   mii_tx_clk,       
        output [3:0] mii_txd,     
        output   mii_tx_en,       
        output   mii_tx_er,       
        input mii_col,
        input mii_crs,
    `endif
    
    `ifdef MII_IF
        `ifdef GMII_IF
            input speedis1000,
        `endif
    `endif
    
    
    `ifdef RGMII_IF
        input duplex_status,
    `endif
    `ifdef MII_IF
        input duplex_status,
    `endif
    
    input rstn,
    //user if 
    output rx_mac_clk,
    output rx_mac_valid,
    output [7:0] rx_mac_data,
    output rx_mac_last,
    output rx_mac_error,
    output rx_statistics_valid,
    output [26:0] rx_statistics_vector,
    
    output tx_mac_clk,
    input tx_mac_valid,
    input [7:0] tx_mac_data,
    input tx_mac_last,
    input tx_mac_error,
    output tx_mac_ready,
    `ifdef RGMII_IF
        output tx_collision,
        output tx_retransmit,
    `endif
    `ifdef MII_IF
        output tx_collision,
        output tx_retransmit,
    `endif
    output tx_statistics_valid,
    output [28:0] tx_statistics_vector,
    
    input rx_fcs_fwd_ena,
    input rx_jumbo_ena,
    output rx_pause_req,
    output [15:0] rx_pause_val,
    
    input tx_fcs_fwd_ena, 
    input tx_ifg_delay_ena,
    input [7:0] tx_ifg_delay,    
    input tx_pause_req,
    input [15:0] tx_pause_val,
    input [47:0] tx_pause_source_addr,
    
    input         clk,             
    input   [4:0] miim_phyad,        
    input   [4:0] miim_regad,        
    input  [15:0] miim_wrdata,       
    input         miim_wren,         
    input         miim_rden,         
    output [15:0] miim_rddata,       
    output        miim_rddata_valid,
    output        miim_busy,         
    output        mdc,               
    input         mdio_in,           
    output        mdio_out,          
    output        mdio_oen 
);


`getname(triple_speed_mac,`module_name) u_triple_speed_mac (
    //RGMII IF
    `ifdef RGMII_IF
        .rgmii_rxc(rgmii_rxc),
        .rgmii_rx_ctl(rgmii_rx_ctl),
        .rgmii_rxd(rgmii_rxd),
        
        .gtx_clk(gtx_clk),
        .rgmii_txc(rgmii_txc),
        .rgmii_tx_ctl(rgmii_tx_ctl),
        .rgmii_txd(rgmii_txd),
        .speedis1000(speedis1000),
        .speedis10(speedis10),
    `endif
   
    //GMII IF
    `ifdef GMII_IF
        .gmii_rx_clk(gmii_rx_clk),
        .gmii_rx_dv(gmii_rx_dv),
        .gmii_rxd(gmii_rxd),
        .gmii_rx_er(gmii_rx_er),
        .gtx_clk(gtx_clk),
        .gmii_gtx_clk(gmii_gtx_clk),         
        .gmii_txd(gmii_txd),        
        .gmii_tx_en(gmii_tx_en),          
        .gmii_tx_er(gmii_tx_er),          
    `endif
    
    //MII IF
    `ifdef MII_IF
        .mii_rx_clk(mii_rx_clk),       
        .mii_rxd(mii_rxd),      
        .mii_rx_dv(mii_rx_dv),        
        .mii_rx_er(mii_rx_er),        
        .mii_tx_clk(mii_tx_clk),       
        .mii_txd(mii_txd),     
        .mii_tx_en(mii_tx_en),       
        .mii_tx_er(mii_tx_er),       
        .mii_col(mii_col),
        .mii_crs(mii_crs),
    `endif
    
    `ifdef MII_IF
        `ifdef GMII_IF
            .speedis1000(speedis1000),
        `endif
    `endif
    
    
    `ifdef RGMII_IF
        .duplex_status(duplex_status),
    `endif
    `ifdef MII_IF
        .duplex_status(duplex_status),
    `endif
    
    .rstn(rstn),
    //user if 
    .rx_mac_clk(rx_mac_clk),
    .rx_mac_valid(rx_mac_valid),
    .rx_mac_data(rx_mac_data),
    .rx_mac_last(rx_mac_last),
    .rx_mac_error(rx_mac_error),
    
    .tx_mac_clk(tx_mac_clk),
    .tx_mac_valid(tx_mac_valid),
    .tx_mac_data(tx_mac_data),
    .tx_mac_last(tx_mac_last),
    .tx_mac_error(tx_mac_error),
    .tx_mac_ready(tx_mac_ready),
    `ifdef RGMII_IF
        .tx_collision(tx_collision),
        .tx_retransmit(tx_retransmit),
    `endif
    `ifdef MII_IF
        .tx_collision(tx_collision),
        .tx_retransmit(tx_retransmit),
    `endif
    
    .rx_fcs_fwd_ena(rx_fcs_fwd_ena),
    .rx_jumbo_ena(rx_jumbo_ena),
    .rx_statistics_valid(rx_statistics_valid),
    .rx_statistics_vector(rx_statistics_vector),
    .rx_pause_req(rx_pause_req),
    .rx_pause_val(rx_pause_val),
    
    .tx_pause_req(tx_pause_req),
    .tx_pause_val(tx_pause_val),
    .tx_pause_source_addr(tx_pause_source_addr),
    .tx_ifg_delay_ena(tx_ifg_delay_ena),
    .tx_ifg_delay(tx_ifg_delay),
    .tx_fcs_fwd_ena(tx_fcs_fwd_ena),
    .tx_statistics_valid(tx_statistics_valid),
    .tx_statistics_vector(tx_statistics_vector),
    
    .clk(clk),             
    .miim_phyad(miim_phyad),        
    .miim_regad(miim_regad),        
    .miim_wrdata(miim_wrdata),       
    .miim_wren(miim_wren),         
    .miim_rden(miim_rden),         
    .miim_rddata(miim_rddata),       
    .miim_rddata_valid(miim_rddata_valid),
    .miim_busy(miim_busy),         
    .mdc(mdc),               
    .mdio_in(mdio_in),           
    .mdio_out(mdio_out),          
    .mdio_oen(mdio_oen)      
    );

endmodule    
