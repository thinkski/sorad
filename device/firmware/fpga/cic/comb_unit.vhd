------------------------------------------------------------------------------
--
-- Cascaded Integrator-Comb (CIC) Filter
-- Comb Unit
--
-- DESCRIPTION
--	This is a VHDL implementation of a single comb stage for a CIC filter.
--	The feed-forward coefficient is negative unity. The differential delay
--	is one. The stage is designed for pipelining.
--
-- PARAMETERS
--	size		Size of data register. Data input and output are same
--			size.
--
-- INPUT
--	clk		Clock
--	nreset		Active-low asynchronous reset
--	din		Signed two's complement input data
--
-- OUTPUT
--	dout		Signed two's complement output data
--
-- AUTHOR
--	Chris Hiszpanski <chiszp@gmail.com>
--
-- HISTORY
--	Mar 26 2007	Initial revision.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
                                        
-- Filter declaration
entity comb_unit is
	-- Generic parameters
	generic (
		SIZE	: integer
	);

	-- Port declaration
	port (
		clk	: in	std_logic;
		nreset	: in	std_logic;
		din	: in	signed (SIZE-1 downto 0);
		dout	: out	signed (SIZE-1 downto 0)
	);
end comb_unit;

-- CIC filter integration unit architecture
architecture dataflow of comb_unit is
	-- Differential delay register
	signal delay	:	signed (SIZE-1 downto 0);
	-- Difference register
	signal diff	:	signed (SIZE-1 downto 0);
begin

	-- Synthesize delay flip flops
	process (clk, nreset)
	begin

		-- Asynchronous active-low reset
		if (nreset = '0') then
			delay (SIZE-1 downto 0) <= (others => '0');
			diff  (SIZE-1 downto 0) <= (others => '0');

		-- Rising clock edge
		elsif (clk'event and clk = '1') then
			-- Propagate differential delay
			delay (SIZE-1 downto 0) <= din (SIZE-1 downto 0);
                
			-- Propagate combing difference
			diff (SIZE-1 downto 0) <=
				din   (SIZE-1 downto 0) -
				delay (SIZE-1 downto 0);
		end if;

	end process;
    
	-- Drive output
	dout (SIZE-1 downto 0) <= diff (SIZE-1 downto 0);

end dataflow;
