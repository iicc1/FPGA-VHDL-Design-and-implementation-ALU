----------------------------------------------------------------------------------
-- Company:			  
-- Engineers:		  
-- 
-- Create Date:    19:32:03 05/12/2016 
-- Design Name:	 ALU
-- Module Name:    Codigo - Behavioral 
-- Project Name:	 Practice 1
-- Target Devices: XC3S400
-- Tool versions:  ISE 14.7
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.02 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Codigo is
    Port ( a_in		: in	STD_LOGIC_VECTOR(7 downto 0);
           b_in		: in  STD_LOGIC_VECTOR(7 downto 0);
			  a_out		: out	STD_LOGIC_VECTOR(7 downto 0);
           b_out		: out  STD_LOGIC_VECTOR(7 downto 0);
           OP_in		: in  STD_LOGIC_VECTOR(4 downto 0);
           TipoOP		: out	STD_LOGIC_VECTOR(1 downto 0);   
           a_reset	: in	STD_LOGIC;
			  clk			: in	STD_LOGIC;
			  RESULTADO : out STD_LOGIC_VECTOR(8 downto 0);
			  CERO 		: out STD_LOGIC;
			  SIGNO		: out STD_LOGIC;
			  LEDS 		: out STD_LOGIC_VECTOR(7 downto 0));
end Codigo;		 


Architecture behavioral of Codigo is

	-- Internal signals
		signal	A_aux				 :	 	STD_LOGIC_VECTOR(8 downto 0);
		signal	B_aux				 :	 	STD_LOGIC_VECTOR(8 downto 0);
		signal	auxOP 			 : 	STD_LOGIC_VECTOR(4 downto 0);		-- Creo que con 4 downto 0 basta, antes estaba en 7, lo pongo en 4
		signal	auxauxOP 		 : 	STD_LOGIC_VECTOR(1 downto 0);		-- Otra señal auxiliar del OP_in para el TipoOP previo a los registros
		signal	auxRESULTADO	 :		STD_LOGIC_VECTOR(8 downto 0);		-- Otra señal auxiliar del RESULTADO previo a los registros
		signal	auxauxRESULTADO :		STD_LOGIC_VECTOR(8 downto 0);
      --signal   auxLEDs			 : 	STD_LOGIC_VECTOR(7 downto 0);
		--signal	auxZERO			 :		STD_LOGIC;
		--signal	auxSIGN			 : 	STD_LOGIC;
		signal	ELEDs				 :		STD_LOGIC;
		signal 	ERES				 :		STD_LOGIC;
		signal	ESign				 :		STD_LOGIC;
		signal	EZero				 :		STD_LOGIC;
begin

process(a_reset,clk)
	begin
		if (a_reset ='1') then							-- Si esta el reset
			A_aux <= (others => '0');					-- Asigna '0' en todas las posiciones			
			elsif (clk'EVENT and clk ='1')then
			if(a_in(7)='0') then							-- Si hay un '0' en la última posición
				A_aux <= '0' & a_in(7 downto 0);		-- Se le pone otro '0' en el bit adicional que lleva A_aux
				a_out <= a_in(7 downto 0);				-- Salidas directas de la ALU
			else
				A_aux <= '1' & a_in(7 downto 0);		-- Se le pone un '1' en el bit adicional que lleva A_aux
				a_out <= a_in(7 downto 0);				-- Salidas directas de la ALU
			end if;
		end if;
end process;

process(a_reset,clk)
	begin
		if (a_reset ='1') then							-- Si esta el reset
			B_aux <= (others => '0');					-- Asigna '0' en todas las posiciones		
			elsif (clk'EVENT AND clk ='1') THEN	
			if(b_in(7)='0') then							-- Si hay un '0' en la última posición
				B_aux <= '0' & b_in(7 downto 0);		-- Se le pone otro '0' en el bit adicional que lleva B_aux
				b_out <= b_in(7 downto 0);				-- Salidas directas de la ALU
			else
				B_aux <= '1' & b_in(7 downto 0);		-- Se le pone un '1' en el bit adicional que lleva B_aux
				b_out <= b_in(7 downto 0);				-- Salidas directas de la ALU		
			end if;
		end if;
end process;

process(a_reset,clk)
	begin
		if (a_reset ='1') then							-- Si esta el reset
			auxOP <= (others => '0');					-- Asigna '0' en todas las posiciones		
			elsif (clk'EVENT AND clk ='1') THEN	
				auxOP <= OP_in;							-- auxOP va a ser la señal interna
		end if;
end process;

auxauxRESULTADO <= STD_LOGIC_VECTOR(signed(A_aux) + signed(B_aux));

process(A_aux,B_aux,auxOP,auxauxRESULTADO)
	begin
	case auxOP is
	
	-- Operaciones aritmeticas
		when "00000" => auxRESULTADO <= A_aux;															-- A+0
		when "00001" => auxRESULTADO <= B_aux;															-- B+0
		when "00010" => auxRESULTADO <= STD_LOGIC_VECTOR(signed(A_aux) + signed(B_aux));	-- A+B
		when "00011" => auxRESULTADO <= STD_LOGIC_VECTOR(signed(A_aux) - signed(B_aux));	-- A-B
		when "00100" => auxRESULTADO <= STD_LOGIC_VECTOR(signed(B_aux) - signed(A_aux));	-- B-A
		when "00101" => auxRESULTADO <= STD_LOGIC_VECTOR(signed(A_aux) + 1);					-- A+1
		when "00110" => auxRESULTADO <= STD_LOGIC_VECTOR(signed(A_aux) - 1);					-- A-1
		when "00111" => auxRESULTADO <= STD_LOGIC_VECTOR(signed (NOT(A_aux)) + 1);			-- -A
		when "01000" => if (A_aux(8)='0') then															-- Valor absoluto de A
				auxRESULTADO <= A_aux;
			else
				auxRESULTADO <= STD_LOGIC_VECTOR(signed (NOT(A_aux)) + 1);						-- Por el complemento, hay que sumar 1
			end if;
		
		when "01001" => if (A_aux(8)='0') then															--2*A										
				auxRESULTADO <= A_aux(7 downto 0) & '0';
			else
				auxRESULTADO <= A_aux(7 downto 0) & '0';
			end if;
		
		when "01010" => if (A_aux(8) = '0') then														--A/2 
				auxRESULTADO <= '0' & A_aux(8 downto 1);				
			else																									-- http://es.planetcalc.com/747/?language_select=es
				auxRESULTADO <= '1' & A_aux(8 downto 1);
			end if;
			
		when "01011" => 																					-- Media
		 if (auxauxRESULTADO(8) = '0') then														
			auxRESULTADO <= '0' & auxauxRESULTADO(8 downto 1);
		else
			auxRESULTADO <= '1' & auxauxRESULTADO(8 downto 1);
		end if;

		when "01100" => if (signed(A_aux) < signed(B_aux)) then									-- Mínimo
			auxRESULTADO <= A_aux; 
		else
			auxRESULTADO <= B_aux; 
		end if;
		
		when "01101" => if (signed(A_aux) > signed(B_aux)) then									-- Máximo
			auxRESULTADO <= A_aux; 
		else
			auxRESULTADO <= B_aux; 
		end if;

	-- Operaciones Logicas
		when "01110" => auxRESULTADO <= A_aux AND B_aux;											-- AND
		when "01111" => auxRESULTADO <= A_aux OR B_aux; 											-- OR
		when "10000" => auxRESULTADO <= A_aux XOR B_aux; 											-- XOR
		when "10001" => auxRESULTADO <= A_aux NAND B_aux; 											-- NAND
		when "10010" => auxRESULTADO <= NOT(A_aux); 													-- NOT
		when "10011" => auxRESULTADO(0) <= A_aux(7);													-- SWAP A
							 auxRESULTADO(1) <= A_aux(6);		
							 auxRESULTADO(2) <= A_aux(5);		
						 	 auxRESULTADO(3) <= A_aux(4);		
							 auxRESULTADO(4) <= A_aux(3);		
							 auxRESULTADO(5) <= A_aux(2);		
					 		 auxRESULTADO(6) <= A_aux(1);		
							 auxRESULTADO(7) <= A_aux(0);		
							 auxRESULTADO(8) <= A_aux(8);						

		
		when "10100" => auxRESULTADO <= "00000000" & (A_aux(7) XOR A_aux(6) XOR A_aux(5) XOR A_aux(4) XOR A_aux(3) XOR A_aux(2) XOR A_aux(1) XOR A_aux(0)); 														-- PAR A				
	 
	-- Comparaciones
		when "10101" => if (signed(A_aux) < signed(B_aux)) then									-- A menor que B
			auxRESULTADO <= "000000001";  
		else
			auxRESULTADO <= "000000000";
		end if;
		
		when "10110" => if (signed(A_aux) > signed(B_aux)) then									-- A mayor que B
			auxRESULTADO <= "000000001"; 
		else
			auxRESULTADO <= "000000000";
		end if;

		when "10111" => if (signed(A_aux) = signed(B_aux)) then									-- A igual que B
			auxRESULTADO <= "000000001"; 
		else
			auxRESULTADO <= "000000000";
		end if;
		

		WHEN OTHERS => auxRESULTADO <= "000000000";
	end case;
end process;





process (auxOP)
	begin
		if (auxOP < "01110") then										--Aritmetico
			TipoOP <= "01";
			auxauxOP <= "01";																										-- Operaciones aritméticas
		elsif (auxOP < "10101" AND auxOP> "01101") then		--Logico
			TipoOP <= "10";
			auxauxOP <= "10";																										-- Operaciones lógicas
		elsif (auxOP < "11000" AND auxOP > "10100") then		--comparacion
			TipoOP <= "11";	
			auxauxOP <= "11";																										-- Operaciones de comparación
		else
			TipoOP <= "00";	
			auxauxOP <= "00";										   															-- Otras
		end if;

end process;





--Enable LEDS
process(auxauxOP)
	begin
		if(auxauxOP = "10" OR auxauxOP = "11") then
			ELEDs <= '1';
		else
			ELEDs <= '0';
		end if;
end process;

--Enable RESULTDO
process(auxauxOP)
	begin
		if(auxauxOP = "01") then
			ERES <= '1';
		else
			ERES <= '0';
		end if;
end process;

--Enable Sign
process(auxauxOP,auxRESULTADO)
	begin
		if (auxauxOP = "01" ) then
			if (auxRESULTADO(8) = '1' ) then
				ESign <= '1';
			else	
				ESign <= '0';
			end if;
		else
			ESign <= '0';
		end if;
end process;

--Enable Zero
process(auxauxOP,auxRESULTADO)
	begin
		if (auxauxOP = "01" OR auxauxOP = "11" OR auxauxOP = "10") then
			if (auxRESULTADO = "000000000" ) then
				EZero <= '1';
			else	
				EZero <= '0';
			end if;
		else
			EZero <= '0';
		end if;
end process;




process(a_reset,clk)													 	-- Registro leds, tiene un bit menos
	begin
		if (a_reset='1') then
			LEDS <= (others => '0');
		elsif	(clk'EVENT and clk = '1') then
				if (ELEDs='1') then
					LEDS <= auxRESULTADO(7 downto 0);
				else
					LEDS <= (others => '0');
				end if;

		end if;
end process;



process(a_reset,clk)																		-- Registro resultado
	begin
	if (a_reset='1') then
			RESULTADO <= (others => '0');
		elsif	(clk'EVENT and clk = '1') then
				if (ERES='1') then
					RESULTADO <= auxRESULTADO;
				else
					RESULTADO <= "000000000";
				end if;
		end if;
end process;




process(a_reset,clk)																		-- Registro signo
	begin
		if (a_reset='1') then
			SIGNO <= '0';
		elsif	(clk'EVENT and clk = '1') then
			if (ESign='1') then
					SIGNO <= '1';
			else
					SIGNO <= '0';
			
			end if;
		end if;
end process;






process(a_reset,clk)																	-- Registro cero
	begin
		if (a_reset='1') then
			CERO <= '0';
		elsif(clk'EVENT and clk = '1') then
				if (EZero='1') then
					CERO <= '0';
				else
					CERO <= '1';
				end if;
		end if;
end process;








end Behavioral;


