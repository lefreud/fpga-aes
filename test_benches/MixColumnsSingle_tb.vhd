----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 12:55:37 PM
-- Design Name: 
-- Module Name: MixColumnsSingle_tb - Behavioral
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

entity MixColumnsSingle_tb is
--  Port ( );
end MixColumnsSingle_tb;

architecture Behavioral of MixColumnsSingle_tb is
    component MixCoumnsSingle is
        Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
               output : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    signal input_int : STD_LOGIC_VECTOR (31 downto 0);
    signal output_int : STD_LOGIC_VECTOR (31 downto 0);
begin
    
    UUT : MixCoumnsSingle
        port map (
            input => input_int,
            output => output_int
            );
    
    process begin
        input_int <= x"455313db"; -- should yield bca14d8e (big endian)
        wait for 1 ns;
        input_int <= x"5c220af2"; -- should yield 9d58dc9f
        wait for 1 ns;
        input_int <= x"01010101"; -- should yield 01010101
        wait;
    end process;
    
    

end Behavioral;
