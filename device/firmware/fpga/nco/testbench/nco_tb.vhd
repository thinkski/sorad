--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:06:47 05/28/2009
-- Design Name:   
-- Module Name:   E:/WORK/VHDL/NCO/nco_TB.vhd
-- Project Name:  NCO
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: nco
-- 
-- Dependencies:
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
USE ieee.std_logic_arith.ALL;
 
ENTITY nco_TB IS
END nco_TB;
 
ARCHITECTURE behavior OF nco_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT nco
    PORT(
         clk : IN  std_logic;
         reset_n : IN  std_logic;
         load : IN  std_logic;
         phi_inc_i : IN  unsigned(7 downto 0);
         fcos_o : OUT  signed(7 downto 0);
         fsin_o : OUT  signed(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset_n : std_logic := '0';
   signal load : std_logic := '0';
   signal phi_inc_i : unsigned(7 downto 0) := (others => '0');

 	--Outputs
   signal fcos_o : signed(7 downto 0);
   signal fsin_o : signed(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: nco PORT MAP (
          clk => clk,
          reset_n => reset_n,
          load => load,
          phi_inc_i => phi_inc_i,
          fcos_o => fcos_o,
          fsin_o => fsin_o
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ns.
      wait for 100ns;	

      wait for clk_period*10;

      -- insert stimulus here
      reset_n <= '0';
      load <= '0';
      wait for clk_period*2;
      
      reset_n <= '1';
      wait for clk_period*2;
      
      load <= '1';
      phi_inc_i <= "00010010";
      wait for clk_period*2;
      
      load <= '0';
      wait for clk_period*10;
      

      wait;
   end process;

END;
