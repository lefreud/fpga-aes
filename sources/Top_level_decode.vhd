----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2021 12:50:06 AM
-- Design Name: 
-- Module Name: Top_level_decode - Behavioral
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

entity Top_level_decode is
Port ( clk : in STD_LOGIC;
       clk_uart: in STD_LOGIC;
       reset : in STD_LOGIC;
       rx_uart : in STD_LOGIC);
end Top_level_decode;

architecture Behavioral of Top_level_decode is

component sync_bram is
    port (read_clk, write_clk, write_enable : in std_logic;
          addr_write, addr_read : in std_logic_vector(13 downto 0); -- 11250 blocks so 14 bits for the address
          write_data : in std_logic_vector(127 downto 0); -- Blocks of 128 bits
          read_data : out std_logic_vector(127 downto 0)); -- Blocks of 128 bits
end component; 

component compteur_stocker is
    Port ( clk : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (13 downto 0);
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

signal key: STD_LOGIC_VECTOR (127 downto 0):= x"55555555555555555555555555555555";

type type_etat is (attente, stocker, afficher);
signal etat: type_etat:= attente;

signal count_stocker: STD_LOGIC_VECTOR (13 downto 0);
signal reset_counter: STD_LOGIC;
begin


process(CLK, reset)
begin
if(reset = '1') then
    etat <= attente;
elsif(clk = '1' and clk'event) then
    case etat is
        when attente =>
            
        
        
        when stocker => 
        
        
        
        when afficher =>
    
    
    end case;
end if;

end process;

end Behavioral;
