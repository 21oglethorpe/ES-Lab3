
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity uart_tx is
port (
clk , en , send , rst : in std_logic ;
char : in std_logic_vector (7 downto 0) ;
ready, tx : out std_logic) ;
end uart_tx ;

architecture Behavioral of uart_tx is

type state_type is (idle, start, data, stop);
signal curr : state_type := idle;
signal count : std_logic_vector(2 downto 0) := (others => '0');
signal datareg: std_logic_vector(7 downto 0):= (others => '0');
begin

 process(clk, send, en) begin
   if rising_edge(clk) then
       -- resets the state machine and its outputs
       if rst = '1' then

           datareg <= (others => '0');
           curr <= idle;
       -- usual operation
        else
            case curr is

                when idle =>
                    ready <= '1';
                    if send = '1' AND en = '1' then
                        curr <= start;
                        datareg <= char;
                    ready <= '0';
                    end if;

                when start =>
                    if en = '1' then
                    tx <= datareg(0);
                    datareg <= '0' & datareg(7 downto 1);

                    count <= (others => '0');
                    curr <= data;
                    end if;
                when data =>
                    if en = '1' then
                     if unsigned(count) <6 then
                     tx <= datareg(0);
                     datareg <= '0' & datareg(7 downto 1);
                     count <= std_logic_vector(unsigned(count) + 1);
                    elsif unsigned(count) =6 then
                     tx <= datareg(0);
                     datareg <= '0' & datareg(7 downto 1);
                     curr <= stop;
                     else
                     curr <= stop;
                     end if;
                     end if;
                when stop =>
                     curr <= idle;
                when others =>
                    
                     curr <= idle;

            end case;
        end if;
        end if;
   end process;

end Behavioral;
