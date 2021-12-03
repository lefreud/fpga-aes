----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2021 11:56:17 PM
-- Design Name: 
-- Module Name: rx_slave_fsm - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rx_slave_fsm is
 Port ( clk_uart : in STD_LOGIC;
          bram_write_data: in STD_LOGIC_VECTOR (127 downto 0);
          reset : in STD_LOGIC;
          adresse_write_bram: out STD_LOGIC_VECTOR (13 downto 0):="00000000000000";
          data_rdy: out STD_LOGIC;
          rx_uart:in STD_LOGIC);
end rx_slave_fsm;

architecture Behavioral of rx_slave_fsm is

type type_etat is (attente, reception, fin);
signal etat: type_etat;

component UART is
    Port ( RX : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           RESET : in STD_LOGIC;
           data_rdy : out STD_LOGIC;
           clk : in STD_LOGIC);
end component;

signal counter_envoie:STD_LOGIC_VECTOR (13 downto 0):= (others => '0');

--signal start_uart:STD_LOGIC;
signal reset_uart:STD_LOGIC;
signal data_rdy_uart:STD_LOGIC;
--signal occupe_uart:STD_LOGIC;

begin


end Behavioral;
