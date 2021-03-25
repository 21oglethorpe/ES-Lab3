----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2021 02:09:45 AM
-- Design Name: 
-- Module Name: sender - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sender is
port (
    clk, en, btn, ready, rst    : in std_logic;
    send             : out std_logic;
    char                : out std_logic_vector (7 downto 0)
);
end sender;

architecture Behavioral of sender is
 type state is (idle, busyA, busyB, busyC);
   signal curr : state := idle;

   -- shift register to read data in
   signal d : std_logic_vector (7 downto 0) := (others => '0');
    constant n: std_logic_vector(2 downto 0) := "110";
   signal i : std_logic_vector (2 downto 0) := (others => '0');
type memory is array (0 to 5) of std_logic_vector(7 downto 0);
constant NETID : memory := (
0 => x"6a",    --j
1 => x"63",    --c
2 => x"32",    --2
3 => x"33",    --3
4 => x"37",    --7
5 => x"36");   --6
begin
process(clk)
begin
if rising_edge(clk) then
    if (en = '1') then
    if(rst ='1') then char <= (others => '0'); send <= '0'; curr <= idle; i <= (others => '0'); 
    else
    case curr is
        when idle =>
            if(ready = '1' AND btn = '1' AND unsigned(i) < unsigned(n)) then
                send <= '1';
                char <= NETID(to_integer(unsigned(i)));
                i <= std_logic_vector(unsigned(i)+1);
                curr <= busyA;
            elsif(ready = '1' AND btn = '1' AND unsigned(i) = unsigned(n))then
                i <= (others => '0');
            end if;
        when busyA =>
            curr <= busyB;
        when busyB =>
            send <= '0';
            curr <= busyC;
        when busyC => 
            if(ready = '1' AND btn = '0') then
                curr <= idle;
            end if;
        when others =>
        curr <= idle;
        end case;
        end if;
end if;
end if;
end process;
end Behavioral;
