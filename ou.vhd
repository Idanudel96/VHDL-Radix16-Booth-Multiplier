library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ou is
    generic (
        N : integer
    );
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
end entity;


architecture arc_ou of ou is

    -- Internal registers
    signal reg_A      : signed(2*N-1 downto 0) := (others => '0');
    signal reg_B      : signed(N downto 0)     := (others => '0');
    signal acc        : signed(2*N-1 downto 0) := (others => '0');
    signal step_count : integer range 0 to 2*N := 0;

begin

    process(clk, reset)
        variable window     : signed(4 downto 0);
        variable digit      : integer range -16 to 15;
        variable partial    : signed(2*N-1 downto 0);
        variable shifted    : signed(2*N-1 downto 0);
        variable A_ext      : signed(2*N-1 downto 0);
    begin
        if reset = '1' then
            acc        <= (others => '0');
            step_count <= 0;
            reg_A      <= (others => '0');
            reg_B      <= (others => '0');
            reg_B(0)   <= '1';
        elsif rising_edge(clk) then
            -- Load new inputs and reset internal state
            if load = '1' then
                acc        <= (others => '0');
                step_count <= 0;
                reg_A      <= resize(signed(A), 2*N);
                reg_B <= signed(B & '0');

                

            -- Perform one Booth step when enabled
            elsif shift_en = '1' then
                window  := reg_B(4 downto 0);
                digit   := to_integer(window);
                A_ext   := reg_A;

                -- Determine the partial product according to the Booth digit
                case digit is
                    when 0 | -1           => partial := (others => '0');
                    when 1 | 2            => partial := A_ext;
                    when 3 | 4            => partial := A_ext sll 1;
                    when 5 | 6            => partial := A_ext + (A_ext sll 1);
                    when 7 | 8            => partial := A_ext sll 2;
                    when 9 | 10           => partial := (A_ext sll 2) + A_ext;
                    when 11 | 12          => partial := (A_ext sll 2) + (A_ext sll 1);
                    when 13 | 14          => partial := (A_ext sll 2) + (A_ext sll 1) + A_ext;
                    when 15               => partial := A_ext sll 3;
                    when -16              => partial := -(A_ext sll 3);
                    when -15 | -14        => partial := -((A_ext sll 2) + (A_ext sll 1) + A_ext);
                    when -13 | -12        => partial := -((A_ext sll 2) + (A_ext sll 1));
                    when -11 | -10        => partial := -((A_ext sll 2) + A_ext);
                    when -9 | -8          => partial := -(A_ext sll 2);
                    when -7 | -6          => partial := -(A_ext + (A_ext sll 1));
                    when -5 | -4          => partial := -(A_ext sll 1);
                    when -3 | -2          => partial := -A_ext;
                    when others           => partial := (others => '0');
                end case;

                -- Shift and accumulate the partial product
                shifted    := shift_left(partial, step_count);
                acc        <= acc + shifted;
                reg_B      <= shift_right(reg_B, 4);
                step_count <= step_count + 4;
            end if;
        end if;
    end process;

    -- Signal finish when all digits have been processed
    finish  <= '1' when to_integer(reg_B) = 0 or to_integer(reg_B) = -1 else '0';

    -- Final multiplication result
    product <= std_logic_vector(acc);

end architecture;

