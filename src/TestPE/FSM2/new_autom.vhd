library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity new_autom is
    generic ( width: integer :=4 ;
    delay : time := 1 ns ;
    logic_family : logic_family_t := default_logic_family; -- the logic family of the component
    Cload : real := 0.0 -- capacitive load
    );
port( clk, rn : in std_logic;
	 a : in std_logic;
	 eq : in std_logic;
	 loadLO : inout std_logic;
	 loadHI, loadM, shft, rsthi, done : out std_logic;
	 Vcc : in real ; -- supply voltage
     consumption : out consumption_type := cons_zero);
end new_autom;

architecture Behavioral of new_autom is

signal Q2, Q1, Q0, Q2n, Q1n, Q0n, an, rnn : std_logic ;
signal D2, D1, D0 : STD_LOGIC; 
signal eq0, loadLO0, rsthi0: std_logic;
signal cons : consumption_type_array(1 to 21);
signal net : std_logic_vector(1 to 5);

component comparator is
    Generic ( width: integer :=4 ; 
            delay : time := 1 ns;
            logic_family : logic_family_t; -- the logic family of the component
            Cload: real := 5.0 ; -- capacitive load
            Area: real := 0.0 --parameter area 
             );
    Port ( x : in STD_LOGIC_VECTOR (width-1 downto 0);
           y : in STD_LOGIC_VECTOR (width-1 downto 0);
           EQI : in STD_LOGIC;
           EQO : out STD_LOGIC;
           Vcc : in real ; -- supply voltage
           consumption : out consumption_type := cons_zero
           );
end component;

	signal cnt : std_logic_vector(width-1 downto 0);
	signal cnt_en : std_logic;
begin

eq0 <= eq;
compare_cnt_width1: comparator generic map (width => width, delay => delay, logic_family => logic_family ) port map ( x => cnt,  y => std_logic_vector(to_unsigned(width,width)), EQI => '1', EQO => eq0, Vcc => Vcc, consumption => cons(1));
compare_cnt_width2: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '0' , y(1) => '0',  y(2) => '0' , EQI => '1', EQO => cnt_en, Vcc => Vcc, consumption => cons(2));
--contor
counter : counter_Nbits generic  map (width => width, delay => delay, logic_family => logic_family ) port map ( CLK => CLK, Rn => cnt_en, Q=> cnt, Vcc => Vcc, consumption => cons(3));
--inversoarele
inv4: inv_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (a => a, y => an, Vcc => Vcc, consumption => cons(4));
inv5: inv_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (a => rn, y => rnn, Vcc => Vcc, consumption => cons(5));

--D2
and5_gate1: and5_gate generic map(delay => 0 ns, logic_family => logic_family) port map(a => Q2n, b => Q1n, c => Q0n, d => an ,e => rn , y => D2, Vcc => Vcc, consumption => cons(6));
--D1
and_gate2: and4_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n, b => Q1, c => Q0n, d => eq0, y => net(1), Vcc => Vcc, consumption => cons(7));
and_gate3: and3_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2 , b => Q1n , c => Q0n, y => net(2), Vcc => Vcc, consumption => cons(8));
and_gate4: and3_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n , b => Q1n , c => Q0, y => net(3), Vcc => Vcc, consumption => cons(9));
or_gate1: or4_gate generic map (delay => delay, logic_family => logic_family) port map (a => net(1), b => net(2), c => net(3), d => rnn, y => D1, Vcc => Vcc, consumption => cons(10));
--D0
and_gate5: and4_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n, b => Q1, c => Q0n, d => eq0, y => net(4), Vcc => Vcc, consumption => cons(11));
and_gate6: and4_gate generic map (delay => delay, logic_family => logic_family) port map (a => Q2n, b => Q1n, c => Q0n, d => a, y => net(5), Vcc => Vcc, consumption => cons(12));
or_gate2: or3_gate generic map (delay => delay, logic_family => logic_family) port map (a => net(4), b => net(5), c => rnn, y => D0, Vcc => Vcc, consumption => cons(13));

--bistabilele
dff2: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => logic_family ) port map ( D => D2, Ck => clk, Rn => rn, Q => Q2, Qn => Q2n, Vcc => Vcc, consumption => cons(14));
dff1: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => logic_family ) port map ( D => D1, Ck => clk, Rn => rn, Q => Q1, Qn => Q1n, Vcc => Vcc, consumption => cons(15));
dff0: dff_Nbits generic map( active_edge => true, delay => delay, logic_family => logic_family ) port map ( D => D0, Ck => clk, Rn => rn, Q => Q0, Qn => Q0n, Vcc => Vcc, consumption => cons(16));
 
--loadHI0
compare1: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '1' , y(1) => '0',  y(2) => '0' , EQI => '1', EQO => loadHI, Vcc => Vcc, consumption => cons(17));
--loadLO0
compare2: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '1' , y(1) => '1',  y(2) => '0' , EQI => '1', EQO => loadLO0, Vcc => Vcc, consumption => cons(18));
--shft
compare3: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '0' , y(1) => '1',  y(2) => '0' , EQI => '1', EQO => shft, Vcc => Vcc, consumption => cons(19));
--rsthi0
compare4: comparator generic map (width => 3, delay => delay, logic_family => logic_family ) port map ( x(0) => Q0, x(1) => Q1, x(2) => Q2,  y(0) => '1' , y(1) => '1',  y(2) => '0' , EQI => '1', EQO => rsthi0, Vcc => Vcc, consumption => cons(20));
--done0
inv6 : inv_gate generic map (delay => 0 ns, logic_family => logic_family ) port map (a => rsthi0, y => done, Vcc => Vcc, consumption => cons(21));

loadLO <= loadLO0;
loadM <= loadLO0;
rsthi <= rsthi0;

sum_up_i : sum_up generic map (N => 21) port map (cons => cons, consumption => consumption);

end Behavioral;