----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 10:26:20 AM
-- Design Name: 
-- Module Name: MixColumns - Behavioral
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

entity MixColumns is
    Port ( input : in STD_LOGIC_VECTOR(127 downto 0);
           direction : in STD_LOGIC;
           output : in STD_LOGIC_VECTOR(127 downto 0));
end MixColumns;

architecture Behavioral of MixColumns is
    component MixCoumnsSingle is
        Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
               output : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
begin

    columns : for i in range 0 to 3 generate
        column_mixer : MixCoumnsSingle
            port map (
                input => input((i + 1) * 8 - 1 downto i * 8),
                output => output((i + 1) * 8 - 1 downto i * 8)
            );
    
    end generate columns;
    
end Behavioral;
