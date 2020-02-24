library ieee;
use ieee.std_logic_1164.all;

entity latches is 
        port (data, clk, rst, set : in std_logic;
            -- note: VHDL allows outputs to be read
            -- inside the architecture, only if they are
            -- declared as mode "buffer"
              q, qr, qs, qrs: buffer std_logic);
end latches;

architecture behave of latches is
begin
        -- regular latch (no set or reset)
        q   <=  data when clk = '1' else q;

        -- latch with reset
        qr  <= '0' when rst = '1' else 
                data  when clk = '1' else qr;

        -- latch with set
        qs  <= '1' when set = '1' else
                data  when clk = '1' else qs;

        -- latch with reset and set
        qrs <= '0' when rst = '1' else 
               '1' when set = '1' else
                data  when clk = '1' else qrs;
end behave;





