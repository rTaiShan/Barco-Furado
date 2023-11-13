library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity controle_buraco is
  port (
    clock : in std_logic;
    reset : in std_logic;
    buracos_in : in std_logic_vector(3 downto 0);
    buracos_pwm : out std_logic_vector(3 downto 0)
  );
end entity;

architecture behavioral of controle_buraco is

  component circuito_pwm_generic is
    generic (
      conf_periodo : integer := 1000000; -- 20ms
      conf_posicoes : integer := 16;
      conf_largura_posicao : integer := 1563; -- conf_posicoes * conf_largura_posicao + largura_min = largura_max
      largura_min : integer := 75000; -- 1.5ms, 0 deg
      largura_max : integer := 100008 -- 2ms, 90 deg
    );
    port (
      clock : in std_logic;
      reset : in std_logic;
      largura : in std_logic_vector(natural(ceil(log2(real(conf_posicoes)))) downto 0);
      pwm : out std_logic
    );
  end component;

  component contador_custom is generic (
    constant maxM : integer := 16 -- modulo maximo do contador
    );
    port (
      clock : in std_logic;
      zera_as : in std_logic;
      zera_s : in std_logic;
      incrementa_1 : in std_logic;
      incrementa_2 : in std_logic;
      decrementa : in std_logic;
      dificuldade : in std_logic_vector(1 downto 0);
      Q : out std_logic_vector(natural(ceil(log2(real(maxM)))) downto 0);
      fim : out std_logic
    );
  end component contador_custom;

  component contador_m is
    generic (
        constant M: integer := 100 -- modulo do contador
    );
    port (
        clock   : in  std_logic;
        zera_as : in  std_logic;
        zera_s  : in  std_logic;
        conta   : in  std_logic;
        Q       : out std_logic_vector(natural(ceil(log2(real(M))))-1 downto 0);
        fim     : out std_logic;
        meio    : out std_logic
    );
end component contador_m;

  signal s_incrementa, s_decrementa, s_fim : std_logic_vector(3 downto 0);
  signal s_Q0, s_Q1, s_Q2, s_Q3 : std_logic_vector(4 downto 0);
  signal s_tick_vector : std_logic_vector (3 downto 0);
  signal s_tick : std_logic;

begin
  s_tick_vector <= s_tick & s_tick & s_tick & s_tick;
  s_incrementa <= buracos_in and (not s_fim) and s_tick_vector;
  s_decrementa <= not buracos_in and s_tick_vector;

  tick_generator : contador_m
  generic map (
        M => 1000000 -- modulo do contador
    )
    port map (
        clock   => clock,
        zera_as => reset,
        zera_s  => '0',
        conta   => '1',
        Q       => open,
        fim     => s_tick,
        meio    => open
    );

  contador_0 : contador_custom
  generic map(
    maxM => 16
  )
  port map(
    clock => clock,
    zera_as => reset,
    zera_s => '0',
    incrementa_1 => s_incrementa(0),
    incrementa_2 => '0',
    decrementa => s_decrementa(0),
    dificuldade => "00",
    Q => s_Q0,
    fim => s_fim(0)
  );

  pwm_0 : circuito_pwm_generic
  port map(
    clock => clock,
    reset => reset,
    largura =>s_Q0,
    pwm => buracos_pwm(0)
  );

  contador_1 : contador_custom
  generic map(
    maxM => 16
  )
  port map(
    clock => clock,
    zera_as => reset,
    zera_s => '0',
    incrementa_1 => s_incrementa(1),
    incrementa_2 => '0',
    decrementa => s_decrementa(1),
    dificuldade => "00",
    Q => s_Q1,
    fim => s_fim(1)
  );

  pwm_1 : circuito_pwm_generic
  port map(
    clock => clock,
    reset => reset,
    largura =>s_Q1,
    pwm => buracos_pwm(1)
  );

  contador_2 : contador_custom
  generic map(
    maxM => 16
  )
  port map(
    clock => clock,
    zera_as => reset,
    zera_s => '0',
    incrementa_1 => s_incrementa(2),
    incrementa_2 => '0',
    decrementa => s_decrementa(2),
    dificuldade => "00",
    Q => s_Q2,
    fim => s_fim(2)
  );

  pwm_2 : circuito_pwm_generic
  port map(
    clock => clock,
    reset => reset,
    largura =>s_Q2,
    pwm => buracos_pwm(2)
  );

  contador_3 : contador_custom
  generic map(
    maxM => 16
  )
  port map(
    clock => clock,
    zera_as => reset,
    zera_s => '0',
    incrementa_1 => s_incrementa(3),
    incrementa_2 => '0',
    decrementa => s_decrementa(3),
    dificuldade => "00",
    Q => s_Q3,
    fim => s_fim(3)
  );

  pwm_3 : circuito_pwm_generic
  port map(
    clock => clock,
    reset => reset,
    largura =>s_Q3,
    pwm => buracos_pwm(3)
  );

end architecture;