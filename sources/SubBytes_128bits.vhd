----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 11:32:54 AM
-- Design Name: 
-- Module Name: SubBytes_nBytes - Behavioral
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

entity SubBytes_128Bits is
    Port ( data_in : in STD_LOGIC_VECTOR (127 downto 0);
           direction : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (127 downto 0));
end SubBytes_128Bits;

architecture Behavioral of SubBytes_128Bits is

begin

inst:for i in 0 to 15 generate
    byte: entity work.SubBytes port map(input => data_in(127-i*8 downto 128-(i+1)*8), direction => direction, output => data_out(127-i*8 downto 128-(i+1)*8));
end generate;
end Behavioral;
