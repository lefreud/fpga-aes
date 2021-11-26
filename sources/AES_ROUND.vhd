----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 10:36:08 AM
-- Design Name: 
-- Module Name: AES_ROUND - Behavioral
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
library work;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AES_ROUND is
  Port (inputText : in STD_LOGIC_VECTOR (127 downto 0);
        roundKey : in STD_LOGIC_VECTOR (127 downto 0);
        outputText : out STD_LOGIC_VECTOR (127 downto 0));
end AES_ROUND;

architecture Behavioral of AES_ROUND is

signal shiftRows_input: STD_LOGIC_VECTOR (127 downto 0):=(others=>'0');
signal mixColumns_input: STD_LOGIC_VECTOR (127 downto 0):=(others=>'0');

begin

SubBytes: entity work.SubBytes_128Bits port map(data_in=>inputText, data_out=>shiftRows_input);
ShiftRows: entity work.ShiftRows port map(data_in=>shiftRows_input, data_out=>mixColumns_input);
MixColumns: entity work.MixColumns port map(input=>mixColumns_input, output=>mixColumns_output);
outputText <= (mixColumns_output xor roundKey);

end Behavioral;
