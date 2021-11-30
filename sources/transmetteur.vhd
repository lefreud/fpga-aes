----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 11:44:03 AM
-- Design Name: 
-- Module Name: transmetteur - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library logic_com;
use logic_com.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmetteur is
    Port ( start : in STD_LOGIC;
           
           reset : in STD_LOGIC;
           occupe : out STD_LOGIC;
           termine : out STD_LOGIC;
           datain : in STD_LOGIC_VECTOR (5 downto 0);
           clk : in std_logic;
           tx: out std_logic;
           rx: in std_logic);
end transmetteur;

architecture Behavioral of transmetteur is
type etat is (init, chargement, envoi, attente);
signal etat_present : etat;


signal enable_comp_0: std_logic := '1';
signal out_comp_0: std_logic_vector(15 downto 0);

signal cmp_0: std_logic;
signal reset_comp_0: std_logic := '1';

signal data_int: std_logic_vector(7 downto 0);
signal tx_int : std_logic;
signal data_out: STD_LOGIC_VECTOR (7 downto 0);
signal data_rdy : std_logic;
signal start_t : std_logic;
signal slowclock : std_logic;
signal enable : std_logic;
signal term : std_logic;

signal NBRE_COUP_HORLOGE: STD_LOGIC_VECTOR (15 downto 0):=      "0000000000000010";

begin
comparateur_0: entity logic_com.cmp_16bits
    port map(a => out_comp_0, b => NBRE_COUP_HORLOGE, cmp => cmp_0);
    
compteur_0: entity logic_com.compteur_16bits
        port map(reset => reset_comp_0, clk => slowclock, enable =>enable_comp_0, output =>out_comp_0 );
        
slower: entity Logic_com.slowdownclock
   port map(clkout =>slowclock, reset => reset, clkin=>clk);

regdec: entity logic_com.registredecalage
port map(rst => reset,
         clk => clk,
         en => enable,
         led => data_int);

trans_uart: entity logic_com.Transmetteur_UART
port map (reset => reset,
          clk => clk,
          occupe => occupe,
          termine => term,
          start => start_t,
          datain => data_int,
          tx => tx);
          
--recept_uart : entity logic_com.UART
--port map(reset=> reset,
--        clk => clk,
--        data_out => data_out,
--        rx => rx,
--        data_rdy => data_rdy);

termine <= term;
process(clk, slowclock, term)
begin
if(reset = '1') then
    etat_present <= init;
elsif(rising_edge(clk)) then
    case(etat_present) is
        when init =>
            etat_present <= chargement;
            reset_comp_0 <= '1';
            enable <= '0';
            start_t <= '0';
        
        
        when chargement=>
            reset_comp_0 <= '1';
            enable <= '1';
            etat_present <= envoi;
            start_t <= '0';
        
        
        when envoi =>
        reset_comp_0 <= '1';
        start_t <= '1';
        enable <= '0';
        if(term ='1') then 
            etat_present <= attente;
        else 
            etat_present <= envoi;
        end if;
        
        when attente =>
            reset_comp_0 <= '0';
            start_t <= '0';
            enable <= '0';
            if( cmp_0 = '1') then
                reset_comp_0 <= '1';
                etat_present <= chargement;
                --enable_rdc <= '1';
            elsif(cmp_0 = '0') then
                etat_present <= attente;
            end if;
    end case;
end if;


end process;
--data_int <= x"aa";
--tx<= tx_int;
--process(data_rdy)
--begin
--if(data_rdy = '1') then 
--    start_t <= '1';
--elsif(data_rdy = '0') then
--    start_t <= '0';
    
--end if;
--end process;
end Behavioral;
