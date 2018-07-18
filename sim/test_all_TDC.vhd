library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library std;
use std.textio.all;  --include package textio.vhd
use ieee.math_real.all; -- for random value generation

library work;
use work.PECore.all;
use work.PEGates.all;
use work.Nbits.all;

entity test_all_TDC is
    generic ( nr_etaje : natural := 20 );
--  Port ( );
end test_all_TDC;

architecture Behavioral of test_all_TDC is

    component DL_TDC is
        Generic (nr_etaje : natural :=4;
                delay : time := 1 ns;
                active_edge : boolean := true;
                logic_family : logic_family_t; -- the logic family of the component
                Cload: real := 5.0 -- capacitive load
                );
        Port ( start : in STD_LOGIC;
               stop : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
               Vcc : in real; --supply voltage
               consumption : out consumption_type := cons_zero);
    end component;
    
    component VDL_TDC is
         Generic (nr_etaje : natural :=4;
                    delay_start : time := 2 ns;
                    delay_stop : time := 1 ns;
                    logic_family : logic_family_t; -- the logic family of the component
                    Cload: real := 5.0 -- capacitive load
                    );
            Port ( start : in STD_LOGIC;
                stop : in STD_LOGIC;
                Rn : in STD_LOGIC; 
                Q : out STD_LOGIC_VECTOR (log2(nr_etaje)-1 downto 0);
                done : out STD_LOGIC; 
                Vcc : in real ; --supply voltage
                consumption : out consumption_type := cons_zero);
     end component;
     
     component GRO_TDC is
         Generic (width : natural := 4;
                 delay : time :=1 ns;
                 logic_family : logic_family_t; -- the logic family of the component
                 Cload: real := 5.0 -- capacitive load
                  );
         Port ( start : in STD_LOGIC;
                stop : in STD_LOGIC;
                Q : out STD_LOGIC_VECTOR (width-1 downto 0);
                Vcc : in real ; --supply voltage
                consumption : out consumption_type := cons_zero);
     end component;
     
     procedure start_conversion (
        signal reset, start, stop : out std_logic;
        diff : in time;
        signal done : in std_logic) is
     begin
        start <='0';
        stop <= '0';
        reset <= '0';
        wait for 100 ns;
        reset <= '1';
        wait for 100 ns;
        start <= '1';
        wait for diff;
        stop <= '1';
        wait until done'event and done = '1';
        --wait for nr_etaje * 100 ns;
        start <= '0';
        stop <= '0';
        
     end procedure;
     
    signal start,stop,rst, done : STD_LOGIC;
    signal outQ_DL_TDC : STD_LOGIC_VECTOR (log2(nr_etaje) - 1 downto 0);
    signal outQ_VDL_TDC : STD_LOGIC_VECTOR (log2(nr_etaje) - 1 downto 0);
    signal outQ_GRO_TDC : STD_LOGIC_VECTOR (log2(nr_etaje) - 1 downto 0);
    signal energy1, energy2, energy3: consumption_type;
    signal power1, power2, power3: real := 0.0;
    signal vcc : real := 5.0;

begin
    -- TDC instantiations
    DL_TCD_i: DL_TDC generic map (nr_etaje => nr_etaje, delay => 50 ns, logic_family => HC) port map (start => start, stop => stop, Rn => rst, Q => outQ_DL_TDC, Vcc => vcc, consumption => energy1);
    VDL_TDC_i: VDL_TDC generic map (nr_etaje => nr_etaje, delay_start => 100 ns, delay_stop => 50 ns, logic_family => HC) port map (start => start, stop => stop, Rn => rst, Q => outQ_VDL_TDC, done => done, Vcc => vcc, consumption => energy2);
    GRO_TCD_i: GRO_TDC generic map (width => log2(nr_etaje), delay => 50 ns, logic_family => HC) port map (start => start, stop => stop, Q => outQ_GRO_TDC, Vcc => vcc, consumption => energy3);

	pe1 : power_estimator generic map (time_window => 5000 ns) 
		port map (consumption => energy1, power => power1);
	pe2 : power_estimator generic map (time_window => 5000 ns) 
            port map (consumption => energy2, power => power2);
 	pe3 : power_estimator generic map (time_window => 5000 ns) 
                port map (consumption => energy3, power => power3);
                
     run_measurement: process
        variable start_en, stop_en : natural := 0;
        variable i : natural;
        variable str : line;
        file fhandler : text;
        variable seed1, seed2: positive;               -- seed values for random generator
        variable rand: real;   -- random real-number value in range 0 to 1.0  
 
     begin
        file_open(fhandler, "dynamic_5bit.txt", write_mode);
        for i in 1 to nr_etaje*10 loop
            uniform(seed1, seed2, rand);   -- generate random number
            start_conversion(rst, start, stop, integer(rand*real(nr_etaje)) * 50 ns, done);
--            assert to_integer(outQ_DL_TDC) = integer(rand*real(nr_etaje)) report "DL TDC error" severity error;  
--            assert to_integer(outQ_VDL_TDC) = integer(rand*real(nr_etaje)) report "VDL TDC error" severity error;  
--            assert to_integer(outQ_GRO_TDC) = integer(rand*real(nr_etaje)/2) report "GRO TDC error" severity error;  
            write(str, energy1.dynamic);
            writeline(fhandler, str);
            write(str, energy2.dynamic);
            writeline(fhandler, str);
            write(str, energy3.dynamic);
            writeline(fhandler, str);
            write(str, real(NOW / 1 ns));
            writeline(fhandler, str);
        end loop  ;
        --write static comsumption
        file_close(fhandler); 
        file_open(fhandler, "static_5bit.txt", write_mode);
        write(str, energy1.static);
        writeline(fhandler, str);
        write(str, energy2.static);
        writeline(fhandler, str);
        write(str, energy3.static);
        writeline(fhandler, str);
        file_close(fhandler); 
        assert false report "simulation ended" severity failure;       
     end process;
     
end Behavioral;
