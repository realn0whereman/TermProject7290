module fourWayOr(A,B,C,D,O);
	input A,B,C,D;
	output O;
	//computes (A|B) | (C|D)
	
	//handle A and B first
	wire w1U,w2U,w3U,w4U;
	//handle until the last nand gate
	nand N1U(w1U,A,A);
	nand N2U(w2U,B,B);
	nand N3U(w3U,w1U,w2U);
	//negate that
	nand N4U(w4U,w3U,w3U);
	
	//now handle the lower two inputs (C and D)
	wire w1L,w2L,w3L,w4L;
	//handle until the last nand gate
	nand N1L(w1L,C,C);
	nand N2L(w2L,D,D);
	nand N3L(w3L,w1L,w2L);
	//negate that
	nand N4L(w4L,w3L,w3L);
	
	wire outputWire,outputWireNeg;
	nand finalGate(outputWire,w4U,w4L);
	
	assign O= outputWire;
endmodule

module threeWayAnd(A,B,C,O);
	input A,B,C;
	output O;
	
	wire w1,w2,w3,w4;
	
	//w2 = A & B
	nand gate1(w1,A,B);
	nand gate2(w2,w1,w1);
	
	//w4 = w2 & C
	nand gate3(w3,w2,C);
	nand gate4(w4,w3,w3);
	assign O= w4;
endmodule

module singleBitFullAdder(A,B,Cin,Cout,O);
	input A,B,Cin;
	output Cout,O;
	
	//logic for A and B
	nand gate1(w1,A,B);
	
	nand gate2(w2,A,w1);
	nand gate3(w3,B,w1);
	nand gate4(w4,w3,w2);
	
	//account for Cin
	nand gate5(w5,w4,Cin);
	nand gate6(w6,w4,w5);
	nand gate7(w7,w5,Cin);
	nand gate9(w9,w6,w7);
	
	//and cout
	nand gate8(w8,w1,w5);
	
	assign Cout = w8;
	assign O = w9;
endmodule

module singleBitFullSub(A,B,Bin,Bout,O);
	input A,B,Bin;
	output Bout,O;
	
	wire w1 = A ^ B;
	wire w2 = B & ~A;
	wire w3 = ~w1 & Bin;
	
	assign Bout = w2 | w3;
	assign O = Bin ^ w1;
endmodule
	
module Sext22to32(data,sextedData);
	input [21:0] data;
	output [31:0] sextedData;
	
	assign sextedData[20:0] = data[20:0];
	assign sextedData[31:21] = data[21];
	
endmodule

module Sext16to32(data,sextedData);
	input [15:0] data;
	output [31:0] sextedData;
	
	assign sextedData[14:0] = data[14:0];
	assign sextedData[31:15] = data[15];
	
endmodule

	