
--------------------------------------------------------------------------------
-- Company:       None
-- Engineer:      Chris Hiszpanski, <chiszp@hotmail.com>
--
-- Create Date:   06:13:24 02/17/2007
-- Design Name:   cordic
-- Module Name:   C:/sdr/vhdl/cordic_tb.vhd
-- Project Name:  sdr
-- Target Device: Xilinx Spartan-3E XC3S250E
-- Tool versions: Xilinx ISE WebPack 9.1i
-- Description:   Non-exhaustively test sine and cosine computation for various
--                angles. Note that the unit under test contains a pipeline.
-- 
-- VHDL Test Bench Created by ISE for module: cordic
--
-- Dependencies:  cordic.vhd, cordic_step.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

ENTITY cordic_tb_vhd IS
    generic (
        width : integer := 12
    );
END cordic_tb_vhd;

ARCHITECTURE behavior OF cordic_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT cordic
    generic(
        width : integer := 12
    );
	PORT(
		clk : IN std_logic;
		angle : IN std_logic_vector(11 downto 0);          
		sin : OUT std_logic_vector(11 downto 0);
		cos : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL angle :  std_logic_vector(11 downto 0) := (others=>'0');

	--Outputs
	SIGNAL sin :  std_logic_vector(11 downto 0);
	SIGNAL cos :  std_logic_vector(11 downto 0);
    
    signal end_sim : boolean := false;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: cordic PORT MAP(
		clk => clk,
		angle => angle,
		sin => sin,
		cos => cos
	);

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Place stimulus here
        
        -- tenth clock rising edge
        tests: for i in 0 to 2**WIDTH-1 loop
            angle <= std_logic_vector(signed(conv_std_logic_vector(i ,WIDTH)));
            wait for 10 ns;
        end loop;

        -- empty pipeline
        wait for 110 ns;

        -- end of simulation
        end_sim <= true;
        
		wait; -- will wait forever
	END PROCESS;
    
    -- generate 10ns clock
    clock: process
    begin
    
        if end_sim = false then
            -- clock high
            clk <= '1';
            wait for 5ns;
        else
            wait;
        end if;
    
        if end_sim = false then
            -- clock low
            clk <= '0';
            wait for 5ns;
        else
            wait;
        end if;
    
    end process;

END;
