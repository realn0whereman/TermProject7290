`timescale 1ns / 1ps


module a_test_circuit();
  
/*reg   clk;
reg [15:0] inA;	
reg [15:0] inB;
reg [1:0] s;
reg muxAOp,muxBOp;
output [15:0] O;
initial begin
	clk = 1;
	inA = 3;
	inB = 2;
	s = 0;
	muxAOp = 0;
	muxBOp = 0;
end	
	
always begin
   #25 clk = ~clk;
end*/
reg   clk;
reg rst;
initial begin
  clk = 1;
  #5 rst = 1;
  #5 rst = 0;
  
end

always begin
   #50 clk = ~clk;
   
end
  
	TOP circ(clk,rst);

endmodule

