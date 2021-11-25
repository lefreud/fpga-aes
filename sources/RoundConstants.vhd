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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;
--use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity RoundConstants is
 Port (round : in integer:=1;
        rc_next: out  std_logic_vector(31 downto 0));
end RoundConstants;

architecture Behavioral of RoundConstants is

begin
rc_next <= x"00000001" when round = 1 else 
           x"00000002" when round = 2 else 
           x"00000004" when round = 3 else 
           x"00000008" when round = 4 else 
           x"00000010" when round = 5 else 
           x"00000020" when round = 6 else 
           x"00000040" when round = 7 else
           x"00000080" when round = 8 else 
           x"0000001B" when round = 9 else 
           x"00000036" when round = 10 else 
           x"00000000";
end Behavioral;
