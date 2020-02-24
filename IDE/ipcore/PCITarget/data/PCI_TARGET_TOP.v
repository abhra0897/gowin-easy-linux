`include "pci_target_name.v"
`include "pci_params.v"
`include "pci_local_params.v"
`timescale 1 ns/100 ps


module `module_name_pci     (
  // PCI Target Interface 
  pci_clk, 
  pci_rst_l,
  pci_ad, 
  pci_cbe_l, 
  pci_par, 
  pci_frame_l, 
  pci_trdy_l,
  pci_irdy_l,
  pci_stop_l, 
  pci_devsel_l, 
  pci_idsel,
  pci_serr_l,
  pci_perr_l,
`ifdef INTERRUPT_PIN
  pci_int_l,
  tg_int_l,
`endif
  // USER Interface 
  tg_addr, 
  tg_data_out, 
  tg_data_in,
  tg_cbe_l, 
  tg_ready_l,  
  tg_write_l,
  tg_read_l, 
  tg_stop_l, 
  tg_abort_l,
  tg_cmd_o,
`ifdef BAR_ENABLE
  tg_bar_hit,
`endif
  tg_access,
  tg_value
  );

  input                 pci_clk;
  input                 pci_rst_l;
  inout [31:0]          pci_ad;
  input [3:0]           pci_cbe_l;
  inout                 pci_par;
  input                 pci_frame_l;
  output                pci_trdy_l;
  input                 pci_irdy_l;
  output                pci_stop_l;
  output                pci_devsel_l;
  input                 pci_idsel;
  output                pci_serr_l;
  output                pci_perr_l;
`ifdef INTERRUPT_PIN
  output                pci_int_l;
  input                 tg_int_l;
`endif
  output [31:0]         tg_addr; 
  input  [31:0]         tg_data_in;
  output [31:0]         tg_data_out;
  output [3:0]          tg_cbe_l;
  input                 tg_ready_l;
  output                tg_write_l;
  output                tg_read_l;
  input                 tg_stop_l;
  input                 tg_abort_l;
  output [3:0]          tg_cmd_o;
`ifdef BAR_ENABLE
  output [`BAR_NUM-1:0] tg_bar_hit;
`endif
  output                tg_access;
  output                tg_value;


`getname(pci_target,`module_name_pci) u_pci_target (
  // PCI Target Interface 
  .pci_clk          ( pci_clk        ), 
  .pci_rst_l        ( pci_rst_l      ),
  .pci_ad           ( pci_ad         ), 
  .pci_cbe_l        (  pci_cbe_l     ), 
  .pci_par          (  pci_par       ), 
  .pci_frame_l      ( pci_frame_l    ), 
  .pci_trdy_l       ( pci_trdy_l     ),
  .pci_irdy_l       ( pci_irdy_l     ),
  .pci_stop_l       ( pci_stop_l     ), 
  .pci_devsel_l     ( pci_devsel_l   ), 
  .pci_idsel        ( pci_idsel      ),
  .pci_serr_l       ( pci_serr_l     ),
  .pci_perr_l       ( pci_perr_l     ),
`ifdef INTERRUPT_PIN
  .pci_int_l        ( pci_int_l      ),
  .tg_int_l         ( tg_int_l       ),
`endif
  // USER Interface 
  .tg_addr          ( tg_addr        ), 
  .tg_data_out      ( tg_data_out    ), 
  .tg_data_in       ( tg_data_in     ),
  .tg_cbe_l         ( tg_cbe_l       ), 
  .tg_ready_l       ( tg_ready_l     ),  
  .tg_write_l       ( tg_write_l     ),
  .tg_read_l        ( tg_read_l      ), 
  .tg_stop_l        ( tg_stop_l      ), 
  .tg_abort_l       ( tg_abort_l     ),
  .tg_cmd_o         ( tg_cmd_o       ),
`ifdef BAR_ENABLE
  .tg_bar_hit       ( tg_bar_hit     ),
`endif
  .tg_access        ( tg_access      ),
  .tg_value         ( tg_value       )
  );

endmodule