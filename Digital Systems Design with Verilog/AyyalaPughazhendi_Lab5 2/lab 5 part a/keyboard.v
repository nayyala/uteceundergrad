
module clk_200hz_divider(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output reg slowClk; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 250000) begin
      counter <= 1;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module clk_10khz_divider(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output reg slowClk; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 5000) begin
      counter <= 1;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module kdbmodule(
	input clk, ps2clk, ps2data,
	output [7:1] seg,
	output [3:0] an,
	output led);
	wire [7:0] keyval;
	wire [3:0] O, T;
	wire clk200, clk10k, led_en, seg_en;
	
	clk_200hz_divider div200(clk, clk200);
	clk_10khz_divider div10k(clk, clk10k);
	kbdin keyboard(clk10k, ps2clk, ps2data, keyval, O, T, led_en, seg_en);
	strobe leddriver(clk10k, led_en, led);
	SevenSeg display(clk200, seg_en, O, T, seg, an);
endmodule


//debug code for 7seg
/* module tester(
	input clk_200hz,
	output reg[3:0] o, t);
	reg [7:0] value;
	
	initial begin
		value = 0;
	end
	
	always@(negedge clk_200hz) begin
		value <= value + 1;
		o <= value[3:0];
		t <= value[7:4];
	end
endmodule */

module kbdin(
	input clk, ps2clk, ps2data,
	output reg[7:0] keyval,
	output reg[3:0] ones, tens,
	output reg led_en, screen_en);
	reg [21:0] shf_reg;
	
	initial begin
		keyval = 0;
		shf_reg = 0;
		led_en = 0;
		screen_en = 0;
	end
	
	always@(negedge ps2clk) begin
		screen_en <= 1;
		shf_reg <= shf_reg >> 1;
		shf_reg[21] <= ps2data;
	end
	
	always@(posedge clk) begin
		if((shf_reg[8:1] == 8'hF0) && (keyval != shf_reg[19:12])) begin
			led_en <= 1;
			keyval <= shf_reg[19:12];
		end
		else begin
			led_en <= 0;
			keyval <= keyval;
		end
	end
	
	always@(keyval) begin
		ones <= keyval[3:0];
		tens <= keyval[7:4];
	end
endmodule

module strobe(
	input clk10k, led_en,
	output reg led);
	reg[9:0] count;
	reg state, next_state;
	
	initial begin
		count = 0;
		led = 0;
		state = 0;
		next_state = 0;
	end
	
	always@(state, led_en) begin
		case(state)
		0: begin
			led <= 0;
			if(led_en)
				next_state <= 1;
			else
				next_state <= 0;
		end
		1: begin
			led <= 1;
			if(count < 1000)
				next_state <= 1;
			else
				next_state <= 0;
		end
		endcase
	end
	
	always@(posedge clk10k) begin
		if(state)
			count <= count + 1;
		else
			count <= 0;
		state <= next_state;
	end
endmodule


module SevenSeg(
	input clk_200hz, enable,
	input [3:0] o,t,
	output reg [7:1] seven, 
	output reg [3:0] screen_val);
	reg[3:0] output_val;

	initial begin
		screen_val <= 0;
		output_val <= 0;
	end

	always @(posedge clk_200hz) begin
		if(enable)
			if(screen_val == 13)
				screen_val <= 14;
			else
				screen_val <= 13;
		else
			screen_val <= 15;
	end
	
	always@(screen_val) begin
		case(screen_val)
			13: output_val <= t;
			14: output_val <= o;
			default: output_val <= 0;
		endcase
	end
	
	always@(output_val) begin
		case (output_val) 
			4'b0000 : seven <= 7'b1000000;	//0
			4'b0001 : seven <= 7'b1111001;	//1
			4'b0010 : seven <= 7'b0100100;	//2
			4'b0011 : seven <= 7'b0110000;	//3
			4'b0100 : seven <= 7'b0011001;	//4
			4'b0101 : seven <= 7'b0010010;	//5
			4'b0110 : seven <= 7'b0000010;	//6
			4'b0111 : seven <= 7'b1111000;	//7
			4'b1000 : seven <= 7'b0000000;	//8
			4'b1001 : seven <= 7'b0010000;	//9
			4'b1010 : seven <= 7'b0001000;	//A
			4'b1011 : seven <= 7'b0000011;	//B
			4'b1100 : seven <= 7'b1000110;	//C
			4'b1101 : seven <= 7'b0100001;	//D
			4'b1110 : seven <= 7'b0000110;	//E
			4'b1111 : seven <= 7'b0001110;	//F
		endcase
	end
endmodule