# Energy Aware Modeling

The effort to "digitize" as more analog components is a continous trend in IC design. IE. a fully synthesizable frequency synthesizer
could be a grea leap, as the migration from one technology to another one of such a component would be carried out by an EDA software.
Power Estimation Library (PElib), later Power and Aria Estimation Library (PAElib) consist of energy aware components that could be a 
great aid for power estimation in an early (RTL description) design phase. PAElib is written in VHDL, but the power/area estimation 
concept is suitable to be "translated" in other HDL languges, into Verilog an SystemC.

#Repostory Organization

## PElib 

This directory hold the source code (currently in VHDL) of PElib. 

## TestPE

TestPE library is the test suite of PElib. The continuous development of the test suite is desired. Currently some simple circuits
(ring oscillator and finite state machines) were assambled using discrete electronic components form HCT family. Their implementation
was carried out using PElib. Measurement and simulation results are compared in the testsuite.

## docs

Project related publications. The test circuits used in the suite are given in these papers.

# References

[1] B. S. Kirei, V.-I.-M. Chereja, S. Hintea, M. D. Topa, "PAELib: A VHDL Library for Area and Power Dissipation Estimation of CMOS Logic 
Circuits," Advances in Electrical and Computer Engineering, vol.19, no.1, pp.9-16, 2019, doi:10.4316/AECE.2019.01002
[2] Verginia-Iulia-Maria Chereja, Adriana-Ioana Potarniche, Sergiu-Alex Ranga, Botond Sandor Kirei și Marina Dana Țopa, "Power Dissipation 
Estimation of CMOS Digital Circuits at the Gate Level in VHDL",  International Symposium on Electronics and Telecommunications 2018, 
Nov. 7-9, Timisoara, Romania 
