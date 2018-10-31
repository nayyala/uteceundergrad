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

module isvisible(input [9:0] vcount,input [9:0] hcount, output reg signal);
	always @(*)
	begin
	if (hcount<=639 && vcount<=479)
		signal<=1;
	else
		signal<=0;
	end
endmodule

module color(input vsblsignal, input clk, input s0,s1,s2,s3,s4,s5,s6,s7, output reg [3:0] red, output reg [3:0] green, output reg [3:0] blue);
	always @ (posedge clk)begin
	if (vsblsignal)
		begin
		if (s0 == 1)
			begin red<=0;green<=0;blue<=0;end
		else if (s1 == 1)
			begin red<=0;green<=0;blue<=15;end
		else if (s2 == 1)
			begin red<=7;green<=3;blue<=0;end
		else if (s3 == 1)
			begin red<=0;green<=15;blue<=15;end
		else if (s4 == 1)
			begin red<=15;green<=0;blue<=0;end
		else if (s5 == 1)
			begin red<=15;green<=0;blue<=15;end
		else if (s6 == 1)
			begin red<=15;green<=15;blue<=0;end
		else if (s7 == 1)
			begin red<=15;green<=15;blue<=15;end
		else
			begin red<=0;green<=0;blue<=0;end
		end	
		else
		  begin red<=0;green<=0;blue<=0;end
end
	
		
		

endmodule

module VGA(input clk, input s0,s1,s2,s3,s4,s5,s6,s7, output hsyncff,vsyncff, output [3:0] redff,greenff,blueff,inout newclk);
reg [9:0] vcount,hcount;
wire hsync,vsync;
wire [3:0] red,green,blue;
wire visible;
wire [3:0] redn,greenn,bluen,vsyncn,hsyncn;
initial begin
hcount<=0;
vcount<=0;
end
clk25mhz clk1(clk,newclk);

always @ (posedge newclk) begin
    hcount <= (hcount + 1) % 800;
    if(hcount == 799)
    vcount <= (vcount + 1) % 525;
    else
    vcount <= vcount;
end


	//screeninc scrn1(vcount,hcount,newclk,vcount,hcount);
	pulsegen pul1(vcount,hcount,vsync,hsync);
	isvisible is1(vcount,hcount,visrgn);
	color clr1(visrgn,clk,s0,s1,s2,s3,s4,s5,s6,s7,red,green,blue);
	d_ff redf(red,newclk,redff,redn);
	d_ff bluef(blue,newclk,blueff,bluen);
	d_ff greenf(green,newclk,greenff,greenn);
	d_ff vsyncf(vsync,newclk,vsyncff,vsyncn);
	d_ff hsyncf(hsync,newclk,hsyncff,hsyncn);






endmodule
	
	
	
	