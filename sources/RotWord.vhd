----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 10:53:26 PM
-- Design Name: 
-- Module Name: SubWord - Behavioral
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

entity RotWord is
 Port (word_in: in std_logic_vector(31 downto 0);
        word_out : out std_logic_vector(31 downto 0) );
end RotWord;

architecture Behavioral of RotWord is
signal w0: std_logic_vector(7 downto 0); 
signal w1: std_logic_vector(7 downto 0); 
signal w2: std_logic_vector(7 downto 0); 
signal w3: std_logic_vector(7 downto 0); 

begin
process(word_in)
begin
w3 <= word_in(31 downto 24);
w2 <= word_in(23 downto 16);
w1 <= word_in(15 downto 8);
w0 <= word_in(7 downto 0);
end process;

word_out <= w0 & w3 & w2 & w1;

end Behavioral;
