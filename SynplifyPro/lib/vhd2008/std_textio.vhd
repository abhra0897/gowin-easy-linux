--
-- This version of the STD_LOGIC_TEXTIO package is
-- Specific to Synplify and is not usable for simulation
-- Copyright (c) 2002, Synplicity, Inc. All rights reserved
--
--

package TEXTIO is

    type LINE is access string;
    type TEXT is file of string;
    type SIDE is (right, left);
    subtype WIDTH is natural;

	-- changed for vhdl92 syntax:
    file input : TEXT open read_mode is "STD_INPUT";
    file output : TEXT open write_mode is "STD_OUTPUT";

    procedure READLINE(file f: TEXT; L: out LINE);

    procedure READ(L:inout LINE; VALUE: out bit; GOOD : out BOOLEAN);
    procedure READ(L:inout LINE; VALUE: out bit);

    procedure READ(L:inout LINE; VALUE: out bit_vector; GOOD : out BOOLEAN);
    procedure READ(L:inout LINE; VALUE: out bit_vector);

    procedure READ(L:inout LINE; VALUE: out integer; GOOD : out BOOLEAN);
    procedure READ(L:inout LINE; VALUE: out integer);

    procedure READ(L:inout LINE; VALUE: out BOOLEAN; GOOD : out BOOLEAN);
    procedure READ(L:inout LINE; VALUE: out BOOLEAN);

    procedure READ(L:inout LINE; VALUE: out character; GOOD : out BOOLEAN);
    procedure READ(L:inout LINE; VALUE: out character);

    procedure READ(L:inout LINE; VALUE: out real; GOOD : out BOOLEAN);
    procedure READ(L:inout LINE; VALUE: out real);

    procedure READ(L:inout LINE; VALUE: out string; GOOD : out BOOLEAN);
    procedure READ(L:inout LINE; VALUE: out string);

	function ENDFILE(file F : TEXT) return boolean => "endoffile";
    function READALINE(file f: TEXT; maxlen : integer) return LINE => "readaline";
	function v_read_l_to_int_check(L:LINE) return boolean => "read_l_to_int_check";
	function v_read_l_to_int(L:LINE) return integer => "read_l_to_int";
	function v_read_l_to_bool_check(L:LINE) return boolean => "read_l_to_bool_check";
	function v_read_l_to_bool(L:LINE) return boolean => "read_l_to_bool";
	function v_read_l_to_bit_check(L:LINE) return boolean => "read_l_to_bit_check";
	function v_read_l_to_bit(L:LINE) return bit => "read_l_to_bit";
	function v_read_l_to_char(L:LINE) return character => "read_l_to_char";
	function v_read_l_to_char_check(L:LINE) return boolean => "read_l_to_char_check";
	function v_read_l_to_bitv_check(L:LINE; len:natural) return boolean => "read_l_to_bitv_check";
	function v_read_l_to_bitv(L:LINE; len:natural) return bit_vector => "read_l_to_bitv";
	function v_read_l_to_str_check(L:LINE; len:natural) return boolean => "read_l_to_str_check";
	function v_read_l_to_str(L:LINE; len:natural) return string => "read_l_to_str";
	function v_read_l_to_real(L:LINE) return real => "read_l_to_real";
	function v_read_l_to_real_check(L:LINE) return boolean => "read_l_to_real_check";
	function v_file_open_txtfile_withstatus(file F: TEXT; External_Name : string; Open_kind : FILE_OPEN_KIND) return FILE_OPEN_STATUS => "open_txtfile_withstatus";
	function v_close_file(file F: TEXT) return boolean => "close_txtfile";
	function "="(A: FILE_OPEN_STATUS; B: FILE_OPEN_STATUS) return boolean => "eq";

    procedure WRITE(L : inout LINE; VALUE : in bit;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0);

    procedure WRITE(L : inout LINE; VALUE : in bit_vector;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0);

    procedure WRITE(L : inout LINE; VALUE : in BOOLEAN;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0);

    procedure WRITE(L : inout LINE; VALUE : in character;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0);

    procedure WRITE(L : inout LINE; VALUE : in integer;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0);

    procedure WRITE(L : inout LINE; VALUE : in real;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0;
	      DIGITS: in NATURAL := 0);

    procedure WRITE(L : inout LINE; VALUE : in string;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0);

    procedure WRITE(L : inout LINE; VALUE : in time;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0;
	      UNIT: in TIME := ns);

      procedure WRITELINE (file F: TEXT; L: inout LINE);

	procedure FILE_OPEN(Status : out FILE_OPEN_STATUS;
						file F : inout TEXT;
						External_Name : in string;
						Open_Kind : in FILE_OPEN_KIND := READ_MODE);

	procedure FILE_OPEN(file F : inout TEXT;
						External_Name : in string;
						Open_Kind : in FILE_OPEN_KIND := READ_MODE);

	procedure FILE_CLOSE(file F : TEXT);
	procedure DEALLOCATE(L : inout LINE);

end;

package body TEXTIO is

    constant MAX_LINE : integer := 500;
    constant MAX_DIGITS : integer := 20;
    subtype int_string_buf is string(1 to MAX_DIGITS);

    procedure READLINE(file f: TEXT; L: out LINE)
    is
    begin
		L := READALINE(f, MAX_LINE);
    end;

	procedure READ(L:inout LINE; VALUE:out INTEGER; GOOD:out BOOLEAN) is
	begin
		good := v_read_l_to_int_check(L);
		value := v_read_l_to_int(L);
	end READ;

	procedure READ(L:inout LINE; VALUE:out INTEGER) is
	begin
		value := v_read_l_to_int(L);
	end READ;

	procedure READ(L:inout LINE; VALUE:out BOOLEAN; GOOD:out BOOLEAN) is
	begin
		good := v_read_l_to_bool_check(L);
		value := v_read_l_to_bool(L);
	end READ;

	procedure READ(L:inout LINE; VALUE:out BOOLEAN) is
	begin
		value := v_read_l_to_bool(L);
	end READ;

     procedure READ(L:inout LINE; VALUE: out character; GOOD : out BOOLEAN) is
         variable goodResult: boolean;
     begin
		goodResult := v_read_l_to_char_check(L);
		good := goodResult;
           if (goodResult) then
		    value := v_read_l_to_char(L);
           end if;
     end READ;

     procedure READ(L:inout LINE; VALUE: out character) is
     begin 
          value := v_read_l_to_char(L);
     end READ;

	procedure READ(L:inout LINE; VALUE:out STRING; GOOD:out BOOLEAN) is
	variable len: natural := value'length;
    variable goodResult: boolean;
	begin
		goodResult := v_read_l_to_str_check(L, len);
		good := goodResult;
		if(goodResult) then
			value := v_read_l_to_str(L, len);
		end if;
	end READ;

	procedure READ(L:inout LINE; VALUE:out STRING) is
	variable len: natural := value'length;
	begin
		value := v_read_l_to_str(L, len);
	end READ;

	procedure READ(L:inout LINE; VALUE:out BIT_VECTOR; GOOD:out BOOLEAN) is
	variable len: natural := value'length;
	begin
		good := v_read_l_to_bitv_check(L, len);
		value := v_read_l_to_bitv(L, len);
	end READ;

	procedure READ(L:inout LINE; VALUE:out BIT_VECTOR) is
	variable len: natural := value'length;
	begin
		value := v_read_l_to_bitv(L, len);
	end READ;

	procedure READ(L:inout LINE; VALUE:out BIT; GOOD:out BOOLEAN) is
	begin
		good := v_read_l_to_bit_check(L);
		value := v_read_l_to_bit(L);
	end READ;

	procedure READ(L:inout LINE; VALUE:out BIT) is
	begin
		value := v_read_l_to_bit(L);
	end READ;
	
	procedure READ(L:inout LINE; VALUE: out real; GOOD : out BOOLEAN) is
	begin
		good := v_read_l_to_real_check(L);
		if (good) then
		    value := v_read_l_to_real(L);
		end if;
	end READ;
	
    procedure READ(L:inout LINE; VALUE: out real) is 
    begin
	value := v_read_l_to_real(L);
	end READ;

    procedure WRITE(L : inout LINE; VALUE : in bit;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0)
    is
    begin
	null;
    end;


    procedure WRITE(L : inout LINE; VALUE : in bit_vector;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0)
    is
    begin
	null;
    end;

    procedure WRITE(
	variable L :        inout LINE;
	constant VALUE :    in    BOOLEAN;
	constant JUSTIFIED: in    SIDE := right;
	constant FIELD:     in    WIDTH := 0)
    is
    begin
	null;
    end;

    procedure WRITE(L : inout LINE; VALUE : in character;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0)
    is
    begin
	null;
    end;

    procedure WRITE(L : inout LINE; VALUE : in integer;
	      JUSTIFIED: in SIDE := right;
	      FIELD: in WIDTH := 0)
    is
    begin
	null;
    end;

    procedure WRITE(
	variable L        : inout LINE;
	constant VALUE    : in    string;
	constant JUSTIFIED: in    SIDE := right;
	constant FIELD    : in    WIDTH := 0)
    is
    begin
	null;
    end;

    procedure WRITELINE (file F: TEXT; L: inout LINE) is 
    begin
        null;
    end;

	procedure FILE_OPEN(Status : out FILE_OPEN_STATUS;
						file F : inout TEXT;
						External_Name : in string;
						Open_Kind : in FILE_OPEN_KIND := READ_MODE)
	is
	begin
		Status := v_file_open_txtfile_withstatus(F, External_Name, Open_kind);
	end;

	procedure FILE_OPEN(file F : inout TEXT;
						External_Name : in string;
						Open_Kind : in FILE_OPEN_KIND := READ_MODE)
	is
	variable Status : FILE_OPEN_STATUS;
	begin
		Status := v_file_open_txtfile_withstatus(F, External_Name, Open_kind);
	end;

	procedure FILE_CLOSE(file F : TEXT)
	is
	variable retstat : boolean;
	begin
		retstat := v_close_file(F);
	end;

	procedure DEALLOCATE(L : inout LINE)
	is
	begin
		null;
	end;

end TEXTIO;