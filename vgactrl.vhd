-- Original source:
-- Mike Field
-- 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity vga_controller is
  generic (
    -- horizontal timing
    -- sync pulse
    H_S    : integer := 800;
    -- display
    H_DISP : integer := 640;
    -- front porch
    H_FP   : integer := 16;
    -- pulse width
    H_PW   : integer := 96;
    -- back porch
    H_BP   : integer := 48;
    -- vertical timing
    -- sync pulse
    V_S    : integer := 521;
    -- display
    V_DISP : integer := 480;
    -- front porch
    V_FP   : integer := 10;
    -- pulse width
    V_PW   : integer := 2;
    -- back porch
    V_BP   : integer := 29
  );
  port (
    clk    : in  std_logic; -- assuming a clock of 25MHz
    rst    : in  std_logic; -- reset (synchronous)
    hs     : out std_logic; -- Horizontal sync pulse. Active low
    vs     : out std_logic; -- Vertical sync pulse. Active low
    blank  : out std_logic; -- Blanking interval indicator.  Active low.
                            -- Color to monitor should be black when active
                            -- (ie, AND this signal with your color signals).
    hpix   : out std_logic_vector(9 downto 0); -- horizontal coordinate
    vpix   : out std_logic_vector(9 downto 0)  -- vertical coordinate
  );
end vga_controller;

architecture behavioral of vga_controller is
  --
  -- Constants
  constant hVisible    : natural := H_DISP;
  constant hSyncStart  : natural := H_DISP+H_FP;
  constant hSyncEnd    : natural := H_DISP+H_FP+H_PW;
  constant hTotalCount : natural := H_DISP+H_FP+H_PW+H_BP;
  constant vVisible    : natural := V_DISP;
  constant vSyncStart  : natural := V_DISP+V_FP;
  constant vSyncEnd    : natural := V_DISP+V_FP+V_PW;
  constant vTotalCount : natural := V_DISP+V_FP+V_PW+V_BP;  
  --
  -- Signals
  signal nextHsync  : std_logic;
  signal nextVsync  : std_logic;
  signal vCounter   : std_logic_vector(10 downto 0) := (others => '0');
  signal hCounter   : std_logic_vector(11 downto 0) := (others => '0');   
  --
begin

  process (clk)
  begin
    if rising_edge(clk) then
      hs   <= nextHsync;
      vs   <= nextVsync;
      hpix <= hCounter(9 downto 0);
      vpix <= vCounter(9 downto 0);
      --
      if ((hCounter < hVisible) and (vCounter < vVisible)) then
        blank <= '1';
      else
        blank <= '0';
      end if;
      --
      if (hCounter /= hTotalCount-1) then
        hcounter <= hcounter + 1;
      else
        hcounter <= (others => '0');       
        if (vCounter = vTotalCount-1) then
          vCounter <= (others => '0');
        else
          vCounter <= vCounter + 1;
        end if;
      end if;
      --
      if ((hcounter >= hSyncStart) and (hcounter < hSyncEnd)) then
        nextHsync <= '0';
      else
        nextHsync <= '1';
      end if;
      --
      if ((vcounter >= vSyncStart) and (vcounter < vSyncEnd)) then
        nextVsync <= '1';
      else
        nextVsync <= '0';
      end if;
    end if;
  end process;

end behavioral;
