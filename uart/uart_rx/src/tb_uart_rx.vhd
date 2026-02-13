library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_uart_rx is
generic (
c_clkfreq		: integer := 100_000_000;
c_baudrate		: integer := 115200
);
end tb_uart_rx;

architecture Behavioral of tb_uart_rx is

signal clk             : std_logic := '0';
signal rx_i            : std_logic := '1';
signal data_o          : std_logic_vector(7 downto 0);
signal rx_done_tick_o  : std_logic;

constant c_clkperiod : time := 10 ns;
constant c_baud11520 : time := 8.68 us;
constant c_hex43 : std_logic_vector(9 downto 0) := '1' & x"43" & '0';
constant c_hexA5 : std_logic_vector(9 downto 0) := '1' & x"A5" & '0';           

begin

DUT : entity work.uart_rx
generic map(
    c_clkfreq   => c_clkfreq,
    c_baudrate  => c_baudrate
)
port map(
    clk             => clk,
    rx_i            => rx_i,
    data_o          => data_o,
    rx_done_tick_o  => rx_done_tick_o
);


P_CLKGEN : process begin

clk	<= '0';
wait for c_clkperiod/2;
clk	<= '1';
wait for c_clkperiod/2;

end process P_CLKGEN;

P_STIMULI : process begin

wait for 1 us;

for i in 0 to 9 loop 
    rx_i <= c_hex43(i);
    wait for c_baud11520;
end loop;

wait for 10 us;

for i in 0 to 9 loop 
    rx_i <= c_hexA5(i);
    wait for c_baud11520;
end loop;

wait for 20 us;

assert false
report "SIM DONE"
severity failure;

end process P_STIMULI;


end Behavioral;
