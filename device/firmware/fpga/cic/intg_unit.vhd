------------------------------------------------------------------------------
--
-- Cascaded Integrator-Comb (CIC) Filter
-- Integration Unit
--
-- DESCRIPTION
--	This is a VHDL implementation of a single integration stage for a CIC
--	filter. The feedback coefficient is unity. The stage is designed for
--	pipelining.
--
-- INPUT
--	clk		Clock
--	nreset		Active-low asynchronous reset
--	din		Signed input data using two's complement.
--
-- OUTPUT
--	dout		Signed output data using two's complement.
--
-- AUTHOR
--	Chris Hiszpanski <chiszp@gmail.com>
--
-- HISTORY
--	Mar 26 2007	Initial revision.
--	Dec 18 2009	Replaced ieee.std_logic_signed with ieee.numeric_std.
--			The latter is an IEEE standard. Functionally
--			simulated for correctness using GHDL 0.26.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

                                        
-- Filter declaration
entity intg_unit is

	-- Generic parameters
	generic (
		-- Register width (in bits)
		SIZE	: integer
	);

	-- Port declaration
	port (
		clk	: in	std_logic;
		nreset	: in	std_logic;
		din	: in	signed (SIZE-1 downto 0);
		dout	: out	signed (SIZE-1 downto 0)
	);

end intg_unit;


-- CIC filter integration unit architecture
architecture dataflow of intg_unit is

	-- Integration register
	signal	sum	:	signed (SIZE-1 downto 0);

begin

	-- Synthesize delay flip flops
	process (clk, nreset)
	begin
		-- Asynchronous active-low reset
		if (nreset = '0') then
			sum (SIZE-1 downto 0) <= (others => '0');

		-- Rising clock edge
		elsif (clk'event and clk = '1') then
			-- Integrate
			sum (SIZE-1 downto 0) <= sum (SIZE-1 downto 0) +
			                         din (SIZE-1 downto 0);
		end if;
	end process;
    
    -- Drive output with sum
    dout (SIZE-1 downto 0) <= sum (SIZE-1 downto 0);

end dataflow;
