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

signal key: STD_LOGIC_VECTOR (127 downto 0);

signal data_out_decalage_red: STD_LOGIC_VECTOR (127 downto 0);
signal data_ready_in_ctr_red: STD_LOGIC;
signal data_ready_out_ctr_red: STD_LOGIC;
signal data_encrypte_red: STD_LOGIC_VECTOR (127 downto 0);

signal data_out_decalage_green: STD_LOGIC_VECTOR (127 downto 0);
signal data_ready_in_ctr_green: STD_LOGIC;
signal data_ready_out_ctr_green: STD_LOGIC;
signal data_encrypte_green: STD_LOGIC_VECTOR (127 downto 0);

signal data_out_decalage_blue: STD_LOGIC_VECTOR (127 downto 0);
signal data_ready_in_ctr_blue: STD_LOGIC;
signal data_ready_out_ctr_blue: STD_LOGIC;
signal data_encrypte_blue: STD_LOGIC_VECTOR (127 downto 0);

begin
reg_decalage_red: registre_decalage port map (data_in => data_in(23 downto 16),
                                              data_out => data_out_decalage_red,
                                              data_ready_out =>data_ready_in_ctr_red,
                                              CLK => CLK, enable => '1',
                                              reset => reset);
                                          
aes_red: aes_ctr port map(input =>data_out_decalage_red,
                          clk=>clk, 
                          data_ready_in =>data_ready_in_ctr_red, 
                          key =>key, 
                          data_ready_out =>data_ready_out_ctr_red, 
                          output =>data_encrypte_red);
                          
                          
reg_decalage_green: registre_decalage port map (data_in => data_in(15 downto 8),
                                              data_out => data_out_decalage_green,
                                              data_ready_out =>data_ready_in_ctr_green,
                                              CLK => CLK, enable => '1',
                                              reset => reset);
                                          
aes_green: aes_ctr port map(input =>data_out_decalage_green,
                          clk=>clk, 
                          data_ready_in =>data_ready_in_ctr_green, 
                          key =>key, 
                          data_ready_out =>data_ready_out_ctr_green, 
                          output =>data_encrypte_green);
                          
                          
reg_decalage_blue: registre_decalage port map (data_in => data_in(7 downto 0),
                                              data_out => data_out_decalage_blue,
                                              data_ready_out =>data_ready_in_ctr_blue,
                                              CLK => CLK, enable => '1',
                                              reset => reset);
                                          
aes_blue: aes_ctr port map(input =>data_out_decalage_blue,
                          clk=>clk, 
                          data_ready_in =>data_ready_in_ctr_blue, 
                          key =>key, 
                          data_ready_out =>data_ready_out_ctr_blue, 
                          output =>data_encrypte_blue);
end Behavioral;

