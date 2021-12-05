----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2021 11:59:12 AM
-- Design Name: 
-- Module Name: AES_CTR_tb - Behavioral
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

entity AES_CTR_tb is
--  Port ( );
end AES_CTR_tb;

architecture Behavioral of AES_CTR_tb is

component AES_CTR is
    Port ( input : in STD_LOGIC_VECTOR (127 downto 0);
           CLK: in STD_LOGIC;
           enable: in STD_LOGIC;
           data_ready_in: in STD_LOGIC;
           reset:in STD_LOGIC;
           key : in STD_LOGIC_VECTOR (127 downto 0);
           data_ready_out: out STD_LOGIC;
           output : out STD_LOGIC_VECTOR (127 downto 0));
end component;

signal Data_INPUT_int : STD_LOGIC_VECTOR (127 downto 0);
signal CLK_int : STD_LOGIC;
signal enableEncryption : STD_LOGIC;
signal enableDecryption : STD_LOGIC;
signal Data_ready_in_int : STD_LOGIC;
signal RESET_int : STD_LOGIC;
signal Key_int : STD_LOGIC_VECTOR (127 downto 0);
signal Data_ready_out_int : STD_LOGIC;
signal Data_ready_out_Decryption : STD_LOGIC;
signal Data_OUTPUT_int : STD_LOGIC_VECTOR (127 downto 0);
signal Data_OUTPUT_Decryption : STD_LOGIC_VECTOR (127 downto 0);


begin

AES_CTR_ENCRYPTION : AES_CTR
        port map (
              input => Data_INPUT_int,
              CLK => CLK_int,
              enable => enableEncryption,
              Data_ready_in => Data_ready_in_int,
              RESET => RESET_int,
              Key => Key_int,
              Data_ready_out => Data_ready_out_int,
              output => Data_OUTPUT_int
        );
        
AES_CTR_DECRYPTION : AES_CTR
                port map (
                      input => Data_OUTPUT_int,
                      CLK => CLK_int,
                      enable => enableDecryption,
                      Data_ready_in => Data_ready_out_int,
                      RESET => RESET_int,
                      Key => Key_int,
                      Data_ready_out => Data_ready_out_Decryption,
                      output => Data_OUTPUT_Decryption
                );

process begin
    -- https://www.kavaliro.com/wp-content/uploads/2014/03/AES.pdf
    -- page 1
    Key_int <= x"754620676e754b20796d207374616854";
    Data_INPUT_int <= x"6f775420656e694e20656e4f206f7754";
    Data_ready_in_int <= '0';
    RESET_int <= '0';
    enableEncryption <= '1';
    
    wait for 5 ns;
    --RESET_int <= '0';
    
    wait for 5 ns;
    Data_ready_in_int <= '1';
    wait;
end process;

process begin
wait for 50000 ns;
enableDecryption <= '1';
wait;
end process;

process begin
    CLK_int <= '0';
    wait for 1 ns;
    CLK_int <= '1';
    wait for 1 ns;
end process;


end Behavioral;
