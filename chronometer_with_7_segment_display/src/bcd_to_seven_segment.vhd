library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity bcd_to_sevenseg is 
port(
    bcd_i : in std_logic_vector(3 downto 0);
    sevenseg_o : out std_logic_vector(7 downto 0)
);
end bcd_to_sevenseg;

architecture Behavioral of bcd_to_sevenseg is
begin 
process (bcd_i) begin
    case bcd_i is
        when "0000" => --  ABCDEFGDP    --0
            sevenseg_o <= "00000011";   
        when "0001" =>                  --1
            sevenseg_o <= "10011111";
        when "0010" =>                  --2
            sevenseg_o <= "00100101";   
        when "0011" =>                  --3
            sevenseg_o <= "00001101";  
        when "0100" =>                  --4
            sevenseg_o <= "10011001";
        when "0101" =>                  --5
            sevenseg_o <= "01001001"; 
        when "0110" =>                  --6
            sevenseg_o <= "01000001";
        when "0111" =>                  --7
            sevenseg_o <= "00011111";
        when "1000" =>                  --8
            sevenseg_o <= "00000001";
        when "1001" =>                  --9
            sevenseg_o <= "00001001";
        when others =>
            sevenseg_o <= "11111111";
    end case;
end process;

end Behavioral;