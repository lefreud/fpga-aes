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
           clk_uart: in STD_LOGIC;
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
           RESET : in STD_LOGIC;
           enable:in STD_LOGIC;
           data_ready_in: in STD_LOGIC;
           key : in STD_LOGIC_VECTOR (127 downto 0);
           data_ready_out: out STD_LOGIC;
           output : out STD_LOGIC_VECTOR (127 downto 0));
end component;

component sync_bram is
    port (read_clk, write_clk, write_enable : in std_logic;
          addr_write, addr_read : in std_logic_vector(13 downto 0); -- 11250 blocks so 14 bits for the address
          write_data : in std_logic_vector(127 downto 0); -- Blocks of 128 bits
          read_data : out std_logic_vector(127 downto 0)); -- Blocks of 128 bits
end component; 

component tx_slave_fsm is
    Port ( clk_uart : in STD_LOGIC;
           start : in STD_LOGIC;
           bram_read_data: in STD_LOGIC_VECTOR (127 downto 0);
           reset : in STD_LOGIC;
           adresse_read_bram: out STD_LOGIC_VECTOR (13 downto 0);
           tx_uart : out STD_LOGIC;
           termine: out STD_LOGIC);
end component;

component compteur_stocker is
    Port ( clk : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (13 downto 0);
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

signal key: STD_LOGIC_VECTOR (127 downto 0):= x"55555555555555555555555555555555";

signal enable_decalage: STD_LOGIC;
signal reset_decalage: STD_LOGIC;
signal data_out_decalage_red: STD_LOGIC_VECTOR (127 downto 0);
signal data_ready_in_ctr_red: STD_LOGIC;
signal data_ready_out_ctr_red: STD_LOGIC;
signal data_encrypte_red: STD_LOGIC_VECTOR (127 downto 0);
signal ctr_enable: STD_LOGIC:='1';

type type_etat is (attente, stocker, envoyer);
signal etat: type_etat:= attente;

signal count_stocker: STD_LOGIC_VECTOR (13 downto 0);
signal reset_counter: STD_LOGIC;

signal bram_read_data:STD_LOGIC_VECTOR (127 downto 0);

signal slave_start: STD_LOGIC;
signal slave_ended: STD_LOGIC;
signal slave_reset: STD_LOGIC;
signal adresse_read: STD_LOGIC_VECTOR (13 downto 0):= (others => '0');

begin
reg_decalage_red: registre_decalage port map (data_in => data_in(23),
                                              data_out => data_out_decalage_red,
                                              data_ready_out =>data_ready_in_ctr_red,
                                              CLK => CLK, 
                                              enable => enable_decalage,
                                              reset => reset_decalage);
                                          
aes_red: aes_ctr port map(input =>data_out_decalage_red,
                          clk=>clk, 
                          data_ready_in =>data_ready_in_ctr_red, 
                          reset => reset,
                          enable => ctr_enable,
                          key =>key, 
                          data_ready_out =>data_ready_out_ctr_red, 
                          output =>data_encrypte_red);
                          
                          
bram: sync_bram port map( read_clk => clk_uart,
                          write_clk => clk, 
                          write_enable => data_ready_out_ctr_red,
                          addr_write => count_stocker, 
                          addr_read => adresse_read,
                          write_data => data_encrypte_red,
                          read_data=> bram_read_data);
                          
fsm_slave: tx_slave_fsm port map (  clk_uart => clk_uart,
                                    start => slave_start,
                                    bram_read_data => bram_read_data,
                                    reset => slave_reset,
                                    adresse_read_bram => adresse_read,
                                    tx_uart => data_uart,
                                    termine=> slave_ended);
                                    
compteur: compteur_stocker port map (clk => clk,
                                     count => count_stocker,
                                     enable =>data_ready_out_ctr_red,
                                     reset =>reset_counter);
process(CLK, reset)
begin
if(reset = '1') then
    etat <= attente;
elsif(clk = '1' and clk'event) then
    case etat is
        when attente =>
        --desactiver l'encryption
            ctr_enable <= '0';
        --desactiver le slave
            slave_start <= '0';
        --desactiver registre à décalage
            enable_decalage <= '0';
            reset_decalage <= '1';
        --remettre à zéro le compteur de blocs stocké
            reset_counter <= '1';
        --si la switch enable est activé, on commence
            if(enable = '1')then
                etat <= stocker;
            end if;
            
        when stocker =>
        --activer l'encryption
            ctr_enable <= '1';
        --activer le compteur
            reset_counter <= '0';
        --activer le registre à décalage
            enable_decalage <= '1';
            reset_decalage <= '0';
        --lorsqu'on a stocké 11250 blocs de 128 bits, on a fini
            if(count_stocker = (11250-1)) then
                etat <= envoyer;
            end if;
            
        when envoyer =>
        --desactiver l'encryption
            ctr_enable <= '0';
        --activer le slave
            slave_start <= '1';
        --desactiver le registre à décalage
            enable_decalage <= '0';
            reset_decalage <= '1';
        --lorsque le slave a fini
            if(slave_ended = '1') then
                etat <= attente;
            end if;
            
        when others =>
            etat <= attente;
    end case;
end if;
end process;

end Behavioral;

