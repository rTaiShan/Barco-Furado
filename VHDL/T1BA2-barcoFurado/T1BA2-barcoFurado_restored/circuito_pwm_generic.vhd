-----------------Laboratorio Digital--------------------------------------
-- Arquivo   : circuito_pwm_generic.vhd
-- Projeto   : Experiencia 1 - Controle de um servomotor
--------------------------------------------------------------------------
-- Descricao : 
--             codigo VHDL RTL gera saída digital com modulacao pwm
--
-- parametros de configuracao da saida pwm: conf_periodo e largura_xx
-- (considerando clock de 50MHz ou periodo de 20ns)
--
--------------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     12/11/2023  1.0     Raul Tai          Criacao
-------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity circuito_pwm_generic is
  generic (
    -- 8 configuracoes de largura
    conf_periodo : integer := 1000000; -- 20ms
    conf_posicoes : integer := 16;
    conf_largura_posicao : integer := 1563; -- conf_posicoes * conf_largura_posicao + largura_min = largura_max
    largura_min : integer := 75000; -- 1.5ms, 0 deg
    largura_max : integer := 100008 -- 2ms, 90 deg
  );
  port (
    clock : in std_logic;
    reset : in std_logic;
    largura : in std_logic_vector(natural(ceil(log2(real(conf_posicoes))))-1 downto 0);
    pwm : out std_logic
  );
end entity;

architecture rtl of circuito_pwm_generic is
  signal contagem : integer range 0 to conf_periodo - 1;
  signal largura_pwm : integer range 0 to conf_periodo - 1;
  signal s_largura : integer range 0 to conf_periodo - 1;

  type array_posicoes is array (integer range 0 to conf_posicoes) of integer range largura_min to largura_max;

  function posicoes_init return array_posicoes is
    variable temp : array_posicoes;
  begin
    forLoop : for i in 0 to conf_posicoes loop
      temp(i) := largura_min + i * conf_largura_posicao;
    end loop;
    return temp;
  end function posicoes_init;

  constant tabela_posicoes : array_posicoes := posicoes_init;
begin
  -- define largura do pulso em ciclos de clock
  s_largura <= tabela_posicoes(to_integer(unsigned(largura)));

  process (clock, reset, s_largura)
  begin
    -- inicia contagem e largura
    if (reset = '1') then
      contagem <= 0;
      pwm <= '0';
      largura_pwm <= s_largura;
    elsif (rising_edge(clock)) then
      -- saida
      if (contagem < largura_pwm) then
        pwm <= '1';
      else
        pwm <= '0';
      end if;
      -- atualiza contagem e largura
      if (contagem = conf_periodo - 1) then
        contagem <= 0;
        largura_pwm <= s_largura;
      else
        contagem <= contagem + 1;
      end if;
    end if;
  end process;

end architecture rtl;