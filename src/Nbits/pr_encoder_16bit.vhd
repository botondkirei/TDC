----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description:  Priority encoder on 32 bits with activity monitoring (74148 cascading)
--              - inputs: I(i), i=(0:31) ; EI(Enable Input) 
--              - outputs : Y, EO(Enable output), GS(Group select)
--              - dynamic power dissipation can be estimated using the activity signal 
-- Dependencies: pr_encoder_8bit.vhd
-- Revision: 1.0 - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library xil_defaultlib;
use xil_defaultlib.PElib.all;
use xil_defaultlib.PEGates.all;
use xil_defaultlib.Nbits.all;

entity pr_encoder_16bit is
     Port (I: in STD_LOGIC_VECTOR(15 DOWNTO 0);
              EI: in STD_LOGIC;
              Y : out STD_LOGIC_VECTOR(3 DOWNTO 0);
              GS,EO : out STD_LOGIC;
              consumption: out consumption_type := (0.0,0.0));
end pr_encoder_16bit;

architecture Behavioral of pr_encoder_16bit is
component pr_encoder_8bit is
Port (  I : in STD_LOGIC_VECTOR(7 DOWNTO 0);
               EI: in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(2 DOWNTO 0);
               GS,EO : out STD_LOGIC;
               consumption: out consumption_type := (0.0,0.0));
end component;

signal net: std_logic_vector (19 downto 1);
type en_t is array (1 to 10 ) of consumption_type;
signal en : en_t;
type sum_t is array (0 to 10) of consumption_type;
signal sum : sum_t;

begin
    
--encoder1: pr_encoder_8bit port map ( I(0) => I(31), I(1) => I(30), I(2) => I(29), I(3) => I(28), I(4) => I(27), I(5) => I(26), I(6) => I(25), I(7) => I(24), EI => EI, Y(0) => net(1), Y(1) => net(2), Y(2) => net(3), GS => net(4), EO => net(5), consumption => en(1));
--encoder2: pr_encoder_8bit port map ( I(0) => I(23), I(1) => I(22), I(2) => I(21), I(3) => I(20), I(4) => I(19), I(5) => I(18), I(6) => I(17), I(7) => I(16), EI => net(5), Y(0) => net(6), Y(1) => net(7), Y(2) => net(8),GS => net(9), EO => net(10), consumption => en(2));
encoder3: pr_encoder_8bit port map ( I(0) => I(15), I(1) => I(14), I(2) => I(13), I(3) => I(12), I(4) => I(11), I(5) => I(10), I(6) => I(9), I(7) => I(8), EI => net(10), Y(0) => net(11), Y(1) => net(12), Y(2) => net(13), GS => net(14), EO => net(15), consumption => en(3));
encoder4: pr_encoder_8bit port map ( I(0) => I(7), I(1) => I(6), I(2) => I(5), I(3) => I(4), I(4) => I(3), I(5) => I(2), I(6) => I(1), I(7) => I(0), EI => net(15), Y(0) => net(16), Y(1) => net(17), Y(2) => net(18),GS => net(19), EO => EO, consumption => en(4));
--or_gate1: or_gate generic map(delay => 0 ns) port map (a => net(4), b => net(9), y => Y(4), consumption => en(5));
or_gate2: or_gate generic map(delay => 0 ns) port map (a => net(4), b => net(14), y => Y(3), consumption => en(6));
or4_gate1: or4_gate generic map(delay => 0 ns)  port map (a => net(3), b => net(8), c => net(13),d => net(18), y => Y(2), consumption => en(7));
or4_gate2: or4_gate generic map(delay => 0 ns)  port map (a => net(2), b => net(7), c => net(12),d => net(17), y => Y(1), consumption => en(8));
or4_gate3: or4_gate generic map(delay => 0 ns) port map (a => net(1), b => net(1), c => net(11),d => net(16), y => Y(0), consumption => en(9));
or4_gate4: or4_gate generic map(delay => 0 ns) port map (a => net(4), b => net(9), c => net(14),d => net(19), y => GS, consumption => en(10));

sum(0) <= (0.0,0.0);
    sum_up_energy : for I in 1 to 10  generate
                sum_i: sum(I) <= sum(I-1) + en(I);
    end generate sum_up_energy;
    consumption <= sum(10);

end Behavioral;

architecture Structural of pr_encoder_16bit is

	component pr_encoder_32bit is
		 Port (I: in STD_LOGIC_VECTOR(31 DOWNTO 0);
				  EI: in STD_LOGIC;
				  Y : out STD_LOGIC_VECTOR(4 DOWNTO 0);
				  GS,EO : out STD_LOGIC;
				  consumption: out consumption_type := (0.0,0.0));
	end component;
	signal to_y : std_logic_vector(4 downto 0);
begin

    pe_32bit : pr_encoder_32bit port map (I(15 downto 0) => I , I(31 downto 16) => (others => '0'), EI => EI, Y => to_y, EO => EO, GS => GS, consumption => consumption ); 
	Y <= to_y(3 downto 0);
	
end Structural;
