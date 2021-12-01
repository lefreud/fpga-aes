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
           adresse_read_bram: out STD_LOGIC_VECTOR (13 downto 0):="00000000000000";
           state_attente: out STD_LOGIC;
           tx_uart:out STD_LOGIC);
           
end tx_slave_fsm;

architecture Behavioral of tx_slave_fsm is

component Transmetteur_UART is
    Port ( clk : in STD_LOGIC;
           start : in STD_LOGIC;
           reset : in STD_LOGIC;
           tx : out STD_LOGIC;
           termine : out STD_LOGIC;
           occupe : out STD_LOGIC;
           datain : in STD_LOGIC_VECTOR (127 downto 0));
end component;

type type_etat is (attente, envoyer);
signal etat: type_etat;

signal counter_envoie:STD_LOGIC_VECTOR (13 downto 0):= (others => '0');

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

process(reset,clk_uart)
begin 
if(reset = '1') then
    etat <= attente;
elsif(clk_uart = '1' and clk_uart'event) then
    case etat is
        when attente =>
        --dire au master de changer d'�tat
            state_attente <= '1';
        --desactiver uart
            reset_uart <= '1';
            start_uart <= '0';
         --lorsqu'on re�oit un signal de d�part, on lance l'envoie
            if start = '1' then
                etat <= envoyer;
            end if;
            
        when envoyer =>
        --activer le uart
            start_uart <= '1';
            reset_uart <= '0';
        --lorsqu'on a envoy� 11250 blocs de 128 bits, on a fini
            if(counter_envoie = (11250-1)) then
                etat <= attente;
            end if;
            
        when others =>
            etat <= attente;
    end case;
end if;
end process;

process(clk_uart)
begin
    if(clk_uart='1' and clk_uart'event) then
        if(termine_uart = '1') then
            counter_envoie <= counter_envoie + 1;
            adresse_read_bram <= counter_envoie;
        end if;
    end if;
end process;
end Behavioral;