----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2021 12:20:49 PM
-- Design Name: 
-- Module Name: AES_BLOCK_tb - Behavioral
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

entity AES_BLOCK_tb is
--  Port ( );
end AES_BLOCK_tb;

architecture Behavioral of AES_BLOCK_tb is
    
    signal Data_INPUT_int : STD_LOGIC_VECTOR (127 downto 0);
    signal Key_int : STD_LOGIC_VECTOR (127 downto 0);
    signal Data_OUTPUT_int : STD_LOGIC_VECTOR (127 downto 0);
    
begin

    process begin
        -- https://www.kavaliro.com/wp-content/uploads/2014/03/AES.pdf
        -- page 1
        Key_int <= x"754620676e754b20796d207374616854";
        Data_INPUT_int <= x"6f775420656e694e20656e4f206f7754";
    end process;

end Behavioral;
