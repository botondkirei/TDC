library IEEE;
use IEEE.std_logic_1164.all;
use work.pmonitor.all;

entity nand3 is
	generic (
		Domain : integer := 1;
		Cin : real := 5.0e-15;
		Cpd : real := 7.77e-15;
		pleack : real := 0.9e-9;
		Area : real := 1.7
		);
	port ( 
	  --pragma synthesis_off
	  vcc : in real;
	 --pragma synthesis_on
	 a,b,c : in std_logic;
	 O : out  std_logic );
begin
	PM.monitorInput(o, Cpd, Vcc, Domain);
	PM.monitorInput(a, Cin, Vcc, Domain);
	PM.monitorInput(b, Cin, Vcc, Domain);
	PM.monitorInput(c, Cin, Vcc, Domain);
	AM.addArea(Area,Domain);
	PM.addLeackage(pleack,1);
end entity;
architecture primitiv of nand3 is
begin
	O <= not (a and b and c);
end architecture;
