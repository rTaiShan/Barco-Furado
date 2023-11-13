--------------------------------------------------------------------
-- Arquivo   : contador_custom.vhd
-- Projeto   : Semana 01 - Projeto do Jogo do Barco Furado
--------------------------------------------------------------------
-- Descricao : Componente do fluxo de dados do circuito
--             desenvolvido para a semana 1.
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Raul Tai          versao inicial
--------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity contador_custom is
    generic (
        constant maxM: integer := 256 -- modulo maximo do contador
    );
    port (
        clock   	  : in  std_logic;
        zera_as 	  : in  std_logic;
        zera_s  	  : in  std_logic;
        incrementa_1      : in  std_logic;
        incrementa_2      : in  std_logic;
	decrementa        : in  std_logic;
        dificuldade       : in  std_logic_vector(1 downto 0);
        Q       	  : out std_logic_vector(natural(ceil(log2(real(maxM)))) downto 0);
        fim     	  : out std_logic
    );
end entity contador_custom;

architecture comportamental of contador_custom is
         signal IQ   	: integer range 0 to maxM;
	 signal M 	: integer range 0 to maxM;
	 signal s_Q 	: std_logic_vector(natural(ceil(log2(real(maxM)))) downto 0);
begin
	 --Divisoes sao sintetizaveis??
	 M <= 	maxM     when dificuldade = "00" else
		3*maxM/4 when dificuldade = "01" else
		maxM/2   when dificuldade = "10" else
		maxM/4   when dificuldade = "11";

    process (clock,zera_as,zera_s,incrementa_1, incrementa_2, decrementa ,IQ,M)
    begin
        if zera_as='1' then    IQ <= 0;   
		  elsif rising_edge(clock) then
            if zera_s='1' then IQ <= 0;
            elsif incrementa_1='1' then 
	       if             IQ=M-1 then IQ <= 0; 
               else           IQ <= IQ + 1; 
               end if;
	    elsif incrementa_2='1' then
	       if (IQ=M-2 or IQ=M-1) then IQ <= 0;
	       else                       IQ <= IQ + 2;
	       end if;
	    elsif decrementa='1' then
	       if IQ=0 then IQ <= 0;
	       else IQ <= IQ - 1;
	       end if;
            else             IQ <= IQ;
            end if;
        end if;
    end process;

    fim <= '1' when (IQ=M-1 or IQ=M-2) else
           '0';

    s_Q <= std_logic_vector(to_unsigned(IQ, Q'length));
	Q <= s_Q;

end architecture comportamental;
