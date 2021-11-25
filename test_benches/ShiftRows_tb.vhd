----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 10:43:54 AM
-- Design Name: 
-- Module Name: ShiftRows_tb - Behavioral
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

entity ShiftRows_tb is
end ShiftRows_tb;

architecture Behavioral of ShiftRows_tb is

signal Data_IN : STD_LOGIC_VECTOR (127 downto 0);
signal Data_OUT : STD_LOGIC_VECTOR (127 downto 0);
signal Data_OUT_ShiftRight : STD_LOGIC_VECTOR (127 downto 0);
signal Row_IN : STD_LOGIC_VECTOR (31 downto 0);
signal Row_OUT : STD_LOGIC_VECTOR (31 downto 0);

component ShiftRows is
    Port ( Data_IN : in STD_LOGIC_VECTOR (127 downto 0);
           Data_OUT : out STD_LOGIC_VECTOR (127 downto 0));
end component;

component ShiftRow is
    generic (N : integer);
    Port ( Row_IN : in STD_LOGIC_VECTOR (31 downto 0);
           Row_OUT : out STD_LOGIC_VECTOR (31 downto 0));
end component;

begin
    
    -- We create a component ShiftRows with the two Data signals
    Shift_Rows : ShiftRows port map (Data_IN => Data_IN, Data_OUT => Data_OUT);
    
    -- We create a component ShiftRow with the two Row signals
    ShiftRow_Example : ShiftRow generic map (N => 2) port map (Row_IN => Row_IN, Row_OUT => Row_OUT);

    -- Data_IN = BC 51 EE B3 38 38 EB 12 04 FF 9A 18 20 26 39 A1
    Data_IN <= "10111100010100011110111010110011001110000011100011101011000100100000010011111111100110100001100000100000001001100011100110100001"; 

    -- Row_IN = BC 51 EE B3
    Row_IN <= "10111100010100011110111010110011";
    
end Behavioral;
