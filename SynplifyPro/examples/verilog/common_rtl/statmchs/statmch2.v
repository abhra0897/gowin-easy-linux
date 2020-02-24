//
// Copyright (c) 1995 by Synplicity, Inc.
// You may distribute freely, as long as this header remains attached.
//
// VCR tape player and recorder state machine
//
// 10 states

`define stop            4'h0
`define will_forward    4'h1
`define forward         4'h2
`define will_rewind     4'h3
`define rewind          4'h4
`define pause           4'h5
`define will_play       4'h6
`define play            4'h7
`define will_record     4'h8
`define record          4'h9

module vcr(stop_tape, pause_tape,
                forward_tape, rewind_tape, 
                play_tape, record_tape, 
                clk, 
                stop_button, pause_button,
                forward_button, rewind_button,
                play_button,record_button, 
                is_stopped, reset);
output stop_tape, pause_tape, forward_tape, rewind_tape,
                 play_tape, record_tape;
input clk, stop_button, pause_button, forward_button, rewind_button,
                play_button, record_button, is_stopped, reset;

reg stop_tape, pause_tape, forward_tape, rewind_tape,
                 play_tape, record_tape;
reg [3:0] current_state, next_state;


// FUNCTION to encode all state-independent transitions

function [4:0] get_next_state;
input   stop_button,forward_button, 
        rewind_button, record_button, play_button;
begin
        
/*
get_next_state[4] = 1 means next state is independent of current
state and we are setting it in this function.
get_next_state[3:0] = next_state
*/
        get_next_state = {1'b1, current_state}; 
        if (stop_button)
                get_next_state = `stop;
        else if (record_button && play_button)
                get_next_state  = `will_record;
        else if (play_button)
                get_next_state  = `will_play;
        else if (forward_button)
                get_next_state  = `will_forward;
        else if (rewind_button)
                get_next_state  = `will_rewind;
        else
                // next state is state-dependent and we
                // are not setting it here
                get_next_state  = {1'b0, current_state};
        
end
endfunction


always @ (posedge clk)
begin:  this_always
    reg state_independant;
                
    stop_tape = 0;
    pause_tape = 0;
    play_tape = 0;
    record_tape = 0;
    forward_tape = 0;
    rewind_tape = 0;
        
    // SET OUTPUTS
    case(current_state)
        `stop,`will_play,`will_record,
        `will_forward,`will_rewind:     stop_tape = 1;  
        `pause:                         pause_tape = 1;
        `play:                          play_tape = 1;
        `record:                        record_tape = 1;
        `forward:                       forward_tape = 1;
        `rewind:                        rewind_tape = 1;
    endcase

    // STATE TRANSITIONS
    if (!reset)                 // synchronous reset
        next_state = `stop;
    else
    begin
        // go to next state
        // state independent transitions
        {state_independant, next_state} =get_next_state(stop_button,
                forward_button, rewind_button, record_button, play_button);
        // do state dependent transitions
        if (!state_independant)
                if (is_stopped)
                        case(current_state)
                                `will_forward:  next_state = `forward;  
                                `will_rewind:   next_state = `rewind;
                                `will_play:     next_state = `play;
                                `will_record:   next_state = `record;
                         endcase
                else if (current_state == `play  && pause_button)
                                 next_state = `pause;
                else if (current_state == `pause && pause_button)
                                 next_state = `play;
        
    end // outer if

    current_state = next_state;

end  // always block
endmodule







