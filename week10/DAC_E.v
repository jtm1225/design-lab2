// Pre-lab E : display DAC digital input on 7-segment and Text LCD
// - button 1/3/4/6/7/9 : -1/+1/-2/+2/-8/+8 (same as pre-lab D)
// - 7-segment : right 3 digits (S5~S7) show the input in decimal (000~255)
// - Text LCD  : line 1 "DAC INPUT : XXX " (decimal)
//               line 2 "BIN : XXXXXXXX  " (binary)

module DAC_E(clk, rst, btn, add_sel,
             dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out,
             seg_data, seg_sel,
             LCD_E, LCD_RS, LCD_RW, LCD_DATA);

input clk, rst;
input [5:0] btn;      // {SM1, SM3, SM4, SM6, SM7, SM9}
input add_sel;
output reg dac_csn, dac_ldacn, dac_wrn, dac_a_b;
output reg [7:0] dac_d;
output reg [7:0] led_out;
output reg [7:0] seg_data;   // {A, B, C, D, E, F, G, DP}
output reg [7:0] seg_sel;    // {S0, ..., S7}, active low
output LCD_E;
output reg LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

reg [7:0] dac_d_temp;
reg [7:0] cnt;
wire [5:0] btn_t;

reg [1:0] state;

parameter DELAY   = 2'b00,
          SET_WRN = 2'b01,
          UP_DATA = 2'b10;

oneshot_universal #(.WIDTH(6)) O1(clk, rst, {btn[5:0]}, {btn_t[5:0]});

//==================== DAC (same as pre-lab D) ====================//
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= DELAY;
    end
    else begin
        case(state)
            DELAY   : if(cnt == 200) state <= SET_WRN;
            SET_WRN : if(cnt == 50)  state <= UP_DATA;
            UP_DATA : if(cnt == 30)  state <= DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
        cnt <= 8'b0000_0000;
    else begin
        case(state)
            DELAY :
                if(cnt >= 200) cnt <= 0;
                else cnt <= cnt + 1;
            SET_WRN :
                if(cnt >= 50) cnt <= 0;
                else cnt <= cnt + 1;
            UP_DATA :
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_wrn <= 1;
        dac_d <= 8'b0000_0000;
    end
    else begin
        case(state)
            DELAY :
                dac_wrn <= 1;
            SET_WRN :
                dac_wrn <= 0;
            UP_DATA :
                dac_d <= dac_d_temp;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_d_temp <= 8'b0000_0000;
        led_out <= 8'b0101_0101;
    end
    else begin
        if(btn_t == 6'b100000)      dac_d_temp <= dac_d_temp - 8'b0000_0001; // SM1 : -1
        else if(btn_t == 6'b010000) dac_d_temp <= dac_d_temp + 8'b0000_0001; // SM3 : +1
        else if(btn_t == 6'b001000) dac_d_temp <= dac_d_temp - 8'b0000_0010; // SM4 : -2
        else if(btn_t == 6'b000100) dac_d_temp <= dac_d_temp + 8'b0000_0010; // SM6 : +2
        else if(btn_t == 6'b000010) dac_d_temp <= dac_d_temp - 8'b0000_1000; // SM7 : -8
        else if(btn_t == 6'b000001) dac_d_temp <= dac_d_temp + 8'b0000_1000; // SM9 : +8
        led_out <= dac_d_temp;
    end
end

always @(posedge clk) begin
    dac_csn <= 0;
    dac_ldacn <= 0;
    dac_a_b <= add_sel; // 0 : select A, 1 : select B
end

//==================== decimal digit split ====================//
wire [3:0] d100 = dac_d_temp / 100;
wire [3:0] d10  = (dac_d_temp % 100) / 10;
wire [3:0] d1   = dac_d_temp % 10;

//==================== 7-segment ====================//
function [7:0] seg_decode;
    input [3:0] num;
    begin
        case(num)
            4'd0 : seg_decode = 8'b1111_1100;
            4'd1 : seg_decode = 8'b0110_0000;
            4'd2 : seg_decode = 8'b1101_1010;
            4'd3 : seg_decode = 8'b1111_0010;
            4'd4 : seg_decode = 8'b0110_0110;
            4'd5 : seg_decode = 8'b1011_0110;
            4'd6 : seg_decode = 8'b1011_1110;
            4'd7 : seg_decode = 8'b1110_0100;
            4'd8 : seg_decode = 8'b1111_1110;
            4'd9 : seg_decode = 8'b1111_0110;
            default : seg_decode = 8'b0000_0000;
        endcase
    end
endfunction

reg [2:0] s_cnt;

always @(posedge clk or negedge rst) begin
    if(!rst) s_cnt <= 0;
    else     s_cnt <= s_cnt + 1;
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        seg_sel  <= 8'b1111_1111;
        seg_data <= 8'b0000_0000;
    end
    else begin
        case(s_cnt)
            3'd5 : begin seg_sel <= 8'b1111_1011; seg_data <= seg_decode(d100); end // S5 : hundreds
            3'd6 : begin seg_sel <= 8'b1111_1101; seg_data <= seg_decode(d10);  end // S6 : tens
            3'd7 : begin seg_sel <= 8'b1111_1110; seg_data <= seg_decode(d1);   end // S7 : ones
            default : begin seg_sel <= 8'b1111_1111; seg_data <= 8'b0000_0000; end  // S0~S4 : off
        endcase
    end
end

//==================== Text LCD ====================//
reg [2:0] lcd_state;
integer lcd_cnt;

parameter L_DELAY        = 3'b000,
          L_FUNCTION_SET = 3'b001,
          L_ENTRY_MODE   = 3'b010,
          L_DISP_ONOFF   = 3'b011,
          L_LINE1        = 3'b100,
          L_LINE2        = 3'b101,
          L_DELAY_T      = 3'b110,
          L_CLEAR_DISP   = 3'b111;

always @(posedge clk or negedge rst) begin
    if(!rst)
        lcd_state <= L_DELAY;
    else begin
        case(lcd_state)
            L_DELAY        : if(lcd_cnt == 70) lcd_state <= L_FUNCTION_SET;
            L_FUNCTION_SET : if(lcd_cnt == 30) lcd_state <= L_DISP_ONOFF;
            L_DISP_ONOFF   : if(lcd_cnt == 30) lcd_state <= L_ENTRY_MODE;
            L_ENTRY_MODE   : if(lcd_cnt == 30) lcd_state <= L_LINE1;
            L_LINE1        : if(lcd_cnt == 20) lcd_state <= L_LINE2;
            L_LINE2        : if(lcd_cnt == 20) lcd_state <= L_DELAY_T;
            L_DELAY_T      : if(lcd_cnt == 5)  lcd_state <= L_CLEAR_DISP;
            L_CLEAR_DISP   : if(lcd_cnt == 5)  lcd_state <= L_LINE1;
            default        : lcd_state <= L_DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
        lcd_cnt <= 0;
    else begin
        case(lcd_state)
            L_DELAY        : if(lcd_cnt >= 70) lcd_cnt <= 0; else lcd_cnt <= lcd_cnt + 1;
            L_FUNCTION_SET : if(lcd_cnt >= 30) lcd_cnt <= 0; else lcd_cnt <= lcd_cnt + 1;
            L_DISP_ONOFF   : if(lcd_cnt >= 30) lcd_cnt <= 0; else lcd_cnt <= lcd_cnt + 1;
            L_ENTRY_MODE   : if(lcd_cnt >= 30) lcd_cnt <= 0; else lcd_cnt <= lcd_cnt + 1;
            L_LINE1        : if(lcd_cnt >= 20) lcd_cnt <= 0; else lcd_cnt <= lcd_cnt + 1;
            L_LINE2        : if(lcd_cnt >= 20) lcd_cnt <= 0; else lcd_cnt <= lcd_cnt + 1;
            L_DELAY_T      : if(lcd_cnt >= 5)  lcd_cnt <= 0; else lcd_cnt <= lcd_cnt + 1;
            L_CLEAR_DISP   : if(lcd_cnt >= 5)  lcd_cnt <= 0; else lcd_cnt <= lcd_cnt + 1;
            default        : lcd_cnt <= 0;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        LCD_RS <= 1'b1;
        LCD_RW <= 1'b1;
        LCD_DATA <= 8'b0000_0000;
    end
    else begin
        case(lcd_state)
            L_FUNCTION_SET : begin
                LCD_RS <= 1'b0; LCD_RW <= 1'b0; LCD_DATA <= 8'b0011_1000;
            end
            L_DISP_ONOFF : begin
                LCD_RS <= 1'b0; LCD_RW <= 1'b0; LCD_DATA <= 8'b0000_1100;
            end
            L_ENTRY_MODE : begin
                LCD_RS <= 1'b0; LCD_RW <= 1'b0; LCD_DATA <= 8'b0000_0110;
            end
            L_LINE1 : begin
                LCD_RW <= 1'b0;
                case(lcd_cnt)
                    0  : begin LCD_RS <= 1'b0; LCD_DATA <= 8'b1000_0000; end // line 1 address
                    1  : begin LCD_RS <= 1'b1; LCD_DATA <= "D"; end
                    2  : begin LCD_RS <= 1'b1; LCD_DATA <= "A"; end
                    3  : begin LCD_RS <= 1'b1; LCD_DATA <= "C"; end
                    4  : begin LCD_RS <= 1'b1; LCD_DATA <= " "; end
                    5  : begin LCD_RS <= 1'b1; LCD_DATA <= "I"; end
                    6  : begin LCD_RS <= 1'b1; LCD_DATA <= "N"; end
                    7  : begin LCD_RS <= 1'b1; LCD_DATA <= "P"; end
                    8  : begin LCD_RS <= 1'b1; LCD_DATA <= "U"; end
                    9  : begin LCD_RS <= 1'b1; LCD_DATA <= "T"; end
                    10 : begin LCD_RS <= 1'b1; LCD_DATA <= " "; end
                    11 : begin LCD_RS <= 1'b1; LCD_DATA <= ":"; end
                    12 : begin LCD_RS <= 1'b1; LCD_DATA <= " "; end
                    13 : begin LCD_RS <= 1'b1; LCD_DATA <= 8'h30 + d100; end
                    14 : begin LCD_RS <= 1'b1; LCD_DATA <= 8'h30 + d10;  end
                    15 : begin LCD_RS <= 1'b1; LCD_DATA <= 8'h30 + d1;   end
                    16 : begin LCD_RS <= 1'b1; LCD_DATA <= " "; end
                    default : begin LCD_RS <= 1'b1; LCD_DATA <= " "; end
                endcase
            end
            L_LINE2 : begin
                LCD_RW <= 1'b0;
                case(lcd_cnt)
                    0  : begin LCD_RS <= 1'b0; LCD_DATA <= 8'b1100_0000; end // line 2 address
                    1  : begin LCD_RS <= 1'b1; LCD_DATA <= "B"; end
                    2  : begin LCD_RS <= 1'b1; LCD_DATA <= "I"; end
                    3  : begin LCD_RS <= 1'b1; LCD_DATA <= "N"; end
                    4  : begin LCD_RS <= 1'b1; LCD_DATA <= " "; end
                    5  : begin LCD_RS <= 1'b1; LCD_DATA <= ":"; end
                    6  : begin LCD_RS <= 1'b1; LCD_DATA <= " "; end
                    7  : begin LCD_RS <= 1'b1; LCD_DATA <= 8'h30 + dac_d_temp[7]; end
                    8  : begin LCD_RS <= 1'b1; LCD_DATA <= 8'h30 + dac_d_temp[6]; end
                    9  : begin LCD_RS <= 1'b1; LCD_DATA <= 8'h30 + dac_d_temp[5]; end
                    10 : begin LCD_RS <= 1'b1; LCD_DATA <= 8'h30 + dac_d_temp[4]; end
                    11 : begin LCD_RS <= 1'b1; LCD_DATA <= 8'h30 + dac_d_temp[3]; end
                    12 : begin LCD_RS <= 1'b1; LCD_DATA <= 8'h30 + dac_d_temp[2]; end
                    13 : begin LCD_RS <= 1'b1; LCD_DATA <= 8'h30 + dac_d_temp[1]; end
                    14 : begin LCD_RS <= 1'b1; LCD_DATA <= 8'h30 + dac_d_temp[0]; end
                    15 : begin LCD_RS <= 1'b1; LCD_DATA <= " "; end
                    16 : begin LCD_RS <= 1'b1; LCD_DATA <= " "; end
                    default : begin LCD_RS <= 1'b1; LCD_DATA <= " "; end
                endcase
            end
            L_DELAY_T : begin
                LCD_RS <= 1'b0; LCD_RW <= 1'b0; LCD_DATA <= 8'b0000_0010; // return home
            end
            L_CLEAR_DISP : begin
                LCD_RS <= 1'b1; LCD_RW <= 1'b1; LCD_DATA <= 8'b0000_0000;
            end
            default : begin
                LCD_RS <= 1'b1; LCD_RW <= 1'b1; LCD_DATA <= 8'b0000_0000;
            end
        endcase
    end
end

assign LCD_E = clk;

endmodule
