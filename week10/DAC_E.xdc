## Clock
set_property -dict { PACKAGE_PIN B6  IOSTANDARD LVCMOS33 } [get_ports clk]

## DIP switch (SW1 : reset, SW2 : output select A/B)
set_property -dict { PACKAGE_PIN Y1  IOSTANDARD LVCMOS33 } [get_ports rst]
set_property -dict { PACKAGE_PIN W3  IOSTANDARD LVCMOS33 } [get_ports add_sel]

## Button : btn[5:0] = {SM1, SM3, SM4, SM6, SM7, SM9}
set_property -dict { PACKAGE_PIN K4  IOSTANDARD LVCMOS33 } [get_ports {btn[5]}]
set_property -dict { PACKAGE_PIN N4  IOSTANDARD LVCMOS33 } [get_ports {btn[4]}]
set_property -dict { PACKAGE_PIN N1  IOSTANDARD LVCMOS33 } [get_ports {btn[3]}]
set_property -dict { PACKAGE_PIN N6  IOSTANDARD LVCMOS33 } [get_ports {btn[2]}]
set_property -dict { PACKAGE_PIN L5  IOSTANDARD LVCMOS33 } [get_ports {btn[1]}]
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports {btn[0]}]

## LED : led_out[7] = LED1 ... led_out[0] = LED8
set_property -dict { PACKAGE_PIN L4  IOSTANDARD LVCMOS33 } [get_ports {led_out[7]}]
set_property -dict { PACKAGE_PIN M4  IOSTANDARD LVCMOS33 } [get_ports {led_out[6]}]
set_property -dict { PACKAGE_PIN M2  IOSTANDARD LVCMOS33 } [get_ports {led_out[5]}]
set_property -dict { PACKAGE_PIN N7  IOSTANDARD LVCMOS33 } [get_ports {led_out[4]}]
set_property -dict { PACKAGE_PIN M7  IOSTANDARD LVCMOS33 } [get_ports {led_out[3]}]
set_property -dict { PACKAGE_PIN M3  IOSTANDARD LVCMOS33 } [get_ports {led_out[2]}]
set_property -dict { PACKAGE_PIN M1  IOSTANDARD LVCMOS33 } [get_ports {led_out[1]}]
set_property -dict { PACKAGE_PIN N5  IOSTANDARD LVCMOS33 } [get_ports {led_out[0]}]

## DAC
set_property -dict { PACKAGE_PIN B3  IOSTANDARD LVCMOS33 } [get_ports {dac_d[7]}]
set_property -dict { PACKAGE_PIN B1  IOSTANDARD LVCMOS33 } [get_ports {dac_d[6]}]
set_property -dict { PACKAGE_PIN C4  IOSTANDARD LVCMOS33 } [get_ports {dac_d[5]}]
set_property -dict { PACKAGE_PIN C2  IOSTANDARD LVCMOS33 } [get_ports {dac_d[4]}]
set_property -dict { PACKAGE_PIN D5  IOSTANDARD LVCMOS33 } [get_ports {dac_d[3]}]
set_property -dict { PACKAGE_PIN D2  IOSTANDARD LVCMOS33 } [get_ports {dac_d[2]}]
set_property -dict { PACKAGE_PIN E5  IOSTANDARD LVCMOS33 } [get_ports {dac_d[1]}]
set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports {dac_d[0]}]
set_property -dict { PACKAGE_PIN G2  IOSTANDARD LVCMOS33 } [get_ports dac_a_b]
set_property -dict { PACKAGE_PIN E1  IOSTANDARD LVCMOS33 } [get_ports dac_csn]
set_property -dict { PACKAGE_PIN F4  IOSTANDARD LVCMOS33 } [get_ports dac_ldacn]
set_property -dict { PACKAGE_PIN G4  IOSTANDARD LVCMOS33 } [get_ports dac_wrn]

## 7-segment array : seg_data = {A, B, C, D, E, F, G, DP}
set_property -dict { PACKAGE_PIN F1  IOSTANDARD LVCMOS33 } [get_ports {seg_data[7]}]
set_property -dict { PACKAGE_PIN F5  IOSTANDARD LVCMOS33 } [get_ports {seg_data[6]}]
set_property -dict { PACKAGE_PIN E2  IOSTANDARD LVCMOS33 } [get_ports {seg_data[5]}]
set_property -dict { PACKAGE_PIN E4  IOSTANDARD LVCMOS33 } [get_ports {seg_data[4]}]
set_property -dict { PACKAGE_PIN J1  IOSTANDARD LVCMOS33 } [get_ports {seg_data[3]}]
set_property -dict { PACKAGE_PIN J3  IOSTANDARD LVCMOS33 } [get_ports {seg_data[2]}]
set_property -dict { PACKAGE_PIN J7  IOSTANDARD LVCMOS33 } [get_ports {seg_data[1]}]
set_property -dict { PACKAGE_PIN H2  IOSTANDARD LVCMOS33 } [get_ports {seg_data[0]}]

## 7-segment select : seg_sel = {S0, S1, ..., S7} (S0 leftmost, S7 rightmost)
set_property -dict { PACKAGE_PIN H4  IOSTANDARD LVCMOS33 } [get_ports {seg_sel[7]}]
set_property -dict { PACKAGE_PIN H6  IOSTANDARD LVCMOS33 } [get_ports {seg_sel[6]}]
set_property -dict { PACKAGE_PIN G1  IOSTANDARD LVCMOS33 } [get_ports {seg_sel[5]}]
set_property -dict { PACKAGE_PIN G3  IOSTANDARD LVCMOS33 } [get_ports {seg_sel[4]}]
set_property -dict { PACKAGE_PIN L6  IOSTANDARD LVCMOS33 } [get_ports {seg_sel[3]}]
set_property -dict { PACKAGE_PIN K1  IOSTANDARD LVCMOS33 } [get_ports {seg_sel[2]}]
set_property -dict { PACKAGE_PIN K3  IOSTANDARD LVCMOS33 } [get_ports {seg_sel[1]}]
set_property -dict { PACKAGE_PIN K5  IOSTANDARD LVCMOS33 } [get_ports {seg_sel[0]}]

## Text LCD
set_property -dict { PACKAGE_PIN A4  IOSTANDARD LVCMOS33 } [get_ports {LCD_DATA[0]}]
set_property -dict { PACKAGE_PIN B2  IOSTANDARD LVCMOS33 } [get_ports {LCD_DATA[1]}]
set_property -dict { PACKAGE_PIN C3  IOSTANDARD LVCMOS33 } [get_ports {LCD_DATA[2]}]
set_property -dict { PACKAGE_PIN D4  IOSTANDARD LVCMOS33 } [get_ports {LCD_DATA[3]}]
set_property -dict { PACKAGE_PIN A2  IOSTANDARD LVCMOS33 } [get_ports {LCD_DATA[4]}]
set_property -dict { PACKAGE_PIN C5  IOSTANDARD LVCMOS33 } [get_ports {LCD_DATA[5]}]
set_property -dict { PACKAGE_PIN C1  IOSTANDARD LVCMOS33 } [get_ports {LCD_DATA[6]}]
set_property -dict { PACKAGE_PIN D1  IOSTANDARD LVCMOS33 } [get_ports {LCD_DATA[7]}]
set_property -dict { PACKAGE_PIN G6  IOSTANDARD LVCMOS33 } [get_ports LCD_RS]
set_property -dict { PACKAGE_PIN D6  IOSTANDARD LVCMOS33 } [get_ports LCD_RW]
set_property -dict { PACKAGE_PIN A6  IOSTANDARD LVCMOS33 } [get_ports LCD_E]
