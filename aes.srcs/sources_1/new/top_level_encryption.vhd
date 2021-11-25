----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2021 12:46:38 PM
-- Design Name: 
-- Module Name: top_level_encryption - Behavioral
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

entity top_level_encryption is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (23 downto 0);
           passthrough : in STD_LOGIC;
           data_uart : out STD_LOGIC);
end top_level_encryption;


architecture Behavioral of top_level_encryption is

component registre_decalage is
    Port ( data_in : in STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (127 downto 0);
           data_ready_out: out STD_LOGIC;
           CLK : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

component AES_CTR is
    Port ( input : in STD_LOGIC_VECTOR (127 downto 0);
           CLK: in STD_LOGIC;
           data_ready_in: in STD_LOGIC;
           key : in STD_LOGIC_VECTOR (127 downto 0);
           data_ready_out: out STD_LOGIC;
           output : out STD_LOGIC_VECTOR (127 downto 0));
end component;

signal data_out_decalage: STD_LOGIC_VECTOR (127 downto 0);
signal data_ready_in_ctr: STD_LOGIC;
signal key: STD_LOGIC_VECTOR (127 downto 0);
signal data_ready_out_ctr: STD_LOGIC;
signal data_encrypte: STD_LOGIC_VECTOR (127 downto 0);

begin
reg_decalage: registre_decalage port map (data_in => data_in,
                                          data_out => data_out_decalage,
                                          data_ready_out =>data_ready_in_ctr,
                                          CLK => CLK, enable => '1',
                                          reset => reset);
                                          
aes: aes_ctr port map(input =>data_out_decalage,
                      clk=>clk, 
                      data_ready_in =>data_ready_in_ctr, 
                      key =>key, 
                      data_ready_out =>data_ready_out_ctr, 
                      output =>data_encrypte);
end Behavioral;

