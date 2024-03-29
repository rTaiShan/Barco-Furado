library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity transmissor is
	port (
		clock : in std_logic;
		reset : in std_logic;
		jogar : in std_logic;
		vitoria : in std_logic;
		derrota : in std_logic;
		dificuldade : in std_logic_vector(1 downto 0);
		botoes : in std_logic_vector(3 downto 0);
		buracos : in std_logic_vector(3 downto 0);
		contador_tempo : in std_logic_vector(11 downto 0);
		contador_agua : in std_logic_vector(7 downto 0);
		saida_serial : out std_logic;
		db_saida_serial : out std_logic
	);
end entity;

architecture behavioral of transmissor is
	component transmissor_df is
		port (
			-- Sinais de controle
			clock : in std_logic;
			reset : in std_logic;
			zera_partida : in std_logic; 
			conta_partida : in std_logic;
			partida_tx : in std_logic;
			zera_seletor : in std_logic;
			-- Estado do jogo
			jogar : in std_logic;
			vitoria : in std_logic;
			derrota : in std_logic;
			dificuldade : in std_logic_vector(1 downto 0);
			botoes : in std_logic_vector(3 downto 0);
			buracos : in std_logic_vector(3 downto 0);
			contador_tempo : in std_logic_vector(11 downto 0);
			contador_agua : in std_logic_vector(7 downto 0);
			-- Sinais de controle
			fim_transmissao : out std_logic;
			fim_partida : out std_logic;
			-- Saida da transmissao
			saida_serial : out std_logic;
			db_saida_serial : out std_logic
		);
	end component;

	component transmissor_uc is
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
	end component;
	
	signal fim_transmissao, fim_partida, zera_partida, conta_partida, partida_tx, zera_seletor : std_logic;

	begin

		uc : transmissor_uc 
		port map(
			clock => clock,
			reset => reset,
			fim_transmissao => fim_transmissao,
			fim_partida => fim_partida,
			zera_partida => zera_partida,
			conta_partida => conta_partida,
			partida_tx => partida_tx,
			zera_seletor => zera_seletor
		);

		df : transmissor_df
		port map (
			clock => clock,
			reset => reset,
			zera_partida => zera_partida,
			conta_partida => conta_partida,
			partida_tx => partida_tx,
			zera_seletor => zera_seletor,
			jogar => jogar,
			vitoria => vitoria,
			derrota => derrota,
			dificuldade => dificuldade,
			botoes => botoes,
			buracos => buracos,
			contador_tempo => contador_tempo,
			contador_agua => contador_agua,
			fim_transmissao => fim_transmissao,
			fim_partida => fim_partida,
			saida_serial => saida_serial,
			db_saida_serial => db_saida_serial
		);
	
end architecture;