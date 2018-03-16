----------------------------------------------------------------------------------
-- Company: Technical University of Cluj Napoca
-- Engineer: Chereja Iulia
-- Project Name: NAPOSIP
-- Description: Ripple counter with activity monitoring 
--              - parameters :  delay - simulated delay time of an elementary gate
--                          active_edge  - the active clock front of DFFs
--                          width - the number of DFF cells in the counter
--              - inputs :  Clk - clock, active edge selected by active_edge param
--                          Rn - reset, active logic '0'
--              - outpus :  Q - counter value
--                          activity : number of commutations (used to compute power dissipation)
-- Dependencies: nand_gate.vhd
-- 
-- Revision: 1.0 - Added comments - Botond Sandor Kirei
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_Nbits is
    generic (
            delay : time := 0 ns;
            active_edge : boolean := TRUE;
            width : natural := 8);
    Port ( CLK : in STD_LOGIC;
           Rn : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           activity : out natural);
end counter_Nbits;

architecture Structural of counter_Nbits is

    component dff is
        Generic ( active_edge : boolean := true;
                delay : time := 0 ns);
        Port ( D : in STD_LOGIC;
               Ck : in STD_LOGIC;
               Rn : in STD_LOGIC;
               Q, Qn : out STD_LOGIC;
               activity : out natural);
    end component;
    signal ripple: STD_LOGIC_VECTOR (width downto 0);
    signal feedback,feedback_d : STD_LOGIC_VECTOR (width-1 downto 0);
    -- activity monitoring
    type act_t is array (0 to width -1) of natural;
    signal act : act_t;
    type sum_t is array (-1 to width -1) of natural;
    signal sum : sum_t;

begin

    ripple(0) <= CLK;
    gen_dff:  for i in 0 to width-1 generate
            dffi : dff generic map (active_edge => active_edge) port map (D => feedback_d(i), Ck => ripple(i), Rn => Rn, Q => ripple(i+1), Qn => feedback(i), activity => act(i));
    end generate gen_dff;
    feedback_d <= feedback after 1 ns;
    Q <= ripple(width downto 1);
    
    --+ activity monitoring section
    -- for behavioral simulation only
    sum(-1) <= 0;
    sum_up_energy : for I in 0 to width-1  generate
          sum_i:    sum(I) <= sum(I-1) + act(I);
    end generate sum_up_energy;
    activity <= sum(width - 1);
    --- activity monitoring section
end Structural;


