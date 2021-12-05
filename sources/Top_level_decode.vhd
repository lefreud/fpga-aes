----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2021 12:50:06 AM
-- Design Name: 
-- Module Name: Top_level_decode - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity Top_level_decode is
Port ( clk : in STD_LOGIC;
       --clk_uart: in STD_LOGIC;
       reset : in STD_LOGIC;
       rx_uart : in STD_LOGIC;
       pixel_bit: out std_logic;
       -- ready_out: out std_logic;
       state_debug_0 : out std_logic;
       state_debug_1 : out std_logic;
       state_debug_2 : out std_logic;
       state_debug_3 : out std_logic;
       
       --data_out : out std_logic_vector(23 downto 0);
       pVDE: out STD_LOGIC);
end Top_level_decode;

architecture Behavioral of Top_level_decode is

component sync_bram is
    port (read_clk, write_clk, write_enable : in std_logic;
          addr_write, addr_read : in std_logic_vector(13 downto 0); -- 11250 blocks so 14 bits for the address
          write_data : in std_logic_vector(127 downto 0); -- Blocks of 128 bits
          read_data : out std_logic_vector(127 downto 0)); -- Blocks of 128 bits
end component;


component rx_slave_fsm is
 Port (   clk_uart : in STD_LOGIC;
          bram_write_data: out STD_LOGIC_VECTOR (127 downto 0);
          reset : in STD_LOGIC;
          adresse_write_bram: out STD_LOGIC_VECTOR (13 downto 0);
          data_rdy, write_enable_bram: out STD_LOGIC;
          rx_uart:in STD_LOGIC);
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

component compteur_stocker is
    Port ( clk : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (13 downto 0);
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
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


type type_etat is (attente,recevoir, decoder, envoi, fin);

signal etat: type_etat:= attente;

signal reset_uart: std_logic;
signal reset_ctr : std_logic;
signal enable_ctr: std_logic := '1';
signal data_rdy_in_ctr: std_logic;
signal data_rdy_out_ctr: std_logic;
signal ctr_input: STD_LOGIC_VECTOR (127 downto 0);
signal ctr_output: STD_LOGIC_VECTOR (127 downto 0);

signal reset_res: std_logic;
signal mode_res: std_logic;
signal enable_res: std_logic :='1';
signal input_res: std_logic;

signal compte : integer := 0;

signal fsm_finished: std_logic;
signal uart_out : std_logic_vector(127 downto 0);
signal uart_data_ready : std_logic;
signal rx_addr_write : std_logic_vector(13 downto 0);
signal rx_addr_read : std_logic_vector(13 downto 0):= "00000000000000";
signal rx_write_enable : std_logic;
signal uart_rx_write_data : STD_LOGIC_VECTOR (127 downto 0);
signal bram_read_data : STD_LOGIC_VECTOR (127 downto 0);
signal key: STD_LOGIC_VECTOR (127 downto 0):= x"55555555555555555555555555555555";

begin

-- rx_fsm : rx_slave_fsm port map ( clk_uart => clk,
--                                 bram_read_data => 

bram: sync_bram port map( read_clk => clk,
                          write_clk => clk, 
                          write_enable => rx_write_enable,
                          addr_write => rx_addr_write, 
                          addr_read => rx_addr_read,
                          write_data => uart_rx_write_data,
                          read_data=> bram_read_data);
                          
fsm : rx_slave_fsm port map(clk_uart =>clk,
                            reset => reset_uart,
                            rx_uart => rx_uart,
                            adresse_write_bram =>  rx_addr_write,
                            write_enable_bram=>rx_write_enable,
                            bram_write_data => uart_rx_write_data,
                            data_rdy => fsm_finished);

aes : aes_ctr port map (input => ctr_input,
                           CLK => clk,
                           RESET => reset_ctr,
                           enable => enable_ctr,
                           data_ready_in=>data_rdy_in_ctr,
                           key => key,
                           data_ready_out=> data_rdy_out_ctr,
                           output => ctr_output);
                           
--compteur: compteur_stocker port map(clk => clk,
--                                    count => count,
--                                    enable => enable_count,
--                                    reset => reset_count);


registre : rdc_load_Nbits port map(RESET => reset_res,
           CLK => clk,
           ENABLE => enable_res,
           MODE => mode_res,
           INPUT => input_res,
           LOAD => ctr_output,
           OUTPUT => pixel_bit);


process(CLK, reset)
begin
if(reset = '1') then
    etat <= attente;
elsif(clk = '1' and clk'event) then
    case etat is
        when attente =>
                reset_uart <= '1';
                reset_ctr <= '1';
                enable_ctr <= '0';
                data_rdy_in_ctr <= '0';
                
                reset_res <= '1';
                mode_res <= '0';
                enable_res <= '0';
                    
            reset_ctr <= '1';
            
            reset_uart <= '1';
            
            --reset_count <= '1';
            reset_res <= '1';
            
            rx_addr_read <= (others => '0');
            compte <= 0;
            data_rdy_in_ctr <= '0';
            pvde <='0';
            etat <= recevoir;
            state_debug_0 <= '1';
            state_debug_1 <= '0';
            state_debug_2 <= '0';
            state_debug_3 <= '0';
            
            
        when recevoir =>
            pvde <='0';
            reset_uart <= '0';
           -- reset_count <= '1';
            reset_ctr <= '1';
            if (fsm_finished = '1') then
                etat <= decoder; 
            else 
                etat <= recevoir;
            end if;
            state_debug_0 <= '0';
            state_debug_1 <= '1';
            state_debug_2 <= '0';
            state_debug_3 <= '0';
        
        when decoder =>
            pvde <='0';
            reset_uart <= '1';
            reset_ctr <= '0';
            reset_res <= '0';
            enable_res <='0';
            enable_ctr <='1';
            mode_res <= '0';
            data_rdy_in_ctr <= '1';
            if( rx_addr_read = 11250) then
                etat <= attente;
            elsif(data_rdy_out_ctr = '1') then 
                etat <= envoi;
                data_rdy_in_ctr <= '0';
                rx_addr_read <= rx_addr_read +1 ;
                enable_ctr <= '0';
            else
                etat <= decoder;
            end if;
            
            state_debug_0 <= '0';
            state_debug_1 <= '0';
            state_debug_2 <= '1';
            state_debug_3 <= '0';
        
        when envoi =>
        -- uart inactif
            reset_uart <= '1';
            
            -- le ctr reste actif mais pas en marche
            enable_ctr <='0';
            reset_ctr <= '0';
            --on active le registre 
            reset_res <= '0';
            enable_res <='1';
           
            pvde <='1';
            --envoi bit par bit 
            mode_res <= '1';
                    
            reset_uart <= '1';
            
            --reset_count <= '';
            reset_res <= '1';
            if(compte = 127) then
                etat <= decoder;
                compte <= 0;
            else
                etat <= envoi; 
                compte <= compte + 1;
            end if;

            state_debug_0 <= '0';
            state_debug_1 <= '0';
            state_debug_2 <= '0';
            state_debug_3 <= '1';
        when others =>
        etat <= attente;
    
    
    end case;
end if;

end process;

end Behavioral;
