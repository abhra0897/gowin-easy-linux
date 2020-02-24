## part 1: new lib
vlib work
vmap work work

## part 2: load design
vlog -novopt -incr -work work "../../tb/MIPI_RX_tb.v"
vlog -novopt -incr -work work "../../DPHY_RX_TOP.vo"
vlog -novopt -incr -work work "gw2a/prim_sim.v"

## part 3: sim design
vsim -novopt work.tb

## part 4: add signals
add wave *


## part 5: show ui 
view wave
view structure
view signals

## part 6: run 
run -all
