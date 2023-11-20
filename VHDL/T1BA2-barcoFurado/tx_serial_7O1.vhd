-------------------------------------------------------------------
-- Arquivo   : tx_serial_7O1.vhd
-- Projeto   : Experiencia 2 - Comunicacao Serial Assincrona
-------------------------------------------------------------------
-- Descricao : circuito da experiencia 2 
-- > implementa configuracao 7O1 e taxa de 115200 bauds
-- > 
-- > componente edge_detector (U4) trata pulsos largos
-- > de PARTIDA (veja linha 83)
-------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     09/09/2021  1.0     Edson Midorikawa  versao inicial
--     31/08/2022  2.0     Edson Midorikawa  revisao do codigo
--     19/09/2022  2.1     Edson Midorikawa  revisao (db_estado)
--     17/08/2023  3.0     Edson Midorikawa  revisao para 7O1
-------------------------------------------------------------------
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_serial_7O1 is
    port (
        clock           : in  std_logic;
        reset           : in  std_logic;
        partida         : in  std_logic;
        dados_ascii     : in  std_logic_vector(6 downto 0);
        dado_serial     : out std_logic;
        pronto          : out std_logic;
        db_clock        : out std_logic;
        db_tick         : out std_logic;
        db_partida      : out std_logic;
        db_dado_serial  : out std_logic
    );
end entity;

architecture tx_serial_7O1_arch of tx_serial_7O1 is
     
    component tx_serial_uc 
    port ( 
        clock     : in  std_logic;
        reset     : in  std_logic;
        partida   : in  std_logic;
        tick      : in  std_logic;
        fim       : in  std_logic;
        zera      : out std_logic;
        conta     : out std_logic;
        carrega   : out std_logic;
        desloca   : out std_logic;
        pronto    : out std_logic
    );
    end component;

    component tx_serial_7O1_fd
    port (
        clock        : in  std_logic;
        reset        : in  std_logic;
        zera         : in  std_logic;
        conta        : in  std_logic;
        carrega      : in  std_logic;
        desloca      : in  std_logic;
        dados_ascii  : in  std_logic_vector(6 downto 0);
        saida_serial : out std_logic;
        fim          : out std_logic
    );
    end component;
    
    component contador_m_n
    generic (
        constant M : integer; 
        constant N : integer 
    );
    port (
        clock   : in  std_logic;
        zera_as : in  std_logic;
        zera_s  : in  std_logic;
        conta   : in  std_logic;
        Q       : out std_logic_vector(N-1 downto 0);
        fim     : out std_logic;
        meio    : out std_logic
    );
    end component;
 
    signal s_reset, s_partida : std_logic;
    signal s_zera, s_conta, s_carrega, s_desloca, s_tick, s_fim : std_logic;
    signal s_dado_serial : std_logic;

begin

    -- sinais reset e partida mapeados na GPIO (ativos em alto)
    s_reset   <= reset;
    s_partida <= partida;

    -- unidade de controle
    U1_UC: tx_serial_uc 
           port map (
               clock     => clock, 
               reset     => s_reset, 
               partida   => s_partida, 
               tick      => s_tick, 
               fim       => s_fim,
               zera      => s_zera, 
               conta     => s_conta, 
               carrega   => s_carrega, 
               desloca   => s_desloca, 
               pronto    => pronto
           );

    -- fluxo de dados
    U2_FD: tx_serial_7O1_fd 
           port map (
               clock        => clock, 
               reset        => s_reset, 
               zera         => s_zera, 
               conta        => s_conta, 
               carrega      => s_carrega, 
               desloca      => s_desloca, 
               dados_ascii  => dados_ascii, 
               saida_serial => s_dado_serial, 
               fim          => s_fim
           );


    -- gerador de tick
    -- fator de divisao para 9600 bauds (5208=50M/9600)
    -- fator de divisao para 115.200 bauds (434=50M/115200)
    U3_TICK: contador_m_n 
             generic map (
                 M => 434, -- 115200 bauds
                 N => 13
             ) 
             port map (
                 clock => clock,
					  zera_as => reset, 
                 zera_s  => s_zera, 
                 conta => '1', 
                 Q     => open, 
                 fim   => s_tick, 
                 meio  => open
             );
 
    -- saida
    dado_serial <= s_dado_serial;

    -- debug
    db_clock   <= clock;
    db_tick    <= s_tick;
    db_partida <= partida;
    db_dado_serial <= s_dado_serial;

end architecture;
