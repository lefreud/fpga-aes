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
    Port ( data_in : in STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (127 downto 0);
           data_ready_out: out STD_LOGIC;
           CLK : in STD_LOGIC;
           enable : in STD_LOGIC;
           reset : in STD_LOGIC);
end registre_decalage;

architecture Behavioral of registre_decalage is
signal data0: STD_LOGIC_VECTOR (7 downto 0);
signal data1: STD_LOGIC_VECTOR (7 downto 0);
signal data2: STD_LOGIC_VECTOR (7 downto 0);
signal data3: STD_LOGIC_VECTOR (7 downto 0);
signal data4: STD_LOGIC_VECTOR (7 downto 0);
signal data5: STD_LOGIC_VECTOR (7 downto 0);
signal data6: STD_LOGIC_VECTOR (7 downto 0);
signal data7: STD_LOGIC_VECTOR (7 downto 0);
signal data8: STD_LOGIC_VECTOR (7 downto 0);
signal data9: STD_LOGIC_VECTOR (7 downto 0);
signal data10: STD_LOGIC_VECTOR (7 downto 0);
signal data11: STD_LOGIC_VECTOR (7 downto 0);
signal data12: STD_LOGIC_VECTOR (7 downto 0);
signal data13: STD_LOGIC_VECTOR (7 downto 0);
signal data14: STD_LOGIC_VECTOR (7 downto 0);
signal data15: STD_LOGIC_VECTOR (7 downto 0);

signal counter: STD_LOGIC_VECTOR (3 downto 0):="0000";
begin

reg0: entity work.registre_8bits port map (input => data_in, output =>data0, clk=> clk, reset=>reset, enable=>enable);
reg1: entity work.registre_8bits port map (input => data0, output =>data1, clk=> clk, reset=>reset, enable=>enable);
reg2: entity work.registre_8bits port map (input => data1, output =>data2, clk=> clk, reset=>reset, enable=>enable);
reg3: entity work.registre_8bits port map (input => data2, output =>data3, clk=> clk, reset=>reset, enable=>enable);
reg4: entity work.registre_8bits port map (input => data3, output =>data4, clk=> clk, reset=>reset, enable=>enable);
reg5: entity work.registre_8bits port map (input => data4, output =>data5, clk=> clk, reset=>reset, enable=>enable);
reg6: entity work.registre_8bits port map (input => data5, output =>data6, clk=> clk, reset=>reset, enable=>enable);
reg7: entity work.registre_8bits port map (input => data6, output =>data7, clk=> clk, reset=>reset, enable=>enable);
reg8: entity work.registre_8bits port map (input => data7, output =>data8, clk=> clk, reset=>reset, enable=>enable);
reg9: entity work.registre_8bits port map (input => data8, output =>data9, clk=> clk, reset=>reset, enable=>enable);
reg10: entity work.registre_8bits port map (input => data9, output =>data10, clk=> clk, reset=>reset, enable=>enable);
reg11: entity work.registre_8bits port map (input => data10, output =>data11, clk=> clk, reset=>reset, enable=>enable);
reg12: entity work.registre_8bits port map (input => data11, output =>data12, clk=> clk, reset=>reset, enable=>enable);
reg13: entity work.registre_8bits port map (input => data12, output =>data13, clk=> clk, reset=>reset, enable=>enable);
reg14: entity work.registre_8bits port map (input => data13, output =>data14, clk=> clk, reset=>reset, enable=>enable);
reg15: entity work.registre_8bits port map (input => data14, output =>data15, clk=> clk, reset=>reset, enable=>enable);

data_out<= data0 & data1 & data2 & data3 & data4 & data5 & data6 & data7 & data8 & data9 & data10 & data11 & data12 & data13 & data14 & data15;

process(clk)
begin
    if(clk='1' and clk'event) then
        if(counter = 15) then
            data_ready_out <= '1';
        else
            data_ready_out <= '0';
        end if;
        counter <= counter + 1;
    end if;
end process;
end Behavioral;
