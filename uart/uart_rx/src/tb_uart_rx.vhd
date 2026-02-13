library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_uart_rx is
generic (
c_clkfreq		: integer := 100_000_000; -- System clock frequency (Hz)
c_baudrate		: integer := 115200 -- Serial communication baud rate (bps)
);
end tb_uart_rx;

architecture Behavioral of tb_uart_rx is
-- Testbench signals
signal clk             : std_logic := '0'; -- clock signal
signal rx_i            : std_logic := '1'; -- RX line (idle state is '1')
signal data_o          : std_logic_vector(7 downto 0); -- data output from DUT
signal rx_done_tick_o  : std_logic; -- RX done tick output from DUT

-- Time constants (for the test)
constant c_clkperiod : time := 10 ns; -- 100 MHz clock period
constant c_baud11520 : time := 8.68 us; -- time for one bit at 115200 baud (1/115200 seconds)

-- Example frames: start-bit = '1' + data(8 bit) + stop-bit = '0' (defined for test)
-- Note: here c_hex43 and c_hexA5 are defined as 10-bit vectors (start+8bit+stop)
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

-- Clock generator: produces continuous square wave
P_CLKGEN : process begin

clk	<= '0';
wait for c_clkperiod/2;
clk	<= '1';
wait for c_clkperiod/2;

end process P_CLKGEN;

-- Stimulus: write example data frames to the RX line
P_STIMULI : process begin

wait for 1 us; -- initial wait before starting stimuli

-- first frame: send bits of c_hex43 sequentially
for i in 0 to 9 loop 
    rx_i <= c_hex43(i);
    wait for c_baud11520;
end loop;

wait for 10 us; -- gap between frames

-- second frame: send bits of c_hexA5 sequentially
for i in 0 to 9 loop 
    rx_i <= c_hexA5(i);
    wait for c_baud11520;
end loop;

wait for 20 us; -- wait before ending simulation

-- Use an assertion to terminate the simulation intentionally
assert false
report "SIM DONE"
severity failure;

end process P_STIMULI;


end Behavioral;
