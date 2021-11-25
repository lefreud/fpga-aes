----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2021 10:54:40 AM
-- Design Name: 
-- Module Name: registre_8bits - Behavioral
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
library work;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registre_8bits is
    Port ( input : in STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC);
end registre_8bits;

architecture Behavioral of registre_8bits is

begin

process(CLK, reset)
begin
if(reset = '1') then
    output <= "00000000";
elsif(clk'event and clk='1') then
    if(enable = '1') then
        output <= input;
    end if;
end if;
end process;

end Behavioral;
