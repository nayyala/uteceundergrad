
module traffic_light(
	input clk_1hz, clk_2hz, rst, 
	output reg Ga, Ya, Ra, Gb, Yb, Rb, Gw, Rw);
	reg[3:0] state, nextstate;
	reg prev_rst;

	initial begin
	Ga <= 0;
	Ya <= 0;
	Ra <= 0;
	Gb <= 0;
	Yb <= 0;
	Rb <= 0;
	Gw <= 0;
	Rw <= 0;
	state <= 0;
	prev_rst <= 0;
	end

	always@(state, clk_2hz, clk_1hz) begin
	case(state)
	0:begin
		nextstate <= state + 1;
		Ga <= 1;
		Ya <= 0;
		Ra <= 0;
		Gb <= 0;
		Yb <= 0;
		Rb <= 1;
		Gw <= 0;
		Rw <= 1;
	end
	1:begin
		nextstate <= state + 1;
		Ga <= 1;
		Ya <= 0;
		Ra <= 0;
		Gb <= 0;
		Yb <= 0;
		Rb <= 1;
		Gw <= 0;
		Rw <= 1;
	end
	2:begin
		nextstate <= state + 1;
		Ga <= 1;
		Ya <= 0;
		Ra <= 0;
		Gb <= 0;
		Yb <= 0;
		Rb <= 1;
		Gw <= 0;
		Rw <= 1;
	end
	3:begin
		nextstate <= state + 1;
		Ga <= 0;
		Ya <= 1;
		Ra <= 0;
		Gb <= 0;
		Yb <= 0;
		Rb <= 1;
		Gw <= 0;
		Rw <= 1;
	end
	4:begin
		nextstate <= state + 1;
		Ga <= 0;
		Ya <= 1;
		Ra <= 0;
		Gb <= 0;
		Yb <= 0;
		Rb <= 1;
		Gw <= 0;
		Rw <= 1;
	end
	5:begin
		nextstate <= state + 1;
		Ga <= 0;
		Ya <= 0;
		Ra <= 1;
		Gb <= 1;
		Yb <= 0;
		Rb <= 0;
		Gw <= 0;
		Rw <= 1;
	end
	6:begin
		nextstate <= state + 1;
		Ga <= 0;
		Ya <= 0;
		Ra <= 1;
		Gb <= 1;
		Yb <= 0;
		Rb <= 0;
		Gw <= 0;
		Rw <= 1;
	end
	7:begin
		nextstate <= state + 1;
		Ga <= 0;
		Ya <= 0;
		Ra <= 1;
		Gb <= 1;
		Yb <= 0;
		Rb <= 0;
		Gw <= 0;
		Rw <= 1;
	end
	8:begin
		nextstate <= state + 1;
		Ga <= 0;
		Ya <= 0;
		Ra <= 1;
		Gb <= 0;
		Yb <= 1;
		Rb <= 0;
		Gw <= 0;
		Rw <= 1;
	end
	9:begin
		nextstate <= state + 1;
		Ga <= 0;
		Ya <= 0;
		Ra <= 1;
		Gb <= 0;
		Yb <= 0;
		Rb <= 1;
		Gw <= 1;
		Rw <= 0;
	end
	10:begin
		nextstate <= state + 1;
		Ga <= 0;
		Ya <= 0;
		Ra <= 1;
		Gb <= 0;
		Yb <= 0;
		Rb <= 1;
		Gw <= 1;
		Rw <= 0;
	end
	11:begin
		nextstate <= state + 1;
		Ga <= 0;
		Ya <= 0;
		Ra <= 1;
		Gb <= 0;
		Yb <= 0;
		Rb <= 1;
		Gw <= 0;
		Rw <= clk_2hz;
	end
	12:begin
		nextstate <= 0;
		Ga <= 0;
		Ya <= 0;
		Ra <= 1;
		Gb <= 0;
		Yb <= 0;
		Rb <= 1;
		Gw <= 0;
		Rw <= clk_2hz;
	end
	13:begin
		nextstate <= 13;
		Ga <= 0;
		Ya <= 0;
		Ra <= clk_1hz;
		Gb <= 0;
		Yb <= 0;
		Rb <= clk_1hz;
		Gw <= 0;
		Rw <= clk_1hz;
	end
	default:begin
		nextstate <= 0;
		Ga <= 1;
		Ya <= 0;
		Ra <= 0;
		Gb <= 0;
		Yb <= 0;
		Rb <= 1;
		Gw <= 0;
		Rw <= 1;
	end
	endcase
	end

	always@(posedge clk_1hz, posedge rst)begin
	if(rst == 1)begin
		state <= 13;
		prev_rst <= 1;
	end
	else if((rst == 0) && (prev_rst == 1)) begin
		state <= 0;
		prev_rst <= 0;
	end
	else
		state <= nextstate;
	end
endmodule

