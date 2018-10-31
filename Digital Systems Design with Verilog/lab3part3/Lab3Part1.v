module packagesorter(clk,reset,weight,grp1,grp2,grp3,grp4,grp5,grp6,currgrp,prevweight);
input clk;
input reset;
input [11:0] weight;
output reg [7:0] grp1;
output reg [7:0] grp2;
output reg [7:0] grp3;
output reg [7:0] grp4;
output reg [7:0] grp5;
output reg [7:0] grp6;
output reg [2:0] currgrp;
output reg [11:0] prevweight;

initial begin
grp1=0;
grp2=0;
grp3=0;
grp4=0;
grp5=0;
grp6=0;
currgrp=0;
prevweight=0;
end

always @ (negedge clk)
if (prevweight == 0)
begin
if (weight>=1 && weight<=250)
begin
grp1<=grp1+1;
currgrp<=1;
prevweight<=weight;
end
else if (weight>=251 && weight<=500)
begin
grp2<=grp2+1;
currgrp<=2;
prevweight<=weight;
end
else if (weight>=501 && weight<=750)
begin
grp3<=grp3+1;
currgrp<=3;
prevweight<=weight;
end
else if (weight>=751 && weight<=1500)
begin
grp4<=grp4+1;
currgrp<=4;
prevweight<=weight;
end
else if (weight>=1501 && weight<=2000)
begin
grp5<=grp5+1;
currgrp<=5;
prevweight<=weight;
end
else if (weight>=2000)
begin
grp6<=grp6+1;
currgrp<=6;
prevweight<=weight;
end
else
prevweight<=weight;
end
else
begin
prevweight<=weight;
if (weight>=1&&weight<=250)currgrp<=1;
else if (weight>=251&&weight<=500)currgrp<=2;
else if (weight>=501&&weight<=750)currgrp<=3;
else if (weight>=751&&weight<=1500)currgrp<=4;
else if (weight>=1501&&weight>=2000)currgrp<=5;
else if (weight>=2000)currgrp<=6;
else currgrp<=0;
end

always @ (reset)
if (reset)
begin
grp1<=0;
grp2<=0;
grp3<=0;
grp4<=0;
grp5<=0;
grp6<=0;
currgrp<=0;
end
else
currgrp<=currgrp;
endmodule


module testbench();
reg clk;
reg reset;
reg [11:0] weight;
wire [7:0] grp1;
wire [7:0] grp2;
wire [7:0] grp3;
wire [7:0] grp4;
wire [7:0] grp5;
wire [7:0] grp6;
wire [2:0] currgrp;
wire [11:0] prevweight;

initial begin
clk<=0;
weight<=0;
reset<=0;
end

packagesorter test1(clk,reset,weight,grp1,grp2,grp3,grp4,grp5,grp6,currgrp,prevweight);

always
begin
weight<=1500;
clk<=1;
reset<=0;
#(5);
clk<=0;
#(5);
if (grp4 == 8'h01 && currgrp == 8'h04)begin
$display("Right Answer 1");
end
else begin
$display("Wrong Answer 1");
end

weight<=1650;
#(5);
if (grp4 == 8'h01) begin
$display("Right Answer 2");
end
else begin
$display("Wrong Answer 2");
end

weight<=0;
#(5);
clk<=1;
#(5);
clk<=0;
#(5);
weight<=1650;
clk<=1;
#(5);
clk<=0;
#(5);
if (grp5 == 8'h01) begin
$display ("Right Answer 3");
end
else begin
$display("Wrong Answer 3");
end
weight<=241;
clk<=1;
#(5);
clk<=0;
#(5);
if (grp1 == 8'h00) begin
$display ("Right Answer 4");
end
else begin
$display("Wrong Answer 4");
end




end

endmodule

