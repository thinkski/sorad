------------------------------------------------------------------------------
--
-- Cascaded Integrator-Comb (CIC) Filter
-- Main Unit
--
-- DESCRIPTION
--	This is a VHDL implementation of a cascaded integrator-comb
--	filter, as described in "An Economical Class of Digital
--	Filters for Decimation and Interpolation" by E. B. Hogenauer.
--	This core only implements decimation.
--
--	The filter implemented is a low-pass, multi-rate, decimating
--	filter. Full precision is used for all stages -- no truncation
--	occurs. Differential delay is fixed at 1.
--
-- PARAMETERS
--	B		Number of bits in data
--	N		Number of stage pairs
--	R		Rate change factor
--
-- INPUT
--	clk		Clock
--	nreset		Active-low asynchronous reset
--	din		Signed two's complement input data
--
-- OUTPUT
--	clkout		Output clock. Data valid on rising edge.
--	dout		Signed two's complement output data
--
-- AUTHOR
--	Chris Hiszpanski <chiszp@gmail.com>
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
                                        
-- Filter declaration
entity cic is

	-- Generic parameters
	generic (
		B	: integer;	-- Number of bits in data
		N	: integer;	-- Number of stage pairs
		R	: integer	-- Rate change factor
	);

	-- Port declaration
	port (
		clk	: in	std_logic;
		nreset	: in	std_logic;
		din	: in	signed (B-1 downto 0);

		clkout	: out	std_logic;
		dout	: out	signed (B-1 downto 0)
	);

end cic;

-- Filter architecture
architecture dataflow of cic is

	--
	-- Component definitions
	--

	-- Integration unit
	component intg_unit is
		generic (
			SIZE	:	integer
		);

		port (
			clk	: in	std_logic;
			nreset	: in	std_logic;
			din	: in	signed (SIZE-1 downto 0);
			dout	: out	signed (SIZE-1 downto 0)
		);
	end component intg_unit;
    
	-- Comb unit
	component comb_unit is
		generic (
			SIZE	:	integer
		);

		port (
			clk	: in	std_logic;
			nreset	: in	std_logic;
			din	: in	signed (SIZE-1 downto 0);
			dout	: out	signed (SIZE-1 downto 0)
		);
	end component comb_unit;
    
	--
	-- Constants
	--

	-- Compute the required number of register bits for full precision:
	--     b_max = ceil(N*log2(R*M) + WIDTH - 1)
	-- where M is the differential delay and is fixed at 1
	constant BMAX : integer :=
		integer(ceil(real(N)*log2(real(R)) + real(B) - 1.0));
            
	--
	-- Type declarations
	-- 

	-- Define register and register vector types
	subtype column is signed (BMAX-1 downto 0);
	type interconnect is array (integer range <>) of column;

	--
	-- Signal definitions
	--

	-- Interconnect
	signal intgbus	: interconnect (N downto 0);
	signal combbus	: interconnect (N downto 0);

	-- Register for up-counter to rate change factor
	signal count	: unsigned (R-1 downto 0);

	-- Decimated clock
	signal dclk	: std_logic;

begin

	-- Feed integrators
	intgbus(0)(B-1 downto 0)    <= din (B-1 downto 0);
	intgbus(0)(BMAX-1 downto B) <= (others => din (din'high));

	-- Integrator cascade
	integrators: for i in 0 to N-1 generate
	begin
		intg: intg_unit
			generic map (SIZE => BMAX)
			port map (
				clk	=> clk,
				nreset	=> nreset,
				din	=> intgbus(i),
				dout	=> intgbus(i+1)
			);
	end generate;
    
	-- Decimate
	process (clk, nreset)
		variable count : integer range 0 to R-1;
	begin
		-- Active-low asynchronous reset
		if (nreset = '0') then
			count := 0;
			dclk <= '0';

		-- Rising clock edge
		elsif (clk'event and clk = '1') then
			count := (count + 1) mod R;

			if (count < R/2) then
				dclk <= '0';
			else
				dclk <= '1';
			end if;
		end if;
	end process;
    
	-- Feed combs
	combbus(0)(BMAX-1 downto 0) <= intgbus(N)(BMAX-1 downto 0);

	-- Comb cascade
	combs: for i in 0 to N-1 generate
	begin
		comb: comb_unit
			generic map (
				SIZE => BMAX
			)
			port map (
				clk	=> dclk,
				nreset	=> nreset,
				din	=> combbus(i),
				dout	=> combbus(i+1)
			);
	end generate;
    
	-- Drive filter and decimated clock outputs
	dout (B-1 downto 0) <= combbus(N)(BMAX-1 downto BMAX-B);
	clkout              <= dclk;

end dataflow;
