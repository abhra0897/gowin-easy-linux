--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
--                             ENTITY DECLARATIONS                            --
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
 

    library XL; use XL.XL_STD.all;
    entity AND2 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end AND2;

    library XL; use XL.XL_STD.all; 
    entity AND3 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end AND3;

    library XL; use XL.XL_STD.all; 
    entity AND4 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end AND4;

    library XL; use XL.XL_STD.all; 
    entity ANDn is
		generic ( n			: in POSITIVE);
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n) 
                ); 
    end ANDn; 

    library XL; use XL.XL_STD.all; 
    entity NAND2 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end NAND2;

    library XL; use XL.XL_STD.all; 
    entity NAND3 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end NAND3;

    library XL; use XL.XL_STD.all; 
    entity NAND4 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end NAND4;

    library XL; use XL.XL_STD.all; 
    entity NANDn is
		generic ( n			: in POSITIVE);
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n) 
                );
    end NANDn; 

    library XL; use XL.XL_STD.all; 
    entity OR2 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end OR2;

    library XL; use XL.XL_STD.all; 
    entity OR3 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end OR3;

    library XL; use XL.XL_STD.all; 
    entity OR4 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end OR4;

    library XL; use XL.XL_STD.all; 
    entity ORn is
		generic ( n			: in POSITIVE);
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n)
                ); 
    end ORn; 

    library XL; use XL.XL_STD.all; 
    entity NOR2 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end NOR2;

    library XL; use XL.XL_STD.all; 
    entity NOR3 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end NOR3;

    library XL; use XL.XL_STD.all; 
    entity NOR4 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end NOR4;

    library XL; use XL.XL_STD.all; 
    entity NORn is
		generic ( n			: in POSITIVE);
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n)
                );
    end NORn; 

    library XL; use XL.XL_STD.all; 
    entity XOR2 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end XOR2;

    library XL; use XL.XL_STD.all; 
    entity XOR3 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end XOR3;

    library XL; use XL.XL_STD.all; 
    entity XOR4 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end XOR4;

    library XL; use XL.XL_STD.all; 
    entity XORn is
		generic ( n			: in POSITIVE);
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n)
                );
    end XORn;

    library XL; use XL.XL_STD.all; 
    entity XNOR2 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end XNOR2;

    library XL; use XL.XL_STD.all; 
    entity XNOR3 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end XNOR3;

    library XL; use XL.XL_STD.all; 
    entity XNOR4 is
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end XNOR4;

    library XL; use XL.XL_STD.all; 
    entity XNORn is
		generic ( n			: in POSITIVE);
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n)
                );
    end XNORn;

    library XL; use XL.XL_STD.all; 
    entity BUF is  
        port    ( output    : out   MVL;
                  input     : in    MVL
                ); 
    end BUF;

    library XL; use XL.XL_STD.all; 
    entity BUF2 is
        port    ( output1   : out   MVL;
                  output2   : out   MVL;
                  input     : in    MVL
                ); 
    end BUF2;

    library XL; use XL.XL_STD.all; 
    entity BUF3 is
        port    ( output1   : out   MVL;
                  output2   : out   MVL;
                  output3   : out   MVL;
                  input     : in    MVL
                ); 
    end BUF3;

    library XL; use XL.XL_STD.all; 
    entity BUFn is
		generic ( n			: in POSITIVE);
        port    ( outputs   : out   MVL_VECTOR (1 TO n);
                  input     : in    MVL
                );            
    end BUFn;

    library XL; use XL.XL_STD.all; 
    entity INV is  
        port    ( output    : out   MVL;
                  input     : in    MVL
                ); 
    end INV;

    library XL; use XL.XL_STD.all; 
    entity INV2 is
        port    ( output1   : out   MVL;
                  output2   : out   MVL;
                  input     : in    MVL
                ); 
    end INV2;

    library XL; use XL.XL_STD.all; 
    entity INV3 is
        port    ( output1   : out   MVL;
                  output2   : out   MVL;
                  output3   : out   MVL;
                  input     : in    MVL
                ); 
    end INV3;

    library XL; use XL.XL_STD.all; 
    entity INVn is
		generic ( n			: in POSITIVE);
        port    ( outputs   : out   MVL_VECTOR (1 TO n);
                  input     : in    MVL
                );            
    end INVn;

    library XL; use XL.XL_STD.all; 
    entity BUFIF0 is
        port    ( output    : out   MVL;
                  input     : in    MVL;
                  control   : in    MVL
                );
    end BUFIF0;


    library XL; use XL.XL_STD.all; 
    entity BUFIF1 is
        port    ( output    : out   MVL;
                  input     : in    MVL;
                  control   : in    MVL
                );
    end BUFIF1; 


    library XL; use XL.XL_STD.all; 
    entity NOTIF0 is
        port    ( output    : out   MVL;
                  input     : in    MVL;
                  control   : in    MVL
                );
    end NOTIF0;


    library XL; use XL.XL_STD.all; 
    entity NOTIF1 is
        port    ( output    : out   MVL;
                  input     : in    MVL;
                  control   : in    MVL 
                );
    end NOTIF1; 

    library XL; use XL.XL_STD.all; 
    entity PULLUP is
        port    ( output    : out   MVL );
    end PULLUP;


    library XL; use XL.XL_STD.all; 
    entity PULLDOWN is
        port    ( output    : out   MVL );
    end PULLDOWN;  


--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
--                         GATES ARCHITECTURES                                --
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--

    architecture arch_AND2 of AND2 is
    begin 
      output <= input1 and input2; 
    end arch_AND2; 

    architecture arch_AND3 of AND3 is
    begin 
      output <= input1 and input2 and input3;
    end arch_AND3; 

    architecture arch_AND4 of AND4 is
    begin 
      output <= input1 and input2 and input3 and input4; 
    end arch_AND4; 

    architecture arch_ANDn of ANDn is
    begin 
      output <= red_and(inputs); 
    end arch_ANDn; 


    architecture arch_NAND2 of NAND2 is
    begin 
      output <= input1 nand input2; 
    end arch_NAND2; 

    architecture arch_NAND3 of NAND3 is
    begin 
      output <= not(input1 and input2 and input3); 
    end arch_NAND3; 

    architecture arch_NAND4 of NAND4 is
    begin 
      output <= not(input1 and input2 and input3 and input4); 
    end arch_NAND4; 

    architecture arch_NANDn of NANDn is
    begin 
      output <= red_nand(inputs);
    end arch_NANDn;


    architecture arch_OR2 of OR2 is
    begin 
      output <= input1 or input2; 
    end arch_OR2; 

    architecture arch_OR3 of OR3 is
    begin 
      output <= input1 or input2 or input3; 
    end arch_OR3; 

    architecture arch_OR4 of OR4 is
    begin 
      output <= input1 or input2 or input3 or input4;
    end arch_OR4; 

    architecture arch_ORn of ORn is
    begin 
      output <= red_or(inputs);
    end arch_ORn; 

    architecture arch_NOR2 of NOR2 is
    begin 
      output <= input1 nor input2; 
    end arch_NOR2; 

    architecture arch_NOR3 of NOR3 is
    begin 
      output <= not(input1 or input2 or input3); 
    end arch_NOR3; 

    architecture arch_NOR4 of NOR4 is
    begin 
      output <= not(input1 or input2 or input3 or input4); 
    end arch_NOR4; 

    architecture arch_NORn of NORn is
    begin 
      output <= red_nor(inputs);
    end arch_NORn;


    architecture arch_XOR2 of XOR2 is
    begin 
      output <= input1 xor input2; 
    end arch_XOR2; 

    architecture arch_XOR3 of XOR3 is
    begin 
      output <= ((input1 xor input2) xor input3); 
    end arch_XOR3; 

    architecture arch_XOR4 of XOR4 is
    begin 
      output <= ((input1 xor input2) xor (input3 xor input4)); 
    end arch_XOR4; 

    architecture arch_XORn of XORn is
    begin 
      output <= red_xor(inputs);
    end arch_XORn; 


    architecture arch_XNOR2 of XNOR2 is
    begin 
      output <= not(input1 xor input2); 
    end arch_XNOR2; 

    architecture arch_XNOR3 of XNOR3 is
    begin 
      output <= not((input1 xor input2) xor input3); 
    end arch_XNOR3; 

    architecture arch_XNOR4 of XNOR4 is
    begin 
      output <= not((input1 xor input2) xor (input3 xor input4)); 
    end arch_XNOR4; 

    architecture arch_XNORn of XNORn is
    begin 
      output <= red_xnor(inputs);
    end arch_XNORn;


    architecture arch_BUF of BUF is
    begin 
      output <= input;
    end arch_BUF; 

    architecture arch_BUF2 of BUF2 is
    begin 
      output1 <= input;
      output2 <= input;
    end arch_BUF2; 

    architecture arch_BUF3 of BUF3 is
    begin 
      output1 <= input;
      output2 <= input;
      output3 <= input;
    end arch_BUF3; 

    architecture arch_BUFn of BUFn is
    begin 
      outputs <= fill_mvl_vector(input, N);
    end arch_BUFn; 

    architecture arch_INV of INV is
    begin 
      output <= not(input);
    end arch_INV; 

    architecture arch_INV2 of INV2 is
    begin 
      output1 <= input;
      output2 <= input;
    end arch_INV2; 

    architecture arch_INV3 of INV3 is
    begin 
      output1 <= input;
      output2 <= input;
      output3 <= input;
    end arch_INV3; 

    architecture arch_INVn of INVn is
    begin 
      outputs <= fill_mvl_vector(not(input), N);
    end arch_INVn; 

    architecture arch_BUFIF0 of BUFIF0 is
    begin 
      output <= input when (control = '0') else 'Z';
    end arch_BUFIF0; 


    architecture arch_BUFIF1 of BUFIF1 is
    begin 
      output <= input when (control = '1') else 'Z';
    end arch_BUFIF1;


    architecture arch_NOTIF0 of NOTIF0 is
    begin 
      output <= not input when (control = '0') else 'Z';
    end arch_NOTIF0; 


    architecture arch_NOTIF1 of NOTIF1 is
    begin 
      output <= not input when (control = '0') else 'Z';
    end arch_NOTIF1; 

 
    architecture arch_PULLUP of PULLUP is
    begin                             
    end arch_PULLUP; 


    architecture arch_PULLDOWN of PULLDOWN is
    begin                             
    end arch_PULLDOWN; 
   

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
--!!                                                                    !!--
--!!                          XL_GATES    V 1.2.2                       !!--
--!!                                                                    !!--
--!! This program is the confidential and proprietary product of        !!--
--!! Cadence Design Systems, Inc. Any unauthorized use,                 !!--
--!! reproduction, or transfer of this program is  prohibited.          !!--
--!! Copyright (c) 1990, 1991, 1992 by Cadence Design Systems, Inc.     !!--
--!! All Rights Reserved.                                               !!--
--!!                                                                    !!--
--!!This package must not be modified under any circumstances.          !!--
--!! This file contains the package XL_GATES. The package XL_GATES is   !!--
--!! provided with VHDL-XL to define the gate components for this tool. !!--
--!! It contains component declarations, entities, and architectures    !!--
--!! for the gates. These gates use the XL_STD package.                 !!--
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--
--                        PACKAGE XL_GATES                                --
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!--

library XL; use XL.XL_STD.all;

package XL_GATES is

    -- AND GATES 2, 3, 4, and n inputs --

    component AND2 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end component;

    component AND3 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end component;

    component AND4 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end component;

    component ANDn
		generic ( n			: in POSITIVE); 
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n) 
                ); 
    end component;


    -- NAND GATES 2, 3, 4, and n inputs --

    component NAND2 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end component;

    component NAND3 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end component;

    component NAND4 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end component;

    component NANDn 
		generic ( n			: in POSITIVE);
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n) 
                );
    end component; 


    -- OR GATES 2, 3, 4, and n inputs --

    component OR2 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end component;

    component OR3 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end component;

    component OR4 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end component;

    component ORn 
		generic ( n			: in POSITIVE);
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n)
                ); 
    end component;


    -- NOR GATES 2, 3, 4, and n inputs --

    component NOR2 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end component;

    component NOR3 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end component;

    component NOR4 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end component;

    component NORn 
		generic ( n			: in POSITIVE);
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n)
                );
    end component;


    -- XOR GATES 2, 3, 4, and n inputs --

    component XOR2 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end component;

    component XOR3 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end component;

    component XOR4 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end component;

    component XORn 
		generic ( n			: in POSITIVE);
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n)
                );
    end component;


    -- XNOR GATES 2, 3, 4, and n inputs --

    component XNOR2 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL
                ); 
    end component;

    component XNOR3 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL
                ); 
    end component;

    component XNOR4 
        port    ( output    : out   MVL;
                  input1    : in    MVL;
                  input2    : in    MVL;
                  input3    : in    MVL;
                  input4    : in    MVL
                ); 
    end component;

    component XNORn 
		generic ( n			: in POSITIVE);
        port    ( output    : out   MVL;
                  inputs    : in    MVL_VECTOR (1 TO n)
                );
    end component;


    -- BUFFER GATES 1, 2, 3, and n outputs --

    component BUF  
        port    ( output    : out   MVL;
                  input     : in    MVL
                ); 
    end component;

    component BUF2 
        port    ( output1   : out   MVL;
                  output2   : out   MVL;
                  input     : in    MVL
                ); 
    end component;

    component BUF3 
        port    ( output1   : out   MVL;
                  output2   : out   MVL;
                  output3   : out   MVL;
                  input     : in    MVL
                ); 
    end component;

    component BUFn 
		generic ( n			: in POSITIVE);
        port    ( outputs   : out   MVL_VECTOR (1 TO n);
                  input     : in    MVL
                );            
    end component;


    -- INVERTER GATES 1, 2, 3, and n outputs --

    component INV  
        port    ( output    : out   MVL;
                  input     : in    MVL
                ); 
    end component;

    component INV2 
        port    ( output1   : out   MVL;
                  output2   : out   MVL;
                  input     : in    MVL
                ); 
    end component;

    component INV3 
        port    ( output1   : out   MVL;
                  output2   : out   MVL;
                  output3   : out   MVL;
                  input     : in    MVL
                ); 
    end component;

    component INVn 
		generic ( n			: in POSITIVE);
        port    ( outputs   : out   MVL_VECTOR (1 TO n);
                  input     : in    MVL
                );            
    end component;


    -- Controlled buffers and inverters --

    component BUFIF0 
        port    ( output    : out   MVL;
                  input     : in    MVL;
                  control   : in    MVL
                );
    end component;

    component BUFIF1
        port    ( output    : out   MVL;
                  input     : in    MVL;
                  control   : in    MVL
                );
    end component;   

    component NOTIF0
        port    ( output    : out   MVL;
                  input     : in    MVL;
                  control   : in    MVL
                );
    end component;  

    component NOTIF1
        port    ( output    : out   MVL;
                  input     : in    MVL;
                  control   : in    MVL 
                );
    end component;   

    component PULLUP
	port	( output    : out   MVL );
    end component;

    component PULLDOWN
	port	( output    : out   MVL );
    end component;

end XL_GATES;




