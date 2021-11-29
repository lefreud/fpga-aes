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
use IEEE.STD_LOGIC_unsigned.ALL;

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
           enable : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (23 downto 0);
           passthrough : in STD_LOGIC;
           data_uart : out STD_LOGIC);
end top_level_encryption;


architecture Behavioral of top_level_encryption is

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
           data_ready_in: in STD_LOGIC;
           key : in STD_LOGIC_VECTOR (127 downto 0);
           data_ready_out: out STD_LOGIC;
           output : out STD_LOGIC_VECTOR (127 downto 0));
end component;

signal key: STD_LOGIC_VECTOR (127 downto 0):= x"55555555555555555555555555555555";

signal enable_decalage: STD_LOGIC;
signal reset_decalage: STD_LOGIC;
signal data_out_decalage_red: STD_LOGIC_VECTOR (127 downto 0);
signal data_ready_in_ctr_red: STD_LOGIC;
signal data_ready_out_ctr_red: STD_LOGIC;
signal data_encrypte_red: STD_LOGIC_VECTOR (127 downto 0);

type type_etat is (attente, stocker, envoyer);
signal etat: type_etat:= attente;

signal counter_stocker: STD_LOGIC_VECTOR (20 downto 0):= (others => '0');
signal counter_envoie: STD_LOGIC_VECTOR (20 downto 0):= (others => '0');

begin
reg_decalage_red: registre_decalage port map (data_in => data_in(23),
                                              data_out => data_out_decalage_red,
                                              data_ready_out =>data_ready_in_ctr_red,
                                              CLK => CLK, 
                                              enable => '1',
                                              reset => reset_decalage);
                                          
aes_red: aes_ctr port map(input =>data_out_decalage_red,
                          clk=>clk, 
                          data_ready_in =>data_ready_in_ctr_red, 
                          key =>key, 
                          data_ready_out =>data_ready_out_ctr_red, 
                          output =>data_encrypte_red);
            
process(CLK, reset)
begin
if(reset = '1') then
    etat <= attente;
elsif(clk = '1' and clk'event) then
    case etat is
        when attente =>
            counter_stocker <= (others => '0');
            if(enable = '1')then
                etat <= stocker;
            end if;
        when stocker =>
            enable_decalage <= '1';
            counter_envoie <= (others => '0');
            reset_decalage <= '0';
            if(counter_stocker = (11250-1)) then
                etat <= envoyer;
            end if;
        when envoyer =>
            enable_decalage <= '0';
            reset_decalage <= '1';
            if(counter_envoie = (11250-1)) then
                etat <= attente;
            end if;
        when others =>
            etat <= attente;
    end case;
end if;
end process;

process(clk)
begin
    if(clk='1' and clk'event) then
        if(data_ready_out_ctr_red = '1') then
            counter_stocker <= counter_stocker + 1;
            if(counter_stocker = 11250) then
                counter_stocker <= (others => '0');
            end if;
        end if;
    end if;
end process;


process(clk)
begin
    if(clk='1' and clk'event) then
        counter_envoie <= counter_envoie + 1;
    end if;
end process;
end Behavioral;

