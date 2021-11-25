----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2021 11:50:55 AM
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
use work.MixColumnsPackage.ALL;

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
    component MixColumnsSingle is
        Port ( input : in column;
               output : out column);
    end component;
    
    signal input_int : column;
    signal output_int : column;
begin
    UUT : MixColumnsSingle
        port map (
            input => input_int,
            output => output_int
        );
    
    -- https://en.wikipedia.org/wiki/Rijndael_MixColumns#Test_vectors_for_MixColumn()
    process begin
        -- should yield 8e 4d a1 bc (little endian)
        input_int(0) <= x"db";
        input_int(1) <= x"13";
        input_int(2) <= x"53";
        input_int(3) <= x"45";
        wait for 10 ns;
        -- should yield 9f dc 58 9d (little endian)
        input_int(0) <= x"f2";
        input_int(1) <= x"0a";
        input_int(2) <= x"22";
        input_int(3) <= x"5c";
        wait for 10 ns;
        -- should yield 01 01 01 01 (little endian)
        input_int(0) <= x"01";
        input_int(1) <= x"01";
        input_int(2) <= x"01";
        input_int(3) <= x"01";
        wait for 10 ns;
        -- 7a,f4,75,ba -- shouldnt output cU,eb,4U,27
        input_int(0) <= x"ba";
        input_int(1) <= x"75";
        input_int(2) <= x"f4";
        input_int(3) <= x"7a";
        wait;
    end process;

end Behavioral;
