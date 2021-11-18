----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 10:56:08 AM
-- Design Name: 
-- Module Name: AES_key_schedule - Behavioral
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

entity AES_key_schedule is
    Port ( input : in STD_LOGIC_VECTOR (127 downto 0);
            round : in integer := 1;
           output : out STD_LOGIC_VECTOR (127 downto 0));
end AES_key_schedule;

architecture Behavioral of AES_key_schedule is

type column is array(3 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
type con is array(9 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
signal a_int : column;
signal b_int : column;


signal g_int: STD_LOGIC_VECTOR(31 downto 0);

signal a_int_1: STD_LOGIC_VECTOR(31 downto 0);

signal roundCon:STD_LOGIC_VECTOR(31 downto 0);

begin
a_int(0) <= input(127 downto 96);
a_int(1) <= input(95 downto 64);
a_int(2) <= input(63 downto 32);
a_int(3) <= input(31 downto 0);

rcon: entity work.RoundConstants
port map(round => round,
          rc_next => roundCon);


rot: entity work.RotWord
        port map(word_in => a_int(3),
                 word_out => a_int_1);

sub: entity work.SubWord
port map(word_in => a_int_1,
         word_out => g_int);
        
b_int(0)<= a_int(0) xor g_int xor roundCon;
b_int(1) <= b_int(0) xor a_int(1);
b_int(2) <= b_int(1) xor a_int(2);
b_int(3) <= b_int(2) xor a_int(3);

output(127 downto 96) <= b_int(0);
output(95 downto 64) <= b_int(1);
output(63 downto 32) <= b_int(2);
output(31 downto 0) <= b_int(3);


end Behavioral;
