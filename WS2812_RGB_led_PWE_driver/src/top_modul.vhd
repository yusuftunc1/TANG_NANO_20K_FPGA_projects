library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity top_modul is
port(
    clk : in std_logic;         -- Tang Nano 27Mhz
    led_o : out std_logic       -- WS2812 Din
);
end top_modul;


architecture Behavioral of top_modul is
    -- component declerations
    component ws2812 is 
    port(
        clk : in std_logic;
        start_i : in std_logic;
        rgb_i  : in std_logic_vector(23 downto 0);
        data_o : out std_logic;
        busy_o : out std_logic  
    );
    end component;


    -- WS2812 driver signals
    signal start_tx : std_logic := '0';
    signal busy_tx : std_logic;
    signal rgb_data : std_logic_vector(23 downto 0);

    -- simple power on counter
    --signal init_cnt : unsigned(15 downto 0) := (others => '0');
    signal started : std_logic := '0';
    
    signal color_idx : unsigned(2 downto 0) := (others => '0');

    constant COLOR_PERIOD : integer := 13_500_000; -- ~0.5s
    signal slow_cnt  : unsigned(25 downto 0) := (others => '0');
    signal start_req : std_logic := '0';


begin 
    -- WS2812 driver instance
    ws2812_init : ws2812
    port map(
        clk => clk,
        start_i => start_tx,
        rgb_i => rgb_data,
        data_o => led_o,
        busy_o => busy_tx
    );
        

    process(color_idx)
    begin
        case color_idx is
            when "000" => rgb_data <= x"00FF00"; -- Red
            when "001" => rgb_data <= x"FF0000"; -- Green
            when "010" => rgb_data <= x"0000FF"; -- Blue
            when "011" => rgb_data <= x"FFFFFF"; -- White
            when others => rgb_data <= x"000000";
        end case;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            start_req <= '0';
            if slow_cnt = COLOR_PERIOD then
                slow_cnt <= (others => '0');

                if busy_tx = '0' then
                    color_idx <= color_idx + 1; -- ONLY color here
                    start_req <= '1';           -- request send
                end if;
            else
                slow_cnt <= slow_cnt + 1;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            start_tx <= start_req;
        end if;
    end process;                
    

end Behavioral;