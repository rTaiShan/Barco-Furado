library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity contador_3000 is
    port (
        clock   : in  std_logic;
        zera_as : in  std_logic;
        zera_s  : in  std_logic;
        conta   : in  std_logic;
        fim     : out std_logic;
		  leds    : out std_logic_vector(3 downto 0);
		  led_derrota : out std_logic
    );
end entity contador_3000;

architecture comportamental of contador_3000 is
    signal IQ: integer range 0 to 2999;
begin
  
    process (clock,zera_as,zera_s,conta,IQ)
    begin
        if zera_as='1' then    IQ <= 0;   
        elsif rising_edge(clock) then
            if zera_s='1' then IQ <= 0;
            elsif conta='1' then 
                if IQ=3000-1 then IQ <= 0; 
                else           IQ <= IQ + 1; 
                end if;
            else               IQ <= IQ;
            end if;
        end if;
    end process;

    -- saida fim
    fim <= '1' when IQ=3000-1 else
           '0';

	 led_derrota  <= '1' when ((IQ<500) or (IQ>1000 and IQ<1500) or (IQ>2000 and IQ<2500)) else
						  '0';
						  
	 leds 		  <= "1111" when ((IQ<500) or (IQ>1000 and IQ<1500) or (IQ>2000 and IQ<2500)) else
						  "0000";

end architecture comportamental;
