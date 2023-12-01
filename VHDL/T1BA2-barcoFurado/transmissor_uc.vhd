library ieee;
use ieee.std_logic_1164.all;

entity transmissor_uc is
	port (
		clock : in std_logic;
		reset : in std_logic;
		fim_transmissao : in std_logic;
		fim_partida : in std_logic;
		zera_partida : out std_logic;
		conta_partida : out std_logic;
		partida_tx : out std_logic;
		zera_seletor : out std_logic
	);
end entity;

architecture behave of transmissor_uc is
	
    type tipo_estado is (espera, transmite);
    signal Eatual: tipo_estado;  -- estado atual
    signal Eprox:  tipo_estado;  -- proximo estado

begin

  -- memoria de estado
  process (reset, clock)
  begin
      if reset = '1' then
          Eatual <= espera;
      elsif clock'event and clock = '1' then
          Eatual <= Eprox; 
      end if;
  end process;

  -- logica de proximo estado
  process (Eatual, fim_transmissao, fim_partida) 
  begin

    case Eatual is

		when espera =>   
			if fim_partida = '1' then
				Eprox <= transmite;
			else
				Eprox <= espera;
			end if;

      when transmite =>   
		if fim_transmissao = '1' then
			Eprox <= espera;
		else
			Eprox <= transmite;
		end if;

      when others =>       Eprox <= espera;

    end case;

  end process;

  -- logica de saida (Moore)
  with Eatual select
  	zera_partida <= '1' when transmite, '0' when others;

  with Eatual select
  	conta_partida <= '1' when espera, '0' when others;

  with Eatual select
  	partida_tx <= '1' when transmite, '0' when others;

  with Eatual select
  	zera_seletor <= '1' when espera, '0' when others;


end architecture;