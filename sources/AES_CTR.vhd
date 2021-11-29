----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2021 11:02:08 AM
-- Design Name: 
-- Module Name: AES_CTR - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;
library work;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AES_CTR is
    Port ( input : in STD_LOGIC_VECTOR (127 downto 0);
           CLK: in STD_LOGIC;
           data_ready_in: in STD_LOGIC;
           reset:in STD_LOGIC;
           key : in STD_LOGIC_VECTOR (127 downto 0);
           data_ready_out: out STD_LOGIC;
           output : out STD_LOGIC_VECTOR (127 downto 0));
end AES_CTR;

architecture Behavioral of AES_CTR is

component AES_BLOCK is
    Port ( Data_INPUT : in STD_LOGIC_VECTOR (127 downto 0);
           Key : in STD_LOGIC_VECTOR (127 downto 0);
           Data_ready_in : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           Data_ready_out : out STD_LOGIC;
           Data_OUTPUT : out STD_LOGIC_VECTOR (127 downto 0));
end component;

signal aes_output: STD_LOGIC_VECTOR (127 downto 0);
signal nonce : STD_LOGIC_VECTOR (63 downto 0):= x"0123456789012345";
signal counter : STD_LOGIC_VECTOR (63 downto 0):= x"0000000000000000";
signal aes_input: STD_LOGIC_VECTOR (127 downto 0);

begin

aes_input <= counter & nonce;

aes_block0: AES_BLOCK port map (Data_ready_in =>data_ready_in, 
                               Data_INPUT => aes_input, 
                               Key =>key, 
                               Data_ready_out=>data_ready_out, 
                               Data_OUTPUT=>aes_output, 
                               CLK=>CLK, 
                               RESET=>RESET);

process(data_ready_in)
begin
    if(data_ready_in'event and data_ready_in = '1') then
        counter <= counter + 1;
    end if;
end process;

output <= input xor aes_output;
end Behavioral;
