----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 10:08:04 AM
-- Design Name: 
-- Module Name: ShiftRows - Behavioral
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

entity ShiftRows is
    Port ( Direction : in STD_LOGIC;
           Data_IN : in STD_LOGIC_VECTOR (127 downto 0);
           Data_OUT : out STD_LOGIC_VECTOR (127 downto 0));
end ShiftRows;

architecture Behavioral of ShiftRows is

signal firstRowShiftLeft: std_logic_vector(31 downto 0);
signal secondRowShiftLeft: std_logic_vector(31 downto 0);
signal thirdRowShiftLeft: std_logic_vector(31 downto 0);
signal fourthRowShiftLeft: std_logic_vector(31 downto 0);
signal firstRowShiftRight: std_logic_vector(31 downto 0);
signal secondRowShiftRight: std_logic_vector(31 downto 0);
signal thirdRowShiftRight: std_logic_vector(31 downto 0);
signal fourthRowShiftRight: std_logic_vector(31 downto 0);

component ShiftRow is
    generic (N : integer);
    Port ( Row_IN : in STD_LOGIC_VECTOR (31 downto 0);
           Row_OUT : out STD_LOGIC_VECTOR (31 downto 0));
end component;

begin

ShiftRowLeft_FirstRow : ShiftRow generic map (N => 0) port map (Row_IN => Data_IN(127 downto 96), Row_OUT => firstRowShiftLeft);
ShiftRowLeft_SecondRow : ShiftRow generic map (N => 1) port map (Row_IN => Data_IN(95 downto 64), Row_OUT => secondRowShiftLeft);
ShiftRowLeft_ThirdRow : ShiftRow generic map (N => 2) port map (Row_IN => Data_IN(63 downto 32), Row_OUT => thirdRowShiftLeft);
ShiftRowLeft_FourthRow : ShiftRow generic map (N => 3) port map (Row_IN => Data_IN(31 downto 0), Row_OUT => fourthRowShiftLeft);
ShiftRowRight_FirstRow : ShiftRow generic map (N => 0) port map (Row_IN => Data_IN(127 downto 96), Row_OUT => firstRowShiftRight);
ShiftRowRight_SecondRow : ShiftRow generic map (N => 3) port map (Row_IN => Data_IN(95 downto 64), Row_OUT => secondRowShiftRight);
ShiftRowRight_ThirdRow : ShiftRow generic map (N => 2) port map (Row_IN => Data_IN(63 downto 32), Row_OUT => thirdRowShiftRight);
ShiftRowRight_FourthRow : ShiftRow generic map (N => 1) port map (Row_IN => Data_IN(31 downto 0), Row_OUT => fourthRowShiftRight);

process(Direction, Data_IN, firstRowShiftLeft, secondRowShiftLeft,thirdRowShiftLeft,fourthRowShiftLeft,firstRowShiftRight,secondRowShiftRight,thirdRowShiftRight,fourthRowShiftRight)
begin
    if Direction = '1' then
        Data_OUT(127 downto 96) <= firstRowShiftLeft;
        Data_OUT(95 downto 64) <= secondRowShiftLeft;
        Data_OUT(63 downto 32) <= thirdRowShiftLeft;
        Data_OUT(31 downto 0) <= fourthRowShiftLeft;
    elsif Direction = '0' then
        Data_OUT(127 downto 96) <= firstRowShiftRight;
        Data_OUT(95 downto 64) <= secondRowShiftRight;
        Data_OUT(63 downto 32) <= thirdRowShiftRight;
        Data_OUT(31 downto 0) <= fourthRowShiftRight;
    else
        Data_OUT <= Data_IN;
    end if;
end process;

end Behavioral;
