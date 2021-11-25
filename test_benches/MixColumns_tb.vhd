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
               output : out STD_LOGIC_VECTOR(127 downto 0));
    end component;
    
    signal input_int : STD_LOGIC_VECTOR(127 downto 0);
    signal output_int : STD_LOGIC_VECTOR(127 downto 0);
begin
    
    UUT : MixColumns
        port map (
            input => input_int,
            output => output_int
        );
    
    process begin
        -- https://www.kavaliro.com/wp-content/uploads/2014/03/AES.pdf
        wait for 10 ns;
        -- (big endian)
        -- should yield 5d7d401b0e068de8328da4847af475ba
        input_int <= x"2b30c0a0cbab929f20c793eba2af2f63";
        wait;
    end process;

end Behavioral;
