library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

library xil_defaultlib;
use xil_defaultlib.PElib.all;
use xil_defaultlib.PEGates.all;
use xil_defaultlib.Nbits.all;

entity test_pe_Nbit is
    generic (N : natural := 9);
end entity;

architecture sim_2 of test_pe_Nbit is
--    component pe_Nbit is
--        Generic ( N: natural := 4);
--        Port ( bi : in STD_LOGIC_VECTOR (N-1 downto 0);
--           bo : out STD_LOGIC_VECTOR (log2(N)-1 downto 0));
--    end component;
    signal bi : STD_LOGIC_VECTOR (N-1  downto 0);
    signal bo : STD_LOGIC_VECTOR (log2(N)-1 downto 0);
begin

        uut: pe_Nbits generic map (N=>N) port map (ei=>'0', bi => bi, bo =>bo,eo => open, gs => open, consumption => open);
        
        test_p : process 
            variable i: integer;
            begin
                 for i in 1 to 10 loop
                    bi <= std_logic_vector(to_unsigned(i,N));
                    wait for 1 ns;
                 end loop;
            end process;
            
        
end architecture;