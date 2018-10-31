module obs(a,b,bin,diff,bout);
input a,b,bin;
output diff,bout; 

assign diff = (a&b&bin)|(a&~b&~bin)|(~a&~b&bin)|(~a&b&~bin);
assign bout = (b&bin)|(~a&bin)|(~a&b);

endmodule 


module fbs(a,b,bin,diff,bout);
input [3:0] a;
input [3:0] b;
input bin;
output [3:0] diff; 
output bout;
wire bit0,bit1,bit2;
	obs bitthree (a[0],b[0],bin,diff[0],bit0);
	obs bittwo (a[1],b[1],bit0,diff[1],bit1);
	obs bitone (a[2],b[2],bit1,diff[2],bit2);
	obs bitzero (a[3],b[3],bit2,diff[3],bout);
endmodule
