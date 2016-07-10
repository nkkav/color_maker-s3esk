library IEEE, STD;
use STD.textio.all;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity color_maker_top_tb is
end color_maker_top_tb;


architecture tb_arch of color_maker_top_tb is

  -- UUT component
  component color_maker_top
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      sldsw    : in  std_logic_vector(2 downto 0);
      red      : out std_logic;
      green    : out std_logic;
      blue     : out std_logic;
      vs       : out std_logic;
      hs       : out std_logic
    );
  end component;
  -- I/O signals
  signal clk   : std_logic := '0';
  signal rst   : std_logic;
  signal sldsw : std_logic_vector(2 downto 0);
  signal red   : std_logic;
  signal green : std_logic;
  signal blue  : std_logic;
  signal vs    : std_logic;
  signal hs    : std_logic;
  -- Profiling signals
  signal ncycles : integer;
  -- Constant declarations
  constant CLK_PERIOD : time := 20 ns;
  -- Declare results file
  file ResultsFile: text open write_mode is "color_maker_top_results.txt";

begin

  uut : color_maker_top
    port map (
      clk   => clk,
      rst   => rst,
      sldsw => sldsw,
      red   => red,
      green => green,
      blue  => blue,
      vs    => vs,
      hs    => hs
    );

  CLK_GEN_PROC: process(clk)
  begin
    if (clk = '0') then
      clk <= '1';
    else
      clk <= not clk after CLK_PERIOD/2;
    end if;
  end process CLK_GEN_PROC;

  RST_STIM: process
  begin
    rst   <= 'U';
    sldsw <= "UUU";
    wait for CLK_PERIOD;
    rst   <= '1';
    sldsw <= "UUU";
    wait for CLK_PERIOD;
    rst   <= '0';
    sldsw <= "010";
    wait for 2400000*CLK_PERIOD;
  end process RST_STIM;

  PROFILING: process(clk, rst)
  begin
    if (rst = '1') then
      ncycles <= 0;
    elsif (rising_edge(clk)) then
      ncycles <= ncycles + 1;
    end if;
  end process PROFILING;

process (clk)
  variable line_el: line;
  variable red_ext   : std_logic_vector(2 downto 0);
  variable green_ext : std_logic_vector(2 downto 0);
  variable blue_ext  : std_logic_vector(1 downto 0);
begin
  if rising_edge(clk) then

    -- Write the time
    write(line_el, now);   -- write the line
    write(line_el, ':');   -- write the line

    -- Write the hsync
    write(line_el, ' ');
    write(line_el, hs);    -- write the line

    -- Write the vsync
    write(line_el, ' ');
    write(line_el, vs);    -- write the line

    -- Write the red component
    red_ext := red & red & red;
    write(line_el, ' ');
    write(line_el, red_ext);   -- write the line

    -- Write the green component
    green_ext := green & green & green;
    write(line_el, ' ');
    write(line_el, green_ext); -- write the line

    -- Write the blue component
    blue_ext := blue & blue;
    write(line_el, ' ');
    write(line_el, blue_ext);  -- write the line

    writeline(ResultsFile, line_el); -- write the contents into the file

  end if;
end process;

end tb_arch;

