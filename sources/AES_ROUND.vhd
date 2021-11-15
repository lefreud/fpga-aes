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
        direction: in STD_LOGIC;
        outputText : out STD_LOGIC_VECTOR (127 downto 0));
end AES_ROUND;

architecture Behavioral of AES_ROUND is
signal subBytes_output: STD_LOGIC_VECTOR (127 downto 0);
signal shiftRows_output: STD_LOGIC_VECTOR (127 downto 0);
signal mixColumns_output: STD_LOGIC_VECTOR (127 downto 0);

begin

SubBytes: entity work.SubBytes_128Bits port map(data_in=>inputText, direction=>direction, data_out=>subBytes_output);
ShiftRows: entity work.ShiftRows port map(data_in=>subBytes_output, direction=>direction, data_out=>shiftRows_output);
MixColumns: entity work.MixColumns port map(input=>shiftRows_output, direction=>direction, output=>mixColumns_output);
outputText <= mixColumns_output + roundKey;

end Behavioral;
