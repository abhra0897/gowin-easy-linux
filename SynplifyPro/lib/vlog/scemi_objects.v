
module SceMiMessageOutPort(TransmitReady,
			   ReceiveReady,
			   Message);

   // SCE-MI port parameters
   // Width of the Message port;
   parameter PortWidth         = 1;

   // signals for SceMi interface
  input                           TransmitReady;
  output 			  ReceiveReady;
  input [PortWidth-1:0] 	  Message;

endmodule // SceMiMessageOutPort

module SceMiMessageInPort
  (
   ReceiveReady,
   TransmitReady,
   Message);

  // SCE-MI parameters
  // Width of the Message port;
  parameter PortWidth = 1;

  // signals for SceMi interface
  input                         ReceiveReady;
  output 			TransmitReady;
  output [PortWidth-1:0] 	Message;

endmodule // SceMiMessageInPort

module SceMiClockPort
  (
   // Outputs
   Cclock,
   Creset
  );

  //
  // Module parameters.
  //

  parameter ClockNum         = 1;
  parameter RatioNumerator   = 1;
  parameter RatioDenominator = 1;
  parameter DutyHi	     = 0;
  parameter DutyLo	     = 100;
  parameter Phase	     = 0;
  parameter ResetCycles	     = 8;

  //
  // Module interface.
  //

  output Cclock;
  output Creset;

endmodule // SceMiClockPort

module SceMiClockControl
  (
      Uclock,
      Ureset,
      ReadyForCclock,
      CclockEnabled,
      ReadyForCclockNegEdge,
      CclockNegEdgeEnabled
  );

  //
  // Module parameters.
  //

  // SCE-MI parameters.
  parameter ClockNum = 1;

  // SCE-MI interface.
  input        ReadyForCclock;
  input        ReadyForCclockNegEdge;

  output       Uclock;
  output       Ureset;
  output       CclockEnabled;
  output       CclockNegEdgeEnabled;

endmodule // SceMiClockControl

module SceMiClockPortP
(
    Cclock,
    Creset
);

    parameter ClockNum    = 1;
    parameter ClockPeriod = "1 s";
    parameter DutyHi      = 1;
    parameter DutyLo      = 1;
    parameter Phase       = 0;
    parameter ResetCycles = 8;
	
	output Cclock;
	output Creset;
endmodule // SceMiClockPortP
