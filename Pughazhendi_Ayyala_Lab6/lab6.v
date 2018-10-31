module top(clk, mode, btns, swtchs, leds, segs, an);
  input clk;
  input[1:0] mode;
  input[1:0] btns;
  input[7:0] swtchs;
  output[7:0] leds;
  output[6:0] segs;
  output[3:0] an;

  //might need to change some of these from wires to regs
  wire cs;
  wire we;
  wire[6:0] addr;
  wire[7:0] data_out_mem;
  wire[7:0] data_out_ctrl;
  wire[7:0] data_bus;

  //MODIFY THE RIGHT HAND SIDE OF THESE TWO STATEMENTS ONLY
					// 1st driver of the data bus -- tri state switches,
                    // logical function of we and data_out_ctrl
  assign data_bus = (we == 1'b1) ? data_out_ctrl : 8'bzzzzzzzz; 

					   // 2nd driver of the data bus -- tri state switches,
                       // logical function of we and data_out_mem
  assign data_bus = (we == 1'b0) ? data_out_mem : 8'bzzzzzzzz; 


  controller ctrl(clk, cs, we, addr, data_bus, data_out_ctrl, mode,
    btns, swtchs, leds, segs, an);

  memory mem(clk, cs, we, addr, data_bus, data_out_mem);

  //add any other functions you need
  //(e.g. debouncing, multiplexing, clock-division, etc)

endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

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

module d_ff(
	input D, clk,
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

module AND_gate2(
	input A, B,
	output C);
	reg LUT[1:0][1:0];

	initial begin
	LUT[0][0] <= 0;
	LUT[0][1] <= 0;
	LUT[1][0] <= 0;
	LUT[1][1] <= 1;
	end

	assign C = LUT[A][B];
endmodule

module debouncer(
	input in, clk,
	output out);
	wire qa, qan;

	d_ff d1(in,clk,qa,qan);
	d_ff d2(qa,clk,out,qan);
endmodule

module singlepulse(
	input in, clk, 
	output s1, sp, s1n);
	wire syncout;

	d_ff d1(in,clk,s1,s1n);
	AND_gate2 and1(s1n,in,sp);

endmodule

module singlepulsedebounce(
	input press, clk,
	output sp);
	wire outdeb, s1, s1n;

	debouncer db1(press,clk,outdeb);
	singlepulse sp1(outdeb,clk,s1,sp, s1n);

endmodule

module SevenSeg(
	input clk_200hz,
	input [3:0] o,t,
	output reg [7:1] seven, 
	output reg [3:0] screen_val);
	reg[3:0] output_val;

	initial begin
		screen_val <= 0;
		output_val <= 0;
	end

	always @(posedge clk_200hz) begin
		if(screen_val == 13)
			screen_val <= 14;
		else
			screen_val <= 13;
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

module controller(clk, cs, we, address, data_in, data_out, mode, btns, swtchs, leds, segs, an);
 input clk;
 output cs;
 output reg we;
 output reg[6:0] address;
 input[7:0] data_in;
 output reg[7:0] data_out;
 input[1:0] mode;
 input[1:0] btns;
 input[7:0] swtchs;
 output[7:0] leds;
 output[6:0] segs;
 output[3:0] an;
 reg [4:0] state;
 reg[6:0] SPR, DAR;
 reg[7:0] DVR, op1, op2;
 wire btnl, btnr, clk_200hz;
 
 //WRITE THE FUNCTION OF THE CONTROLLER
	initial begin
		SPR = 7'b1111111;
		DAR = 7'b0000000;
		DVR = 8'b00000000;
		state = 0;
	end
	
	always@(posedge clk) begin
		case(state)								// BTNL is swtchs[1] and BTNR is swtchs[0]
			0: begin							// push/pop mode
				we <= 0;
				DVR <= data_in;
				address <= DAR;
				if(btnl) begin					// delete/pop
					SPR <= SPR + 1;
					DAR <= SPR + 2;
				end
				else if(btnr) begin				// enter/push
					we <= 1;
					data_out <= swtchs;
					address <= SPR;
					SPR <= SPR -1;
					DAR <= SPR;
				end
				else
					state <= {3'b000, mode};
			end
			1: begin							// add/subtract mode
				we <= 0;
				DVR <= data_in;
				address <= DAR;
				if(btnl) begin					// subtract
					DAR <= SPR + 1;
					address <= SPR + 1;
					state <= 10;
				end
				else if(btnr) begin				// add
					DAR <= SPR + 1;
					address <= SPR + 1;
					state <= 4;
				end
				else
					state <= {3'b000, mode};
			end	
			2: begin							// clear/top mode
				we <= 0;
				DVR <= data_in;
				address <= DAR;
				if(btnl) begin					// clear/rst
					SPR = 7'b1111111;
					DAR = 7'b0000000;
					DVR = 8'b00000000;
				end
				else if(btnr)					// top
					DAR <= (SPR == 7'h7F) ? SPR : SPR + 1;
				else
					state <= {3'b000, mode};
			end
			3: begin							// dec/inc mode
				we <= 0;
				DVR <= data_in;
				address <= DAR;
				if(btnl)						// dec
					DAR <= DAR - 1;
				else if(btnr)					// inc
					DAR <= DAR + 1;
				else
					state <= {3'b000, mode};
			end
			4: begin	// wait for one cycle of memory
				state <= 5;
			end
			5: begin
				SPR <= SPR + 1;
				DAR <= DAR + 1;
				address <= DAR + 1;
				op1 <= data_in;
				state <= 6;
			end
			6: begin	// wait for one cycle of memory
				state <= 7;
			end
			7: begin
				SPR <= SPR + 1;
				op2 <= data_in;
				state <= 8;
			end
			8: begin	// wait for one cycle of memory
				state <= 9;
			end
			9: begin
				we <= 1;
				address <= SPR;
				data_out <= op2 + op1;
				SPR <= SPR - 1;
				// op1 <= 0;
				// op2 <= 0;
				state <= 16;
			end
			10: begin
				state <= 11;
			end
			11: begin
				SPR <= SPR + 1;
				DAR <= DAR + 1;
				address <= DAR + 1;
				op1 <= data_in;
				state <= 12;
			end
			12: begin
				state <= 13;
			end
			13: begin
				SPR <= SPR + 1;
				op2 <= data_in;
				state <= 14;
			end
			14: begin
				state <= 15;
			end
			15: begin
				we <= 1;
				address <= SPR;
				data_out <= op2 - op1;
				SPR <= SPR - 1;
				// op1 <= 0;
				// op2 <= 0;
				state <= 16;
			end
			16: begin
				state <= 17;
			end
			default: begin
				state <= {3'b000, mode};
			end
		endcase
	end
	
	
	clk_200hz_divider clk200(clk, clk_200hz);
	SevenSeg display(clk_200hz, DVR[3:0], DVR[7:4], segs, an);
	singlepulsedebounce btn0(btns[0], clk, btnr);
	singlepulsedebounce btn1(btns[1], clk, btnl);
	assign leds[6:0] = DAR;
	assign leds[7] = (SPR == 7'h7F) ? 1'b1 : 1'b0;
	assign cs = we;
endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module memory(clock, cs, we, address, data_in, data_out);
  //DO NOT MODIFY THIS MODULE
  input clock;
  input cs;
  input we;
  input[6:0] address;
  input[7:0] data_in;
  output[7:0] data_out;

  reg[7:0] data_out;

  reg[7:0] RAM[0:127];

  always @ (negedge clock)
  begin
    if((we == 1) && (cs == 1))
      RAM[address] <= data_in[7:0];

    data_out <= RAM[address];
  end
endmodule

module tristate_buffer(
	input[7:0] input_x,
	input enable,
	output[7:0] output_x);
	assign output_x = enable? input_x : 8'bzzzzzzzz;
endmodule
