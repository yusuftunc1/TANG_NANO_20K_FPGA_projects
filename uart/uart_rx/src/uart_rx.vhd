library IEEE;
use IEEE.std_logic_1164.ALL;

entity uart_rx is
generic(
    c_clkfreq   : integer := 100_000_000; -- System clock frequency (Hz)
    c_baudrate  : integer := 115_200 -- Serial communication baud rate (bps)
);
port(
    clk             : in std_logic; -- system clock input
    rx_i            : in std_logic; -- serial data input (RX line)
    data_o          : out std_logic_vector(7 downto 0); -- parallel data output (received byte)
rx_done_tick_o  : out std_logic -- tick output indicating a byte has been received and is valid on data_o
);
end uart_rx;


architecture Behavioral of uart_rx is

    constant c_bittimerlim : integer := c_clkfreq/c_baudrate; -- number of clock cycles for one bit period at the given baud rate
    
    -- State machine states
    type states is (S_IDLE, S_START, S_DATA, S_STOP); 
    signal state : states := S_IDLE;

    signal bittimer : integer range 0 to c_bittimerlim := 0; -- timer to count clock cycles for bit timing
    signal bitcntr  : integer range 0 to 7 := 0; -- counter for the number of data bits received (0 to 7 for 8 bits)
    signal shreg    : std_logic_vector (7 downto 0) := (others => '0'); -- shift register to hold incoming bits

begin
--- Main process: handles the state machine for receiving UART data
P_MAIN : process(clk) begin 

    if(rising_edge(clk)) then 
    
    case state is
        when S_IDLE => -- waiting for start bit
            rx_done_tick_o <= '0';
            bittimer <= 0;
            if(rx_i = '0') then
                state <= S_START;
            end if;

        when S_START => -- start bit detected, wait for the middle of the start bit to sample
            if (bittimer = c_bittimerlim/2 -1) then
                state <= S_DATA;
                bittimer <= 0;
            else 
                bittimer <= bittimer + 1;
            end if;

        when S_DATA => -- receiving data bits
            if(bittimer = c_bittimerlim -1) then 
                if(bitcntr = 7 ) then 
                    state <= S_STOP;
                    bitcntr <= 0;
                else
                    bitcntr <= bitcntr + 1;
                end if;
                shreg <= rx_i & (shreg(7 downto 1));
                bittimer <= 0;
            else 
                bittimer <= bittimer + 1;
            end if;

        when S_STOP => -- stop bit, wait for it to finish and then go back to idle
            if (bittimer = c_bittimerlim -1) then
                state <= S_IDLE;
                bittimer <= 0;
                rx_done_tick_o <= '1';
            else 
                bittimer <= bittimer + 1;
            end if;
    end case;

    end if;

end process P_MAIN;

-- Output the received data byte (updated when a full byte has been received and stop bit is processed)
data_o <= shreg;

end Behavioral;
