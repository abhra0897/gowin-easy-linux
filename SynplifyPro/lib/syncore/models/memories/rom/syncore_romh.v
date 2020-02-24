// -----------------------------------------------------------------------------
// ---
// ---                 (C) COPYRIGHT 2001-2010 SYNOPSYS, INC.
// ---                           ALL RIGHTS RESERVED
// ---
// --- This software and the associated documentation are confidential and
// --- proprietary to Synopsys, Inc.  Your use or disclosure of this
// --- software is subject to the terms and conditions of a written
// --- license agreement between you, or your company, and Synopsys, Inc.
// ---
// --- The entire notice above must be reproduced on all authorized copies.
// ---
// --- RCS information:
// ---    $Author$
// ---    $DateTime$
// ---    $Revision$
// ---    $Id$
// ---
// --- IP Description : This Module infers Generic Dual/Single Port ROM
// -----------------------------------------------------------------------------



//Simulator Resolution
`timescale	1ns/1ps

//Module Definition
module syncorerom #(
                     parameter  DATA_WIDTH     = 8,
					 parameter  CONFIG_PORT    = "dual",  //single or dual
         			 parameter  RST_TYPE_A     = 1,
					 parameter  RST_TYPE_B     = 1,
        			 parameter  RST_DATA_A     = 1111_1111,
					 parameter  RST_DATA_B     = 1111_1111,
        			 parameter  EN_SENSE_A     = 1,
					 parameter  EN_SENSE_B     = 1,
        			 parameter  ADDR_LTNCY_A   = 1,
					 parameter  ADDR_LTNCY_B   = 1,
         			 parameter  DATA_LTNCY_A   = 1,
					 parameter  DATA_LTNCY_B   = 1,
					 parameter  INIT_FILE      = "init.txt", // file name with extension
					 parameter  ADD_WIDTH      = 10
				   )
				// Port List
				  (
          			input  wire [0 : 0]            ClkA,
					input  wire [0 : 0]            EnA,
       				input  wire [ADD_WIDTH-1 : 0]  AddrA,
					input  wire [0 : 0]            ResetA,
        			input  wire [0 : 0]            ClkB,
					input  wire [0 : 0]            EnB,
       				input  wire [ADD_WIDTH-1 : 0]  AddrB,
					input  wire [0 : 0]            ResetB,
       				output wire [DATA_WIDTH-1 : 0] DataA,
					output wire	[DATA_WIDTH-1 : 0] DataB
				  );

    reg [DATA_WIDTH-1 : 0] 	rom [2**ADD_WIDTH -1 : 0];
	reg [ADD_WIDTH-1 : 0] 	addra_reg;
	reg [ADD_WIDTH-1 : 0] 	addrb_reg;
	reg [DATA_WIDTH-1 : 0] 	dataa_reg;
	reg [DATA_WIDTH-1 : 0] 	datab_reg;

	wire [DATA_WIDTH-1 : 0] dataa_temp;
	wire [DATA_WIDTH-1 : 0] datab_temp;
	
	// rom intialization 					
	initial 
	begin
     $readmemh (INIT_FILE, rom);
	end	
	

	assign en_sense_a = EN_SENSE_A ? EnA : ~EnA;
	assign en_sense_b = EN_SENSE_B ? EnB : ~EnB;
		
		
				
	generate
	begin
		if (CONFIG_PORT == "single")  			// single port rom
		begin
		 	if (RST_TYPE_A == 0) 				// synchronous reset
			begin					
				always @ (posedge ClkA) 
		  		begin
			    	if (ResetA)
			        begin
						addra_reg <= 0;
		              	dataa_reg <= RST_DATA_A;
					end
 		        	else if (en_sense_a)
			     	begin
			 			addra_reg <= AddrA;
			         	dataa_reg <= ADDR_LTNCY_A ? rom[addra_reg] : rom[AddrA];
			     	end						
		        end
			end
            else           						// asynchronous reset
		    begin							
   		         always @ (posedge ClkA or posedge ResetA) 
		         begin
            	 	if (ResetA)
            		begin
            			addra_reg <= 0;
            			dataa_reg <= RST_DATA_A;
            		end
                  	else if (en_sense_a)
            		begin
            			addra_reg <= AddrA;
              		    dataa_reg <= ADDR_LTNCY_A ? rom[addra_reg] : rom[AddrA];
               	    end						
            	end
			end
      	 // output assignments
      	 	assign dataa_temp = ResetA ? RST_DATA_A : (ADDR_LTNCY_A ? rom[addra_reg] : rom[AddrA]);	
      		assign DataA = DATA_LTNCY_A ? dataa_reg : dataa_temp;
        end										// End of single port rom
        
		else if (CONFIG_PORT == "dual")  		// dual port rom
		begin
			if (RST_TYPE_A == 0)				// synchronous reset for PortA
			begin					
		        always @ (posedge ClkA) 
		        begin
					if (ResetA)
					begin
						addra_reg <= 0;
				        dataa_reg <= RST_DATA_A;
					end
 				    else if (en_sense_a)
					begin
						addra_reg <= AddrA;
						dataa_reg <= ADDR_LTNCY_A ? rom[addra_reg] : rom[AddrA];
					end						
				end
			end
			else           						// asynchronous reset for PortA
			begin							
   		        always @ (posedge ClkA or posedge ResetA) 
		        begin
            		if (ResetA)
            		begin
            			addra_reg <= 0;
            			dataa_reg <= RST_DATA_A;
            		end
                  	else if (en_sense_a)
            		begin
            			addra_reg <= AddrA;
              			dataa_reg <= ADDR_LTNCY_A ? rom[addra_reg] : rom[AddrA];
               	    end						
            	end
			end
			if (RST_TYPE_B == 0)				// synchronous reset for portB
			begin					
		        always @ (posedge ClkB) 
		        begin
					if (ResetB)
					begin
						addrb_reg <= 0;
				        datab_reg <= RST_DATA_B;
					end
 				    else if (en_sense_b)
					begin
						addrb_reg <= AddrB;
						datab_reg <= ADDR_LTNCY_B ? rom[addrb_reg] : rom[AddrB];
					end						
				end
			end
          	else 								// asynchronous reset for portB
			begin
				always @ (posedge ClkB or posedge ResetB)
	            begin					
					if (ResetB)
					begin
					    addrb_reg <= 0;
				        datab_reg <= RST_DATA_B;
					end
 				    else if (en_sense_b)
					begin
					 	addrb_reg <= AddrB;
					    datab_reg <= ADDR_LTNCY_B ? rom[addrb_reg] : rom[AddrB];
					end
				end						
			end
			
			// output assignments
			assign dataa_temp = ResetA ? RST_DATA_A : (ADDR_LTNCY_A ? rom[addra_reg] : rom[AddrA]);
			assign datab_temp = ResetB ? RST_DATA_B : (ADDR_LTNCY_B ? rom[addrb_reg] : rom[AddrB]);
      		assign DataA = DATA_LTNCY_A ? dataa_reg : dataa_temp;
			assign DataB = 	DATA_LTNCY_B ? datab_reg : datab_temp;
		end										// End of dual port rom
    end  
	endgenerate    
   
endmodule
												
            
//##################################################################################################
















