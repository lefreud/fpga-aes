----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2021 01:36:19 PM
-- Design Name: 
-- Module Name: AES_BLOCK - Behavioral
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

entity AES_BLOCK is
    Port ( Data_INPUT : in STD_LOGIC_VECTOR (127 downto 0);
           direction: in STD_LOGIC;
           Key : in STD_LOGIC_VECTOR (127 downto 0);
           Data_OUTPUT : out STD_LOGIC_VECTOR (127 downto 0));
end AES_BLOCK;

architecture Behavioral of AES_BLOCK is

component AES_ROUND is
  Port (inputText : in STD_LOGIC_VECTOR (127 downto 0);
        roundKey : in STD_LOGIC_VECTOR (127 downto 0);
        direction: in STD_LOGIC;
        outputText : out STD_LOGIC_VECTOR (127 downto 0));
end component;

signal firstRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal secondRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal thirdRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal fourthRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal fifthRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal sixthRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal seventhRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal eigthRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal ninethRoundOutput: STD_LOGIC_VECTOR (127 downto 0);

begin

FirstRound : AES_ROUND port map (inputText => Data_INPUT, roundKey => Key, direction => direction, outputText => firstRoundOutput);
SecondRound : AES_ROUND port map (inputText => firstRoundOutput, roundKey => Key, direction => direction, outputText => secondRoundOutput);
ThirdRound : AES_ROUND port map (inputText => secondRoundOutput, roundKey => Key, direction => direction, outputText => thirdRoundOutput);
FourthRound : AES_ROUND port map (inputText => thirdRoundOutput, roundKey => Key, direction => direction, outputText => fourthRoundOutput);
FifthRound : AES_ROUND port map (inputText => fourthRoundOutput, roundKey => Key, direction => direction, outputText => fifthRoundOutput);
SixthRound : AES_ROUND port map (inputText => fifthRoundOutput, roundKey => Key, direction => direction, outputText => sixthRoundOutput);
SeventhRound : AES_ROUND port map (inputText => sixthRoundOutput, roundKey => Key, direction => direction, outputText => seventhRoundOutput);
EigthRound : AES_ROUND port map (inputText => seventhRoundOutput, roundKey => Key, direction => direction, outputText => eigthRoundOutput);
NinethRound : AES_ROUND port map (inputText => eigthRoundOutput, roundKey => Key, direction => direction, outputText => ninethRoundOutput);
TenthRound : AES_ROUND port map (inputText => ninethRoundOutput, roundKey => Key, direction => direction, outputText => Data_OUTPUT);

end Behavioral;
