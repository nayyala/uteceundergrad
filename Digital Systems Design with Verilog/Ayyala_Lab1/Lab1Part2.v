

module ALU(a,b,cin,out,cout,control,temp);

input cin;
input [2:0] control;
input [3:0] a;
input [3:0] b;
output [3:0] out;
output cout,temp;
reg [3:0] out;
reg cout;
reg [3:0] temp; 
always @ (a,b,cin,control) begin
if (control == 000) begin
{cout,out}<=a+b+cin;
end
else if (control == 001)begin
{cout,out}<=a-b-cin;
end
else if (control == 6)begin
out<=(a<<1);
temp<=a>>3;
#3;
out<=out|temp;
end
else if (control == 7)begin
out<=(a>>1);
temp<=a<<3;
#3;
out<=out|temp;
end
else if (control == 4)begin
out<= a<<1;
end
else if (control == 5)begin
out<= a>>1;
end

else if (control == 2)begin
out<=a|b;
end

else begin
out<=a&b;
end
end
endmodule





