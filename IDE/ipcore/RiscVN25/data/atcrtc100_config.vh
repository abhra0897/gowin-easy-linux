`ifndef ATCRTC100_CONFIG_VH
`define ATCRTC100_CONFIG_VH

/* --------------------------------------------------------------------	*/
/* Define the day counter bit width (value: 1 ~ 15)			*/
/* One week  : 3 bits							*/
/* One month : 5 bits							*/
/* One year  : 9 bits							*/
/* -------------------------------------------------------------------- */
`define ATCRTC100_DAY_BITS 5

/* -------------------------------------------------------------------- */
/* Half second support                                                  */
/* -------------------------------------------------------------------- */
//`define ATCRTC100_HALF_SECOND_SUPPORT

`endif // ATCRTC100_CONFIG_VH
