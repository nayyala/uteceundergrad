module lab3top(
    
input clk, rst, 
	output Ga, Ya, Ra, Gb, Yb, Rb, Gw, Rw);
	wire clk_2hz, clk_1hz;
	clk_to_2hz convert2hz(clk, clk_2hz);
	clk_to_1hz convert1hz(clk_2hz, clk_1hz);
	traffic_light light(clk_1hz, clk_2hz, rst, Ga, Ya, Ra, Gb, Yb, Rb, Gw, Rw);
endmodule


module clk_to_2hz(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output reg slowClk; //slow clock

  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk100Mhz)
  begin
    if(counter == 50000000) begin
      counter <= 1;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule

module clk_to_1hz(clk2hz, slowClk);
  input clk2hz; //fast clock
  output reg slowClk; //slow clock

  reg[1:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk2hz)
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