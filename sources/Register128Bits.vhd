----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2021 10:48:23 AM
-- Design Name: 
-- Module Name: Register128Bits - Behavioral
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

entity Register128Bits is
    Port ( RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Data_IN : in STD_LOGIC_VECTOR (127 downto 0);
           EN : in STD_LOGIC;
           Data_OUT : out STD_LOGIC_VECTOR (127 downto 0));
end Register128Bits;

architecture Behavioral of Register128Bits is

component BitRegister is
    Port ( RESET : in STD_LOGIC;
       CLK : in STD_LOGIC;
       D : in STD_LOGIC;
       EN : in STD_LOGIC;
       Q : out STD_LOGIC);
end component;

begin

BitsRegister : FOR n IN (127) DOWNTO 0 GENERATE
 OneBitRegister : BitRegister
 PORT MAP( RESET => RESET,
           CLK => CLK,
           D => Data_IN(n),
           EN => EN,
           Q => Data_OUT(n));
END GENERATE BitsRegister;

end Behavioral;
