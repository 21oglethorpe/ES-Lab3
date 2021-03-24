  
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
entity regs is
  port (inp : in std_logic;
  CLK         : in std_logic;
  result          : out std_logic);
end regs;
-- architecture
architecture regs0 of regs is
begin
  reg: process(CLK)
  begin
      if (rising_edge(CLK)) then

          result <= inp;
      end if;
  end process;
end regs0;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
entity shiftreg is
port( clk, inp : in std_logic;
    result : out std_logic);
end entity;
architecture shiftreg2b of shiftreg is

component regs
port (inp : in std_logic;
  CLK         : in std_logic;
  result       : out std_logic);
  end component;
signal q1 : std_logic;
begin
  reg1: regs
  port map(CLK=> clk, inp => inp, result => q1);
  reg2: regs
  port map(CLK => clk, inp => q1, result => result);
end shiftreg2b;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity debounce is
port(clk, btn : in std_logic;
   dbnc : out std_logic := '0');
   end debounce;
architecture struct of debounce is
component shiftreg
port( clk, inp : in std_logic;
    result : out std_logic);
    end component;
    signal output_shift : std_logic;
    signal counter : std_logic_vector(23 downto 0);
begin
reg0: shiftreg
port map(CLK => clk, inp => btn, result => output_shift);
process(clk)
begin
if rising_edge(clk) then
      if (output_shift = '1') then
              counter <= std_logic_vector(unsigned(counter) + 1);
              if (unsigned(counter) > 2499999) then
                  counter <= (others => '0');
                  dbnc <= '1';
              end if;
      else
      counter <= (others => '0');
      dbnc <= '0';
      end if;
end if;
end process;
end struct;