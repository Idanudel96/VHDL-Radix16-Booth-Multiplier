library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cu is
    port (
        clk              : in  std_logic;
        reset            : in  std_logic;
        start            : in  std_logic;
        done_calc        : in  std_logic;

        load_data    : out std_logic;
        shift_enable : out std_logic;
        finish       : out std_logic
    );
end entity;

architecture arc_cu of cu is
    type state is (IDLE, LOAD, SHIFT, DONE);
    signal current_state : state := IDLE;
begin

    process(clk, reset)
        variable next_state : state;
    begin
        if reset = '1' then
            current_state <= IDLE;
            load_data     <= '0';
            shift_enable  <= '0';
            finish        <= '0';

        elsif rising_edge(clk) then
            -- Default outputs (inactive)
            load_data     <= '0';
            shift_enable  <= '0';
            finish        <= '0';

            -- Next state logic & outputs
            case current_state is
                when IDLE =>
                    if start = '1' then
                        next_state := LOAD;
                    else
                        next_state := IDLE;
                    end if;

                when LOAD =>
                    load_data <= '1';
                        next_state := SHIFT;
                  

                when SHIFT =>
                    shift_enable <= '1';
                    if done_calc = '1' then
                        next_state := DONE;
                    else
                        next_state := SHIFT;
                    end if;

                when DONE =>
                    finish <= '1';
                    next_state := IDLE;

                when others =>
                    next_state := IDLE;
            end case;

            -- Update state
            current_state <= next_state;
        end if;
    end process;

end architecture;


