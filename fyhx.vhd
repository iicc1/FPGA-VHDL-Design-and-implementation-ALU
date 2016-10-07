--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:11:59 05/27/2016
-- Design Name:   
-- Module Name:   F:/UPCT/2/2ndHalf/SISTEMAS BASADOS EN MICROPROOCESADORES/VHDL/ALU3/tbALU3.vhd
-- Project Name:  ALU3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Codigo
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tbALU3 IS
END tbALU3;
 
ARCHITECTURE behavioral OF tbALU3 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Codigo
    PORT(
         a_in : IN  std_logic_vector(7 downto 0);
         b_in : IN  std_logic_vector(7 downto 0);
         a_out : OUT  std_logic_vector(7 downto 0);
         b_out : OUT  std_logic_vector(7 downto 0);
         OP_in : IN  std_logic_vector(4 downto 0);
         TipoOP : OUT  std_logic_vector(1 downto 0);
         a_reset : IN  std_logic;
         clk : IN  std_logic;
         RESULTADO : OUT  std_logic_vector(8 downto 0);
         CERO : OUT  std_logic;
         SIGNO : OUT  std_logic;
         LEDS : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal a_in : std_logic_vector(7 downto 0) := (others => '0');
   signal b_in : std_logic_vector(7 downto 0) := (others => '0');
   signal OP_in : std_logic_vector(4 downto 0) := (others => '0');
   signal a_reset : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal a_out : std_logic_vector(7 downto 0);
   signal b_out : std_logic_vector(7 downto 0);
   signal TipoOP : std_logic_vector(1 downto 0);
   signal RESULTADO : std_logic_vector(8 downto 0);
   signal CERO : std_logic;
   signal SIGNO : std_logic;
   signal LEDS : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Codigo PORT MAP (
          a_in => a_in,
          b_in => b_in,
          a_out => a_out,
          b_out => b_out,
          OP_in => OP_in,
          TipoOP => TipoOP,
          a_reset => a_reset,
          clk => clk,
          RESULTADO => RESULTADO,
          CERO => CERO,
          SIGNO => SIGNO,
          LEDS => LEDS
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
		      wait for clk_period*10;
		
      a_reset <= '1';
		wait for 15 ns;
		a_reset <= '0';
		
		a_in  <= "10010111";
		b_in <= "01100101";
		
		OP_in <= "00001";	--B+0
      wait for 100 ns;	
		OP_in <= "00000";	--A+0
      wait for 100 ns;
		OP_in <= "00110";	--A-1
      wait for 100 ns;
		OP_in <= "10101";	--AmenorqueB
      wait for 100 ns;
		OP_in <= "10110";	--Amayor que B
      wait for 100 ns;
		OP_in <= "10010"	;--NOT
      wait for 100 ns;
		OP_in <= "01110"	;--AND
      wait for 100 ns;
		OP_in <= "10001";--NAND
      wait for 100 ns;
		OP_in <= "01111";--OR
      wait for 100 ns;
		OP_in <= "10000";--XOR
      wait for 100 ns;
		OP_in <= "10011";--SWAP
      wait for 100 ns;
		OP_in <= "10100";--PAR
      wait for 100 ns;
		OP_in <= "00010";--A+B
      wait for 100 ns;
		OP_in <= "01011";--MEDIA A B
      wait for 100 ns;
		OP_in <= "00011";-- A-B
      wait for 100 ns;
		OP_in <= "01001";--2*A
      wait for 100 ns;
		OP_in <= "01101";--max(A,B)
      wait for 100 ns;
		
		a_in  <= "10010111";
		b_in <=  "10010111";
		
		OP_in <= "10111";-- A=B
      wait for 100 ns;
		OP_in <= "00011";--A-B
      wait for 100 ns;
		OP_in <= "01000";--abs(A)
      wait for 100 ns;
		
		a_in  <= "01110110";
		b_in <=  "10110110";
		
		OP_in <= "00101";-- A+1
      wait for 100 ns;
		OP_in <= "01100";--min(A,B)
      wait for 100 ns;
		OP_in <= "00111";-- -A
      wait for 100 ns;
		OP_in <= "00100";-- B-A
      wait for 100 ns;
		OP_in <= "01010";--A/2
      wait for 100 ns;
		OP_in <= "01011";--Media(A,B)
      wait for 100 ns;
		
		OP_in <= "11110"; 	-- Deberia de no hacer nada
		wait for 100 ns;



      -- insert stimulus here 

      wait;
   end process;

END;
