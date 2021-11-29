----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2021 01:09:50 PM
-- Design Name: 
-- Module Name: sync_bram_tb - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sync_bram_tb is
--  Port ( );
end sync_bram_tb;

architecture Behavioral of sync_bram_tb is

component sync_bram is
    port (read_clk, write_clk, enable, write_enable : in std_logic;
          addr_write, addr_read : in std_logic_vector(13 downto 0); -- 11250 blocks so 14 bits for the address
          write_data : in std_logic_vector(127 downto 0); -- Blocks of 128 bits
          read_data : out std_logic_vector(127 downto 0)); -- Blocks of 128 bits
end component; 

signal read_clk, write_clk, enable, write_enable : std_logic := '0';
signal addr_write, addr_read : std_logic_VECTOR(13 downto 0) := (others => '0');
signal write_data, read_data : std_logic_VECTOR(127 downto 0) := (others => '0');

begin

BRAM : sync_bram port map 
                        (read_clk => read_clk,
                         write_clk => write_clk,
                         enable => enable,
                         write_enable => write_enable,
                         addr_write => addr_write, 
                         addr_read => addr_read,
                         write_data => write_data,
                         read_data => read_data);

process
begin
    wait for 2 ns;
    for i in 0 to 10000 loop
        enable <= '1';  --Enable RAM always.
        write_enable <= '1';
        wait for 2 ns;
        addr_write <= addr_write + "1";
        write_data <= write_data + "1";
    end loop;
    write_enable <= '0';
    wait;
end process;

process
begin
wait for 10 ns;
for i in 0 to 10000 loop
    enable <= '1';  --Enable RAM always.
    wait for 2 ns;
    addr_read <= addr_read + "1";
end loop;
end process;

process
begin
    read_clk <= '0';
    write_clk <= '1';
    wait for 1 ns;  -- "ON" time.
    read_clk <= '1';
    write_clk <= '0';
    wait for 1 ns;  -- "OFF" time.
end process;

end Behavioral;
