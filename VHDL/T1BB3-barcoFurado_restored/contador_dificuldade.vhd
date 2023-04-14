library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity contador_dificuldade is
	 generic (
		constant M_facil   : integer := 2000;
		constant M_normal  : integer := 1500;
		constant M_dificil : integer := 1000
	 );
    port (
		  dificuldade : in  std_logic_vector(1 downto 0);
        clock   	  : in  std_logic;
        fim	        : out std_logic
    );
end entity contador_dificuldade;

architecture comportamental of contador_dificuldade is
    signal IQ   	: integer range 0 to M_facil;
	 signal M 	: integer range 0 to M_facil;
	 signal s_Q 	: std_logic_vector(natural(ceil(log2(real(M_facil)))) downto 0);
begin
	 --Divisoes sao sintetizaveis??
	 M <= M_facil when dificuldade = "00" else
		M_dificil when dificuldade = "10" else
		M_normal;

		
	 process (clock, IQ, M)
	 begin
		if rising_edge(clock) then
			if IQ=M-1 then 
				IQ <= 0;
			else 
				IQ<=IQ+1;
			end if;
		end if;
	 end process;
	 

    fim <= '1' when IQ=M-1 else
           '0';
end architecture comportamental;
