----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 11:04:34 AM
-- Design Name: 
-- Module Name: ShiftRow - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ShiftRow is
    generic (N : integer := 0);
    Port ( Row_IN : in STD_LOGIC_VECTOR (31 downto 0);
           Row_OUT : out STD_LOGIC_VECTOR (31 downto 0));
end ShiftRow;

architecture Behavioral of ShiftRow is

signal ShiftOneByte : STD_LOGIC_VECTOR (31 downto 0);
signal ShiftTwoByte : STD_LOGIC_VECTOR (31 downto 0);
signal ShiftThreeByte : STD_LOGIC_VECTOR (31 downto 0);

begin
ShiftOneByte(31 downto 8) <= Row_IN(23 downto 0);
ShiftOneByte(7 downto 0) <= Row_IN(31 downto 24);
ShiftTwoByte(31 downto 16) <= Row_IN(15 downto 0);
ShiftTwoByte(15 downto 0) <= Row_IN(31 downto 16);
ShiftThreeByte(31 downto 24) <= Row_IN(7 downto 0);
ShiftThreeByte(23 downto 0) <= Row_IN(31 downto 8);

Row_OUT <= Row_IN           when N = 0 else
           ShiftOneByte     when N = 1 else
           ShiftTwoByte     when N = 2 else
           ShiftThreeByte   when N = 3 else
           Row_IN;

end Behavioral;
