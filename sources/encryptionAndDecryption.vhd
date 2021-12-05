----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/05/2021 12:42:11 PM
-- Design Name: 
-- Module Name: encryptionAndDecryption - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity encryptionAndDecryption is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (23 downto 0);
           data_out : out STD_LOGIC;
           data_ready_out : out STD_LOGIC);
end encryptionAndDecryption;

architecture Behavioral of encryptionAndDecryption is

component registre_decalage is
    Port ( data_in : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (127 downto 0);
           data_ready_out: out STD_LOGIC;
           CLK : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

component AES_CTR is
    Port ( input : in STD_LOGIC_VECTOR (127 downto 0);
           CLK: in STD_LOGIC;
           RESET : in STD_LOGIC;
           enable:in STD_LOGIC;
           data_ready_in: in STD_LOGIC;
           key : in STD_LOGIC_VECTOR (127 downto 0);
           data_ready_out: out STD_LOGIC;
           output : out STD_LOGIC_VECTOR (127 downto 0));
end component;

component rdc_load_Nbits is
    generic (N : integer := 128);
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           ENABLE : in STD_LOGIC;
           MODE : in STD_LOGIC;
           INPUT : in STD_LOGIC;
           LOAD : in STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out STD_LOGIC);
end component;

-- La clé
signal key: STD_LOGIC_VECTOR (127 downto 0):= x"55555555555555555555555555555555";

-- Signaux pour ralentir l'horloge
signal clk_int : std_logic_vector(7 downto 0) := (others=>'0');
signal clkout  : STD_LOGIC;

-- Signaux pour l'encryption
signal data_out_decalage_red: STD_LOGIC_VECTOR (127 downto 0); -- Contient les 128 derniers pixels
signal data_ready_in_ctr_red: STD_LOGIC; -- Pour signaler que l'encryption peut commencer
signal encryption_data_out : STD_LOGIC_VECTOR (127 downto 0); -- 128 pixels cryptés
signal encryptionFinished : STD_LOGIC; -- Pour signaler que la décryption peut commencer

-- Signaux pour la décryption
signal decryption_data_out : STD_LOGIC_VECTOR (127 downto 0);
signal decryptionFinished : STD_LOGIC;

-- Signaux pour le shiftRegister qui nous renvoie nos pixels un à la fois
signal input_res : STD_LOGIC := '1'; -- Valeur bidon

begin

-- On diminue la clock pour qu'elle soit à 1 pendant 128 coups de pixelCLK et à 0 ensuite pour 128 coups et ainsi de suite
Process(Reset, clk)
begin
    if(reset='1') then
        clk_int <= (others=>'0');
    Elsif (clk'event and clk='1') then
        clk_int <= clk_int + '1';
    end if;
end process;
clkout <= clk_int(7);

-- Registre à décalage contenant les 128 derniers pixels
reg_decalage_red: registre_decalage port map (data_in => data_in(23),
                                              data_out => data_out_decalage_red,
                                              data_ready_out =>data_ready_in_ctr_red,
                                              CLK => CLK, 
                                              enable => enable,
                                              reset => reset);

-- AES_CTR pour encrypter les 128 derniers pixels
aes_ctr_encryption: aes_ctr port map(input =>data_out_decalage_red,
                          clk=>clkout, 
                          data_ready_in =>data_ready_in_ctr_red, 
                          reset => reset,
                          enable => enable,
                          key =>key, 
                          data_ready_out => encryptionFinished, 
                          output => encryption_data_out);

-- AES_CTR pour décrypter les 128 derniers pixels
aes_ctr_decryption: aes_ctr port map(input => encryption_data_out,
                          clk => clkout, 
                          data_ready_in => encryptionFinished, 
                          reset => reset,
                          enable => enable,
                          key =>key, 
                          data_ready_out =>decryptionFinished, 
                          output => decryption_data_out);
                          
-- Registre prenant les 128 bits et qui nous les sort par la suite un à la fois
registre : rdc_load_Nbits port map(RESET => reset,
                                   CLK => clk,
                                   ENABLE => enable,
                                   MODE => NOT(decryptionFinished), -- Si decryptionFinished == 1, alors on LOAD dans le registre, sinon, on sort 1 à 1 !
                                   INPUT => input_res,
                                   LOAD => decryption_data_out,
                                   OUTPUT => data_out);

-- Output qui nous servira de futur pVDE
data_ready_out <= NOT(decryptionFinished);

end Behavioral;
