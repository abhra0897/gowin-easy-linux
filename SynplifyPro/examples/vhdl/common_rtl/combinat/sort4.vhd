-- Bus Sorter
-- This bus sorter illustrates using procedures in VHDL.

entity sort4 is
        generic (top : integer :=3);
        port (
                a, b, c, d : in bit_vector(0 to top);
                ra, rb, rc, rd : out bit_vector(0 to top)
        );
end sort4;

architecture muxes of sort4 is
        procedure sort2(x, y : inout bit_vector(0 to top)) is
                variable tmp : bit_vector(0 to top);
        begin
                if x > y then
                        tmp := x;
                        x := y;
                        y := tmp;
                end if;
        end sort2;
begin
        process (a, b, c, d)
                variable va, vb, vc, vd : bit_vector(0 to top);
        begin
                va := a; vb := b; vc := c; vd := d;
                sort2(va, vc); sort2(vb, vd);
                sort2(va, vb); sort2(vc, vd);
                sort2(vb, vc);
                ra <= va; rb <= vb; rc <= vc; rd <= vd;
        end process;
end muxes;
