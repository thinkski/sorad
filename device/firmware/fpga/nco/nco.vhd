------------------------------------------------------------------------------
--
-- FILE
--	nco.vhd
--
-- DESCRIPTION
--	Synthesizable numerically controlled oscillator. Uses a ROM (computed
--	at compile time) to look-up sine/cosine values. The ROM contains
--	entries for the positive-half cycle.
--
-- PARAMETERS
--	A		Angular precision: 2^A is the number of words in ROM.
--	M		Magnitude precision: number of bits in each output.
--	P		Phase precision: number of bits in phase accumulator.
--
-- INPUTS
--	clk		Clock
--	reset_n		Active-low asynchronous reset; zeros phase accumulator
--	load		Active-high gating signal to latch value on phi_inc_i
--	phi_inc_i	Value of phase increment per clock (bus)
--
-- OUTPUTS
--	fcos_o		Cosine output (bus)
--	fsin_o		Sine output (bus)
--
-- AUTHOR
--	Copyright (C) 2009 Alpha Devices. All rights reserved.
--
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.math_real.all;

ENTITY nco IS
	GENERIC (
		A		: INTEGER := 10;
		M		: INTEGER := 12;
		P		: INTEGER := 28
	);

	PORT (
		clk		: IN	STD_LOGIC;
		reset_n		: IN	STD_LOGIC;
		load		: IN	STD_LOGIC;
		phi_inc_i	: IN	UNSIGNED(P-1 DOWNTO 0);
		fcos_o		: OUT	SIGNED(M-1 DOWNTO 0);
		fsin_o		: OUT	SIGNED(M-1 DOWNTO 0)
	);
END nco;

ARCHITECTURE rtl OF nco IS
	-- Maximum value that ROM entry can hold. Entries are signed.
	CONSTANT rommax: INTEGER := 2**(M-1)-1;

	-- ROM size is half cycle long
	CONSTANT romsize: INTEGER := 2**A;

	SIGNAL   phacc: UNSIGNED(P-1 DOWNTO 0);
	SIGNAL   phinc: UNSIGNED(P-1 DOWNTO 0);

	TYPE signed_array IS ARRAY(0 TO romsize-1) OF SIGNED(M-1 DOWNTO 0);
	SIGNAL   rom: signed_array;	
	
BEGIN

	-- Generate ROM containing full cycle of sine function
	genrom: FOR idx IN 0 TO romsize-1 GENERATE
	BEGIN
		rom(idx) <=
			CONV_SIGNED( INTEGER(
				SIN(
					2.0*MATH_PI*REAL(idx)/REAL(rommax)
				) * REAL(rommax)
			), M);
	END GENERATE;

	-- Resets, loads, and increments phase
	PROCESS (clk, reset_n)
	BEGIN
		IF (reset_n = '0') THEN
			phacc <= (OTHERS => '0');
			phinc <= (OTHERS => '0');
		ELSIF (clk'EVENT AND clk = '1') THEN
			-- Load phase accumulator increment value
			IF (load = '1') THEN
				phinc <= phi_inc_i;
			END IF;
			
			-- Increment the phase accumulator
			phacc <= phacc + phinc;
		END IF;
	END PROCESS;
	
	-- Drive sine and cosine outputs with ROM word, selected using
	-- the high order bits of the phase accumulator
	fcos_o <= rom(CONV_INTEGER(phacc(P-1 DOWNTO P-1-(A-1))));
	fsin_o <= rom(CONV_INTEGER(phacc(P-1 DOWNTO P-1-(A-1))));

END rtl;
