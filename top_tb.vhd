library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end entity;

architecture sim of top_tb is
    constant N : integer := 8;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal start   : std_logic := '0';
    signal A, B    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal P       : std_logic_vector(2*N-1 downto 0);
    signal done    : std_logic;

begin

    -- DUT instantiation
    DUT: entity work.top
        generic map (N => N)
        port map (
            clk   => clk,
            reset => reset,
            start => start,
            A     => A,
            B     => B,
            P     => P,
            done  => done
        );

    -- Clock generation
    clk <= not clk after 10 ns;

       process
        type int_pair is record
            a : integer;
            b : integer;
        end record;

        type pair_array is array (0 to 6) of int_pair;

        constant tests : pair_array := (
            (a =>  3, b =>  4),
            (a => -5, b =>  6),
            (a =>  7, b => -8),
            (a => -9, b => -2),
            (a =>  0, b => 15),
            (a => 12, b =>  0),
            (a => -7, b =>  7)
        );

        variable expected : integer;
    begin
        -- Apply initial reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        for i in 0 to 6 loop
            -- Apply reset between test cases
            reset <= '1';
            wait for 20 ns;
            reset <= '0';
            wait for 20 ns;

            A <= std_logic_vector(to_signed(tests(i).a, N));
            B <= std_logic_vector(to_signed(tests(i).b, N));
            expected := tests(i).a * tests(i).b;

            wait until rising_edge(clk);
            start <= '1';
            wait until rising_edge(clk);
            start <= '0';

            -- Wait for multiplication to complete
            wait until rising_edge(clk) and done = '1';

            -- Extra clock cycle before next test
            wait until rising_edge(clk);

            -- Check result
            assert to_integer(signed(P)) = expected
            report "Test failed at index " & integer'image(i) &
                   ": A=" & integer'image(tests(i).a) &
                   ", B=" & integer'image(tests(i).b) &
                   ", Expected=" & integer'image(expected) &
                   ", Got=" & integer'image(to_integer(signed(P)))
            severity error;
        end loop;

        report "All multiplication tests passed.";
        wait;
    end process;
 -- Stimulus process
    

end architecture;

