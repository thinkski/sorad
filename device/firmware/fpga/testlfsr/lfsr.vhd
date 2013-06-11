-- library declarations
library ieee;
use ieee.std_logic_1164.all;

--entity declaration
entity lfsr is
	port (
		clk	: in	std_logic;
		reset	: in	std_logic;
		q		: out	std_logic_vector(15 downto 0);
		gate	: out	std_logic
	);
end lfsr;

-- dataflow implementation
architecture dataflow of lfsr is
	signal lfsr	:	std_logic_vector(15 downto 0);
begin
	-- generate d flip flops
	process (clk)
	begin
		if (clk'event and clk = '1') then
			if (lfsr(15 downto 0) = "0000000000000000") then
				lfsr(15 downto 0) <= "1000000000000000";
			else
				-- implement linear feedback shift register
				lfsr(15 downto 0) <=
					lfsr(14 downto 0) &
					(lfsr(15) xor lfsr(4) xor lfsr(2) xor lfsr(1));
			end if;
		end if;
	end process;
	
	-- drive output
	q(15 downto 0) <= lfsr(15 downto 0);
	gate <= clk;
	
end dataflow;