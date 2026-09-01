library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    generic (
        N : integer := 8  -- bit width of inputs
    );
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        start : in  std_logic;
        A     : in  std_logic_vector(N-1 downto 0);
        B     : in  std_logic_vector(N-1 downto 0);

        P     : out std_logic_vector(2*N-1 downto 0);
        done  : out std_logic
    );
end entity;

architecture arc_top of top is

    -- Internal control signals between CU and OU
    signal load         : std_logic;
    signal shift_en     : std_logic;
    signal finish       : std_logic;
    signal product      : std_logic_vector(2*N-1 downto 0);

    -- Component declarations
    component cu is
        port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            start        : in  std_logic;
            done_calc         : in  std_logic;
            load_data         : out std_logic;
            shift_enable : out std_logic;
            finish       : out std_logic
        );
    end component;

    component ou is
        generic ( N : integer );
        port (
            clk      : in  std_logic;
            reset    : in  std_logic;
            load     : in  std_logic;
            shift_en : in  std_logic;
            A        : in  std_logic_vector(N-1 downto 0);
            B        : in  std_logic_vector(N-1 downto 0);
            finish   : out std_logic;
            product  : out std_logic_vector(2*N-1 downto 0)
        );
    end component;

begin

    -- Operational Unit
    u_ou: ou
        generic map (N => N)
        port map (
            clk      => clk,
            reset    => reset,
            load     => load,
            shift_en => shift_en,
            A        => A,
            B        => B,
            finish   => finish,
            product  => product
        );

    -- Control Unit
    u_cu: cu
        port map (
            clk          => clk,
            reset        => reset,
            start        => start,
            done_calc         => finish,
            load_data         => load,
            shift_enable => shift_en,
            finish       => done
        );

    -- Output assignment
    P <= product;

end architecture;
