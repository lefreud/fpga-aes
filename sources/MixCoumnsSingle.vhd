----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 11:30:16 AM
-- Design Name: 
-- Module Name: MixCoumnsSingle - Behavioral
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

-- https://en.wikipedia.org/wiki/Rijndael_MixColumns
-- https://replit.com/@lefreud/KnowingMatureInfo#main.c

entity MixCoumnsSingle is
    Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0));
end MixCoumnsSingle;

architecture Behavioral of MixCoumnsSingle is
    component MixColumnsByte is
        Port ( input : in STD_LOGIC_VECTOR (7 downto 0);
               output : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    type column is array(3 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
    signal a_int : column;
    signal b_int : column;
    signal output_int : column;
begin
    
    a_int(0) <= input(7 downto 0);
    a_int(1) <= input(15 downto 8);
    a_int(2) <= input(23 downto 16);
    a_int(3) <= input(31 downto 24);
    
    MixColumnsBytes : for i in 0 to 3 generate
        MixColumnsByte_instance : MixColumnsByte
            port map (
                input => a_int(i),
                output => b_int(i)
            );
    end generate MixColumnsBytes;

    output(7 downto 0) <= b_int(0) xor a_int(3) xor a_int(2) xor b_int(1) xor a_int(1);
    output(15 downto 8) <= b_int(1) xor a_int(0) xor a_int(3) xor b_int(2) xor a_int(2);
    output(23 downto 16) <= b_int(2) xor a_int(1) xor a_int(0) xor b_int(3) xor a_int(3);
    output(31 downto 24) <= b_int(3) xor a_int(2) xor a_int(1) xor b_int(0) xor a_int(0);

end Behavioral;
