library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
entity interupt is
        generic(msb: integer := 7);
        port( nmi,float,int,peripheral: in std_logic;
              flush_cache: out std_logic;
              goto_addr: out std_logic_vector(msb downto 0)
            );
end interupt;
architecture behave of interupt is
        constant nop:           integer:=0;
        constant nmi_addr:      integer:=1;
        constant float_addr:    integer:=2;
        constant int_addr:      integer:=3;
        constant periph_addr:   integer:=4;
begin
      process (nmi,float,int,peripheral)
        variable address: integer;
      begin
         flush_cache <= '0';
         if nmi = '1' then
            address := nmi_addr;
         elsif float = '1' then
            address := float_addr;
            flush_cache <= '1';
         elsif int = '1' then
            address := int_addr;
            flush_cache <= '1';
         elsif peripheral = '1' then
            address := periph_addr;
         else
            address :=nop;
         end if;
         goto_addr <= conv_std_logic_vector(address,msb+1);
      end process;
end behave;
