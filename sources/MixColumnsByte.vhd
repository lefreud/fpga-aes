----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 11:35:25 AM
-- Design Name: 
-- Module Name: MixColumnsByte - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- https://en.wikipedia.org/wiki/Rijndael_MixColumns

entity MixColumnsByte is
    Port ( input : in STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (7 downto 0));
end MixColumnsByte;

architecture Behavioral of MixColumnsByte is
    constant GALOIS_FIELD_CONSTANT  : STD_LOGIC_VECTOR(7 downto 0) := x"1B";
begin
    
    output(7 downto 0) <= (input(6 downto 0) & '0') when input(7) = '0' else
                          ((input(6 downto 0) & '0') xor GALOIS_FIELD_CONSTANT);

end Behavioral;
