-- Arquivo   : gera_buracos_df.vhd
-- Projeto   : Semana 02 - Projeto do Jogo do Barco Furado
--------------------------------------------------------------------
-- Descricao : Componente do fluxo de dados do componente
--             gera_buracos.
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

entity gera_buracos_df is
	port(
		clock			  	  : in  std_logic;
		reset				  : in  std_logic;
		registra_buracos : in  std_logic;
		move				  : in  std_logic;
		add				  : in  std_logic;
		dificuldade 	  : in  std_logic_vector(1 downto 0);
		buracos		  	  : out std_logic_vector(3 downto 0);
		zero_buracos  	  : out std_logic;
		um_buraco  	  	  : out std_logic;
		dois_buracos  	  : out std_logic;
		faz_algo			  : out std_logic
	);
end entity gera_buracos_df;

architecture comportamental of gera_buracos_df is
signal s_buracos, s_novos_buracos  : std_logic_vector(3 downto 0);
signal s_zero_buracos, s_um_buraco : std_logic;
signal s_q1 : std_logic_vector(natural(ceil(log2(real(317))))-1 downto 0);
signal s_q1_concat : std_logic_vector(1 downto 0);
signal s_q2 : std_logic_vector(natural(ceil(log2(real(443))))-1 downto 0);
signal s_add, s_move : std_logic_vector(3 downto 0);

	component registrador_n is
		generic (
			constant N: integer := 8 
		);
		port (
			clock  : in  std_logic;
			clear  : in  std_logic;
			enable : in  std_logic;
			D      : in  std_logic_vector (N-1 downto 0);
			Q      : out std_logic_vector (N-1 downto 0) 
		);
	end component;
	
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
	 end component;
	 
	 
	component contador_dificuldade is
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
	end component;
	 
	 component move_buraco is
		port(
			buracos_in			: in  std_logic_vector(3 downto 0);
			move_lsb          : in  std_logic; --Se ativo, move buraco do LSB
			para_onde			: in  std_logic_vector(1 downto 0); --seleciona a posicao de destino
			buracos_out			: out std_logic_vector(3 downto 0)
		);
	  end component;


begin
buracos <= s_buracos;
zero_buracos <= s_zero_buracos;
um_buraco <= s_um_buraco;

s_zero_buracos <= '1' when s_buracos="0000" else
					   '0';
						
s_um_buraco <= '1' when s_buracos="0001" or s_buracos="0010" or s_buracos="0100" or s_buracos="1000" else
					'0';
					
dois_buracos <= not (s_zero_buracos or s_um_buraco);

s_q1_concat <= s_q1(1) & s_q1(0);
with s_q1_concat select
	s_add <= s_buracos or "0001" when "00",
				s_buracos or "0010" when "01",
				s_buracos or "0100" when "10",
				s_buracos or "1000" when others;

s_novos_buracos <= s_add  	  when add='1' and move='0' else
						 s_move 	  when move='1' and add='0'else
						 s_buracos;
				
registrador: registrador_n 
	generic map(
		N => 4
   )
   port map (
		clock  => clock,
      clear  => reset,
      enable => registra_buracos,
      D      => s_novos_buracos,
      Q      => s_buracos
	);
					

conta_buraco : contador_dificuldade
	generic map (
		M_facil => 1500,
		M_normal => 1000,
		M_dificil => 500
	 )
	port map (
	   dificuldade => dificuldade,
		clock => clock,
		fim => faz_algo
	);
	
contador_1 : contador_m
		generic map(
				M => 317		--Adotando dois primos para os modulos, para melhor "aleatoriedade"
			)
		port map(
			clock   => clock,
			zera_as => '0', 
			zera_s  => '0', 
			conta   => '1',
			Q       => s_q1,
			fim     => open, 
			meio    => open
		);

contador_2 : contador_m
		generic map(
				M => 443
			)
		port map(
			clock   => clock,
			zera_as => '0', 
			zera_s  => '0', 
			conta   => '1',
			Q       => s_q2,
			fim     => open, 
			meio    => open
		);
		
movedor : move_buraco
	port map(
		buracos_in	=> s_buracos,
		move_lsb    => s_q2(0),
		para_onde	=> s_q1_concat,
		buracos_out	=> s_move
	);
				  
end architecture;