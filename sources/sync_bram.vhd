library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_bram is
    port (read_clk, write_clk, write_enable : in std_logic;
          addr_write, addr_read : in std_logic_vector(13 downto 0); -- 11250 blocks so 14 bits for the address
          write_data : in std_logic_vector(127 downto 0); -- Blocks of 128 bits
          read_data : out std_logic_vector(127 downto 0)); -- Blocks of 128 bits
end sync_bram; 

architecture Behavioral of sync_bram is

type ram_type is array (0 to 2**14 - 1) of std_logic_vector(127 downto 0);
signal ram : ram_type; 

begin

Process(write_clk, enable, write_enable, addr_write, write_data)
begin
    if write_clk'event AND write_clk = '1' then
        if write_enable = '1' then
            ram(to_integer(unsigned(addr_write))) <= write_data;
        end if;
    end if;
end Process;

Process(read_clk)
begin
    if read_clk'event AND read_clk = '1' then
        read_data <= ram(to_integer(unsigned(addr_read)));
    end if;
end Process;

end Behavioral;
