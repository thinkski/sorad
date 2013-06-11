----------------------------------------------------------------------------------
--
-- CORDIC (Coordinate Rotation Digital Computer) Processor
--
-- Description: Compute sine and cosine for given angle.
--
-- Target:      Xilinx Spartan-3E XC3S250E-4TQ144
-- Synthesizer: Xilinx XST 9.1i
--
-- Author:      Chris Hiszpanski, <chiszp@hotmail.com>
--
-- Revisions: 
-- Feb 16 2007  Initial revision.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity cordic is
    -- Generic parameters
    generic (
        -- Size of vector component (in bits)
        WIDTH   : integer := 12
    );

    -- Port declaration
    port (
        -- Clock (one sin and cos sample output per clock)
        clk     : in    std_logic;
        
        -- Input angle
        angle   : in    std_logic_vector(WIDTH-1 downto 0);
        
        -- Computed sine of angle
        sin     : out   std_logic_vector(WIDTH-1 downto 0);
        -- Computed cosine of angle
        cos     : out   std_logic_vector(WIDTH-1 downto 0)
    );
end cordic;

architecture dataflow of cordic is

    -- Define bus subtype and bus vector type
    subtype std_bus is std_logic_vector(WIDTH-1 downto 0);
    type std_bus_vector is array (integer range <>) of std_bus;

    -- CORDIC step component declaration
    component cordic_step is
        generic (
            -- Size of vector component (in bits)
            WIDTH	: integer;
            -- CORDIC step number (i.e. unrolled iteration number)
            STEPNUM	: integer
        );
                
        port (
            -- Clock (one sample output per clock)
            clk : in    std_logic;
                
            -- Input vector components
            xi  : in    std_logic_vector(WIDTH-1 downto 0);
            yi  : in    std_logic_vector(WIDTH-1 downto 0);
            -- Rotation angle
            zi  : in    std_logic_vector(WIDTH-1 downto 0);

            -- Rotated vector components
            xo  : out   std_logic_vector(WIDTH-1 downto 0);
            yo  : out   std_logic_vector(WIDTH-1 downto 0);
            -- Remaining rotation angle 
            zo  : out   std_logic_vector(WIDTH-1 downto 0)                        
        );
    end component cordic_step;
        
    -- Intermediate signals
    signal  x   : std_bus_vector(WIDTH-1 downto 0);
    signal  y   : std_bus_vector(WIDTH-1 downto 0);
    signal  z   : std_bus_vector(WIDTH-1 downto 0);
begin

    -- Initial vector <x_0,y_0> = <1,0>: Result scaled by ~1.647, so
    -- let x_0 be half it's maximum signed value to prevent overflow.
    x(0)(WIDTH-1 downto 0) <= conv_std_logic_vector(2**(WIDTH-2), WIDTH);
    y(0)(WIDTH-1 downto 0) <= (others => '0');

    -- Initial angle to rotate
    z(0)(WIDTH-1 downto 0) <= angle(WIDTH-1 downto 0);

    -- Cascade (i.e. unroll) CORDIC steps as combinational logic
    cascade: for i in 1 to WIDTH-1 generate
        step: cordic_step
            generic map (WIDTH => WIDTH, STEPNUM => i-1)
            port map (clk => clk,
                xi => x(i-1), yi => y(i-1), zi => z(i-1),
                xo => x(i),   yo => y(i),   zo => z(i)
            );
    end generate;

    -- Cosine
    cos(WIDTH-1 downto 0) <= x(WIDTH-1)(WIDTH-1 downto 0);
        
    -- Sine
    sin(WIDTH-1 downto 0) <= y(WIDTH-1)(WIDTH-1 downto 0);
        
end dataflow;

