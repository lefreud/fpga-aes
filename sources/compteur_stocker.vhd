----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2021 11:19:32 AM
-- Design Name: 
-- Module Name: compteur_stocker - Behavioral
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

entity compteur_stocker is
    Port ( clk : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (13 downto 0);
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
end compteur_stocker;

architecture Behavioral of compteur_stocker is
signal compteur:STD_LOGIC_VECTOR (13 downto 0):="00000000000000";
begin

count <= compteur;

process(clk, reset)
begin
    if reset = '1' then 
        compteur <= "00000000000000";
    elsif(clk='1' and clk'event) then
        if(enable = '1') then
            compteur <= compteur + 1;
 
        end if;
    end if;
end process;

end Behavioral;
