library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity color_maker_top is
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
end color_maker_top;


architecture top_level of color_maker_top is
  --
  -- Component declarations
  component vga_controller is
    generic (
      H_S    : integer := 800;
      H_DISP : integer := 640;
      H_FP   : integer := 16;
      H_PW   : integer := 96;
      H_BP   : integer := 48;
      V_S    : integer := 521;
      V_DISP : integer := 480;
      V_FP   : integer := 10;
      V_PW   : integer := 2;
      V_BP   : integer := 29
    );
    port (
      clk    : in  std_logic;
      rst    : in  std_logic;
      hs     : out std_logic;
      vs     : out std_logic;
      blank  : out std_logic;
      hpix   : out std_logic_vector(9 downto 0); -- horizontal coordinate
      vpix   : out std_logic_vector(9 downto 0)  -- vertical coordinate
    );
  end component;
  --
  component color_maker is
    port (
      sldsw    : in  std_logic_vector(2 downto 0);
      red      : out std_logic;
      green    : out std_logic;
      blue     : out std_logic
    );
  end component;
  --
  component clockdiv
    generic (
      DIVPARAM : integer := 5_000_000
    );
    port (
      clk_i    : in  std_logic;
      rst      : in  std_logic;
      clk_o    : out std_logic
    );
  end component;
  --
  -- Signal declarations
  signal clkdiv2  : std_logic;
  signal hsSig    : std_logic;
  signal vsSig    : std_logic;
  signal redSig   : std_logic;
  signal greenSig : std_logic;
  signal blueSig  : std_logic;
  signal vidonSig : std_logic;
  signal hdrawSig : std_logic_vector(9 downto 0);
  signal vdrawSig : std_logic_vector(9 downto 0);
  --
begin

  clockdiv_vga_instance : clockdiv
    generic map (
      DIVPARAM => 2
    )
    port map (
      clk_i    => clk,
      rst      => rst,
      clk_o    => clkdiv2
    );

  vgaSync_instance : vga_controller
    generic map (
--      H_S    => 1040,
--      H_DISP =>  800,
--      H_FP   =>   56,
--      H_PW   =>  120,
--      H_BP   =>   64,
--      V_S    =>  666,
--      V_DISP =>  600,
--      V_FP   =>   37,
--      V_PW   =>    6,
--      V_BP   =>   23    
      H_S    =>  800,
      H_DISP =>  640,
      H_FP   =>   16,
      H_PW   =>   96,
      H_BP   =>   48,
      V_S    =>  521,
      V_DISP =>  480,
      V_FP   =>   10,
      V_PW   =>    2,
      V_BP   =>   29
    )
    port map (
      clk   => clkdiv2,
--      clk   => clk,
      rst   => rst,
      hs    => hsSig,
      vs    => vsSig,
      blank => vidonSig,
      hpix  => hdrawSig,
      vpix  => vdrawSig
    );

  color_maker_instance : color_maker
    port map (
      sldsw    => sldsw,
      red      => redSig,
      green    => greenSig,
      blue     => blueSig
    );

  hs <= hsSig;
  vs <= vsSig;

  red   <= redSig   and vidonSig;
  green <= greenSig and vidonSig;
  blue  <= blueSig  and vidonSig;

end top_level;
