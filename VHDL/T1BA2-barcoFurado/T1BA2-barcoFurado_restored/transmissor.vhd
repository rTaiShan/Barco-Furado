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
		db_saida_serial : out std_logic;
		fim_transmissao : out std_logic
	);
end entity;

architecture behavioral of transmissor is

	component contador_m is
		generic (
			constant M : integer := 100 -- modulo do contador
		);
		port (
			clock : in std_logic;
			zera_as : in std_logic;
			zera_s : in std_logic;
			conta : in std_logic;
			Q : out std_logic_vector(natural(ceil(log2(real(M)))) - 1 downto 0);
			fim : out std_logic;
			meio : out std_logic
		);
	end component;

	component tx_serial_7O1 is
		port (
			clock : in std_logic;
			reset : in std_logic;
			partida : in std_logic;
			dados_ascii : in std_logic_vector(6 downto 0);
			dado_serial : out std_logic;
			pronto : out std_logic;
			db_clock : out std_logic;
			db_tick : out std_logic;
			db_partida : out std_logic;
			db_dado_serial : out std_logic
		);
	end component;

	component hex_ascii_decoder is
		port (
			hex : in std_logic_vector(3 downto 0);
			ascii : out std_logic_vector(6 downto 0)
		);
	end component;

	signal s_conta_seletor, s_fim_seletor : std_logic;
	signal s_dado_paralelo : std_logic_vector(6 downto 0);
	signal s_Q_seletor : std_logic_vector(4 downto 0);
	signal acii_jogar, ascii_vitoria, acii_derrota, ascii_dificuldade,
	ascii_botao3, ascii_botao2, ascii_botao1, ascii_botao0,
	ascii_buraco3, ascii_buraco2, ascii_buraco1, ascii_buraco0,
	ascii_tempo2, ascii_tempo1, ascii_tempo0,
	ascii_agua1, ascii_agua0 : std_logic_vector(6 downto 0);
	constant ascii_J : std_logic_vector(6 downto 0) := "1001010"; -- J -> 0x4A
	constant ascii_V : std_logic_vector(6 downto 0) := "1010110"; -- V -> 0x56
	constant ascii_D : std_logic_vector(6 downto 0) := "1000100"; -- D -> 0x44
	constant ascii_d_minusculo : std_logic_vector(6 downto 0) := "1100100"; -- d -> 0x64
	constant ascii_b_minusculo : std_logic_vector(6 downto 0) := "1100010"; -- b -> 0x62
	constant ascii_n_minusculo : std_logic_vector(6 downto 0) := "1101110"; -- n -> 0x6E
	constant ascii_f_minusculo : std_logic_vector(6 downto 0) := "1100110"; -- f -> 0x66
	constant ascii_B : std_logic_vector(6 downto 0) := "1000010"; -- B -> 0x42
	constant ascii_A : std_logic_vector(6 downto 0) := "1000001"; -- A -> 0x41
	constant ascii_T : std_logic_vector(6 downto 0) := "1010100"; -- T -> 0x54
	constant ascii_0 : std_logic_vector(6 downto 0) := "0110000"; -- 0 -> 0x30
	constant ascii_1 : std_logic_vector(6 downto 0) := "0110001"; -- 0 -> 0x31

begin
	seletor : contador_m
	generic map(
		M => 26
	)
	port map(
		clock => clock,
		zera_as => reset,
		zera_s => '0',
		conta => s_conta_seletor,
		Q => s_Q_seletor,
		fim => s_fim_seletor,
		meio => open
	);

	tx : tx_serial_7O1
	port map(
		clock => clock,
		reset => reset,
		partida => '1', -- Transmite logo que pronto
		dados_ascii => s_dado_paralelo,
		dado_serial => saida_serial,
		pronto => s_conta_seletor,
		db_clock => open,
		db_tick => open,
		db_partida => open,
		db_dado_serial => db_saida_serial
	);
	fim_transmissao <= s_fim_seletor and s_conta_seletor;

	-- J.V.D.d.b....B....T...A..\0 -> Jogar, Vitoria, Derrota, dificuldade, botoes, Buracos, Tempo, Agua
	with s_Q_seletor select
		s_dado_paralelo <= 	ascii_J 			when "00000",
							acii_jogar 			when "00001",

							ascii_V 			when "00010",
							ascii_vitoria 		when "00011",

							ascii_D 			when "00100",
							acii_derrota 		when "00101",

							ascii_d_minusculo 	when "00110",
							ascii_dificuldade 	when "00111",

							ascii_b_minusculo 	when "01000",
							ascii_botao3 		when "01001",
							ascii_botao2 		when "01010",
							ascii_botao1 		when "01011",
							ascii_botao0 		when "01100",

							ascii_B 			when "01101",
							ascii_buraco3 		when "01110",
							ascii_buraco2 		when "01111",
							ascii_buraco1 		when "10000",
							ascii_buraco0 		when "10001",

							ascii_T 			when "10010",
							ascii_tempo2 		when "10011",
							ascii_tempo1 		when "10100",
							ascii_tempo0 		when "10101",

							ascii_A 			when "10110",
							ascii_agua1 		when "10111",
							ascii_agua0 		when "11000",
							"0000000"		 	when others;

	acii_jogar <= ascii_1 when jogar = '1' else
		ascii_0;
	ascii_vitoria <= ascii_1 when vitoria = '1' else
		ascii_0;
	acii_derrota <= ascii_1 when derrota = '1' else
		ascii_0;

	with dificuldade select
		ascii_dificuldade <= ascii_d_minusculo when "10", -- dificil
		ascii_f_minusculo when "00", -- facil
		ascii_n_minusculo when others; -- normal

	ascii_botao3 <= ascii_1 when botoes(3) = '1' else
		ascii_0;
	ascii_botao2 <= ascii_1 when botoes(2) = '1' else
		ascii_0;
	ascii_botao1 <= ascii_1 when botoes(1) = '1' else
		ascii_0;
	ascii_botao0 <= ascii_1 when botoes(0) = '1' else
		ascii_0;
	ascii_buraco3 <= ascii_1 when buracos(3) = '1' else
		ascii_0;
	ascii_buraco2 <= ascii_1 when buracos(2) = '1' else
		ascii_0;
	ascii_buraco1 <= ascii_1 when buracos(1) = '1' else
		ascii_0;
	ascii_buraco0 <= ascii_1 when buracos(0) = '1' else
		ascii_0;

	decoder_tempo2 : hex_ascii_decoder
	port map (
		hex => contador_tempo(11 downto 8),
		ascii => ascii_tempo2
	);

	decoder_tempo1 : hex_ascii_decoder
	port map (
		hex => contador_tempo(7 downto 4),
		ascii => ascii_tempo1
	);

	decoder_tempo0 : hex_ascii_decoder
	port map (
		hex => contador_tempo(3 downto 0),
		ascii => ascii_tempo0
	);

	decoder_agua1 : hex_ascii_decoder
	port map (
		hex => contador_agua(7 downto 4),
		ascii => ascii_agua1
	);

	decoder_agua0 : hex_ascii_decoder
	port map (
		hex => contador_agua(3 downto 0),
		ascii => ascii_agua0
	);
	
end architecture;