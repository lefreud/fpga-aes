----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 10:28:33 AM
-- Design Name: 
-- Module Name: MixColumns_tb - Behavioral
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

entity MixColumns_tb is
--  Port ( );
end MixColumns_tb;

architecture Behavioral of MixColumns_tb is
    component MixColumns is
        Port ( input : in STD_LOGIC_VECTOR(127 downto 0);
               direction : in STD_LOGIC;
               output : in STD_LOGIC_VECTOR(127 downto 0));
    end component;
    
    signal input_int : STD_LOGIC_VECTOR(127 downto 0);
    signal direction_int : STD_LOGIC;
    signal output_int : STD_LOGIC_VECTOR(127 downto 0);
begin
    
    UUT : MixColumns
        port map (
            input => input_int,
            direction => direction_int,
            output => output_int
        );
    
    process begin
        -- https://www.kavaliro.com/wp-content/uploads/2014/03/AES.pdf
        -- should yield (in little endian):
        -- 15 C9 7F 9D 
        -- CE 4D 4B C2 
        -- 89 71 BE 88 
        -- 65 47 97 CD
        input_int(31 downto 0) <= x"bdcb596a";
        input_int(63 downto 32) <= x"a012484e";
        input_int(95 downto 64) <= x"9b309e98";
        input_int(127 downto 96) <= x"9bf43d8b";
        wait;
    end process;

end Behavioral;
