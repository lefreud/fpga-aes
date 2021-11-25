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
           key : in STD_LOGIC_VECTOR (127 downto 0);
           
           data_ready_out: out STD_LOGIC;
           output : out STD_LOGIC_VECTOR (127 downto 0));
end AES_CTR;

architecture Behavioral of AES_CTR is
signal aes_output: STD_LOGIC_VECTOR (127 downto 0);
signal nounce : STD_LOGIC_VECTOR (63 downto 0);
signal counter : STD_LOGIC_VECTOR (63 downto 0);
begin

aes_block: entity work.AES_BLOCK port map (data_ready_in =>data_ready_in, input => (counter & nounce), key =>key, data_ready_out=>data_ready_out, output=>aes_output, CLK=>CLK);

process(data_ready_in)
begin
    if(data_ready_in'event and data_ready_in = '1') then
        counter <= counter + 1;
    end if;
end process;

output <= input xor aes_output;
end Behavioral;