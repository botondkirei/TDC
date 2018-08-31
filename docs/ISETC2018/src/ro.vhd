library ieee; 
use ieee.std_logic_1164.all; 
library work;
use work.PECore.all;
use work.PEGates.all;

entity ro is
	generic (delay : time := 1 ns);
	port ( en : in std_logic;
			Vcc : real :=5.0;
			cons : out consumption_type );
end entity;

architecture struct of ro is
	signal c1,c2,c3,c4,c5,cc : consumption_type;
	signal clks : std_logic_vector( 4 downto 0);
begin
	u1 : nand_gate generic map ( delay => delay, logic_family => cmos, Cload => 47.0e-12) port map ( a => en, b => clks(0), y => clks(1), Vcc => Vcc, consumption => c1);
	u2 : inv_gate generic map ( delay => delay, logic_family => cmos, Cload => 47.0e-12) port map ( a => clks(1), y => clks(2), Vcc => Vcc, consumption => c2);
	u3 : inv_gate generic map ( delay => delay, logic_family => cmos, Cload => 47.0e-12) port map ( a => clks(2), y => clks(3), Vcc => Vcc, consumption => c3);
	u4 : inv_gate generic map ( delay => delay, logic_family => cmos, Cload => 47.0e-12) port map ( a => clks(3), y => clks(4), Vcc => Vcc, consumption => c4);
	u5 : inv_gate generic map ( delay => delay, logic_family => cmos, Cload => 47.0e-12) port map ( a => clks(4), y => clks(0), Vcc => Vcc, consumption => c5);
	cons <= c1 + c2 + c3 + c4 + c5;
	cons_sum: sum_up generic map (N => 5)
	port map (cons(1) => c1, cons(2) => c2, cons(3) => c3, cons(4) => c4, cons(5) => c5, consumption => cc);
end architecture;
