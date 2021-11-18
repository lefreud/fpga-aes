----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2021 10:30:54 AM
-- Design Name: 
-- Module Name: packages - Behavioral
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

package MixColumnsPackage is
    type column is array(3 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
end package MixColumnsPackage;

