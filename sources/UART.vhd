----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2021 23:00:40
-- Design Name: 
-- Module Name: UART - Behavioral
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
library logic_com;
use logic_com.ALL;
library work;
use work.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is
    Port ( RX : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (1277 downto 0);
           RESET : in STD_LOGIC;
           data_rdy : out STD_LOGIC;
           clk : in STD_LOGIC);
end UART;

architecture Behavioral of UART is
type etat is (waiting, bit_verification, transmission, end_bit, end_all);
signal etat_present : etat;
signal bitvalide: std_logic;
signal data_middle: std_logic;

signal data_buffer: std_logic_vector(127 downto 0);

--signal enable_reg_dec: std_logic;
signal enable_comp_0: std_logic := '1';
signal out_comp_0: std_logic_vector(15 downto 0);

signal enable_comp_1: std_logic:= '1';
signal out_comp_1: std_logic_vector(15 downto 0);

signal reset_comp_0: std_logic := '1';
signal reset_comp_1: std_logic := '1';

signal compte : integer := 0;
--signal A_0: STD_LOGIC_VECTOR (15 downto 0);
--signal B_0: STD_LOGIC_VECTOR (15 downto 0);
signal cmp_0: std_logic;

--signal A_1: STD_LOGIC_VECTOR (15 downto 0);
--signal B_1: STD_LOGIC_VECTOR (15 downto 0);
signal cmp_1: std_logic;

--signal A_2: STD_LOGIC_VECTOR (15 downto 0);
--signal B_2: STD_LOGIC_VECTOR (15 downto 0);
signal cmp_2: std_logic;

--signal data_rdy: STD_LOGIC;
signal enable_rdc: STD_LOGIC;

signal NBRE_COUP_HORLOGE: STD_LOGIC_VECTOR (15 downto 0):=      "0000010000111101";
signal HALF_NBRE_COUP_HORLOGE: STD_LOGIC_VECTOR (15 downto 0):= "0000001000011110";
signal Nbre_bits: STD_LOGIC_VECTOR (15 downto 0):=              "0010010000000110";

begin
comparateur_0: entity cmp_16bits
    port map(a => out_comp_0, b => NBRE_COUP_HORLOGE, cmp => cmp_0);

--comparateur_1: entity cmp_16bits
--    port map(a => out_comp_0, b => HALF_NBRE_COUP_HORLOGE,cmp => cmp_1);

comparateur_2: entity cmp_16bits
    port map(a => out_comp_1, b => Nbre_bits, cmp => cmp_2);
    
compteur_0: entity compteur_16bits
    port map(reset => reset_comp_0, clk => clk, enable =>enable_comp_0, output =>out_comp_0 );

--compteur_1: entity compteur_16bits
--    port map(reset => reset_comp_1, clk => clk, enable =>enable_comp_1, output =>out_comp_1 );
    
registre_dec: entity reg_8bits
    generic map(N =>128)
    port map(reset =>reset, datain => rx, clk => clk, enable =>enable_rdc, dataout => data_buffer);
process(clk, reset, rx)
begin
    if(reset = '1') then
        etat_present <= waiting;
       
    elsif (rising_edge(clk)) then
        case(etat_present) is
            when waiting =>
                data_rdy <= '0';
                enable_rdc <= '0';
                if(rx = '1') then
                    etat_present <= waiting;
                    --bitvalide <= '1';
                elsif(rx = '0') then
                    etat_present <= bit_verification;
                end if;
                
            when bit_verification =>
                data_rdy <= '0';
                --a_0 <= out_comp_0;
                reset_comp_0 <= '0';
                if(rx = '1') then 
                    --bitvalide <= '0';
                    etat_present <= waiting;
                elsif(rx = '0') then
                    if(cmp_1 = '0') then    
                        etat_present <= bit_verification;
                    elsif(cmp_1 = '1') then
                        reset_comp_0 <= '1';
                        etat_present <= transmission;
                    end if;
                end if; 
      
            when transmission =>
                data_rdy <= '0';
                enable_rdc <= '0';
                reset_comp_0 <= '0';
                --reset_comp_1 <= '0';
                if(compte = 8) then
                    etat_present <= end_bit;
                    data_rdy <= '1';
                    compte <= 0;   
                else
                    etat_present <= transmission;
                    data_rdy <= '0';
                    if( cmp_0 = '1') then
                        enable_rdc <= '1';
                        reset_comp_0 <= '1';
                        compte <= compte +1;
                    elsif(cmp_0 = '0') then
                        enable_rdc <= '0';
                    end if;
                    --reset_comp_0 <= '1';
                   -- enable_rdc <= '1';
                end if;
                
                
                
                
                
                
--            when last =>
--                enable_rdc <= '0';
--                reset_comp_0 <= '0';
--                --reset_comp_1 <= '0';
--                if(cmp_1 = '0') then    
--                    etat_present <= last;
--                elsif(cmp_1 = '1') then
--                    reset_comp_0 <= '1';
--                    --enable_rdc <= '1';
--                    etat_present <= end_bit;
--                end if;
                
            when end_bit =>
                data_rdy <= '0';
                enable_rdc <= '0';
                if(rx = '0') then 
                    etat_present <= end_bit;
                elsif(rx = '1') then
                etat_present <= end_all;
                end if; 
                
            when end_all =>
                data_rdy <= '1';
                enable_rdc <= '0';
                data_out <= data_buffer;
                etat_present <= waiting;
        end case;
    end if;
 end process;

end Behavioral;
