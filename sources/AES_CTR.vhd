----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2021 11:02:08 AM
-- Design Name: 
-- Module Name: AES_CTR - Behavioral
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

entity AES_CTR is
    generic(number_blocks: integer := 100);
    Port ( input : in STD_LOGIC_VECTOR (number_blocks*128-1 downto 0);
           CLK: in STD_LOGIC;
           direction : in STD_LOGIC;
           key : in STD_LOGIC_VECTOR (127 downto 0);
           output : out STD_LOGIC_VECTOR (number_blocks*128-1 downto 0));
end AES_CTR;

architecture Behavioral of AES_CTR is
signal int_output: STD_LOGIC_VECTOR (number_blocks*128-1 downto 0);
begin
aes_block: for i in 0 to (number_blocks-1) generate
insti: entity work.aes_block port map(data_input=>input((number_blocks+1)*128-1 downto number_blocks*128),
                                      direction=>direction, 
                                      key=>key, 
                                      data_output=>int_output((number_blocks+1)*128-1 downto number_blocks*128));
end generate;
output <= int_output;
end Behavioral;
