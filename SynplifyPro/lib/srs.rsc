// Resource File for srs file
Name srs

Resource LOGIC 1 1 
: Warpable 

Resource IO 1 1
: Overlay LOGIC
: Discrete
: Fixed

Resource MISC 0 0 
: Null

NetlistType logic LOGIC ( inv buf keepbuf and or nand nor xnor xor andv orv xorv
	maj decode lut nlut chainor chainand clkbuf
) 1 1
	Pin I MISC  MISC 0 0 

NetlistType dff LOGIC ( 
	dff dffr dffs dffrs dffnr dffns dffnrs 
	dffe dffre dffse dffrse dffnre dffnse dffnrse
	dffpatre dffpatse dffpatrse sdffr sdffs sdffrs
	sdffpatr sdffre sdffse sdffrse sdffpatre dffpatr dffpatrs
	ddrrse
	dff_qn dffr_qn dffs_qn dffrs_qn dffnr_qn dffns_qn dffnrs_qn dffpatr_qn dffpatrs_qn
	dffe_qn dffre_qn dffse_qn dffrse_qn dffnre_qn dffnse_qn dffnrse_qn dffpatre_qn
	dffpatse_qn dffpatrse_qn sdffr_qn sdffs_qn sdffrs_qn sdffpatr_qn 
	sdffre_qn sdffse_qn sdffrse_qn sdffpatre_qn
 ) 1 1
	Pin I MISC  MISC 0 0 

NetlistType mux LOGIC (mux imux emux mux41 mux81 pmux primux) 1 1
	Pin I MISC  MISC 0 0 

NetlistType mult LOGIC (mult smult csmult) 1 1
:NoCluster
	Pin I MISC MISC 0 0

NetlistType cmp LOGIC (eq lt lteq slt) 1 1
:NoCluster
	Pin I MISC  MISC 0 0 

NetlistType add LOGIC ( add addsub csadd addmux neg) 1 1
:NoCluster
	Pin I MISC  MISC 0 0 

NetlistType shift LOGIC ( lsh srsh rsh rotr rotl srl ) 1 1
:NoCluster
	Pin I MISC  MISC 0 0 

NetlistType sreg LOGIC (seqshift) 1 1
	Pin I MISC  MISC 0 0 

NetlistType rom LOGIC (rom romreg) 1 1
:NoCluster
	Pin I MISC  MISC 0 0 

NetlistType ram LOGIC (ram1 ram2 nram) 1 1
:NoCluster
	Pin I MISC  MISC 0 0 

NetlistType fifo LOGIC (fifo) 1 1
:NoCluster
	Pin I MISC  MISC 0 0 

NetlistType fsm LOGIC (statemachine) 1 1
	Pin I MISC  MISC 0 0 

NetlistType divide LOGIC ( divmod sdivmod rem srem mod div sdiv ) 1 1
:NoCluster
	Pin I MISC  MISC 0 0 

NetlistType latch LOGIC ( 
	lat latr lats latrs latnr latns latnrs
	lat_qn latr_qn lats_qn latrs_qn latnr_qn latns_qn latnrs_qn
) 1 1
	Pin I MISC  MISC 0 0 

NetlistType io LOGIC (tri) 1 1
	Pin I MISC  MISC 0 0 

// for internal use
NetlistType GCELL LOGIC (GCELL sram_card_venus ) 1 1
	Pin I MISC MISC 0 0

NetlistType HIER_CELL LOGIC () 1 1
	Pin I MISC MISCIN 0 0
	Pin O MISC MISCOUT 0 0 

NetlistType NULL MISC (NONE) 0 0
	Pin I MISC MISC 0 0

NetlistType _IOBUF IO (IO) 0 0 
: NoCluster
	Pin I IN IO_IN 0 0 
	Pin O OUT IO_OUT 0 0

