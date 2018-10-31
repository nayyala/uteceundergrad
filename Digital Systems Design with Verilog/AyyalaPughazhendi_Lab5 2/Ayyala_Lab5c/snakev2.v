module clk_5hz_divider(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output reg slowClk; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 10000000) begin
      counter <= 1;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

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

module clk25mhz(input clk, output reg slowClk);
  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk)
  begin
    if(counter == 2) begin
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

module d_ff(
	input [3:0] D, input clk,
	output reg [3:0] Q, Qnot);

	initial begin
		Q = 0;
		Qnot = 1;
	end

	always @(posedge clk) begin
		Q <= D;
		Qnot <= ~D;
	end
endmodule

module d_ff1bit(
	input D, input clk,
	output reg Q, Qnot);

	initial begin
		Q = 0;
		Qnot = 1;
	end

	always @(posedge clk) begin
		Q <= D;
		Qnot <= ~D;
	end
endmodule

module pulsegen(
	input [9:0] vcount, hcount, 
	output reg vsync, hsync);

	initial begin
		vsync = 1;
		hsync = 1;
	end
	
	always @(*) begin
		if ((hcount >= 659) && (hcount <= 755))
			hsync <= 0;
		else
			hsync <= 1;
		if ((vcount == 493) || (vcount == 494))
			vsync <= 0;
		else
			vsync<=1;
	end	
endmodule

module isvisible(
	input [9:0] vcount, hcount,
	output reg signal);
	always @(*) begin
		if ((hcount<=639) && (vcount<=479))
			signal<=1;
		else
			signal<=0;
	end	
endmodule

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

module fillblock(
	input [6:0] firstcornerv, firstcornerh, secondcornerh, secondcornerv, thirdcornerh, thirdcornerv, lastcornerh, lastcornerv,
	input [1:0] control,
	input visible,
	input [9:0] vcount, hcount,
	output reg [3:0] red, green, blue);
	always @(*) begin
		if (visible) begin
			if (control != 2) begin
				if (((vcount>=(firstcornerv*10)) && (vcount<=(firstcornerv*10 + 10)) && (hcount>=(firstcornerh*10)) && (hcount<=(firstcornerh*10 + 10)))
				|| ((vcount>=(secondcornerv*10)) && (vcount<=(secondcornerv*10 + 10)) && (hcount>=(secondcornerh*10)) && (hcount<=(secondcornerh*10 + 10)))
				|| ((vcount>=(thirdcornerv*10)) && (vcount<=(thirdcornerv*10 + 10)) && (hcount>=(thirdcornerh*10)) && (hcount<=(thirdcornerh*10 + 10)))
				|| ((vcount>=(lastcornerv*10)) && (vcount<=(lastcornerv*10 + 10)) && (hcount>=(lastcornerh*10)) && (hcount<=(lastcornerh*10 + 10)))) begin
					red <= 0;
					blue <= 15;
					green <= 0;
				end
				else begin
					red <= 15;
					blue <= 15;
					green <= 15;
				end
			end
			else begin 
				red<=0;
				green<=0;
				blue<=0;
			end
				
		end
		else begin
			red <= 0;
			green <= 0;
			blue <= 0;
		end
	end
endmodule


module movesnake(
	input [1:0] direction, control,
	input clk_5hz, error,
	output reg [6:0] FCV, FCH, SCH, SCV, TCH, TCV, LCV, LCH,
	output reg [1:0] prev_dir);
	
	initial begin
		FCV = 31;
		SCV = 31;
		TCV = 31;
		LCV = 31;
		FCH = 3;
		SCH = 2;
		TCH = 1;
		LCH = 0;
		prev_dir=3;
		
	end
	
	always @(posedge clk_5hz) begin
		if (error) begin
			FCH<=FCH;
			FCV<=FCV;
			SCH<=SCH;
			SCV<=SCV;
			TCV<=TCV;
			TCH<=TCH;
			LCV<=LCV;
			LCH<=LCH;
			prev_dir<=prev_dir;
		end
		else begin
			case(control)
				0: begin 
					case(prev_dir)
						0, 1: begin	// down or up
							if((direction == 0) || (direction == 1)) begin
								if(prev_dir == 0) begin			// down
									FCV <= FCV + 1;
									FCH <= FCH;
								end
								else begin						// up
									FCV <= FCV - 1;
									FCH <= FCH;
								end
							end
							else if(direction == 2) begin		// left
								FCV <= FCV;
								FCH <= FCH - 1;
								prev_dir <= direction;
							end
							else begin							// right
								FCV <= FCV;
								FCH <= FCH + 1;
								prev_dir <= direction;
							end	
						end
						2, 3:begin		// left or right
							if((direction == 2) || (direction == 3)) begin
								if(prev_dir == 2) begin			// left
									FCV <= FCV;
									FCH <= FCH - 1;
								end
								else begin						// right
									FCV <= FCV;
									FCH <= FCH + 1;
								end
							end
							else if(direction == 1) begin		// up
								FCV <= FCV - 1;
								FCH <= FCH;
								prev_dir <= direction;
							end
							else begin								// down
								FCV <= FCV + 1;
								FCH <= FCH;
								prev_dir <= direction;
							end	
						end
					endcase
					SCH <= FCH;
					SCV <= FCV;
					TCH <= SCH;
					TCV <= SCV;
					LCH <= TCH;
					LCV <= TCV;
				end
				1: begin 
					FCH<=FCH;
					FCV<=FCV;
					SCH<=SCH;
					SCV<=SCV;
					TCV<=TCV;
					TCH<=TCH;
					LCV<=LCV;
					LCH<=LCH;
					prev_dir<=prev_dir;
				end
				2, 3: begin
					FCV <= 31;
					SCV <= 31;
					TCV <= 31;
					LCV <= 31;
					FCH <= 3;
					SCH <= 2;
					TCH <= 1;
					LCH <= 0;
					prev_dir <= 3;
				end
			endcase
		end
	end
endmodule


module CollisionDetection(
	input [6:0] SCV, SCH,
	input [1:0] prev_dir, control,
	output reg error);
	initial begin
	   error<=1;
	end
	always @(*) begin
		if (control == 2 || control == 3) 
			error<=0;
		else begin
			case(prev_dir)
				0: begin			//down
					if((SCV == 47))
						error <= 1;
					else
						error <= 0;
				end
				1: begin			// up
					if((SCV == 0))
						error <= 1;
					else
						error <= 0;
				end
				2: begin			//left
					if((SCH == 0))
						error <= 1;
					else
						error <= 0;
				end
				3: begin			//right
					if((SCH == 63))
						error <= 1;
					else
						error <= 0;
				end
			endcase
		end
	end
endmodule

module interpretkeyboard(
	input[7:0] keyval, 
	input error, enable,
	output reg [1:0] direction, control);
	
	initial begin
		direction<=3;
		control<=2;
	end
	
	always@(posedge enable) begin
		 if (error) begin
			if ((keyval != 8'h76) && (keyval != 8'h1B))begin
				control<=control;
				direction<=direction;
			end
			else if (keyval == 8'h76) begin
				control<=2;
			end
			else begin
				control<=3;
			end
		end
		else begin
			case(keyval)
				8'h75: begin		// up
					direction <= 1;
					control <= control;
				end
				8'h72: begin		// down
					direction <= 0;
					control <= control;
				end
				8'h6B: begin		// left
					direction <= 2;
					control <= control;
				end
				8'h74: begin		// right
					direction <= 3;
					control <= control;
				end
				8'h2D: begin		// R
					if (control != 2) begin
						direction <= direction;
						control <= 0;
					end
					else
						control<=control;
				end
				8'h4D: begin		// P
					if (control != 2) begin
						direction <= direction;
						control <= 1;
					end
					else
						control<=control;
				end
				8'h76: begin		// esc
					direction <= direction;
					control <= 2;
				end
				8'h1B: begin		// S
					direction <= direction;
					control <= 3;
				end
				default: begin
					direction <= direction;
					control <= control;
				end
			endcase
		end
	end
endmodule

module lab5main(
	input clk, ps2clk, ps2data,
	output hsyncff, vsyncff,
	output [3:0] redff, greenff, blueff,
	output [7:1] seg,
	output [3:0] an,
	inout clk25m, led);
	wire [7:0] keyval;
	wire [6:0] FCV, FCH, SCH, SCV, TCH, TCV, LCV, LCH;
	wire [3:0] O, T, red, green, blue, redn, greenn, bluen;
	wire [1:0] direction, prev_dir, control;
	wire clk5, clk10k, clk200, seg_en, led_en, hsync, vsync, visrgn, error, vsyncn, hsyncn;
	reg [9:0] vcount,hcount;
	
	always @ (posedge clk25m) begin
		hcount <= (hcount + 1) % 800;
		if(hcount == 799)
			vcount <= (vcount + 1) % 525;
		else
			vcount <= vcount;
	end
	
	clk_200hz_divider div200(clk, clk200);
	clk_5hz_divider div5(clk, clk5);
	clk_10khz_divider div10k(clk, clk10k);
	clk25mhz div25m(clk,clk25m);
	
	kbdin keyboard(clk10k, ps2clk, ps2data, keyval, O, T, led_en, seg_en);
	strobe strober(clk10k, led_en, led);
	SevenSeg display(clk200, seg_en, O, T, seg, an);
	
	interpretkeyboard whatever(keyval, error, led, direction, control);
	movesnake main(direction, control, clk5, error, FCV, FCH, SCH, SCV, TCH, TCV, LCV, LCH, prev_dir);
	CollisionDetection detector(SCV, SCH, prev_dir, control, error);
	fillblock filler(FCV, FCH, SCH, SCV, TCH, TCV, LCH, LCV, control, visrgn, vcount, hcount, red, green, blue);
	
	pulsegen pul1(vcount, hcount, vsync, hsync);
	isvisible is1(vcount, hcount, visrgn);
	
	d_ff redf(red, clk25m, redff, redn);
	d_ff bluef(blue, clk25m, blueff, bluen);
	d_ff greenf(green, clk25m, greenff, greenn);
	d_ff1bit vsyncf(vsync, clk25m, vsyncff, vsyncn);
	d_ff1bit hsyncf(hsync, clk25m, hsyncff, hsyncn);
endmodule