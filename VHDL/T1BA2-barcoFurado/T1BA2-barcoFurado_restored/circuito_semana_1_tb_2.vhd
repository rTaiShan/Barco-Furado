library ieee;
use ieee.std_logic_1164.all;

entity circuito_semana_1_tb_2 is
end entity;

architecture tb of circuito_semana_1_tb_2 is
  
  -- Componente a ser testado (Device Under Test -- DUT)
  component circuito_semana_1 is
    port(
      clock            : in  std_logic;
      reset            : in  std_logic;
      iniciar          : in  std_logic;
      dificuldade	 : in  std_logic_vector(1 downto 0);
      botoes           : in  std_logic_vector(3 downto 0);
      buracos_in 	 : in  std_logic_vector(3 downto 0);
      db_buracos		  : in std_logic;
      pronto           : out std_logic;
      vitoria          : out std_logic;
            derrota          : out std_logic;
            leds	         : out std_logic_vector(3 downto 0);
      nivel_agua_0	 : out std_logic_vector(6 downto 0);
      nivel_agua_1	 : out std_logic_vector(6 downto 0);
      db_estado        : out std_logic_vector(6 downto 0);
      db_clock	 : out std_logic;
      led_externo   : out std_logic_vector(3 downto 0)
	);
  end component;
  
  -- Declaracao de sinais para conectar o componente a ser testado (DUT)
  --   valores iniciais para fins de simulacao (GHDL ou ModelSim)
  signal s_clock              : std_logic := '0';
  signal s_reset              : std_logic := '0';
  signal s_iniciar            : std_logic := '0';
  signal s_botoes             : std_logic_vector(3 downto 0) := "0000";
  signal s_dificuldade		  : std_logic_vector(1 downto 0) := "00";
  signal s_db_buracos     : std_logic := '1';
  signal s_buracos_in		  : std_logic_vector(3 downto 0) := "0000";
  signal s_pronto             : std_logic := '0';
  signal s_vitoria 		      : std_logic := '0';
  signal s_derrota	          : std_logic := '0';
  signal s_leds		          : std_logic_vector(3 downto 0) := "0000";
  signal s_nivel_agua_0	 	  : std_logic_vector(6 downto 0);
  signal s_nivel_agua_1	 	  : std_logic_vector(6 downto 0);
  signal s_db_estado	 	  : std_logic_vector(6 downto 0);
  signal s_db_clock		 	  : std_logic;
  signal s_led_externo    : std_logic_vector(3 downto 0) := "0000";


  -- Configuracoes do clock
  signal keep_simulating : std_logic := '0'; -- delimita o tempo de geracao do clock
  constant clockPeriod   : time := 20 ns;
  
  -- Identificacao de casos de teste
  signal caso : integer := 0;
  signal cenario : integer := 1;

begin
  
  -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o periodo especificado. 
  -- Quando keep_simulating=0, clock e interrompido, bem como a simulacao de eventos
  s_clock <= (not s_clock) and keep_simulating after clockPeriod/2;

  -- Conecta DUT (Device Under Test)
  dut: circuito_semana_1 
       port map( 
        clock            => s_clock,
		reset            => s_reset,
		iniciar          => s_iniciar,
		dificuldade		 => s_dificuldade,
		botoes           => s_botoes,
		buracos_in 		 => s_buracos_in,
    db_buracos     => s_db_buracos,
		pronto           => s_pronto,
		vitoria          => s_vitoria,
	    derrota          => s_derrota,
	    leds	         => s_leds,
		nivel_agua_0	 => s_nivel_agua_0,
		nivel_agua_1	 => s_nivel_agua_1,
		db_estado		 => s_db_estado,
		db_clock		 => s_db_clock,
      led_externo => s_led_externo
       );

  -- geracao dos sinais de entrada (estimulos)
  stimulus: process is
  begin

    assert false report "Inicio da simulacao" severity note;
    keep_simulating <= '1';  -- inicia geracao do sinal de clock
    
    ---- condicoes iniciais ----------------
    caso       <= 0;
	cenario    <= 2;
    s_reset   <= '0';
    s_iniciar <= '0';
    s_botoes  <= "0000";
    s_db_buracos <= '1'; -- selecionar buracos manualmente
    wait for clockPeriod;

	-- Cenario 2, derrota, dificuldade 0
    ---- Teste 1 (resetar circuito)    
    caso       <= 1;
    -- gera pulso de reset
    wait until falling_edge(s_clock);
    s_reset   <= '1';
    wait for clockPeriod;
	s_buracos_in <= "0001";
    s_reset   <= '0';
    s_iniciar <= '1';
    wait for clockPeriod;
    s_iniciar <= '0';
	
	
	caso <= 2;
	wait for 40*clockPeriod;
	
	caso <= 3;
	s_buracos_in <= "0011";
	wait for 40 * clockPeriod;
	
	caso <= 4;
	s_botoes <= "0011";
	wait for 40 * clockPeriod;
	
	caso <= 5;
	s_buracos_in <= "0110";
  s_botoes <= "0000";
	wait for 1000 ms;
	

    ---- final dos casos de teste  da simulacao
    assert false report "Fim da simulacao" severity note;
    keep_simulating <= '0';
    
    wait; -- fim da simulacao: aguarda indefinidamente
  end process;

end architecture;
