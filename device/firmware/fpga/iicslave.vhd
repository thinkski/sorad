------------------------------------------------------------------------------
--
-- FILE
--	iicslave.vhd
--
-- DESCRIPTION
--	Synthesizable inter-integrated circuit (I2C) bus slave node.
--
-- PARAMETERS
--	ADDRESS	Address of node on the bus
--
-- INPUTS
--	clk	Core clock; should be at least 4x faster than bus clock
--	reset_n	Active-low asynchronous reset; resets finite state machine
--	scl	Serial bus clock
--	sda	Serial bus data
--
-- OUTPUTS
--	sda	Serial bus data
--	rdy	Active-high ready bit signalling when 'data' available
--	dout	Output register
--
-- AUTHOR
--	Copyright (C) 2009 Alpha Devices. All rights reserved.
--
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY iicslave IS
	GENERIC (
		ADDRESS	: NATURAL RANGE 0 TO 127 := 42
	);
	
	PORT (
		clk	: IN	STD_LOGIC;
		reset_n	: IN	STD_LOGIC;
		scl	: IN	STD_LOGIC;
		
		sda	: INOUT	STD_LOGIC;
		
		rdy	: OUT	STD_LOGIC;
		dout	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END iicslave;

ARCHITECTURE rtl OF iicslave IS
	SIGNAL start : STD_LOGIC;
	SIGNAL stop : STD_LOGIC;
	SIGNAL bitcount : NATURAL RANGE 0 TO 7;
BEGIN
	-- Detects master-issued START condition
	startfsm: PROCESS (clk, reset_n)
		TYPE state IS (init, wait_on_sda, wait_on_scl, done);
		VARIABLE mystate : state;
	BEGIN
		IF (reset_n = '0') THEN
			mystate := init;
		ELSIF (clk'EVENT AND clk = '1') THEN
			CASE mystate IS
				WHEN init =>
					start <= '0';
					IF (scl = '1' AND sda = '1') THEN
						mystate := wait_on_sda;
					ELSE
						mystate := init;
					END IF;
				WHEN wait_on_sda =>
					start <= '0';
					IF (scl = '1' AND sda = '0') THEN
						mystate := wait_on_scl;
					ELSIF (scl = '1' AND sda = '1') THEN
						mystate := wait_on_sda;
					ELSE
						mystate := init;
					END IF;
				WHEN wait_on_scl =>
					start <= '0';
					IF (scl = '0' AND sda = '0') THEN
						mystate := done;
					ELSIF (scl = '1' AND sda = '0') THEN
						mystate := wait_on_scl;
					ELSE
						mystate := init;
					END IF;
				WHEN done =>
					start <= '1';
					mystate := init;
				WHEN OTHERS =>
					start <= '0';
					mystate := init;
			END CASE;
		END IF;
	END PROCESS;
	
	-- Detects master-issued STOP condition
	stopfsm: PROCESS (clk, reset_n)
		TYPE state IS (init, wait_on_sda, done);
		VARIABLE mystate : state;
	BEGIN
		IF (reset_n = '0') THEN
			mystate := init;
		ELSIF (clk'EVENT AND clk = '1') THEN
			CASE mystate IS
				WHEN init =>
					stop <= '0';
					IF (scl = '1' AND sda = '0') THEN
						mystate := wait_on_sda;
					ELSE
						mystate := init;
					END IF;
				WHEN wait_on_sda =>
					stop <= '0';
					IF (scl = '1' AND sda = '1') THEN
						mystate := done;
					ELSIF (scl = '1' AND sda = '0') THEN
						mystate := wait_on_sda;
					ELSE
						mystate := init;
					END IF;
				WHEN done =>
					stop <= '1';
					mystate := init;
				WHEN OTHERS =>
					stop <= '0';
					mystate := init;
			END CASE;
		END IF;
	END PROCESS;

--	sample: PROCESS (scl)
--	BEGIN
--		IF (scl'EVENT and scl = '1') THEN
--			IF (state = data) THEN
--				dout(7 DOWNTO 0) <= dout(6 DOWNTO 0) & sda; 
--			END IF;
--		END IF;
--	END PROCESS;
END rtl;
