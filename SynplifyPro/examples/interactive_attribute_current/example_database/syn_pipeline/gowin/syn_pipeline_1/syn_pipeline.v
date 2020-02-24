//Interactive attribute example for syn_pipeline attribute

module test(input clk,
                input [3:0] a,b,c,
                output [7:0] r)/* synthesis syn_multstyle=logic */;


reg [7:0] temp2, temp3;
reg [3:0] a_reg,b_reg,c_reg;
wire [7:0] temp1 = a_reg * b_reg;

always @ (posedge clk)
begin
       a_reg<=a;
       b_reg<=b;
       c_reg<=c;
      temp2 <= temp1+c_reg;
      temp3 <= temp2;
      
  
end


assign r=temp3;

endmodule
