----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2021 11:27:50 AM
-- Design Name: 
-- Module Name: tx_slave_fsm - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tx_slave_fsm is
    Port ( clk_uart : in STD_LOGIC;
           start : in STD_LOGIC;
           bram_read_data: in STD_LOGIC_VECTOR (127 downto 0);
           reset : in STD_LOGIC;
           adresse_read_bram: out STD_LOGIC_VECTOR (13 downto 0);
           termine: out STD_LOGIC;
           tx_uart:out STD_LOGIC);
           
end tx_slave_fsm;

architecture Behavioral of tx_slave_fsm is

component compteur_stocker is
    Port ( clk : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (13 downto 0);
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

component Transmetteur_UART is
    Port ( clk : in STD_LOGIC;
           start : in STD_LOGIC;
           reset : in STD_LOGIC;
           tx : out STD_LOGIC;
           termine : out STD_LOGIC;
           occupe : out STD_LOGIC;
           datain : in STD_LOGIC_VECTOR (127 downto 0));
end component;

type type_etat is (attente, envoyer, fin);
signal etat: type_etat;

signal reset_counter:STD_LOGIC;
signal data_compteur:STD_LOGIC_VECTOR (13 downto 0);

signal start_uart:STD_LOGIC;
signal reset_uart:STD_LOGIC;
signal termine_uart:STD_LOGIC;
signal occupe_uart:STD_LOGIC;

begin
uart: transmetteur_uart port map( clk => clk_uart,
                                  start => start_uart,
                                  reset => reset_uart,
                                  tx => tx_uart,
                                  termine => termine_uart,
                                  occupe => occupe_uart,
                                  datain => bram_read_data);

compteur: compteur_stocker port map (clk => clk_uart,
                                     count => data_compteur,
                                     enable =>termine_uart,
                                     reset =>reset_counter);
                                     
adresse_read_bram <= data_compteur;

process(reset,clk_uart)
begin 
if(reset = '1') then
    etat <= attente;
    termine <= '0';
    reset_uart <= '1';
    start_uart <= '0';
    reset_counter <= '1';
elsif(clk_uart = '1' and clk_uart'event) then
    case etat is
        when attente =>
            reset_counter <= '1';
            termine <= '0';
        --desactiver uart
            reset_uart <= '1';
            start_uart <= '0';
         --lorsqu'on reçoit un signal de départ, on lance l'envoie
            if start = '1' then
                etat <= envoyer;
            end if;
            
        when envoyer =>
            reset_counter <= '0';
            termine <= '0';
        --activer le uart
            start_uart <= '1';
            reset_uart <= '0';
        --lorsqu'on a envoyé 11250 blocs de 128 bits, on a fini
            if(counter_envoie = 11250) then
                etat <= fin;
            end if;
        when fin =>
        --dire au master de changer d'état
            termine <= '1';
            etat <= attente;
            
        when others =>
            etat <= attente;
    end case;
end if;
end process;
end Behavioral;