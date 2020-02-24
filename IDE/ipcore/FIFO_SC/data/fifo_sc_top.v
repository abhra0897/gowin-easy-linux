`include "fifo_sc_define.v"
`timescale 1ns/1ps
 module `module_name(
          Data                ,
          Clk                 ,         
          WrEn                ,
          RdEn                ,
          Reset               ,
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
   `ifdef Full_D_Single_Th
          AlmostFullTh        ,
   `endif
`endif

`ifdef    Count_W 
          Wnum                ,
`endif
`ifdef    Al_Empty_Flag
          Almost_Empty        ,
`endif
`ifdef    Al_Full_Flag
          Almost_Full         ,
`endif
`ifdef    En_ECC
          ERROR               ,
`endif  
          Q                   ,
          Empty               ,
          Full 
);
   
      `include "fifo_sc_parameter.v"
       input           [DSIZE-1:0]   Data ;
       input                         Clk  ;   
       input                         WrEn ;
       input                         RdEn ;
       input                         Reset;
    
`ifdef Al_Empty_Flag 
    `ifdef Empty_D_Dual_Th
       input          [ASIZE-1:0]    AlmostEmptySetTh ;
       input          [ASIZE-1:0]    AlmostEmptyClrTh ;
    `endif
    `ifdef Empty_D_Single_Th
       input          [ASIZE-1:0]    AlmostEmptyTh    ;
    `endif
`endif

`ifdef Al_Full_Flag 
   `ifdef Full_D_Dual_Th
       input          [ASIZE-1:0]    AlmostFullSetTh  ;
       input          [ASIZE-1:0]    AlmostFullClrTh  ;
  `endif
  `ifdef Full_D_Single_Th
       input          [ASIZE-1:0]    AlmostFullTh     ;
  `endif
`endif

`ifdef Count_W 
       output         [ASIZE:0]      Wnum             ;
`endif

`ifdef   Al_Empty_Flag
       output                        Almost_Empty     ;
`endif
`ifdef   Al_Full_Flag
       output                        Almost_Full      ;
`endif
`ifdef En_ECC
       output         [1:0]          ERROR            ;
`endif  

       output         [DSIZE-1:0]    Q                ;
       output                        Empty            ;
       output                        Full             ;

`getname(fifo_sc,`module_name) fifo_sc_inst (
          .Data               (Data)                ,
          .Clk                (Clk)                 ,         
          .WrEn               (WrEn)                ,
          .RdEn               (RdEn)                ,
          .Reset              (Reset)               ,
`ifdef    Al_Empty_Flag 
   `ifdef Empty_D_Dual_Th
          .AlmostEmptySetTh   (AlmostEmptySetTh)    ,
          .AlmostEmptyClrTh   (AlmostEmptyClrTh)    ,
   `endif
   `ifdef Empty_D_Single_Th
          .AlmostEmptyTh      (AlmostEmptyTh)       ,
   `endif
`endif

`ifdef    Al_Full_Flag 
   `ifdef Full_D_Dual_Th
          .AlmostFullSetTh    (AlmostFullSetTh)     ,
          .AlmostFullClrTh    (AlmostFullClrTh)     ,
   `endif
   `ifdef Full_D_Single_Th
          .AlmostFullTh       (AlmostFullTh)        ,
   `endif
`endif

`ifdef    Count_W 
          .Wnum               (Wnum)                ,
`endif
`ifdef    Al_Empty_Flag
          .Almost_Empty       (Almost_Empty)        ,
`endif
`ifdef    Al_Full_Flag
          .Almost_Full        (Almost_Full)         ,
`endif
`ifdef    En_ECC
          .ERROR              (ERROR)               ,
`endif  
          .Q                  (Q)                   ,
          .Empty              (Empty)               ,
          .Full               (Full) 
    );

endmodule
