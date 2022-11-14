-- COORD_CONVERTER.VHD
--
-- SCOMP PHERIPHERAL THAT TAKES A X AND Y COORDINATE 
-- AND OUTPUTS THE ADDRESS OF THE CORRESPONDING PIXEL IN A 2D NEOPIXEL ARRAY
--
-- GROUP 23
-- HOWARD HU, LIZHE ZHANG, GIGI TU, TIANCHI YU
-- ECE 2031 L02
-- 07/23/2022

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity Coord_Converter is
 
 port(
  resetn   : in    std_logic ;
  io_write : in    std_logic ;
  cs       : in    std_logic ;
  
  data    : inout std_logic_vector(15 downto 0)
 ); 

end entity;

architecture internals of Coord_Converter is

 -- Internal register.  This will hold the swapped nibbles,
 -- and SCOMP will be able to read this register with IN.
 signal data_assigned, xcord, ycord, yshift, xshift, row_Length, zero: std_logic_vector(15 downto 0);
 
begin

 -- Create read functionality.
 -- ONLY drive the bus when SCOMP is reading.
 -- 'Z' is high impedance.
  row_Length <= "0000000000011111";
  zero <= "0000000000000000";
  
 data <= "ZZZZZZZZZZZZZZZZ" when (cs='0' or io_write='1') else data_assigned;
 
 process (cs, io_write, resetn)
 begin
  -- reset to a known value
  if resetn='0' then
   data_assigned <= "0000000000000000";
   yshift <= "0000000000000000";
  
  elsif (io_write='1') and rising_edge(cs) then
  
   yshift <= "0000000000000000";
   xshift <= "0000000000000000";

   xcord(4 downto 0) <= data(4 downto 0);
   ycord(2 downto 0) <= data(7 downto 5);
	
   if data = "0000000000000000" then
	 data_assigned <= "0000000000000000";
	
	elsif ycord(0) = '0'and (data(9) = '0') then 
     yshift(7 downto 5) <= ycord(2 downto 0);
     data_assigned <= yshift + xcord;
	  
	 
   elsif ycord(0) = '1' and (data(9) = '1') then 
    yshift(7 downto 5) <= ycord(2 downto 0);
     xshift <= std_logic_vector(unsigned(row_Length(15 downto 0)) - unsigned(xcord(15 downto 0)));
     data_assigned <= yshift + xshift;
   end if;

  end if;
 end process;

end internals;