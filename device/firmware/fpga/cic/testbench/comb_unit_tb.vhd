library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comb_unit_tb is
end comb_unit_tb;

architecture behavioral of comb_unit_tb is
	component comb_unit
		generic (
			SIZE	: integer
		);
		port (
			clk	: in	std_logic;
			nreset	: in	std_logic;
			din	: in	signed (SIZE-1 downto 0);
			dout	: out	signed (SIZE-1 downto 0)
		);
	end component;

	for comb_unit_0: comb_unit use entity work.comb_unit;

	signal din	: signed (7 downto 0);
	signal dout	: signed (7 downto 0);
	signal clk	: std_logic;
	signal nreset	: std_logic;

	signal end_sim	: boolean := false;
begin

	-- component instantiation
	comb_unit_0: comb_unit
		generic map (SIZE=>8)
		port map (clk=>clk, nreset=>nreset, din=>din, dout=>dout);

	-- generate input values
	process
		type pattern_type is record
			-- The inputs
			nreset	: std_logic;
			din	: signed (7 downto 0);
			-- The expected outputs
			dout	: signed (7 downto 0);
		end record;

		-- Patterns to apply
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
		('0', x"00", x"00"),
		('1', x"01", x"01"),
		('1', x"02", x"01"),
		('1', x"01", x"ff"),
		('1', x"ff", x"fe"),
		('1', x"7f", x"80"),
		('1', x"80", x"01")
		);
	begin
		for i in patterns'range loop
			-- Set the inputs
			nreset <= patterns(i).nreset;
			din <= patterns(i).din;

			-- Wait for the results
			wait for 10 ns;

			-- Check the outputs
			assert dout = patterns(i).dout
				report "bad output value" severity error;
		end loop;
		assert false report "end of test" severity note;
		end_sim <= true;
		-- Wait forever; this will finish the simulation.
		wait;
	end process;

	process
	begin
		while end_sim = false loop
			clk <= '1';
			wait for 5 ns;
			clk <= '0';
			wait for 5 ns;
		end loop;
		-- Wait forever; this will finish the simulation.
		wait;
	end process;
end behavioral;
