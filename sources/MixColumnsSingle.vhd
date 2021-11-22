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
use work.MixColumnsPackage.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- https://en.wikipedia.org/wiki/Rijndael_MixColumns
-- https://replit.com/@lefreud/KnowingMatureInfo#main.c

entity MixColumnsSingle is
    Port ( input : in column;
           output : out column);
end MixColumnsSingle;

architecture Behavioral of MixColumnsSingle is
    component MixColumnsByte is
        Port ( input : in STD_LOGIC_VECTOR (7 downto 0);
               output : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    signal b_int : column;
begin
    
    MixColumnsBytes : for i in 0 to 3 generate
        MixColumnsByte_instance : MixColumnsByte
            port map (
                input => input(i),
                output => b_int(i)
            );
    end generate MixColumnsBytes;

    output(0) <= b_int(0) xor input(3) xor input(2) xor b_int(1) xor input(1);
    output(1) <= b_int(1) xor input(0) xor input(3) xor b_int(2) xor input(2);
    output(2) <= b_int(2) xor input(1) xor input(0) xor b_int(3) xor input(3);
    output(3) <= b_int(3) xor input(2) xor input(1) xor b_int(0) xor input(0);

end Behavioral;
