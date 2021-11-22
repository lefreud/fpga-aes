----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2021 02:45:29 PM
-- Design Name: 
-- Module Name: MixColumnsInv_tb - Behavioral
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

entity MixColumnsInv_tb is
--  Port ( );
end MixColumnsInv_tb;

architecture Behavioral of MixColumnsInv_tb is
    component MixColumnsInv is
        Port ( input : in STD_LOGIC_VECTOR(127 downto 0);
               output : out STD_LOGIC_VECTOR(127 downto 0));
    end component;
    
    signal input_int : STD_LOGIC_VECTOR(127 downto 0);
    signal output_int : STD_LOGIC_VECTOR(127 downto 0);
begin

    UUT : MixColumnsInv
        port map (
            input => input_int,
            output => output_int
        );
    
    process begin
        -- https://www.kavaliro.com/wp-content/uploads/2014/03/AES.pdf
        wait for 10 ns;
        -- (big endian)
        -- should yield 2bcb20a230abc7afc092932fa09feb63
        input_int <= x"5d0e327a7d068df4408da4751be884ba";
        wait;
    end process;

end Behavioral;
