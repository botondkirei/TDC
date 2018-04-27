library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_inv is
end test_inv;

architecture Behavioral of test_inv is
    component inv_gate is
        Generic (delay : time :=1 ns);
        Port ( a : in STD_LOGIC;
           y : out STD_LOGIC);
    end component;
    signal intr, y1, y2 : std_logic;

begin
    process
    begin
        intr <= '0';
        wait for 10 ns;
        intr <= '1';
        wait for 10 ns;
    end process;
    
    d1 : inv_gate generic map ( delay => 1 ns) port map (a => intr, y => y1);
    d2 : inv_gate generic map ( delay => 2 ns) port map (a => intr, y => y2);
         
end Behavioral;