library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 
library synplify;
use synplify.attributes.all;

entity ram is 
generic( d_width : integer := 8; 
addr_width : integer := 8; 
mem_depth : integer := 256); 
port (data0, data1, data2, data3, data4 : in STD_LOGIC_VECTOR(d_width - 1 downto 0); 
waddr0, waddr1, waddr2, waddr3, waddr4, addr : in STD_LOGIC_VECTOR(addr_width - 1 downto 0); 
sel0, sel1, we0, we1, clk, rst : in STD_LOGIC; 
q : out STD_LOGIC_VECTOR(d_width - 1 downto 0)); 
end ram; 

architecture rtl of ram is 
type mem_type is array (mem_depth - 1 downto 0) of 
STD_LOGIC_VECTOR (d_width - 1 downto 0); 

signal mem : mem_type; 
attribute syn_ramstyle of mem : signal is "block_ram" ;
begin 

process(clk) 
begin 
if (rising_edge(clk)) then 
if (rst = '1') then
q <= (q'range => '0');
else
q <= mem(conv_integer(addr));
end if;
end if;
end process;

process (clk)
begin
if (rising_edge(clk)) then 
    			mem(conv_integer(waddr0)) <= data0; 
    			mem(conv_integer(waddr1)) <= data1; 
end if;
end process; 

--o <= mem(conv_integer(addr)); 

end rtl; 
