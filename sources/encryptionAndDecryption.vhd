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
use ieee.std_logic_arith.all;

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
           pVDE : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (23 downto 0);
           data_out : out STD_LOGIC_VECTOR (23 downto 0);
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
    generic (N : integer);
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
signal shift_register_output : STD_LOGIC;
signal output_of_shft_register_counter : unsigned (15 downto 0) := "1111110000000000";
signal mode: STD_LOGIC;

begin

-- On diminue la clock pour qu'elle soit à 1 pendant 128 coups de pixelCLK et à 0 ensuite pour 128 coups et ainsi de suite
--Process(Reset, clk)
--begin
--    if(reset='1') then
--        clk_int <= (others=>'0');
--    Elsif (clk'event and clk='1') then
--        clk_int <= clk_int + '1';
--    end if;
--end process;
--clkout <= clk_int(6);

-- Registre à décalage contenant les 128 derniers pixels
reg_decalage_red: registre_decalage port map (data_in => data_in(23),
                                              data_out => data_out_decalage_red,
                                              data_ready_out =>data_ready_in_ctr_red,
                                              CLK => CLK, 
                                              enable => enable,
                                              reset => reset);

-- AES_CTR pour encrypter les 128 derniers pixels
aes_ctr_encryption: AES_CTR port map(input =>data_out_decalage_red,
                          clk=>clk, 
                          data_ready_in =>data_ready_in_ctr_red, 
                          reset => reset,
                          enable => enable,
                          key =>key, 
                          data_ready_out => encryptionFinished, 
                          output => encryption_data_out);

-- AES_CTR pour décrypter les 128 derniers pixels
aes_ctr_decryption: AES_CTR port map(input => encryption_data_out,
                          clk => clk, 
                          data_ready_in => encryptionFinished, 
                          reset => reset,
                          enable => enable,
                          key =>key, 
                          data_ready_out =>decryptionFinished, 
                          output => decryption_data_out);
                          
-- Registre prenant les 128 bits et qui nous les sort par la suite un à la fois
registre : rdc_load_Nbits generic map (N => 128)
                          port map(RESET => reset,
                                   CLK => clk,
                                   ENABLE => enable,
                                   MODE => mode , -- Si decryptionFinished == 1, alors on LOAD dans le registre, sinon, on sort 1 à 1 !
                                   INPUT => input_res,
                                   LOAD => decryption_data_out,
                                   OUTPUT => shift_register_output);

mode <= NOT decryptionFinished;
data_out <= "100000000000000000000000" when shift_register_output = '1' else
            "000000000000000000000000" when shift_register_output = '0' else
            "000000000000000000000000";

-- Output qui nous servira de futur pVDE
data_ready_out <= '1' when output_of_shft_register_counter < 128 else '0';

process(clk) begin
if(clk'event and clk = '1') THEN
    if(decryptionFinished = '0') then
        output_of_shft_register_counter <= output_of_shft_register_counter + 1;
    elsif (decryptionFinished = '1') then
        output_of_shft_register_counter <= (others=>'0');
    end if;
end if;
end process;

end Behavioral;
