library ieee;

--library work;

use ieee.std_logic_1164.all;

use ieee.numeric_std.all;

entity FIFO8x9 is

port(

clk, rst: in std_logic;

RdPtrClr, WrPtrClr: in std_logic;

RdInc, WrInc: in std_logic;

DataIn: in std_logic_vector(8 downto 0);

DataOut: out std_logic_vector(8 downto 0);

rden, wren: in std_logic

);

end entity FIFO8x9;

architecture RTL of FIFO8x9 is

type fifo_array is array(7 downto 0) of std_logic_vector(8 downto 0); -- makes use of VHDL’s enumerated type

signal fifo: fifo_array;

signal wrptr, rdptr: unsigned(2 downto 0);

signal en: std_logic_vector(7 downto 0);

signal dmuxout: std_logic_vector(8 downto 0);

begin

-- fifo register array:

reg_array: process (rst, clk)

begin

if rst = '1' then

for i in 7 downto 0 loop

fifo(i) <= (others => '0');

end loop;

elsif (clk'event and clk = '1') then

if wren = '1' then

for i in 7 downto 0 loop

if en(i) = '1' then

fifo(i) <= DataIn;

else

fifo(i) <= fifo(i);

end if;

end loop;

end if;

end if;

end process reg_array;

-- read pointer

read_count: process (rst, clk)

begin

if rst = '1' then

rdptr <= (others => '0');

elsif (clk'event and clk='1') then

if rdptrclr = '1' then

rdptr <= (others => '0');

elsif rdinc = '1' then

rdptr <= rdptr + 1;

end if;

end if;

end process read_count;

-- write pointer

write_count: process (rst, clk)

begin

if rst = '1' then

wrptr <= (others => '0');

elsif (clk'event and clk='1') then

if wrptrclr = '1' then

wrptr <= (others => '0');

elsif wrinc = '1' then

wrptr <= wrptr + 1;

end if;

end if;

end process write_count;

-- 8:1 output data mux

with std_logic_vector(rdptr) select

dmuxout <= fifo(0) when "000",

fifo(1) when "001",

fifo(2) when "010",

fifo(3) when "011",

fifo(4) when "100",

fifo(5) when "101",

fifo(6) when "110",

fifo(7) when others;

-- FIFO register selector decoder

with std_logic_vector(wrptr) select

en <= "00000001" when "000",

"00000010" when "001",

"00000100" when "010",

"00001000" when "011",

"00010000" when "100",

"00100000" when "101",

"01000000" when "110",

"10000000" when others;

-- three-state control of outputs

three_state: process (rden, dmuxout)

begin

if (rden = '1') then

DataOut <= dmuxout;

else

DataOut <= "ZZZZZZZZZ";

end if;

end process three_state;

end RTL;