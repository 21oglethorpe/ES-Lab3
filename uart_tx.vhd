----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 11:37:06 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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
use ieee.numeric_std.all;

entity uart_tx is
port (
clk , en , send , rst : in std_logic ;
char : in std_logic_vector (7 downto 0) ;
ready , tx : out std_logic
) ;
end uart_tx ;

architecture Behavioral of uart_tx is

type state_type is (idle, start, data);
signal curr : state_type := idle;
    signal count : std_logic_vector(2 downto 0) := (others => '0');
    signal inshift : std_logic_vector(3 downto 0) := (others => '0');
signal maj: std_logic;
signal datareg: std_logic_vector(7 downto 0):= (others => '0');
begin
 
 process(clk) begin
   if rising_edge(clk) then

       -- resets the state machine and its outputs
       if rst = '1' then

           datareg <= (others => '0');
           curr <= idle;
       -- usual operation
       -- usual operation
        elsif en = '1' then
            case curr is

                when idle =>
                    ready <= '1';
                    if send = '1' then
                        curr <= start;
                    end if;

                when start =>
                    datareg <= char;
                    count <= (others => '0');
                    ready <= '0';
                    curr <= data;

                when data =>
                    if unsigned(count) < 7 then
                        tx <= datareg(0);
                        datareg <=  datareg(7 downto 1) & '0';
                        count <= std_logic_vector(unsigned(count) + 1);

                   
                    else
                        curr <= idle;
                    end if;

                when others =>
                    curr <= idle;

            end case;
        end if;

   end if;
   end process;

end Behavioral;
