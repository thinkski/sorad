library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cic_tb is
end cic_tb;

architecture behavioral of cic_tb is
	component cic
		generic (
			B	: integer := 8;
			N	: integer := 4;
			R	: integer := 2
		);
		port (
			clk	: in	std_logic;
			nreset	: in	std_logic;
			din	: in	signed (B-1 downto 0);
			clkout	: out	std_logic;
			dout	: out	signed (B-1 downto 0)
		);
	end component;

	for cic_0: cic use entity work.cic;

	signal din	: signed (7 downto 0);
	signal dout	: signed (7 downto 0);
	signal clk	: std_logic;
	signal clkout	: std_logic;
	signal nreset	: std_logic;

	signal end_sim	: boolean := false;
begin

	-- component instantiation
	cic_0: cic
		generic map (B=>8, N=>4, R=>2)
		port map (clk    => clk,
		          nreset => nreset,
		          din    => din,
		          clkout => clkout,
		          dout   => dout);

	-- generate input values
	process
		type pattern_type is record
			-- The inputs
			nreset	: std_logic;
			din	: signed (7 downto 0);
			-- The expected outputs
			clkout	: std_logic;
			dout	: signed (7 downto 0);
		end record;

		-- Patterns to apply
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
		('0', x"00", '0', x"00"),
		('1', x"5a", '0', x"01"),
		('1', x"7f", '0', x"01"),
		('1', x"5a", '0', x"ff"),
		('1', x"00", '0', x"fe"),
		('1', x"a6", '0', x"80"),
		('1', x"81", '0', x"00"),
		('1', x"a6", '0', x"01"),
		('1', x"00", '0', x"01"),
		('1', x"5a", '0', x"ff"),
		('1', x"7f", '0', x"fe"),
		('1', x"5a", '0', x"80"),
		('1', x"00", '0', x"00"),
		('1', x"a6", '0', x"01"),
		('1', x"81", '0', x"01"),
		('1', x"a6", '0', x"ff"),
		('1', x"00", '0', x"01"),
		('1', x"5a", '0', x"ff"),
		('1', x"7f", '0', x"fe"),
		('1', x"5a", '0', x"80"),
		('1', x"00", '0', x"00"),
		('1', x"a6", '0', x"01"),
		('1', x"81", '0', x"01"),
		('1', x"a6", '0', x"01"),
		('1', x"00", '0', x"01"),
		('1', x"5a", '0', x"ff"),
		('1', x"7f", '0', x"fe"),
		('1', x"5a", '0', x"80"),
		('1', x"00", '0', x"00"),
		('1', x"a6", '0', x"01"),
		('1', x"81", '0', x"01"),
		('1', x"a6", '0', x"01"),
		('1', x"00", '0', x"01"),
		('1', x"5a", '0', x"ff"),
		('1', x"7f", '0', x"fe"),
		('1', x"5a", '0', x"80"),
		('1', x"00", '0', x"00"),
		('1', x"a6", '0', x"01"),
		('1', x"81", '0', x"01"),
		('1', x"a6", '0', x"01"),
		('1', x"00", '0', x"01"),
		('1', x"5a", '0', x"ff"),
		('1', x"7f", '0', x"fe"),
		('1', x"5a", '0', x"80"),
		('1', x"00", '0', x"00"),
		('1', x"a6", '0', x"01"),
		('1', x"81", '0', x"01"),
		('1', x"a6", '0', x"01"),
		('1', x"00", '0', x"01"),
		('1', x"5a", '0', x"ff"),
		('1', x"7f", '0', x"fe"),
		('1', x"5a", '0', x"80"),
		('1', x"00", '0', x"00"),
		('1', x"a6", '0', x"01"),
		('1', x"81", '0', x"01")
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
			assert clkout = patterns(i).clkout
				report "bad clock output value" severity error;
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
