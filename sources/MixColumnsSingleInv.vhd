----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2021 11:42:20 AM
-- Design Name: 
-- Module Name: MixColumnsSingleInv - Behavioral
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

-- Details on p. 55: https://cs.ru.nl/~joan/papers/JDA_VRI_Rijndael_2002.pdf

entity MixColumnsSingleInv is
    Port ( input : in column;
           output : out column);
end MixColumnsSingleInv;

architecture Behavioral of MixColumnsSingleInv is
    component MixColumnsByte is
        Port ( input : in STD_LOGIC_VECTOR (7 downto 0);
               output : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    component MixColumnsSingle is
        Port ( input : in column;
               output : out column);
    end component;

    signal d0d2 : STD_LOGIC_VECTOR(7 downto 0);
    signal d0d2times2 : STD_LOGIC_VECTOR(7 downto 0);
    signal d0d2times4 : STD_LOGIC_VECTOR(7 downto 0);
    signal d1d3 : STD_LOGIC_VECTOR(7 downto 0);
    signal d1d3times2 : STD_LOGIC_VECTOR(7 downto 0);
    signal d1d3times4 : STD_LOGIC_VECTOR(7 downto 0);
    signal mix_columns_single_input : column;
begin
    d0d2 <= input(0) xor input(2); 
    d1d3 <= input(1) xor input(3);
    
    d0d2multiply2 : MixColumnsByte
        port map (
            input => d0d2,
            output => d0d2times2
        );
    d0d2multiply4 : MixColumnsByte
        port map (
            input => d0d2times2,
            output => d0d2times4
        );
    d1d3multiply2 : MixColumnsByte
        port map (
            input => d1d3,
            output => d1d3times2
        );
    d1d3multiply4 : MixColumnsByte
        port map (
            input => d1d3,
            output => d1d3times4
        );
    
    mix_columns_single_input(0) <= d0d2times4 xor input(0);
    mix_columns_single_input(1) <= d1d3times4 xor input(1);
    mix_columns_single_input(2) <= d0d2times4 xor input(2);
    mix_columns_single_input(3) <= d1d3times4 xor input(3);
    
    mix_columns_regular : MixColumnsSingle
        port map (
            input => mix_columns_single_input,
            output => output
        );
end Behavioral;
