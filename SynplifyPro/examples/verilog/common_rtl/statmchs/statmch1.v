//
// Copyright (c) 1995 by Synplicity, Inc.
// You may distribute freely, as long as this header remains attached.
//
// State Machine Example

// Space shuttle controller
// Copyright ® 1994-1995 Synplicity, Inc.  All rights reserved.

module statmch1(launch_shuttle, land_shuttle, start_countdown, 
start_trip_meter, clk, all_systems_go, just_launched, is_landed, cnt, 
abort_mission);
output launch_shuttle, land_shuttle, start_countdown, start_trip_meter;
input clk, just_launched, is_landed, abort_mission, all_systems_go;
input [3:0] cnt;
reg launch_shuttle, land_shuttle, start_countdown, start_trip_meter;
// parameters for the one-hot encoding of the states
parameter HOLD = 5'h1, SEQUENCE = 5'h2, LAUNCH = 5'h4;
parameter ON_MISSION = 5'h8, LAND = 5'h10;
reg [4:0] present_state, next_state;

always @ (negedge clk or posedge abort_mission)
begin
    /* set the outputs to some default values (so you don't have to set them in 
every case below */
    {launch_shuttle, land_shuttle, start_trip_meter, start_countdown} = 4'b0;


    /* check the value of the asynchronous reset */
    if (abort_mission)
               next_state = LAND;
    else begin
          /* set the next_state to be the present_state by default */
          next_state = present_state;
          /* depending on the present_state and inputs, the case items set the 
next_state variable and output values */
          case (present_state)
            HOLD:    if (all_systems_go) begin
                next_state = SEQUENCE;
                start_countdown = 1;
                end
            SEQUENCE:    if (cnt == 0) next_state = LAUNCH;
            LAUNCH:    begin
                next_state = ON_MISSION;
                launch_shuttle = 1;
               end
            ON_MISSION:

                // Stay on mission until abort mission
                if (just_launched) start_trip_meter = 1;
            LAND:    if (is_landed)
                    next_state = HOLD;
                else land_shuttle = 1;
            /* set the default case to 'bx (don't care) or some known state, so it 
matches simulation before you do a reset */
            default:    next_state = 'bx;
          endcase
    end // end of if-else
    /* make sure you set the present_state variable to the next_state that you 
just assigned, so it has the correct value at the next active clock edge */
    present_state = next_state;
end // end of always
endmodule

