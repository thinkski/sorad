------------------------------------------------------------------------------
--
-- CORDIC (Coordinate Rotation Digital Computer) Processor
--
-- Description: This is a VHDL implementation of a polar to cartesian
--              coordinate transform via the CORDIC algorithm (see "The Birth
--              of CORDIC" by Jack E. Volder)
--
--              Only a single step (i.e. a single iteration) is implemented.
--              The following three computations are performed:
--                  x_{i+1} = x_i - (y_i * d_i * 2^{-i})
--                  y_{i+1} = y_i + (x_i * d_i * 2^{-i})
--                  z_{i+1} = z_i - (d_i * arctan(2^{-i})
--              where d_i is the direction to rotate, determined by the sign
--              of the input angle z_i. x_i an y_i are the cartesian
--              coordinates of the input vector. Similarily, x_{i+1} and
--              y_{i+1} are the output coordinates. z_{i+1} is the output
--              angle, denoting the angle left to rotate (portion of angle
--              unrotated by this step).
--
--              The computation is done in combinational logic, but the
--              output is registered.
--
-- Inputs:      clk     Sample clock.
--              xi      Cartesian x-component of input vector to rotate.
--              yi      Cartesian y-component of input vector to rotate.
--              zi      Angle by which to rotate.
-- Outputs:     xo      Cartesian x-component of output rotated vector.
--              yo      Cartesian y-component of output rotated vector.
--              zo      Remaing angle by which to rotate.
--
-- Target:      Xilinx Spartan-3E XC3S250E-4TQ144
-- Synthesizer: Xilinx XST 9.1i
--
-- Author:      Chris Hiszpanski, <chiszp@hotmail.com>
--
-- Revisions:
-- Feb 12 2007	Initial revision.
-- Feb 16 2007  Added clock for registed output to enabling step pipelining.
-- Feb 17 2007  Changed mux syntax to synthesize under Xilinx XST. Changed
--              tab width to 4 for readability.
--              Corrected arctan scaling bug: limit(arctan(x),x=infinity) is
--              Pi/2, not 2*Pi.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.math_real.all; 
                                        
-- CORDIC step declaration
entity cordic_step is
    -- Generic parameters
    generic(
        -- Size of vector component (in bits)
        WIDTH	: integer;
        -- CORDIC step number (i.e. unrolled iteration number)
        STEPNUM	: integer
    );

    -- Port declaration
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
end cordic_step;

-- CORDIC step architecture
architecture dataflow of cordic_step is

    -- Signed arc tangent constant for step number STEPNUM
    constant ATAN : std_logic_vector(WIDTH-1 downto 0) :=
        -- Convert to two's complement signed standard logic vector
        std_logic_vector( signed(
            -- Convert to standard logic vector
            conv_std_logic_vector( integer(
                -- Compute arctan(2^{-i}) scaled over available precision
                arctan(1.0/(2.0**STEPNUM)) * (2.0**(WIDTH-1)) * 2.0 / MATH_PI
            ), WIDTH) 
        ));
                
    -- Intermediate signals
    signal  x   : std_logic_vector(WIDTH-1 downto 0);
    signal  dx  : std_logic_vector(WIDTH-1 downto 0);
    signal  y   : std_logic_vector(WIDTH-1 downto 0);
    signal  dy  : std_logic_vector(WIDTH-1 downto 0);
    signal  z   : std_logic_vector(WIDTH-1 downto 0);

begin

    -- Combinational logic: Synthesize 2:1 signed muxes

    -- Note: d_i is the direction to rotate (1 for counter clockwise, -1
    -- for clockwise) based upon the sign of the input angle.

    -- Synthesize arithmetic shift right for delta x and delta y:
    --    dx = x_i * 2^{-i}
    --    dy = y_i * 2^{-i}
    sign: for i in WIDTH-1 downto WIDTH-1 - STEPNUM generate
    begin
        dx(i) <= xi(WIDTH-1);
        dy(i) <= yi(WIDTH-1);
    end generate;
    magnitude: for i in WIDTH-1 - STEPNUM - 1 downto 0 generate
    begin
        dx(i) <= xi(i + STEPNUM);
        dy(i) <= yi(i + STEPNUM);
    end generate;

    -- X-component computation: x_{i+1} = x_i - (y_i * d_i * 2^{-i})
    x(WIDTH-1 downto 0) <= xi(WIDTH-1 downto 0) -
                           dy(WIDTH-1 downto 0) when zi(WIDTH-1)='0'
                      else xi(WIDTH-1 downto 0) +
                           dy(WIDTH-1 downto 0);

    -- Y-component computation: y_{i+1} = y_i + (x_i * d_i * 2^{-i})
    y(WIDTH-1 downto 0) <= yi(WIDTH-1 downto 0) +
                           dx(WIDTH-1 downto 0) when zi(WIDTH-1)='0'
                      else yi(WIDTH-1 downto 0) -
                           dx(WIDTH-1 downto 0);
							
    -- Remaining angle computation: z_{i+1} = z_i - (d_i * arctan(2^{-i})
    z(WIDTH-1 downto 0) <= zi(WIDTH-1 downto 0) -
                           ATAN(WIDTH-1 downto 0) when zi(WIDTH-1)='0'
                      else zi(WIDTH-1 downto 0) +
                           ATAN(WIDTH-1 downto 0);

    -- Synthesize registers
    process (clk)
    begin
        -- Clock rising edge
        if (clk'event and clk = '1') then
            -- Latch combination logic result
            xo <= x;
            yo <= y;
            zo <= z;
        end if;
    end process;

end dataflow;
