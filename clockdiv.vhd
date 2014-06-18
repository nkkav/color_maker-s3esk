library IEEE;
use IEEE.std_logic_1164.all;


entity clockdiv is
  generic (
    DIVPARAM : integer := 5_000_000
  );
  port (
    clk_i    : in  std_logic;   
    rst      : in  std_logic;   
    clk_o    : out std_logic
  );   
end clockdiv;


architecture rtl of clockdiv is
  signal count   : integer range 0 to DIVPARAM;   
  signal temp_q  : std_logic;   
begin

  process (clk_i, rst) 
  begin
    if (rst = '1') then
      count  <= 0;
      temp_q <= '0';
    elsif (rising_edge(clk_i)) then
      if (count = DIVPARAM/2-1) then
        count  <= 0;
        temp_q <= not (temp_q);
      else
        count  <= count + 1;
      end if;
    end if;
  end process;

  clk_o <= temp_q;

end rtl;
