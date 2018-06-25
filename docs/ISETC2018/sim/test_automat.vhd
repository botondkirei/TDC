library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.PELib.all;
use xil_defaultlib.PEGates.all;


entity test_automat is
generic ( delay : time := 100 ns;
		  N : real := 7.0);
end test_automat;

architecture Behavioral of test_automat is

signal clk, clrn, a, b : std_logic;   
signal state: std_logic_vector(2 downto 0);   
constant period : time := 100 ns; 
signal cons : consumption_type;
signal power : real := 0.0;

component automat_secv is
    Generic (delay : time := 1 ns);
    Port ( Clock, Clearn, a, b : in std_logic;  
           Q : out std_logic_vector(2 downto 0);
		 consumption : out consumption_type := (0.0,0.0)); 
end component;



begin
maping: automat_secv generic map (delay => delay) port map (Clock => clk, Clearn => clrn, a => a, b => b, Q => state, consumption => cons); 

scenario : process  
           begin 
          --initials values  
            clrn <= '0';     
            a <= '0';    
            b <= '0';  
            wait for 2*period;     
            clrn <= '1';     
            wait for 20*period;     
             a <= '0';    
             b <= '1';
             wait for 3*period;
             a <= '1';    
             b <= '0';
             wait for 3*period;
             a <= '1';    
             b <= '0';
             wait for 3*period;
             a <= '0';    
             b <= '1';
             wait for 12*period;  
end process; 
gen_clk : process   
          begin     
          clk <= '1';     
          wait for period/2;     
          clk <= '0';     
          wait for period/2; 
end process;

pe : power_estimator generic map (time_window => N * delay) 
		             port map (consumption => cons, power => power);
		             
message: process 
         begin
         wait for 100 * delay;
         assert false report "End Simulation" severity failure ;
end process; 
 
end Behavioral;

configuration Behavioral_c of test_automat is
	for Behavioral
		for maping : automat_secv  
			use configuration xil_defaultlib.automat_secv_Behavioral;
		end for;
	end for;
end configuration;
