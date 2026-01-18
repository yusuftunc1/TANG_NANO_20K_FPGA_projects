library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity bcd_incrementor is
generic(
    c_first_digit_lim : integer := 9;
    c_second_digit_lim : integer := 5
);
port(
    clk_i : in std_logic;
    inc_i : in std_logic;
    res_i : in std_logic;
    first_digit_o   : out std_logic_vector(3 downto 0);
    second_digit_o  : out std_logic_vector(3 downto 0)
);
end bcd_incrementor;

architecture Behavioral of bcd_incrementor is
    signal first_digit : std_logic_vector(3 downto 0) := (others => '0');
    signal second_digit : std_logic_vector(3 downto 0) := (others => '0');
begin 

process (clk_i) begin 
    if(rising_edge(clk_i)) then
        if(inc_i = '1') then 
            if (first_digit = c_first_digit_lim) then
                if (second_digit = c_second_digit_lim) then
                    first_digit <= x"0";
                    second_digit <= x"0";
                else
                    first_digit <= x"0";
                    second_digit <= second_digit + 1;
                end if;
            else
                first_digit <= first_digit + 1;
            end if;
        end if;
        
        if(res_i = '1') then
            first_digit <= x"0";
            second_digit <= x"0";
        end if;

    end if;        
end process;                

first_digit_o <= first_digit;
second_digit_o <= second_digit;


end Behavioral;
