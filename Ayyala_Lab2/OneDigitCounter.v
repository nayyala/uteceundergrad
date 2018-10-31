module complexDivider(clk100Mhz, slowClk);
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

module onedigitcounter(enable,load,up,clr,d,cout,qout,clk1);
input enable,load,up,clr;
input [3:0] d;
output cout;
output [3:0] qout;
reg [3:0] q;
reg cut;
wire clk;
input clk1;

complexDivider(clk1,clk);

initial begin
assign cut=1'b1;
assign q = 4'b0000;
end

always @ (posedge clk)
begin
if (load&enable&(d<=1001))
	q<=d;
else if (~load&enable&up&q[3]&~q[2]&~q[1]&q[0])
	begin
	q<=0;
	end
else if (~load&enable&up) 
	q<=q+1;
else if (~load&~up&enable&~q[3]&~q[2]&~q[1]&~q[0])
	begin
	q<=9;
	end
else if (~load&~up&enable)
	q<=q-1;
else
	q<=q;
end

always @ (clr)
if (~clr)   
begin        
cut<=1'b0;  
end
else
cut<=1'b1;
         

assign qout = q&clr;
assign cout = ((enable&up&q[3]&~q[2]&~q[1]&q[0])|(enable&~up&~q[3]&~q[2]&~q[1]&~q[0]))&cut;


endmodule