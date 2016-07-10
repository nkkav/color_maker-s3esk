library IEEE;
use IEEE.std_logic_1164.all;


entity color_maker is
  port (
    sldsw    : in  std_logic_vector(2 downto 0);
    red      : out std_logic;
    green    : out std_logic;
    blue     : out std_logic
  );
end color_maker;


architecture rtl of color_maker is
  --
begin

  red   <= sldsw(2);
  green <= sldsw(1);
  blue  <= sldsw(0);

end rtl;
