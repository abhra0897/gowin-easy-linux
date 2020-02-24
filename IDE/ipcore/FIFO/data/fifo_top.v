`include "fifo_define.v"
`timescale 1ns/1ps
 module `module_name (
          Data                ,
  `ifdef  En_Reset
     `ifdef Reset_Synchronization 
          Reset               ,        
     `else 
          WrReset             ,
          RdReset             ,
     `endif
  `endif
          WrClk               ,
          RdClk               ,
          WrEn                ,
          RdEn                ,
`ifdef    Al_Empty_Flag 
   `ifdef Empty_D_Dual_Th
          AlmostEmptySetTh    ,
          AlmostEmptyClrTh    ,
   `endif
   `ifdef Empty_D_Single_Th
          AlmostEmptyTh       ,
   `endif
`endif

`ifdef    Al_Full_Flag 
   `ifdef Full_D_Dual_Th
          AlmostFullSetTh     ,
          AlmostFullClrTh     ,
  `endif
  `ifdef  Full_D_Single_Th
          AlmostFullTh        ,
  `endif
`endif

`ifdef    Count_W 
          Wnum                ,
`endif
`ifdef    Count_R
          Rnum                ,
`endif 
`ifdef    Al_Empty_Flag
          Almost_Empty        ,
`endif
`ifdef    Al_Full_Flag
          Almost_Full         ,
`endif
`ifdef En_ECC
          ERROR               ,
`endif  
          Q                   ,
          Empty               ,
          Full 
);
      `include "fifo_parameter.v"

       input           [WDSIZE-1:0]  Data  ;    // Data writed into the FIFO
       input                         WrClk ;    // Write Clock
       input                         RdClk ;    // Read  Clock
       input                         WrEn  ;    // Write Enable
       input                         RdEn  ;    // Read  Enable
`ifdef En_Reset
    `ifdef Reset_Synchronization
       input                         Reset ;    //Reset Synchronization : only Reset
    `else
       input                         WrReset ;  // Two Reset :Write Reset, Read Reset
       input                         RdReset ;
     `endif
`endif

`ifdef Al_Empty_Flag 
    `ifdef Empty_D_Dual_Th
       input          [RASIZE-1:0]   AlmostEmptySetTh ;   // Dynamic input threshold of almost empty set to 1 
       input          [RASIZE-1:0]   AlmostEmptyClrTh ;   // Dynamic input threshold of almost empty set to 0
    `endif
    `ifdef Empty_D_Single_Th
       input          [RASIZE-1:0]   AlmostEmptyTh    ;   //Dynamic input threshold of  almost empty set to 1 
    `endif
`endif

`ifdef Al_Full_Flag 
   `ifdef Full_D_Dual_Th
       input          [ASIZE-1:0]    AlmostFullSetTh ;   // Dynamic input threshold of almost full set to 1
       input          [ASIZE-1:0]    AlmostFullClrTh ;   // Dynamic input threshold of almost full set to 0

   `endif
   `ifdef Full_D_Single_Th
       input          [ASIZE-1:0]    AlmostFullTh    ;   //Dynamic input threshold of  almost full set to 1
   `endif
`endif
        
`ifdef Count_W 
       output         [ASIZE:0]      Wnum ;              // Write data count: synchronized to WrClk;
`endif
`ifdef Count_R
       output         [RASIZE:0]     Rnum ;              // Read data count: synchronized to RdCLK;
`endif 

`ifdef   Al_Empty_Flag
       output                        Almost_Empty ;      // Flag of Almost empty
`endif
`ifdef   Al_Full_Flag
       output                        Almost_Full  ;      // Flag of Almost full
`endif
`ifdef En_ECC
       output         [1:0]          ERROR        ; 
`endif  

       output         [RDSIZE-1:0]   Q     ;             // Data read from the fifo
       output                        Empty ;             // Empty flag
       output                        Full  ;             // Full flag

`getname(fifo,`module_name) fifo_inst (
          .Data                  (Data)                ,
  `ifdef  En_Reset
     `ifdef Reset_Synchronization 
          .Reset                 (Reset)               ,        
     `else 
          .WrReset               (WrReset)             ,
          .RdReset               (RdReset)             ,
     `endif
  `endif
          .WrClk                 (WrClk)               ,
          .RdClk                 (RdClk)               ,
          .WrEn                  (WrEn)                ,
          .RdEn                  (RdEn)                ,
`ifdef    Al_Empty_Flag 
   `ifdef Empty_D_Dual_Th
          .AlmostEmptySetTh      (AlmostEmptySetTh)    ,
          .AlmostEmptyClrTh      (AlmostEmptyClrTh)    ,
   `endif
   `ifdef Empty_D_Single_Th
          .AlmostEmptyTh         (AlmostEmptyTh)       ,
   `endif
`endif

`ifdef    Al_Full_Flag 
   `ifdef Full_D_Dual_Th
          .AlmostFullSetTh       (AlmostFullSetTh)     ,
          .AlmostFullClrTh       (AlmostFullClrTh)     ,
  `endif
  `ifdef  Full_D_Single_Th
          .AlmostFullTh          (AlmostFullTh)        ,
  `endif
`endif

`ifdef    Count_W 
          .Wnum                  (Wnum)                ,
`endif
`ifdef    Count_R
          .Rnum                  (Rnum)                ,
`endif 
`ifdef    Al_Empty_Flag
          .Almost_Empty          (Almost_Empty)        ,
`endif
`ifdef    Al_Full_Flag
          .Almost_Full           (Almost_Full)         ,
`endif
`ifdef En_ECC
          .ERROR                 (ERROR)               ,
`endif  
          .Q                     (Q)                   ,
          .Empty                 (Empty)               ,
          .Full                  (Full) 
    );

endmodule   
