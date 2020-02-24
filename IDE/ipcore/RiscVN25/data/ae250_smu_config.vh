`ifndef AE250_SMU_CONFIG_VH
`define AE250_SMU_CONFIG_VH

`include "ae250_config.vh"

// -------------------------------------------------
// main power power off signal
// if define AE250_SMU_MDP_PWR_OFF_HIGH, 
//	the power off command would set the X_mpd_pwr_off to high to power off main power
// if don't define AE250_SMU_MDP_PWR_OFF_HIGH,
//	the power off command would set the X_mpd_pwr_off to low  to power off main power
`define AE250_SMU_MDP_PWR_OFF_HIGH

// -------------------------------------------------
// when X_wakeup_in high to trigger the wakeup event, must define the macro AE250_SMU_EXT_WAKEUP_HIGH
//`define AE250_SMU_EXT_WAKEUP_HIGH

// -------------------------------------------------
// scratch pad
//`define AE250_SMU_SCRATCH_SUPPORT
//`define AE250_SMU_SCRATCH_BIT		32
//`define AE250_SMU_SCRATCH_DEFAULT	0

// -------------------------------------------------
// users define register
//`define AE250_SMU_USERDR0_SUPPORT
//`define AE250_SMU_USERDR0_BIT		32
//`define AE250_SMU_USERDR0_DEFAULT	0
//`define AE250_SMU_USERDR1_SUPPORT
//`define AE250_SMU_USERDR1_BIT		32
//`define AE250_SMU_USERDR1_DEFAULT	0

`endif // AE250_SMU_CONFIG_VH

