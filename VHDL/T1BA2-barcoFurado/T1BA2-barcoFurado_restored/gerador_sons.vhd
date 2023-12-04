library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity gerador_sons is
    port ( clk : in std_logic;
           sound_on : in std_logic;
           sound_out : out std_logic 
        );
end gerador_sons;

architecture behavioral of gerador_sons is
    constant CLOCK_FREQUENCY_HZ : real := 50.0E6; -- 50MHz
    constant SOUND_FREQUENCY_HZ : real := 1000.0; -- 1kHz
    signal counter : integer := 0;
    signal sound_wave : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if counter >= (integer(CLOCK_FREQUENCY_HZ / (2.0 * SOUND_FREQUENCY_HZ)) - 1) then
                counter <= 0;
                sound_wave <= not sound_wave;
            else
                counter <= counter + 1;
            end if;

            if sound_on = '1' then
                sound_out <= sound_wave;
            else
                sound_out <= '0';
            end if;
        end if;
    end process;
end behavioral;
