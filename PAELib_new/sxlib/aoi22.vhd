----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Rares Marincas, Botond Sandor Kirei
-- Project Name: Power/Area Avare Modeling and Estimation
-- Description: - sxlib standard libary cell file
-- Dependencies: - PAECore.vhd
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.pmonitor.all;

entity aoi22 is
	generic (
		Domain : integer := 1;
		Cin : real := 5.0e-15;
		Cpd : real := 10.0e-15;
		pleack : real := 1.16e-9;
		Area : real := 2.0
		);
	port ( 
	  --pragma synthesis_off
	  vcc : in real;
	 --pragma synthesis_on
	 a,b,c,d : in std_logic;
	 O : out  std_logic );
begin
	PM.monitorInput(o, Cpd, Vcc, Domain);
	PM.monitorInput(a, Cin, Vcc, Domain);
	PM.monitorInput(b, Cin, Vcc, Domain);
	PM.monitorInput(c, Cin, Vcc, Domain);
	PM.monitorInput(d, Cin, Vcc, Domain);
	AM.addArea(Area,Domain);
	PM.addLeackage(pleack,Domain);
end entity;
architecture primitiv of aoi22 is
begin
	O <= not ((a and b) or (c and d)); --O=!(a*b+c*d);
end architecture;