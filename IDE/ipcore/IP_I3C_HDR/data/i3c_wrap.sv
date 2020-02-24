`include "define.v"

module  `MODULE_NAME (
	scl_i,
	scl_o,
	scl_oen,
	
	sda_i,
	sda_o,
	sda_oen,
	
	sdaPull_o,
	sdaPull_oen,
	
	addr_i,
	wre_i,
	dataN_i,
	dataN_o,
	dataP_i,
	dataP_o,
	irq_o,
	
	sysClk_i,
	ce_i,
	locRst_i,
	rstn_i
);

input   [11:0]  addr_i;
input 		 	wre_i;
input   [7:0]   dataN_i;
output  [7:0]   dataN_o;
input   [7:0]   dataP_i;
output  [7:0]   dataP_o;
output			irq_o;

input			sysClk_i;
input			ce_i;
input			locRst_i;
input			rstn_i;

input       scl_i;
output      scl_o;
output		scl_oen;

input       sda_i;
output		sda_o;
output		sda_oen;

output      sdaPull_o	;
output      sdaPull_oen	;

	I3cPhy iPhy(
	.scl_i		(scl_i),
	.scl_o		(scl_o),
	.scl_oen	(scl_oen),
	
	.sda_i		(sda_i),
	.sda_o		(sda_o),
	.sda_oen	(sda_oen),
	
	.sdaPull_o	(sdaPull_o),
	.sdaPull_oen(sdaPull_oen),
	
	.addr_i		(addr_i),
	.wre_i		(wre_i),
	.dataN_i	(dataN_i),
	.dataN_o	(dataN_o),
	.dataP_i	(dataP_i),
	.dataP_o	(dataP_o),
	.irq_o		(irq_o),
	
	.sysClk_i	(sysClk_i),
	.ce_i		(ce_i),
	.locRst_i	(locRst_i),
	.rstn_i		(rstn_i)
);


endmodule
