----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2021 09:42:19 AM
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
library work;
use work.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SubWord is
    Port ( word_in : in STD_LOGIC_VECTOR (31 downto 0);
           word_out : out STD_LOGIC_VECTOR (31 downto 0));
end SubWord;


architecture Behavioral of SubWord is

--signal w0: std_logic_vector(7 downto 0); 
--signal w1: std_logic_vector(7 downto 0); 
--signal w2: std_logic_vector(7 downto 0); 
--signal w3: std_logic_vector(7 downto 0); 

type column is array(3 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
signal a_int : column;
signal b_int : column;
    
begin
a_int(0) <= word_in(31 downto 24);
a_int(1) <= word_in(23 downto 16);
a_int(2) <= word_in(15 downto 8);
a_int(3) <= word_in(7 downto 0);

Subwords: for i in 0 to 3 generate
    sub_instance:  entity work.SubBytes
    port map (input => a_int(i),
                output => b_int(i));
    end generate;

word_out(7 downto 0) <= b_int(3);
word_out(15 downto 8) <=b_int(2);
word_out(23 downto 16) <= b_int(1);
word_out(31 downto 24) <= b_int(0);

end Behavioral;
