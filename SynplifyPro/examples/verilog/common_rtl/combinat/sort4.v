//
// Copyright (c) 1995 by Synplicity, Inc.
// You may distribute freely, as long as this header remains attached.
//
module sort4(ra, rb, rc, rd, a, b, c, d);
parameter t = 3;
output [t:0] ra, rb, rc, rd;
input [t:0]    a, b, c, d;
reg [t:0]       ra, rb, rc, rd;

        always @(a or b or c or d) begin :lbl
                reg [t:0] va, vb, vc, vd;
                {va,vb,vc,vd} = {a,b,c,d};
                sort2(va, vc); sort2(vb, vd);
                sort2(va, vb); sort2(vc, vd);
                sort2(vb, vc);
                {ra,rb,rc,rd} = {va,vb,vc,vd};  
        end

        task sort2;
                inout [t:0] x, y;
                reg [t:0] tmp;
                if(x > y)  begin
                        tmp = x;
                        x = y;
                        y = tmp;
                end
        endtask

endmodule



