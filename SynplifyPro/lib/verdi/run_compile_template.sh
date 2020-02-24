#!/bin/sh
##set VERDI_HOME=$::env(VERDI_HOME)
## -y $XILINX_VIVADO/ids_lite/ISE/verilog/src/unisims -y $XILINX_VIVADO/data/verilog/src/unisims -y $XILINX_VIVADO/data/verilog/src/unimacro -y $XILINX_VIVADO/data/verilog/src/retarget 
##RTL_FILES=${RTL_FILES}
export VERILOG_FILELIST=$(VERILOG_FILELIST)
export VHDL_FILELIST=$(VHDL_FILELIST)
export INCLUDE_DIR={$(INCLUDE_DIR)}
##VENDOR_LIBS=${VENDOR_LIBS}
##LIB_NAME=$(LIB_NAME)

##### Compile the built-in files #####
if [ "$VERILOG_FILELIST" != "" ];
then
	$VERDI_HOME/bin/vericom -autoendcelldef -ignore_macro_redef -applog -comment_transoff_regions -synopsys -comment_transoff_regions -synthesis -ssz -usevcs -error=noMPD $VENDOR_LIBS +libext+.v +define+__UMRPLI_NO_SIM+synthesis+SYNTHESIS -lib haps_work -sverilog -f "$VERILOG_FILELIST"
fi

##### Compile the design VHDL RTL #####
if [ "$VHDL_FILELIST" != "" ];
then
	$VERDI_HOME/bin/vhdlcom  -applog -comment_transoff_regions -synopsys -comment_transoff_regions -synthesis -ssz -usevcs $VENDOR_LIBS +libext+.v +incdir+$INCLUDE_DIR +define+__UMRPLI_NO_SIM+synthesis+SYNTHESIS+portcoerce+inline+noportcoerce+noinline+uselib+delay_mode_path+delay_mode_distributed+delay_mode_unit+delay_mode_zero+SYNTHESIS+synthesis  -lib $LIB_NAME -f "$VHDL_FILELIST"
fi
