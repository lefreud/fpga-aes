----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2021 10:53:14 AM
-- Design Name: 
-- Module Name: registre_decalage - Behavioral
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
library work;
use IEEE.STD_LOGIC_unsigned.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registre_decalage is
    generic (reg_width:integer:=128);
    Port ( data_in : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (127 downto 0);
           data_ready_out: out STD_LOGIC;
           CLK : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
end registre_decalage;

architecture Behavioral of registre_decalage is
signal data: STD_LOGIC_VECTOR (127 downto 0);

signal counter: STD_LOGIC_VECTOR (6 downto 0):="0000000";
begin

inst: for i in 0 to (reg_width-1) generate
    inst0: if i = 0 generate
        reg0: entity work.registre_1bit port map (input => data_in, output =>data(127), clk=> clk, reset=>reset, enable=>enable);
    end generate;
    insti: if ((i > 0) and (i < reg_width)) generate
        regi: entity work.registre_1bit port map (input => data(127-(i-1)), output =>data(127-i), clk=> clk, reset=>reset, enable=>enable);
    end generate;
end generate;

data_out <= data;

process(clk)
begin
    if(clk='1' and clk'event) then
        if(counter = 127) then
            data_ready_out <= '1';
        else
            data_ready_out <= '0';
        end if;
        counter <= counter + 1;
    end if;
end process;
end Behavioral;
