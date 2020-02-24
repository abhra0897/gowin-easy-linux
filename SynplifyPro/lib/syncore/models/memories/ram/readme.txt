
The SynCORE memory compiler helps designers create memory models for their designs.
These memory models are written out in HDL and can be synthesized as well as simulated.
A testbench is provided for all the RAM models created by the SYNCORE memory compiler. 
For detailed information on the SYNCORE memory compiler and its various options,refer 
to the SynCORE documentation.

If you have any questions or issues, please contact support at www.solvnet.com


Known Issues:

1. Avoid using space character for component name, file name & in directory path. 
2. By deafult, the ram has an no_rw_check attribute set in Syncore_ram.v. This attribute 
   can be modified by setting the un-defining SYN_MULTI_PORT_RAM
    `undef SYN_MULTI_PORT_RAM or by commenting `define SYN_MULTI_PORT_RAM in Syncore_ram.v   
3. Testbench covers limited set of vectors for testing.
4. Most of the target technologies support synchronous RAMs. To make use of the techonology
   specific RAMs either register the Read Address or register the Outputs.   
5. Some of the dual port implementations are not supported for certain target technologies. 
   Their support will be enhanced in future releases of Synplify. 