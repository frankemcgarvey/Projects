library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity colorInterface is
	port(
			clk50,
			reset 		 : in    std_logic := '0';
			flag         : out   std_logic := '0'; --Starts the i2c_master fsm
			dout   	    : out   std_logic_vector(7 downto 0) := (others => '0')
			);
end colorInterface;



architecture FSM of colorInterface is

signal machineTimer : std_logic := '0';

 
--States--

type UIstates is (StartUp, Write0, Write1, Write2, Write3, Idle, Hold);

signal prev_State, next_State : UIstates := StartUp;
--==============--	

signal i, iReg : natural range 0 to 7;
signal byteCounter : natural range 0 to 10 := 0;

begin

	process(all)
	begin
		
		if(reset = '1') 	      		 then prev_State <= StartUp;	 
											  iReg <= 0;
		elsif(rising_edge(machineTimer)) then prev_State <= next_State;	
											  iReg <= i;
		end if;	
		
		
	end process;
	
	process(all)	
	begin
		
		if(rising_edge(clk50)) then	machineTimer <= not machineTimer;
		end if;
				
		
	end process;
	process(all)

	begin
	
	--Default values--
	dOut <= x"00";
	i <= iReg;
	flag <= '0';
	------------------
		case(prev_State) is
		
			when StartUp =>
				
				
			                next_State  <= Write0;	 
				
				
			when Write0 =>	
								flag <= '1';
								dOut <= x"02";
								next_State  <= Idle;	
			when Write1 =>
								flag <= '1';
								dOut <= x"0A";
								next_State  <= Idle;		
			when Write2 =>
								flag <= '1';
								dOut <= x"02";
								next_State  <= Idle;		
			when Write3 =>
								flag <= '1';
							   dOut <= x"04";
								next_State  <= Idle;	
								
			when Idle =>
				
				i <= iReg + 1;
					if(i = 1) then next_State <= Write1;
				elsif(i = 2) then next_State <= Write2;
				elsif(i = 3) then next_state <= Write3;
			   else              next_State <= Hold;
				end if;
			when Hold => 	
								flag <= '1';
								next_State <= Hold;
								
		end case;
		
	end process;
end FSM;