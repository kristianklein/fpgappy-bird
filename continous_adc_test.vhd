library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity continous_adc_test is
    Port ( CLK : in  STD_LOGIC;
           JA1,JA4 : out  STD_LOGIC; -- CS and SCLK
           JA2,JA3 : in  STD_LOGIC; -- D0 and D1
           AN0,AN1,AN2,AN3 : out  STD_LOGIC;
           CA,CB,CC,CD,CE,CF,CG : out  STD_LOGIC;
           DP : out  STD_LOGIC;
           LD0, LD1 : OUT STD_LOGIC;
           RED0,RED1,RED2 : OUT STD_LOGIC;
           GRN0,GRN1,GRN2 : OUT STD_LOGIC;
           BLU1,BLU2 : OUT STD_LOGIC;
           HSYNC,VSYNC : OUT STD_LOGIC);
end continous_adc_test;

architecture Behavioral of continous_adc_test is
	-- COMPONENTS
	COMPONENT binary2bcd
	PORT(
		binary : IN std_logic_vector(11 downto 0);
		bcd : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	COMPONENT display_driver
	PORT(
		bcd : IN std_logic_vector(15 downto 0);
		dp_vector : IN std_logic_vector(3 downto 0);
		clock : IN std_logic;          
		seven_segment : OUT std_logic_vector(6 downto 0);
		anodes : OUT std_logic_vector(3 downto 0);
		dp : OUT std_logic
		);
	END COMPONENT;
  
  COMPONENT sampler
	PORT(
		CLK : IN std_logic;
		done : IN std_logic;
		prescaler : IN std_logic_vector(15 downto 0);
		enable : IN std_logic;          
		start : OUT std_logic
		);
	END COMPONENT;

	COMPONENT adc_interface
	PORT(
		Clk : IN std_logic;
		Start : IN std_logic;
		D0 : IN std_logic;
		D1 : IN std_logic;          
		Done : OUT std_logic;
		SClk : OUT std_logic;
		CS : OUT std_logic;
		AD1 : OUT std_logic_vector(11 downto 0);
		AD2 : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;
	

	COMPONENT player_control
	PORT(
		CLK : IN std_logic;
    collision : IN STD_LOGIC;
		adc_value : IN std_logic_vector(11 downto 0);          
		player_y : OUT std_logic_vector(9 downto 0)
		);
	END COMPONENT;
	
	COMPONENT vga_driver
	PORT(
		CLK : IN std_logic;
		reset : IN std_logic;          
		hsync : OUT std_logic;
		vsync : OUT std_logic;
		v_pos : OUT std_logic_vector(9 downto 0);
		h_pos : OUT std_logic_vector(9 downto 0);
		RGB_enable : OUT std_logic;
		vga_clock : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT game_render
	PORT(
		vga_clock : IN std_logic;
		player_y : IN std_logic_vector(9 downto 0);
		obstacle_x : in STD_LOGIC_VECTOR (9 DOWNTO 0);
	    obstacle_y : in STD_LOGIC_VECTOR (9 DOWNTO 0);
		h_pos : IN std_logic_vector(9 downto 0);
		v_pos : IN std_logic_vector(9 downto 0);
		RGB_enable : IN std_logic;
		bird_rom_rgb : IN std_logic_vector(7 downto 0);          
		bird_rom_adr : OUT std_logic_vector(7 downto 0);
		RGB_out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
  COMPONENT bird_rom
	PORT(
		adr : IN std_logic_vector(7 downto 0);          
		dout : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;


	COMPONENT game_timer
	PORT(
		CLK : IN std_logic;
    collision : in STD_LOGIC;
		points : OUT std_logic_vector(11 downto 0);
		game_clock : OUT std_logic
		);
	END COMPONENT;
  
	COMPONENT obstacle
	PORT(
		game_clock : IN std_logic;          
		obstacle_x : OUT std_logic_vector(9 downto 0);
		obstacle_y : OUT std_logic_vector(9 downto 0)
		);
	END COMPONENT;
  
 	COMPONENT collision_detector
	PORT(
		player_y : IN std_logic_vector(9 downto 0);
		obstacle_x : IN std_logic_vector(9 downto 0);
		obstacle_y : IN std_logic_vector(9 downto 0);          
		collision : OUT std_logic
		);
	END COMPONENT;

	-- SIGNALS
	SIGNAL AD1_sig : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL AD2_sig : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL bcd_sig : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL seven_segment_sig : STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL anode_sig : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL start_sig : STD_LOGIC;
	SIGNAL done_sig : STD_LOGIC;
	SIGNAL rgb_out_sig : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL player_y_sig : STD_LOGIC_VECTOR (9 DOWNTO 0);
  SIGNAL obstacle_x_sig : STD_LOGIC_VECTOR (9 DOWNTO 0);
  SIGNAL obstacle_y_sig : STD_LOGIC_VECTOR (9 DOWNTO 0);
	SIGNAL h_pos_sig : STD_LOGIC_VECTOR (9 DOWNTO 0);
	SIGNAL v_pos_sig : STD_LOGIC_VECTOR (9 DOWNTO 0);
	SIGNAL RGB_enable_sig : STD_LOGIC;
	SIGNAL vga_clock_sig : STD_LOGIC;
	SIGNAL player_y_12bit : STD_LOGIC_VECTOR (11 DOWNTO 0);
	SIGNAL bird_adr_sig : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL bird_rgb_sig : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL game_clock_sig : STD_LOGIC;
  SIGNAL points_sig : STD_LOGIC_VECTOR (11 DOWNTO 0);
  SIGNAL collision_sig : STD_LOGIC;
begin
	LD0 <= collision_sig;
	LD1 <= start_sig;
  
	-- INSTANTIATIONS
	Inst_binary2bcd: binary2bcd PORT MAP(
		binary => player_y_12bit,
		bcd => bcd_sig
	);

	Inst_display_driver: display_driver PORT MAP(
		bcd => bcd_sig,
		dp_vector => "1111",
		clock => CLK,
		seven_segment => seven_segment_sig,
		anodes => anode_sig,
		dp => DP 
	);
  
	Inst_sampler: sampler PORT MAP(
		CLK => CLK,
		done => done_sig,
		prescaler => "0100000100011010", -- scale down by 1 MHz down by 16666 (60 Hz)
		enable => '1',
		start => start_sig
	);
	
	Inst_adc_interface: adc_interface PORT MAP(
		Clk => CLK,
		Start => start_sig,
		Done => done_sig,
		SClk => JA4, -- Sclk pin on the ADC
		CS => JA1, -- CS pin on ADC
		D0 => JA2,
		D1 => JA3,
		AD1 => AD1_sig,
		AD2 => AD2_sig
	);
	
	Inst_player_control: player_control PORT MAP(
		CLK => CLK,
    collision => collision_sig,
		adc_value => AD1_sig,
		player_y => player_y_sig
	);


	Inst_vga_driver: vga_driver PORT MAP(
		CLK => CLK,
		reset => '0',
		hsync => HSYNC,
		vsync => VSYNC,
		v_pos => v_pos_sig,
		h_pos => h_pos_sig,
		RGB_enable => RGB_enable_sig,
		vga_clock => vga_clock_sig
	);
	
  Inst_game_render: game_render PORT MAP(
		vga_clock => vga_clock_sig,
		player_y => player_y_sig,
		obstacle_x => obstacle_x_sig, -- 640 max
		obstacle_y => obstacle_y_sig, -- 440 max
		h_pos => h_pos_sig,
		v_pos => v_pos_sig,
		RGB_enable => RGB_enable_sig,
		bird_rom_adr => bird_adr_sig,
		bird_rom_rgb => bird_rgb_sig,
		RGB_out => rgb_out_sig
	);

	Inst_bird_rom: bird_rom PORT MAP(
		adr => bird_adr_sig,
		dout => bird_rgb_sig
	);
  
  Inst_game_timer: game_timer PORT MAP(
		CLK => CLK,
    collision => collision_sig,
		points => points_sig,
		game_clock => game_clock_sig
	);

	Inst_obstacle: obstacle PORT MAP(
		game_clock => game_clock_sig, -- change this to game_clock_sig
		obstacle_x => obstacle_x_sig,
		obstacle_y => obstacle_y_sig
	);
  
 	Inst_collision_detector: collision_detector PORT MAP(
		player_y => player_y_sig,
		obstacle_x => obstacle_x_sig,
		obstacle_y => obstacle_y_sig,
		collision => collision_sig
	);

  
	-- Mapping signals to outputs
	(AN3,AN2,AN1,AN0) <= anode_sig;
	(CA,CB,CC,CD,CE,CF,CG) <= seven_segment_sig;
	(RED2,RED1,RED0,GRN2,GRN1,GRN0,BLU2,BLU1) <= rgb_out_sig;
	player_y_12bit <= '0' & '0' & player_y_sig;
end Behavioral;

