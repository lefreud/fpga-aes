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
    component AES_BLOCK is
        Port ( Data_INPUT : in STD_LOGIC_VECTOR (127 downto 0);
               Key : in STD_LOGIC_VECTOR (127 downto 0);
               Data_ready_in : in STD_LOGIC;
               CLK : in STD_LOGIC;
               RESET : in STD_LOGIC;
               Data_ready_out : out STD_LOGIC;
               Data_OUTPUT : out STD_LOGIC_VECTOR (127 downto 0));
    end component;
        
    signal Data_INPUT_int : STD_LOGIC_VECTOR (127 downto 0);
    signal Key_int : STD_LOGIC_VECTOR (127 downto 0);
    signal Data_ready_in_int : STD_LOGIC;
    signal CLK_int : STD_LOGIC;
    signal RESET_int : STD_LOGIC;
    signal Data_ready_out_int : STD_LOGIC;
    signal Data_OUTPUT_int : STD_LOGIC_VECTOR (127 downto 0);
    
begin
    UUT : AES_BLOCK
        port map (
              Data_INPUT => Data_INPUT_int,
              Key => Key_int,
              Data_ready_in => Data_ready_in_int,
              CLK => CLK_int,
              RESET => RESET_int,
              Data_ready_out => Data_ready_out_int,
              Data_OUTPUT => Data_OUTPUT_int
        );
    
    
    process begin
        -- https://www.kavaliro.com/wp-content/uploads/2014/03/AES.pdf
        -- page 1
        Key_int <= x"754620676e754b20796d207374616854";
        Data_INPUT_int <= x"6f775420656e694e20656e4f206f7754";
        Data_ready_in_int <= '0';
        RESET_int <= '1';
        
        wait for 5 ns;
        RESET_int <= '0';
        
        wait for 5 ns;
        Data_ready_in_int <= '1';
        wait;
    end process;
    
    process begin
        CLK_int <= '0';
        wait for 1 ns;
        CLK_int <= '1';
        wait for 1 ns;
    end process;

end Behavioral;
