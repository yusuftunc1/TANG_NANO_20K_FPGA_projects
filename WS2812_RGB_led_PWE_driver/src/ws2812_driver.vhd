library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity ws2812 is 
port(
    clk : in std_logic;
    start_i : in std_logic;
    rgb_i  : in std_logic_vector(23 downto 0);
    data_o : out std_logic;
    busy_o : out std_logic  
);
end ws2812;


architecture Behavioral of ws2812 is 
    constant T0H : integer := 9;        -- 0.35us
    constant T1H : integer := 19;       -- 0.70us
    constant T0lowtime : integer := 25; -- low time when T0H
    constant T1lowtime : integer := 15; -- low time when T1H 
    constant Tbit : integer := 34;      -- 1.25us
    constant Treset : integer := 1350;  -- > 50us 


    type state_t is (IDLE, SEND_HIGH, SEND_LOW, NEXT_BIT, RESET); -- FSM states
    signal state : state_t := IDLE;


    signal clk_cnt : integer range 0 to Treset := 0;    
    signal bit_idx : integer range 0 to 23 := 23;       -- most significant bit 



begin 

    process(clk) begin 
        if(rising_edge(clk)) then 

            case state is 
            
            when IDLE =>
                data_o <= '0';
                busy_o <= '0';

                if (start_i = '1') then
                    bit_idx <= 23;      -- MSB first
                    clk_cnt <= 0;
                    busy_o <= '1';
                    state <= SEND_HIGH;
                end if;
            
            when SEND_HIGH =>
                data_o <= '1';

                if (rgb_i(bit_idx) = '1') then 
                    if (clk_cnt = T1H) then 
                        clk_cnt <= 0;
                        state <= SEND_LOW;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
                else 
                    if (clk_cnt = T0H) then
                        clk_cnt <= 0;
                        state <= SEND_LOW;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
                end if;
            
            when SEND_LOW =>
                data_o <= '0';
                if (rgb_i(bit_idx) = '0') then
                    if(clk_cnt = T0lowtime) then
                        clk_cnt <= 0;
                        state <= NEXT_BIT;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
                else
                    if(clk_cnt = T1lowtime) then
                        clk_cnt <= 0;
                        state <= NEXT_BIT;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
                end if;
                
            
            when NEXT_BIT =>
                if(bit_idx = 0) then 
                    clk_cnt <= 0;
                    state <= RESET;
                else
                    bit_idx <= bit_idx - 1;
                    state <= SEND_HIGH;
                end if;
            
            when RESET => 
                data_o <= '0';
                if (clk_cnt = Treset) then 
                    clk_cnt <= 0;
                    state <= IDLE;
                else    
                    clk_cnt <= clk_cnt + 1;
                end if;

            end case;
        end if;
        
       

    end process;


end Behavioral;


