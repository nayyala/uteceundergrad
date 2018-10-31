module onedigitcounter(enable,load,up,clr,d,cout,qout,clk);
input enable,load,up,clr;
input [3:0] d;
output cout;
output [3:0] qout;
reg [3:0] q;
reg cut;
input clk;
wire clk1;

top top1(clk1);
complexDivider(clk1,clk);

initial begin
cut<=1;
end

assign qout = q;
assign cout = ((enable&up&q[3]&~q[2]&~q[1]&q[0])|(enable&~up&~q[3]&~q[2]&~q[1]&~q[0]))&cut;

always @ (posedge clk)
begin
if (load&enable&(d<=1001))
	q<=d;
else if (~load&enable&up&q[3]&~q[2]&~q[1]&q[0])
	begin
	q<=0;
	cut<=1;
	end
else if (~load&enable&up) 
	q<=q+1;
else if (~load&~up&enable&~q[3]&~q[2]&~q[1]&~q[0])
	begin
	q<=9;
	cut<=1;
	end
else if (~load&~up&enable)
	q<=q-1;
else
	q<=q;
end

always @ (clr)
if (~clr)
begin
q<=0;
cut<=0;
end

endmodule

module twodigitcountah(enable,load,up,clr,d1,d2,cout,qout,clk);
input enable,load,up,clr;
input [3:0] d1;
input [3:0] d2;
output cout;
output [7:0] qout;
input clk; 
wire clk1;

top top1(clk1);
complexDivider(clk1,clk);


wire carry1;

onedigitcounter ones (enable,load,up,clr,d2,carry1,qout[3:0],clk);
onedigitcounter tens (carry1|load,load,up,clr,d1,cout,qout[7:4],clk);

endmodule

