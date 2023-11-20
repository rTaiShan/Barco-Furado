library IEEE;
use IEEE.std_logic_1164.ALL;

entity soundGenerator_tb is
end soundGenerator_tb;

architecture behavioral of SoundGenerator_tb is
    signal clk : std_logic := '0';
    signal sound_on : std_logic := '0';
    signal sound_out : std_logic;

    constant CLOCK_PERIOD : time := 20 ns; -- 50 MHz
    constant SIMULATION_TIME : time := 20 ms; 

    -- Instantiate the SoundGenerator component
    component SoundGenerator
        Port ( clk : in std_logic;
               sound_on : in std_logic;
               sound_out : out std_logic );
    end component;

begin
    -- Instantiate the SoundGenerator component
    dut: SoundGenerator
        port map (clk => clk, sound_on => sound_on, sound_out => sound_out);

    -- Clock generation
    process
    begin
        while now < SIMULATION_TIME loop
            clk <= not clk;
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Simulation process
    process
    begin
        wait for 50 ns;

        -- Test case: Enable sound
        sound_on <= '1';
        wait for SIMULATION_TIME;
        sound_on <= '0';

        wait for 1 ms;

        wait;

    end process;

end behavioral;
