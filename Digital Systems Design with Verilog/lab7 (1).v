module slow_Clk(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output reg slowClk; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 50) begin
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

/* module singlepulse(
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

endmodule */

module SevenSeg(
	input clk_200hz,
	input [3:0] o,t,h,th,
	output reg [7:1] seven, 
	output reg [3:0] screen_val);
	reg[3:0] output_val;

	initial begin
		screen_val <= 7;
		output_val <= 0;
	end

	always @(posedge clk_200hz) begin
		screen_val <= {screen_val[2:0], screen_val[3]};
	end
	
	always@(screen_val) begin
		case(screen_val)
			7: output_val <= th;
			11: output_val <= h;
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

module reg_Display(
	input[31:0] R2, R3,
	input[2:0] switches,
	input[1:0] btns,
	input clk,
	output[6:0] seg, 
	output[3:0] an);
	reg[15:0] display;
	wire[1:0] btn;
	wire clk_200hz;
	
	always@(posedge clk) begin
		case (switches)
			0: begin
				case (btn)
					0: display <= R2[15:0];
					1: display <= R2[31:16];
					2: display <= R3[15:0];
					3: display <= R3[31:16];
				endcase
			end
			1, 2, 3, 4, 5, 6: begin
				case (btn)
					0: display <= R2[15:0];
					1: display <= R2[31:16];
					default: display <= display;
				endcase
			end
			default: display <= display;
		endcase
	end

	clk_200hz_divider clk_div(clk, clk_200hz);
	debouncer btn0(btns[0], clk, btn[0]); //map btns[0] to BTNR
	debouncer btn1(btns[1], clk, btn[1]); //map btns[1] to BTNL
	SevenSeg disp(clk_200hz, display[3:0], display[7:4], display[11:8], display[15:12], seg, an);
endmodule


/* // You can use this skeleton testbench code, the textbook testbench code, or your own
module MIPS_Testbench ();
  reg CLK;
  reg RST;
  wire CS;
  wire WE;
  wire [31:0] Mem_Bus;
  wire [6:0] Address;

  initial
  begin
    CLK = 0;
  end

  MIPS CPU(CLK, RST, CS, WE, Address, Mem_Bus);
  Memory MEM(CS, WE, CLK, Address, Mem_Bus);

  always
  begin
    #5 CLK = !CLK;
  end

  always
  begin
    RST <= 1'b1; //reset the processor

    //Notice that the memory is initialize in the in the memory module not here

    @(posedge CLK);
    // driving reset low here puts processor in normal operating mode
    RST = 1'b0;

    add your testing code here
    // you can add in a 'Halt' signal here as well to test Halt operation
    // you will be verifying your program operation using the
    // waveform viewer and/or self-checking operations

    $display("TEST COMPLETE");
    $stop;
  end

endmodule */

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module Complete_MIPS(CLK, sw, swtchs, btns, led, seg, an);
  // Will need to be modified to add functionality
  input CLK;
  input [2:0] sw;
  input [1:0] swtchs, btns;
  output [7:0] led;
  output[6:0] seg; 
  output[3:0] an;

  wire CS, WE;
  wire [6:0] ADDR;
  wire [31:0] R2_out, R3_out;
  wire [31:0] Mem_Bus;
  wire slow_clk;
  
  slow_Clk clk10z(CLK, slow_clk);
  MIPS CPU(slow_clk, swtchs[0], swtchs[1], CS, WE, sw, ADDR, Mem_Bus, led, R2_out, R3_out);
  reg_Display DSP(R2_out, R3_out, sw, btns, CLK, seg, an);
  Memory MEM(slow_clk, WE, CLK, ADDR, Mem_Bus);

endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module Memory(CS, WE, CLK, ADDR, Mem_Bus);
  input CS;
  input WE;
  input CLK;
  input [6:0] ADDR;
  inout [31:0] Mem_Bus;

  reg [31:0] data_out;
  reg [31:0] RAM [0:127];


  initial
  begin
    /* Write your Verilog-Text IO code here */
	//$readmemh("leds.txt", RAM, 0, 11);
	$readmemh("testPartB_2.txt", RAM, 0, 39);
  end

  assign Mem_Bus = ((CS == 1'b0) || (WE == 1'b1)) ? 32'bZ : data_out;

  always @(negedge CLK)
  begin

    if((CS == 1'b1) && (WE == 1'b1))
      RAM[ADDR] <= Mem_Bus[31:0];

    data_out <= RAM[ADDR];
  end
endmodule

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

module REG(CLK, RegW, DR, SR1, SR2, Reg_In, ReadReg1, ReadReg2, LED_out, R2_out, R3_out);
  input CLK;
  input RegW;
  input [4:0] DR;
  input [4:0] SR1;
  input [4:0] SR2;
  input [31:0] Reg_In;
  output reg [31:0] ReadReg1;
  output reg [31:0] ReadReg2;
  output [7:0] LED_out;
  output [31:0] R2_out, R3_out;

  reg [31:0] REG [0:31];
  integer i;

  initial begin
    ReadReg1 = 0;
    ReadReg2 = 0;
  end

  always @(posedge CLK)
  begin

    if(RegW == 1'b1)
      REG[DR] <= Reg_In[31:0];

    ReadReg1 <= REG[SR1];
    ReadReg2 <= REG[SR2];
  end
  
  assign LED_out = REG[1][7:0];
  assign R2_out = REG[4];
  assign R3_out = REG[5];
endmodule


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

`define opcode instr[31:26]
`define sr1 instr[25:21]
`define sr2 instr[20:16]
`define f_code instr[5:0]
`define numshift instr[10:6]

module MIPS (CLK, RST, HALT, CS, WE, swt, ADDR, Mem_Bus, LED_out, R2_out, R3_out);
  input CLK, RST, HALT;
  output reg CS, WE;
  input [2:0] swt;
  output [6:0] ADDR;
  inout [31:0] Mem_Bus; 
  output [7:0] LED_out;
  output [31:0] R2_out, R3_out;

  //special instructions (opcode == 000000), values of F code (bits 5-0):
  parameter add = 6'b100000;
  parameter sub = 6'b100010;
  parameter xor1 = 6'b100110;
  parameter and1 = 6'b100100;
  parameter or1 = 6'b100101;
  parameter slt = 6'b101010;
  parameter srl = 6'b000010;
  parameter sll = 6'b000000;
  parameter jr = 6'b001000;
  parameter mult = 6'b011000;	//24, multiply word
  parameter mfhi = 6'b010000;	// move from register hi, 16
  parameter mflo = 6'b010010;	// move from register lo, 18
  parameter add8 = 6'b101101;	//45, byte-wise addition
  parameter rbit = 6'b101111;	// reverse bits, 47
  parameter rev = 6'b110000;	// reverse bytes, 48
  parameter sadd = 6'b110001;	//49, saturating add
  parameter ssub = 6'b110010; 	//50, saturating subtraction

  //non-special instructions, values of opcodes:
  parameter addi = 6'b001000;
  parameter andi = 6'b001100;
  parameter ori = 6'b001101;
  parameter lw = 6'b100011;
  parameter sw = 6'b101011;
  parameter beq = 6'b000100;
  parameter bne = 6'b000101;
  parameter j = 6'b000010;
  parameter jal = 6'b000011;	// jump after link, 3
  parameter lui = 6'b001111;	// load upper immediate, 15

  //instruction format
  parameter R = 2'd0;
  parameter I = 2'd1;
  parameter J = 2'd2;

  //internal signals
  reg [5:0] op, opsave;
  wire [1:0] format;
  reg [31:0] instr;
  reg [63:0] alu_result;
  reg [63:0] prod;
  reg [6:0] pc, npc,tempc;
  wire [31:0] imm_ext, alu_in_A, alu_in_B, reg_in, readreg1, readreg2;
  reg [31:0] alu_result_save, hi_result_save, lo_result_save;
  reg alu_or_mem, alu_or_mem_save, regw, writing, reg_or_imm, reg_or_imm_save;
  reg fetchDorI;
  reg [2:0] prev_swt;
  wire [4:0] dr;
  reg [2:0] state, nstate;
  wire jl, lu;
  wire [31:0] HI,LO;

  //combinational
  assign imm_ext = (instr[15] == 1)? {16'hFFFF, instr[15:0]} : {16'h0000, instr[15:0]};//Sign extend immediate field
  assign dr = (format == R)? ((jl == 1)?31:((opsave == rev || opsave == rbit)?instr[25:21]:instr[15:11])) : instr[20:16]; //Destination Register MUX (MUX1)
  assign alu_in_A = readreg1;
  assign alu_in_B = (reg_or_imm_save)? imm_ext : readreg2; //ALU MUX (MUX2)
  assign reg_in = (alu_or_mem_save)? Mem_Bus : alu_result_save; //Data MUX
  assign HI = hi_result_save;
  assign LO = lo_result_save;
  assign format = (`opcode == 6'd0)? R : ((`opcode == 6'd2)? J : I);
  assign Mem_Bus = (writing)? readreg2 : 32'bZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ;
  assign jl = (`opcode == 6'd3);
  assign lu = (`opcode == lui);

  //drive memory bus only during writes
  assign ADDR = (fetchDorI)? pc : alu_result_save[6:0]; //ADDR Mux
  REG Register(CLK, regw, dr, `sr1, `sr2, reg_in, readreg1, readreg2, LED_out, R2_out, R3_out);

  initial begin
    op = and1; opsave = and1;
    state = 3'b0; nstate = 3'b0;
    alu_or_mem = 0;
    regw = 0;
    fetchDorI = 0;
    writing = 0;
    reg_or_imm = 0; reg_or_imm_save = 0;
    alu_or_mem_save = 0;
    prod = 0;
	prev_swt = 0;
  end

  always @(*)
  begin
    fetchDorI = 0; CS = 0; WE = 0; regw = 0; writing = 0; alu_result = 64'd0;
    npc = pc; op = jr; reg_or_imm = 0; alu_or_mem = 0; nstate = 3'd0;
    case (state)
      0: begin //fetch
		if(HALT)
			nstate = 3'd0;
		else begin
			npc = pc + 7'd1; CS = 1; nstate = 3'd1;
			fetchDorI = 1;
		end
      end
      1: begin //decode
        nstate = 3'd2; reg_or_imm = 0; alu_or_mem = 0;
        if (format == J) begin //jump, and finish
          npc = instr[6:0];
          nstate = 3'd0;
        end
		else if (`opcode == jal) begin 	// jump and finish
			tempc = npc;
			npc = instr[6:0];
			nstate = 3'd2;
		end
		/* else if (`opcode == lui) begin	// load upper immediate
			nstate = 3'd2;	
			reg_or_imm = 1;
		end */
        else if (format == R) //register instructions
          op = `f_code;
        else if (format == I) begin //immediate instructions
          reg_or_imm = 1;
          if(`opcode == lw) begin
            op = add;
            alu_or_mem = 1;
          end
          else if ((`opcode == lw)||(`opcode == sw)||(`opcode == addi)) op = add;
          else if ((`opcode == beq)||(`opcode == bne)) begin
            op = sub;
            reg_or_imm = 0;
          end
          else if (`opcode == andi) op = and1;
          else if (`opcode == ori) op = or1;
        end
      end
      2: begin //execute
        nstate = 3'd3;
        if (opsave == and1) alu_result = alu_in_A & alu_in_B;
        else if (opsave == or1) alu_result = alu_in_A | alu_in_B;
        else if (opsave == add) alu_result = alu_in_A + alu_in_B;
        else if (opsave == sub) alu_result = alu_in_A - alu_in_B;
        else if (opsave == srl) alu_result = alu_in_B >> `numshift;
        else if (opsave == sll) alu_result = alu_in_B << `numshift;
        else if (opsave == slt) alu_result = (alu_in_A < alu_in_B)? 32'd1 : 32'd0;
        else if (opsave == xor1) alu_result = alu_in_A ^ alu_in_B;
		else if (opsave == mult) alu_result = alu_in_A * alu_in_B;
		else if (opsave == mfhi) alu_result = HI;
		else if (opsave == mflo) alu_result = LO;
		else if (`opcode == jal) alu_result = tempc;
		else if (`opcode == lui) alu_result = alu_in_B << 16;
		else if (opsave == add8) begin
			alu_result[7:0] = alu_in_A[7:0] + alu_in_B[7:0];
			alu_result[15:8] = alu_in_A[15:8] + alu_in_B[15:8];
			alu_result[23:16] = alu_in_A[23:16] + alu_in_B[23:16];
			alu_result[31:24] = alu_in_A[31:24] + alu_in_B[31:24];		
		end
		else if (opsave == rev) begin
			alu_result[7:0]<=alu_in_B[31:24];
			alu_result[15:8]<=alu_in_B[23:16];
			alu_result[23:16]<=alu_in_B[15:8];
			alu_result[31:24]<=alu_in_B[7:0];		
		end
		else if (opsave == rbit) begin
			alu_result[0] <= alu_in_B[31];
            alu_result[1] <= alu_in_B[30];
            alu_result[2] <= alu_in_B[29];
            alu_result[3] <= alu_in_B[28];
            alu_result[4] <= alu_in_B[27];
            alu_result[5] <= alu_in_B[26];
            alu_result[6] <= alu_in_B[25];
            alu_result[7] <= alu_in_B[24];
            alu_result[8] <= alu_in_B[23];
            alu_result[9] <= alu_in_B[22];
            alu_result[10] <= alu_in_B[21];
            alu_result[11] <= alu_in_B[20];
            alu_result[12] <= alu_in_B[19];
            alu_result[13] <= alu_in_B[18];
            alu_result[14] <= alu_in_B[17];
            alu_result[15] <= alu_in_B[16];
            alu_result[16] <= alu_in_B[15];
            alu_result[17] <= alu_in_B[14];
            alu_result[18] <= alu_in_B[13];
            alu_result[19] <= alu_in_B[12];
            alu_result[20] <= alu_in_B[11];
            alu_result[21] <= alu_in_B[10];
            alu_result[22] <= alu_in_B[9];
            alu_result[23] <= alu_in_B[8];
            alu_result[24] <= alu_in_B[7];
            alu_result[25] <= alu_in_B[6];
            alu_result[26] <= alu_in_B[5];
            alu_result[27] <= alu_in_B[4];
            alu_result[28] <= alu_in_B[3];
            alu_result[29] <= alu_in_B[2];
            alu_result[30] <= alu_in_B[1];
            alu_result[31] <= alu_in_B[0];
		end
		else if (opsave == sadd) begin
			if (alu_in_A + alu_in_B > 2^32 - 1)
				alu_result = 2^32 - 1;
			else if (alu_in_A + alu_in_B < -2^32)
				alu_result = -2^32;
			else
				alu_result = alu_in_A + alu_in_B;
		end
		else if (opsave == ssub) begin
			if (alu_in_A - alu_in_B < 0)
				alu_result = 0;
			else
				alu_result = alu_in_A - alu_in_B;		
		end
        if (((alu_in_A == alu_in_B)&&(`opcode == beq)) || ((alu_in_A != alu_in_B)&&(`opcode == bne))) begin
          npc = pc + imm_ext[6:0];
          nstate = 3'd0;
        end
        else if ((`opcode == bne)||(`opcode == beq)) nstate = 3'd0;
        else if (opsave == jr) begin
          npc = alu_in_A[6:0];
          nstate = 3'd0;
        end
      end
      3: begin //prepare to write to mem
        nstate = 3'd0;
        if ((format == R)||(`opcode == addi)||(`opcode == andi)||(`opcode == ori)||(`opcode == jal)||(`opcode == lui)) regw = 1;
        else if (`opcode == sw) begin
          CS = 1;
          WE = 1;
          writing = 1;
        end
        else if (`opcode == lw) begin
          CS = 1;
          nstate = 3'd4;
        end
      end
      4: begin
        nstate = 3'd0;
        CS = 1;
        if (`opcode == lw) regw = 1;
      end
    endcase
  end //always

  always @(posedge CLK) begin

    if (RST) begin
      state <= 3'd0;
      pc <= 7'd0;
    end
    else begin
		state <= nstate;
		if(prev_swt != swt) begin
			case (swt)
				0: pc <= 11;
				1: pc <= 13;
				2: pc <= 15;
				3: pc <= 17;
				4: pc <= 19;
				5: pc <= 21;
				6: pc <= 23;
				default: pc <= npc;
			endcase
			prev_swt <= swt;
		end
		else begin
			prev_swt <= prev_swt;
			pc <= npc;
		end
    end

    if (state == 3'd0) instr <= Mem_Bus;
    else if (state == 3'd1) begin
      opsave <= op;
      reg_or_imm_save <= reg_or_imm;
      alu_or_mem_save <= alu_or_mem;
    end
    else if (state == 3'd2) begin
        if(opsave == mult)begin
            hi_result_save <= alu_result[63:32];
            lo_result_save <= alu_result[31:0];
        end
		else begin
			alu_result_save <= alu_result[31:0];
        end
    end

  end //always

endmodule
