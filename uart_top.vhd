----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2021 11:02:25 PM
-- Design Name: 
-- Module Name: uart_top - Behavioral
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

entity uart_top is
port( TXD, clk :in std_logic;
     btn : in std_logic_vector(1 downto 0);
     RXD : out std_logic;
     CTS, RTS : out std_logic);

end uart_top;

architecture Behavioral of uart_top is
component debounce
port (btn : in std_logic;
  clk         : in std_logic;
  dbnc          : out std_logic);
  end component;
component clock_div
port (
  clk : in std_logic;
  div : out std_logic :='0'
);
end component;
component sender
port (
    clk, en, btn, ready, rst    : in std_logic;
    send             : out std_logic;
    char                : out std_logic_vector (7 downto 0)
);
end component;
component uart
port (

    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0)

);
end component;
signal btn_rg : std_logic;
signal enabler : std_logic;
signal rdy : std_logic;
signal rst : std_logic;
signal uart_send : std_logic;
signal send : std_logic;
signal chars: std_logic_vector(7 downto 0);

begin
CTS <= '0';
RTS <= '0';
u1 : debounce
port map (btn => btn(0), clk => clk, dbnc => rst);
u2 : debounce
port map (btn => btn(1), clk => clk, dbnc => btn_rg);
u3 : clock_div
port map(clk => clk, div => enabler);
u4: sender
port map(btn => btn_rg, clk => clk, en => enabler, ready => rdy, rst => rst, char => chars, send => send);
u5 : uart
port map(clk => clk, en => enabler, charSend => chars, rst => rst, rx => TXD, send => send, ready => rdy, tx => RXD);
end Behavioral;
