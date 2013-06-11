------------------------------------------------------------------------------
--
-- FILE
--	testbench.vhd
--
-- DESCRIPTION
--	This is a VHDL testbench for intg_unit.vhd.
--
-- AUTHOR
--	Chris Hiszpanski <chiszp@gmail.com>
--
-- Copyright (C) 2009 Alpha Devices LLC. All rights reserved.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity intg_unit_tb is
end intg_unit_tb;

architecture behavioral of intg_unit_tb is
	constant SIZE		: integer		:= 8;

	component intg_unit
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

	for intg_unit_0: intg_unit use entity work.intg_unit;

	signal din	: signed (SIZE-1 downto 0)	:= (others => '0');
	signal dout	: signed (SIZE-1 downto 0);
	signal clk	: std_logic			:= '0';
	signal nreset	: std_logic			:= '1';

begin

	-- add component
	intg_unit_0: intg_unit
		generic map (SIZE=>8)
		port map (clk=>clk, nreset=>nreset, din=>din, dout=>dout);

	-- generate input values
	process
	begin
		clk	<= '0';
		nreset	<= '0';
		din	<= x"01";
		wait for 5 ns;

		clk	<= '1';
		nreset	<= '0';
		din	<= x"01";
		wait for 5 ns;

		clk	<= '0';
		nreset	<= '1';
		din	<= x"01";
		wait for 5 ns;

		clk	<= '1';
		nreset	<= '1';
		din	<= x"01";
		wait for 5 ns;

		clk	<= '0';
		nreset	<= '1';
		din	<= x"fe";
		wait for 5 ns;

		clk	<= '1';
		nreset	<= '1';
		din	<= x"fe";
		wait for 5 ns;

		clk	<= '0';
		nreset	<= '1';
		din	<= x"01";
		wait for 5 ns;

		clk	<= '1';
		nreset	<= '1';
		din	<= x"01";
		wait for 5 ns;

		clk	<= '0';
		nreset	<= '1';
		din	<= x"01";
		wait for 5 ns;

		clk	<= '1';
		nreset	<= '1';
		din	<= x"01";
		wait for 5 ns;

		clk	<= '0';
		nreset	<= '1';
		din	<= x"01";

		wait;

	end process;

end behavioral;
