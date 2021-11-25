library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AES_BLOCK is
    Port ( Data_INPUT : in STD_LOGIC_VECTOR (127 downto 0);
           Key : in STD_LOGIC_VECTOR (127 downto 0);
           Data_ready_in : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           Data_ready_out : out STD_LOGIC;
           Data_OUTPUT : out STD_LOGIC_VECTOR (127 downto 0));
end AES_BLOCK;

architecture Behavioral of AES_BLOCK is

component Register128Bits is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Data_IN : in STD_LOGIC_VECTOR (127 downto 0);
           EN : in STD_LOGIC;
           Data_OUT : out STD_LOGIC_VECTOR (127 downto 0));
end component;

component BitRegister is
    Port ( RESET : in STD_LOGIC;
       CLK : in STD_LOGIC;
       D : in STD_LOGIC;
       EN : in STD_LOGIC;
       Q : out STD_LOGIC);
end component;

component AES_ROUND is
  Port (inputText : in STD_LOGIC_VECTOR (127 downto 0);
        roundKey : in STD_LOGIC_VECTOR (127 downto 0);
        outputText : out STD_LOGIC_VECTOR (127 downto 0));
end component;

component AES_key_schedule is
    Port ( input : in STD_LOGIC_VECTOR (127 downto 0);
            round : in integer := 1;
           output : out STD_LOGIC_VECTOR (127 downto 0));
end component;

signal firstRoundKey: STD_LOGIC_VECTOR (127 downto 0);
signal firstRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal firstRegister: STD_LOGIC_VECTOR (127 downto 0);

signal secondRoundKey: STD_LOGIC_VECTOR (127 downto 0);
signal secondRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal secondRegister: STD_LOGIC_VECTOR (127 downto 0);

signal thirdRoundKey: STD_LOGIC_VECTOR (127 downto 0);
signal thirdRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal thirdRegister: STD_LOGIC_VECTOR (127 downto 0);

signal fourthRoundKey: STD_LOGIC_VECTOR (127 downto 0);
signal fourthRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal fourthRegister: STD_LOGIC_VECTOR (127 downto 0);

signal fifthRoundKey: STD_LOGIC_VECTOR (127 downto 0);
signal fifthRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal fifthRegister: STD_LOGIC_VECTOR (127 downto 0);

signal sixthRoundKey: STD_LOGIC_VECTOR (127 downto 0);
signal sixthRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal sixthRegister: STD_LOGIC_VECTOR (127 downto 0);

signal seventhRoundKey: STD_LOGIC_VECTOR (127 downto 0);
signal seventhRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal seventhRegister: STD_LOGIC_VECTOR (127 downto 0);

signal eigthRoundKey: STD_LOGIC_VECTOR (127 downto 0);
signal eigthRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal eigthRegister: STD_LOGIC_VECTOR (127 downto 0);

signal ninethRoundKey: STD_LOGIC_VECTOR (127 downto 0);
signal ninethRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal ninethRegister: STD_LOGIC_VECTOR (127 downto 0);

signal tenthRoundKey: STD_LOGIC_VECTOR (127 downto 0);
signal tenthRoundOutput: STD_LOGIC_VECTOR (127 downto 0);
signal tenthRegister: STD_LOGIC_VECTOR (127 downto 0);

signal firstDataReceived : STD_LOGIC;
signal secondDataReceived : STD_LOGIC;
signal thirdDataReceived : STD_LOGIC;
signal fourthDataReceived : STD_LOGIC;
signal fifthDataReceived : STD_LOGIC;
signal sixthDataReceived : STD_LOGIC;
signal seventhDataReceived : STD_LOGIC;
signal eigthDataReceived : STD_LOGIC;
signal ninethDataReceived : STD_LOGIC;
signal tenthDataReceived : STD_LOGIC;

begin
-- Ça se peut que ça chie icitte
First_Round_Key : AES_key_schedule port map (input => Key, output => firstRoundKey);
First_Round : AES_ROUND port map (inputText => Data_INPUT, roundKey => firstRoundKey, outputText => firstRoundOutput);
First_Register : Register128Bits port map (RESET => RESET, CLK => CLK, Data_IN => firstRoundOutput, EN => Data_ready_in, Data_OUT => firstRegister);
First_Data_Received : BitRegister port map (RESET => RESET, CLK => CLK, D => Data_ready_in, EN => Data_ready_in, Q => firstDataReceived);

Second_Round_Key : AES_key_schedule port map (input => firstRoundKey, output => secondRoundKey);
Second_Round : AES_ROUND port map (inputText => firstRegister, roundKey => secondRoundKey, outputText => secondRoundOutput);
Second_Register : Register128Bits port map (RESET => RESET, CLK => CLK, Data_IN => secondRoundOutput, EN => Data_ready_in, Data_OUT => secondRegister);
Second_Data_Received : BitRegister port map (RESET => RESET, CLK => CLK, D => firstDataReceived, EN => Data_ready_in, Q => secondDataReceived);

Third_Round_Key : AES_key_schedule port map (input => secondRoundKey, output => thirdRoundKey);
Third_Round : AES_ROUND port map (inputText => secondRegister, roundKey => thirdRoundKey, outputText => thirdRoundOutput);
Third_Register : Register128Bits port map (RESET => RESET, CLK => CLK, Data_IN => thirdRoundOutput, EN => Data_ready_in, Data_OUT => thirdRegister);
Third_Data_Received : BitRegister port map (RESET => RESET, CLK => CLK, D => secondDataReceived, EN => Data_ready_in, Q => thirdDataReceived);

Fourth_Round_Key : AES_key_schedule port map (input => thirdRoundKey, output => fourthRoundKey);
Fourth_Round : AES_ROUND port map (inputText => thirdRegister, roundKey => fourthRoundKey, outputText => fourthRoundOutput);
Fourth_Register : Register128Bits port map (RESET => RESET, CLK => CLK, Data_IN => fourthRoundOutput, EN => Data_ready_in, Data_OUT => fourthRegister);
Fourth_Data_Received : BitRegister port map (RESET => RESET, CLK => CLK, D => thirdDataReceived, EN => Data_ready_in, Q => fourthDataReceived);

Fifth_Round_Key : AES_key_schedule port map (input => fourthRoundKey, output => fifthRoundKey);
FifthRound : AES_ROUND port map (inputText => fourthRegister, roundKey => fifthRoundKey, outputText => fifthRoundOutput);
Fifth_Register : Register128Bits port map (RESET => RESET, CLK => CLK, Data_IN => fifthRoundOutput, EN => Data_ready_in, Data_OUT => fifthRegister);
Fifth_Data_Received : BitRegister port map (RESET => RESET, CLK => CLK, D => fourthDataReceived, EN => Data_ready_in, Q => fifthDataReceived);

Sixth_Round_Key : AES_key_schedule port map (input => fifthRoundKey, output => sixthRoundKey);
Sixth_Round : AES_ROUND port map (inputText => fifthRegister, roundKey => sixthRoundKey, outputText => sixthRoundOutput);
Sixth_Register : Register128Bits port map (RESET => RESET, CLK => CLK, Data_IN => sixthRoundOutput, EN => Data_ready_in, Data_OUT => sixthRegister);
Sixth_Data_Received : BitRegister port map (RESET => RESET, CLK => CLK, D => fifthDataReceived, EN => Data_ready_in, Q => sixthDataReceived);

Seventh_Round_Key : AES_key_schedule port map (input => sixthRoundKey, output => seventhRoundKey);
Seventh_Round : AES_ROUND port map (inputText => sixthRegister, roundKey => seventhRoundKey, outputText => seventhRoundOutput);
Seventh_Register : Register128Bits port map (RESET => RESET, CLK => CLK, Data_IN => seventhRoundOutput, EN => Data_ready_in, Data_OUT => seventhRegister);
Seventh_Data_Received : BitRegister port map (RESET => RESET, CLK => CLK, D => sixthDataReceived, EN => Data_ready_in, Q => seventhDataReceived);

Eigth_Round_Key : AES_key_schedule port map (input => seventhRoundKey, output => eigthRoundKey);
Eigth_Round : AES_ROUND port map (inputText => seventhRoundOutput, roundKey => eigthRoundKey, outputText => eigthRoundOutput);
Eigth_Register : Register128Bits port map (RESET => RESET, CLK => CLK, Data_IN => eigthRoundOutput, EN => Data_ready_in, Data_OUT => eigthRegister);
Eigth_Data_Received : BitRegister port map (RESET => RESET, CLK => CLK, D => seventhDataReceived, EN => Data_ready_in, Q => eigthDataReceived);

Nineth_Round_Key : AES_key_schedule port map (input => eigthRoundKey, output => ninethRoundKey);
Nineth_Round : AES_ROUND port map (inputText => eigthRoundOutput, roundKey => ninethRoundKey, outputText => ninethRoundOutput);
Nineth_Register : Register128Bits port map (RESET => RESET, CLK => CLK, Data_IN => ninethRoundOutput, EN => Data_ready_in, Data_OUT => ninethRegister);
Nineth_Data_Received : BitRegister port map (RESET => RESET, CLK => CLK, D => eigthDataReceived, EN => Data_ready_in, Q => ninethDataReceived);

Tenth_Round_Key : AES_key_schedule port map (input => ninethRoundKey, output => tenthRoundKey);
Tenth_Round : AES_ROUND port map (inputText => ninethRoundOutput, roundKey => tenthRoundKey, outputText => tenthRoundOutput);
Tenth_Register : Register128Bits port map (RESET => RESET, CLK => CLK, Data_IN => tenthRoundOutput, EN => Data_ready_in, Data_OUT => Data_OUTPUT);
Tenth_Data_Received : BitRegister port map (RESET => RESET, CLK => CLK, D => ninethDataReceived, EN => Data_ready_in, Q => Data_ready_out);

end Behavioral;
