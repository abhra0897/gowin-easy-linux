
This directory contains packages and package bodys
for the std1164 package and some commonly used arithmetic
packages based on std1164.  These packages are precompiled
into Synplify, but you may need them for simulation.

std1164.vhd   - Defines std_logic and std_logic_vector types and overloads
std1164b.vhd  - implements above
arith.vhd     - Basic arithmetic types (signed & unsigned) and overloads
arithb.vhd    - implements above
signed.vhd    - use if you want std_logic_vector to be "signed"
signedb.vhd   - implements above
unsignd.vhd   - use if you want std_logic_vector to be "unsigned"
unsigndb.vhd  - implements above
misc.vhd      - contains some simple logic functions
