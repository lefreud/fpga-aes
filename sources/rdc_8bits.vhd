----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.10.2021 14:21:27
-- Design Name: 
-- Module Name: Reg_8bits - Behavioral
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

library Logic_com;
use Logic_com.ALL;
library work;
use work.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reg_8bits is
generic (N :integer:=128);
    Port ( reset : in STD_LOGIC;
           datain : in STD_LOGIC;
           dataout : out std_logic_vector(N-1 downto 0);
           clk : in STD_LOGIC;
           enable : in STD_LOGIC);
end Reg_8bits;

architecture Behavioral of Reg_8bits is
--signal sin: std_logic_vector(N-1 downto 0) := (others => '0');
signal sout: std_logic_vector(N-1 downto 0) := (others => '0');


begin


reg_N : for i in 0 to N-1 generate
 reg_1: if i = 0 generate
    reg: entity registre_1 
     port map(rst => reset, en=> enable, clk=>clk, d=> datain, q=>sout(0));
 end generate reg_1;
 reg_autre: if i>0 generate
    reg_i: entity registre_1
    port map(rst => reset, en=> enable, clk=>clk, d=> sout(i-1), q=>sout(i));
 end generate reg_autre;
 end generate;


dataout <= sout;

end Behavioral;
