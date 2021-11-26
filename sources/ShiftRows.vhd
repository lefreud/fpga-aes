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
    Port ( Data_IN : in STD_LOGIC_VECTOR (127 downto 0);
           Data_OUT : out STD_LOGIC_VECTOR (127 downto 0));
end ShiftRows;

architecture Behavioral of ShiftRows is

begin

Data_OUT(7 downto 0) <= Data_IN(7 downto 0);
Data_OUT(15 downto 8) <= Data_IN(47 downto 40);
Data_OUT(23 downto 16) <= Data_IN(87 downto 80);
Data_OUT(31 downto 24) <= Data_IN(127 downto 120);

Data_OUT(39 downto 32) <= Data_IN(39 downto 32);
Data_OUT(47 downto 40) <= Data_IN(79 downto 72);
Data_OUT(55 downto 48) <= Data_IN(119 downto 112);
Data_OUT(63 downto 56) <= Data_IN(31 downto 24);

Data_OUT(71 downto 64) <= Data_IN(71 downto 64);
Data_OUT(79 downto 72) <= Data_IN(111 downto 104);
Data_OUT(87 downto 80) <= Data_IN(23 downto 16);
Data_OUT(95 downto 88) <= Data_IN(63 downto 56);

Data_OUT(103 downto 96) <= Data_IN(103 downto 96);
Data_OUT(111 downto 104) <= Data_IN(15 downto 8);
Data_OUT(119 downto 112) <= Data_IN(55 downto 48);
Data_OUT(127 downto 120) <= Data_IN(95 downto 88);

end Behavioral;
