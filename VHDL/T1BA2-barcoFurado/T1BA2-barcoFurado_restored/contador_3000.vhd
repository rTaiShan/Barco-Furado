library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity contador_inicializacao is
    port (
        clock   : in  std_logic;
        zera_as : in  std_logic;
        zera_s  : in  std_logic;
        conta   : in  std_logic;
        fim     : out std_logic;
		  leds    : out std_logic_vector(3 downto 0);
		  led_derrota : out std_logic
    );
end entity contador_inicializacao;

architecture comportamental of contador_inicializacao is
    -- signal IQ: integer range 0 to 2999;
    signal IQ: integer range 0 to 149999999; -- Modulo = 150000000
begin
  
    process (clock,zera_as,zera_s,conta,IQ)
    begin
        if zera_as='1' then    IQ <= 0;   
        elsif rising_edge(clock) then
            if zera_s='1' then IQ <= 0;
            elsif conta='1' then 
                if IQ=150000000-1 then IQ <= 0; 
                else           IQ <= IQ + 1; 
                end if;
            else               IQ <= IQ;
            end if;
        end if;
    end process;

    -- saida fim
    fim <= '1' when IQ=150000000-1 else
           '0';

	--  led_derrota  <= '1' when ((IQ<500) or (IQ>1000 and IQ<1500) or (IQ>2000 and IQ<2500)) else '0';
     led_derrota  <= '1' when ((IQ<25000000) or (IQ>50000000 and IQ<75000000) or (IQ>100000000 and IQ<125000000)) else '0';
						  
	--  leds 		  <= "1111" when ((IQ<500) or (IQ>1000 and IQ<1500) or (IQ>2000 and IQ<2500)) else "0000";
     leds 		  <= "1111" when ((IQ<25000000) or (IQ>50000000 and IQ<75000000) or (IQ>100000000 and IQ<125000000)) else "0000";

end architecture comportamental;
