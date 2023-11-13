library ieee;
use ieee.std_logic_1164.all;

entity wrapper_df is 
	port(
		clock        : in  std_logic;
		reset 		 : in  std_logic;
		iniciar      : in  std_logic;
		botoes       : in  std_logic_vector(3 downto 0);
		dificuldade	 : in  std_logic_vector(1 downto 0);
		
		conta_regressivo : in  std_logic;
		zera_contagem : in  std_logic;
		led_select    : in  std_logic;
		
		buracos_led  : out std_logic_vector(3 downto 0);
		buracos_pwm  : out std_logic_vector(3 downto 0);
		vitoria_led  : out std_logic;
		derrota_led  : out std_logic;
		
		fim_contagem : out std_logic;
		pronto		 : out std_logic;
		
		db_estado    : out std_logic_vector(6 downto 0);
		db_clock		 : out std_logic;
		nivel_agua_0, nivel_agua_1 : out std_logic_vector(6 downto 0)
	);
end entity;

architecture comportamental of wrapper_df is

signal s_leds_contagem : std_logic_vector(3 downto 0);
signal s_led_derrota_contagem : std_logic; 
signal s_dificuldade   : std_logic_vector(1 downto 0);
signal s_buracos, s_buracos_led, s_buracos_externos : std_logic_vector(3 downto 0);
signal s_vitoria, s_derrota : std_logic;


component contador_inicializacao is
	port (
        clock   : in  std_logic;
        zera_as : in  std_logic;
        zera_s  : in  std_logic;
        conta   : in  std_logic;
        fim     : out std_logic;
		  leds    : out std_logic_vector(3 downto 0);
		  led_derrota : out std_logic
    );
end component;


component circuito_semana_1 is 
	port(
		clock            : in  std_logic;
		reset            : in  std_logic;
		iniciar          : in  std_logic;
		dificuldade		  : in  std_logic_vector(1 downto 0);
		botoes           : in  std_logic_vector(3 downto 0);
		buracos_in 		  : in  std_logic_vector(3 downto 0);
		db_buracos		  : in std_logic;
		pronto           : out std_logic;
		vitoria          : out std_logic;
	   derrota          : out std_logic;
	   leds	        	  : out std_logic_vector(3 downto 0);
		nivel_agua_0	  : out std_logic_vector(6 downto 0);
		nivel_agua_1	  : out std_logic_vector(6 downto 0);
		db_estado        : out std_logic_vector(6 downto 0);
		db_clock	        : out std_logic;
		led_externo   	  : out std_logic_Vector(3 downto 0)
	);
end component;

component controle_buraco is
  port (
	 clock : in std_logic;
	 reset : in std_logic;
	 buracos_in : in std_logic_vector(3 downto 0);
	 buracos_pwm : out std_logic_vector(3 downto 0)
  );
end component;

begin

with dificuldade select 
	s_dificuldade <= "00" when "01",
						  "01" when "00",
						  "10" when others;
						  
with led_select select
	buracos_led <= s_buracos when '0',
						s_leds_contagem when others;
	

with led_select select	
	derrota_led <= s_derrota when '0',
						s_led_derrota_contagem when others;

with led_select select
	vitoria_led <= s_vitoria when '0',
	               '0' when others;
						  
contagem_regressiva : contador_inicializacao
	port map (
        clock => clock,
        zera_as => zera_contagem,
        zera_s => '0',
        conta => conta_regressivo,
        fim => fim_contagem,
		  leds => s_leds_contagem,
		  led_derrota => s_led_derrota_contagem
    );


circuito_principal : circuito_semana_1
	port map (
		clock => clock,
		reset => reset,
		iniciar => iniciar,
		dificuldade => s_dificuldade,
		botoes => botoes,
		buracos_in => "0000",
		db_buracos => '0', 
		pronto => pronto,
		vitoria => s_vitoria,
	   derrota => s_derrota,
	   leds => s_buracos,
		nivel_agua_0 => nivel_agua_0,
		nivel_agua_1 => nivel_agua_1,
		db_estado => db_estado,
		db_clock	=> db_clock,
		led_externo => s_buracos_externos
	);
	
controle_buraco_pwm : controle_buraco
  port map (
	 clock => clock,
	 reset => reset,
	 buracos_in => s_buracos_externos,
	 buracos_pwm => buracos_pwm
  );


end comportamental;
