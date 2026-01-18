    library IEEE;
    use IEEE.std_logic_1164.ALL;
    use IEEE.std_logic_arith.ALL;
    use IEEE.std_logic_unsigned.ALL;

    entity top_modul is
    generic (
        c_clkfreq : integer := 27_000_000 -- tang nano clock freq
    );
    port(
        clk : in std_logic;
        start_i : in std_logic;
        reset_i : in std_logic;
        tm_fd_o : out std_logic_vector(7 downto 0);
        tm_sd_o : out std_logic_vector(7 downto 0)       
    );
    end top_modul;


    architecture Behavioral of top_modul is 

    -- BCD INCREMENTOR
    component bcd_incrementor is
    generic (
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
    end component;

    -- BCD TO SEVEN SEGMENT
    component bcd_to_sevenseg is
    port (
        bcd_i : in std_logic_vector(3 downto 0);
        sevenseg_o : out std_logic_vector(7 downto 0)
    );
    end component;

    -- CONSTANT DEFINATIONS
    constant c_second_counter_lim	: integer := c_clkfreq;	-- second counter
    constant c_minute_counter_lim	: integer := 60;	-- ıt will count 60 second then minute counter will increase

    -- SIGNAL DEFINATIONS
    signal sec_increment : std_logic := '0';
    signal min_increment : std_logic := '0';
    signal continue		 : std_logic := '0';


    signal sec_first_digit : std_logic_vector(3 downto 0) := (others =>'0');
    signal sec_second_digit : std_logic_vector(3 downto 0) := (others =>'0');
    signal min_first_digit : std_logic_vector(3 downto 0) := (others =>'0');
    signal min_second_digit : std_logic_vector(3 downto 0) := (others =>'0');
    signal sec_first_digit_7seg : std_logic_vector(7 downto 0) := (others =>'0');
    signal sec_second_digit_7seg : std_logic_vector(7 downto 0) := (others =>'0');


    signal sec_counter	: integer range 0 to c_second_counter_lim 	:= 0;
    signal min_counter	: integer range 0 to c_minute_counter_lim 	:= 0;


    begin

    -- BCD INCREMENTOR INSTANTIATIONS
    i_second_bcd_increment : bcd_incrementor
    generic map(
        c_first_digit_lim => 9,
        c_second_digit_lim => 5
    )
    port map (
        clk_i => clk,
        inc_i => sec_increment,
        res_i => reset_i,
        first_digit_o  => sec_first_digit,
        second_digit_o => sec_second_digit
    );

    i_minute_bcd_increment : bcd_incrementor
    generic map(
        c_first_digit_lim => 9,
        c_second_digit_lim => 5
    )
    port map (
        clk_i => clk,
        inc_i => min_increment,
        res_i => reset_i,
        first_digit_o  => min_first_digit,
        second_digit_o => min_second_digit
    );


    -- BCD TO SEVEN SEGMENT INSTANTINATIONS
    i_second_first_digit : bcd_to_sevenseg
    port map (
        bcd_i => sec_first_digit,
        sevenseg_o => sec_first_digit_7seg     
    );

    i_second_second_digit : bcd_to_sevenseg
    port map (
        bcd_i => sec_second_digit,
        sevenseg_o => sec_second_digit_7seg 
    );

    -- MAIN PROCESS

    P_MAIN : process (clk) begin
        if rising_edge(clk) then    
            if(start_i = '1' ) then 
                continue <= not continue;
            end if;

            sec_increment <= '0';
            min_increment <= '0';

            if (continue = '1') then 
                if (sec_counter = c_second_counter_lim ) then
                    sec_counter <= 0;
                    sec_increment <= '1';
                    min_counter <= min_counter + 1;
                else
                    sec_counter <= sec_counter + 1;
                end if;
                if (min_counter = c_minute_counter_lim) then
                    min_counter <= 0;
                    min_increment <= '1';
                end if;
            end if;

            if(reset_i = '1') then
                sec_counter <= 0;
                min_counter <= 0;
            end if;
            
            tm_fd_o <= sec_first_digit_7seg;
            tm_sd_o <= sec_second_digit_7seg;

        end if;
    end process;




    end Behavioral;