library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

entity led_counter is
generic(
    c_clkfreq : integer := 27_000_000 -- tang nano clock
);
port(
    clk : in std_logic;
    sw : in std_logic_vector(1 downto 0);
    counter : out std_logic_vector(5 downto 0)
);
end led_counter;

architecture Behavioral of led_counter is
    signal c_timer2seclim   : integer := c_clkfreq*2;
    signal c_timer1seclim   : integer := c_clkfreq;
    signal c_timer500mslim  : integer := c_clkfreq/2;
    signal c_timer250mslim  : integer := c_clkfreq/4;

    signal timer            : integer range 0 to c_clkfreq*2 := 0;
    signal timer_lim        : integer;
    signal counter_int      : std_logic_vector(5 downto 0) := (others => '0');

begin

    timer_lim <= c_timer2seclim when sw = "00" else
                c_timer1seclim when sw = "01" else
                c_timer500mslim when sw = "10" else 
                c_timer250mslim;

    process(clk) begin 
        if(rising_edge(clk)) then
            if(timer > timer_lim -1) then
                counter_int <= counter_int + 1;
                timer <= 0;
            else
                timer <= timer + 1;
            end if;
        end if;
    end process;

    counter <= not counter_int;    -- in tang nano leds are active low by default we have to reverse it     

end Behavioral;