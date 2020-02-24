`include "define.vh"
`include "static_macro_define.vh"

module `module_name (

    sysclk,                
    canclk,                
                        
    ponrst_n,              
    cfgstrp_clkdiv,   
    
    cbus_rxd,      
    cbus_txd,      

`ifdef AHB
    t_htrans,
    t_hwrite,
    t_hsel,
    t_hwdata,
    t_haddr,
    t_hsize,
    t_hready_in,
    t_hrdata,
    t_hready,
    t_hresp,
`endif

`ifdef REG
    cpu_cs,
    cpu_read,
    cpu_write,
    cpu_addr,
    cpu_wdat,
    cpu_rdat,
    cpu_ack,
    cpu_err,
`endif

`ifdef WISHBOND
    CYC_I,	
    STB_I,
    WE_I,
    ADR_I,
    DAT_I,
    ACK_O,
    DAT_O,
`endif
`ifdef APB
    PADDR,
    PWDATA,
    PRDATA, 
    PSEL,
    PWRITE,
    PENABLE,
    PREADY,         
    PSLVERR,
`endif
    int_o
);

input              sysclk;                
input              canclk;                
                                          
input              ponrst_n;              
input  [7:0]       cfgstrp_clkdiv;   
          
input              cbus_rxd;      
output             cbus_txd;      

parameter HTRESP = 2;
parameter BHSIZE = 3;
parameter ADDSIZ = 32;
parameter DATSIZ = 32;

`ifdef AHB
input  [HTRESP -1:0] t_htrans;
input  t_hwrite;
input  t_hsel;
input  [DATSIZ -1:0] t_hwdata;
input  [ADDSIZ -1:0] t_haddr;
input  [BHSIZE -1:0] t_hsize;
input  t_hready_in;
output  [DATSIZ -1:0] t_hrdata;
output  t_hready;
output  [HTRESP -1:0] t_hresp;
`endif

`ifdef REG
input              cpu_cs;
input              cpu_read;
input              cpu_write;
input  [31:0]      cpu_addr;
input  [31:0]      cpu_wdat;
output [31:0]      cpu_rdat;
output             cpu_ack;
output             cpu_err;
`endif

`ifdef WISHBOND
input           CYC_I;	
input           STB_I;
input           WE_I;
input [31:0]    ADR_I;
input [31:0]    DAT_I;
output          ACK_O;
output [31:0]   DAT_O;
`endif
`ifdef APB
input  [31:0]      PADDR;
input  [31:0]      PWDATA;
output [31:0]      PRDATA; 
input              PSEL;
input              PWRITE;
input              PENABLE;
output             PREADY;          
output             PSLVERR;
`endif
output  int_o;


`getname(canc_top,`module_name) u_canc_top (
// System Interface
    .sysclk(sysclk),     
    .canclk(canclk),     
                               
    .ponrst_n(ponrst_n),   
    .cfgstrp_clkdiv(cfgstrp_clkdiv),                 

    .cbus_rxd(cbus_rxd),         
    .cbus_txd(cbus_txd),         


`ifdef AHB
    .t_htrans(t_htrans),
    .t_hwrite(t_hwrite),
    .t_hsel(t_hsel),
    .t_hwdata(t_hwdata),
    .t_haddr(t_haddr),
    .t_hsize(t_hsize),
    .t_hready_in(t_hready_in),
    .t_hrdata(t_hrdata),
    .t_hready(t_hready),
    .t_hresp(t_hresp),
`endif


`ifdef REG
    .cpu_cs(cpu_cs),
    .cpu_read(cpu_read),
    .cpu_write(cpu_write),
    .cpu_addr(cpu_addr),
    .cpu_wdat(cpu_wdat),
    .cpu_rdat(cpu_rdat),
    .cpu_ack(cpu_ack),
    .cpu_err(cpu_err),
`endif

`ifdef WISHBOND
    .CYC_I(CYC_I),	
    .STB_I(STB_I),
    .WE_I(WE_I),
    .ADR_I(ADR_I),
    .DAT_I(DAT_I),
    .ACK_O(ACK_O),
    .DAT_O(DAT_O),
`endif
`ifdef APB
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA), 
    .PSEL(PSEL),
    .PWRITE(PWRITE),
    .PENABLE(PENABLE),
    .PREADY(PREADY),          
    .PSLVERR(PSLVERR),
`endif

    .int_to_arm(int_o)


);


endmodule
