
//------------------------------------------------------------
//Define Space Selections for both Memory and I/O
//------------------------------------------------------------

`define ADDR_2G     28'h8000_000
`define ADDR_1G     28'hC000_000
`define ADDR_512M   28'hE000_000
`define ADDR_256M   28'hF000_000
`define ADDR_128M   28'hF800_000
`define ADDR_64M    28'hFC00_000
`define ADDR_32M    28'hFE00_000
`define ADDR_16M    28'hFF00_000
`define ADDR_8M     28'hFF80_000
`define ADDR_4M     28'hFFC0_000
`define ADDR_2M     28'hFFE0_000
`define ADDR_1M     28'hFFF0_000
`define ADDR_512K   28'hFFF8_000
`define ADDR_256K   28'hFFFC_000
`define ADDR_128K   28'hFFFE_000
`define ADDR_64K    28'hFFFF_000
`define ADDR_32K    28'hFFFF_800
`define ADDR_16K    28'hFFFF_C00
`define ADDR_8K     28'hFFFF_E00
`define ADDR_4K     28'hFFFF_F00
`define ADDR_2K     28'hFFFF_F80
`define ADDR_1K     28'hFFFF_FC0
`define ADDR_512    28'hFFFF_FE0
`define ADDR_256    28'hFFFF_FF0
`define ADDR_128    28'hFFFF_FF8
`define ADDR_64     28'hFFFF_FFC
`define ADDR_32     28'hFFFF_FFE
`define ADDR_16     28'hFFFF_FFF

//------------------------------------------------------------
//PCI command definition
//------------------------------------------------------------

 `define INT_ACK           4'b0000
 `define SPECIAL_C         4'b0001
 `define IO_RD             4'b0010
 `define IO_WR             4'b0011
 `define RESERVED          4'b0100
 `define MEM_RD            4'b0110
 `define MEM_WR            4'b0111
 `define CONFIG_RD         4'b1010
 `define CONFIG_WR         4'b1011
 `define MEM_RD_M          4'b1100
 `define D_AD_C            4'b1101
 `define MEM_RD_L          4'b1110
 `define MEM_WR_I          4'b1111

 `define CONFIG_COMMAND_WIDTH    11                            
 `define CONFIG_STATUS_WIDTH      6                            
 `define CONFIG_CACHE_WIDTH       8                            
 `define PCI_COMMAND_WIDTH        4                            
 `define BAR_WIDTH                32 

 //Command register bit name

 `define IO_SPACE_ENA           0
 `define MEM_SPACE_ENA          1
 `define MASTER_ENA             2
 `define SPECIAL_CYCLES_ENA     3
 `define MEM_WR_I_ENA           4
 `define VGA_PALETTE_SNOOP      5
 `define PARITY_ERROR_RESPONSE  6
 `define STEPPING_CONTROL       7
 `define SERR_ENA               8
 `define FAST_BTB_ENA           9
 `define INT_DIS                10  

 //Status register bit name
 `define M_D_PAR_ERR  0
 `define SIG_T_ABORT  1
 `define REC_T_ABORT  2
 `define REC_M_ABORT  3
 `define SIG_SERR     4
 `define DET_PAR_ERR  5

//DEVICE SELECT TIMING
 `define FAST    2'b00
 `define MEDIUM  2'b01
 `define SLOW    2'b10







