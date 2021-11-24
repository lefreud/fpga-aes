----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2021 11:44:04 AM
-- Design Name: 
-- Module Name: SubBytesInv_128bits - Behavioral
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

entity SubBytesInv_128bits is
    Port ( input : in STD_LOGIC_VECTOR (127 downto 0);
           output : out STD_LOGIC_VECTOR (127 downto 0));
end SubBytesInv_128bits;

architecture Behavioral of SubBytesInv_128bits is

begin
inst:for i in 0 to 15 generate
    byte: entity work.SubBytesInv port map(input => input(127-i*8 downto 128-(i+1)*8), output => output(127-i*8 downto 128-(i+1)*8));
end generate;

end Behavioral;
