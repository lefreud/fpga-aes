library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package MixColumnsPackage is
    type column is array(3 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
    
end package MixColumnsPackage;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- https://en.wikipedia.org/wiki/Rijndael_MixColumns

entity MixColumns is
    Port ( input : in STD_LOGIC_VECTOR(127 downto 0);
           direction : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR(127 downto 0));
end MixColumns;

architecture Behavioral of MixColumns is
    component MixCoumnsSingle is
        Port ( input : in column;
               output : out column);
    end component;
    
    
    type column_block is array(3 downto 0) of column;
    signal input_columns_int : column_block;
    signal output_columns_int : column_block;
begin
    -- column 0
    input_columns_int(0)(0) <= input(7 downto 0);
    input_columns_int(0)(1) <= input(39 downto 32);
    input_columns_int(0)(2) <= input(71 downto 64);
    input_columns_int(0)(3) <= input(103 downto 96);
    
    -- column 1
    input_columns_int(1)(0) <= input(15 downto 8);
    input_columns_int(1)(1) <= input(47 downto 40);
    input_columns_int(1)(2) <= input(79 downto 72);
    input_columns_int(1)(3) <= input(111 downto 104);
    
    -- column 2
    input_columns_int(2)(0) <= input(23 downto 16);
    input_columns_int(2)(1) <= input(55 downto 48);
    input_columns_int(2)(2) <= input(87 downto 80);
    input_columns_int(2)(3) <= input(119 downto 112);
    
    -- column 3
    input_columns_int(3)(0) <= input(31 downto 24);
    input_columns_int(3)(1) <= input(63 downto 56);
    input_columns_int(3)(2) <= input(95 downto 88);
    input_columns_int(3)(3) <= input(127 downto 120);
    
    
    column_singles : for i in 0 to 3 generate
        column_mixer1 : MixCoumnsSingle
            port map (
                input => input_columns_int(i),
                output => output_columns_int(i)
            );
    end generate;

    output <= input_columns_int(0)(0) & input_columns_int(1)(0) & input_columns_int(2)(0) & input_columns_int(3)(0) &
              input_columns_int(0)(1) & input_columns_int(1)(1) & input_columns_int(2)(1) & input_columns_int(3)(1) &
              input_columns_int(0)(2) & input_columns_int(1)(2) & input_columns_int(2)(2) & input_columns_int(3)(2) &
              input_columns_int(0)(3) & input_columns_int(1)(3) & input_columns_int(2)(3) & input_columns_int(3)(3);
    
end Behavioral;
