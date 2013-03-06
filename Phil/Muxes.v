module fourToOneMux(V0,V1,V2,V3,Op1,Op0,O);
	input V0,V1,V2,V3,Op1,Op0;
	output O;

	//create negative
	wire Op1Neg,Op0Neg;
	nand Op1NegGate(Op1Neg,Op1,Op1);
	nand Op0NegGate(Op0Neg,Op0,Op0);
	
	//3way and outputs
	wire V0Out,V1Out,V2Out,V3Out;
	
	//V0
	threeWayAnd V0Gate(Op1Neg,Op0Neg,V0,V0Out);
	
	//V1
	threeWayAnd V1Gate(Op1Neg,Op0,V1,V1Out);
	
	//V2
	threeWayAnd V2Gate(Op1,Op0Neg,V2,V2Out);
	
	//V3
	threeWayAnd V3Gate(Op1,Op0,V3,V3Out);
	
	//OR the outputs together
	wire outputWire;
	fourWayOr outputOr(V0Out,V1Out,V2Out,V3Out,outputWire);
	
	assign O=outputWire;
endmodule

module twoToOneMux(A,B,Op,O);
	input A,B,Op;
	output O;
	
	wire OpNeg;
	nand OpNegGate(OpNeg,Op,Op);
	
	//A
	wire firstNandwire,AOut;
	nand firstNand1(firstNandwire,A,OpNeg);
	nand secondNand1(AOut,firstNandwire,firstNandwire);
	
	//B
	wire secondNandwire,BOut;
	nand firstNand2(secondNandwire,B,Op);
	nand secondNand2(BOut,secondNandwire,secondNandwire);
	
	// A or B
	wire topGate,botGate;
	nand leftGateTop(topGate,AOut,AOut);
	nand leftGateBot(botGate,BOut,BOut);
	nand finGate(O,topGate,botGate);

endmodule

module sixteenBitTwoToOneMux(A,B,Op,O);
	input [15:0] A;
	input [15:0] B;
	input Op;
	output [15:0] O;
	
	
	twoToOneMux bits0(A[0],B[0],Op,O[0]);
	twoToOneMux bits1(A[1],B[1],Op,O[1]);
	twoToOneMux bits2(A[2],B[2],Op,O[2]);
	twoToOneMux bits3(A[3],B[3],Op,O[3]);
	twoToOneMux bits4(A[4],B[4],Op,O[4]);
	twoToOneMux bits5(A[5],B[5],Op,O[5]);
	twoToOneMux bits6(A[6],B[6],Op,O[6]);
	twoToOneMux bits7(A[7],B[7],Op,O[7]);
	twoToOneMux bits8(A[8],B[8],Op,O[8]);
	twoToOneMux bits9(A[9],B[9],Op,O[9]);
	twoToOneMux bits10(A[10],B[10],Op,O[10]);
	twoToOneMux bits11(A[11],B[11],Op,O[11]);
	twoToOneMux bits12(A[12],B[12],Op,O[12]);
	twoToOneMux bits13(A[13],B[13],Op,O[13]);
	twoToOneMux bits14(A[14],B[14],Op,O[14]);
	twoToOneMux bits15(A[15],B[15],Op,O[15]);
	
endmodule
	
	
module TwoToOneMux32(A,B,Op,O);
	input [31:0] A;
	input [31:0] B;
	input Op;
	output reg [31:0] O;
	
	
	always@(A or B or Op) begin
	   if(Op == 0) begin
	     O = A;
	   end
	   if(Op == 1) begin
	     O = B;
	   end
	end
	
	/*twoToOneMux bits0(A[0],B[0],Op,O[0]);
	twoToOneMux bits1(A[1],B[1],Op,O[1]);
	twoToOneMux bits2(A[2],B[2],Op,O[2]);
	twoToOneMux bits3(A[3],B[3],Op,O[3]);
	twoToOneMux bits4(A[4],B[4],Op,O[4]);
	twoToOneMux bits5(A[5],B[5],Op,O[5]);
	twoToOneMux bits6(A[6],B[6],Op,O[6]);
	twoToOneMux bits7(A[7],B[7],Op,O[7]);
	twoToOneMux bits8(A[8],B[8],Op,O[8]);
	twoToOneMux bits9(A[9],B[9],Op,O[9]);
	twoToOneMux bits10(A[10],B[10],Op,O[10]);
	twoToOneMux bits11(A[11],B[11],Op,O[11]);
	twoToOneMux bits12(A[12],B[12],Op,O[12]);
	twoToOneMux bits13(A[13],B[13],Op,O[13]);
	twoToOneMux bits14(A[14],B[14],Op,O[14]);
	twoToOneMux bits15(A[15],B[15],Op,O[15]);
	twoToOneMux bits16(A[16],B[16],Op,O[16]);
	twoToOneMux bits17(A[17],B[17],Op,O[17]);
	twoToOneMux bits18(A[18],B[18],Op,O[18]);
	twoToOneMux bits19(A[19],B[19],Op,O[19]);
	twoToOneMux bits20(A[20],B[20],Op,O[20]);
	twoToOneMux bits21(A[21],B[21],Op,O[21]);
	twoToOneMux bits22(A[22],B[22],Op,O[22]);
	twoToOneMux bits23(A[23],B[23],Op,O[23]);
	twoToOneMux bits24(A[24],B[24],Op,O[24]);
	twoToOneMux bits25(A[25],B[25],Op,O[25]);
	twoToOneMux bits26(A[26],B[26],Op,O[26]);
	twoToOneMux bits27(A[27],B[27],Op,O[27]);
	twoToOneMux bits28(A[28],B[28],Op,O[28]);
	twoToOneMux bits29(A[29],B[29],Op,O[29]);
	twoToOneMux bits30(A[30],B[30],Op,O[30]);
	twoToOneMux bits31(A[31],B[31],Op,O[31]);*/
	
	
endmodule

module OneToTwoMux32(In,A,B,Op);
	input [31:0] In;
	input Op;
	output reg [31:0] A,B;

  always@(In or Op) begin
	   if(Op == 0) begin
	     A = In;
	     B = 32'b0;
	   end
	   if(Op == 1) begin
	     B = In;
	     A = 32'b0;
	   end
	end

	/*OneToTwoMux bit0(In[0],A[0],B[0],Op);
	OneToTwoMux bit1(In[1],A[1],B[1],Op);
	OneToTwoMux bit2(In[2],A[2],B[2],Op);
	OneToTwoMux bit3(In[3],A[3],B[3],Op);
	OneToTwoMux bit4(In[4],A[4],B[4],Op);
	OneToTwoMux bit5(In[5],A[5],B[5],Op);
	OneToTwoMux bit6(In[6],A[6],B[6],Op);
	OneToTwoMux bit7(In[7],A[7],B[7],Op);
	OneToTwoMux bit8(In[8],A[8],B[8],Op);
	OneToTwoMux bit9(In[9],A[9],B[9],Op);
	OneToTwoMux bit10(In[10],A[10],B[10],Op);
	OneToTwoMux bit11(In[11],A[11],B[11],Op);
	OneToTwoMux bit12(In[12],A[12],B[12],Op);
	OneToTwoMux bit13(In[13],A[13],B[13],Op);
	OneToTwoMux bit14(In[14],A[14],B[14],Op);
	OneToTwoMux bit15(In[15],A[15],B[15],Op);
	OneToTwoMux bit16(In[16],A[16],B[16],Op);
	OneToTwoMux bit17(In[17],A[17],B[17],Op);
	OneToTwoMux bit18(In[18],A[18],B[18],Op);
	OneToTwoMux bit19(In[19],A[19],B[19],Op);
	OneToTwoMux bit20(In[20],A[20],B[20],Op);
	OneToTwoMux bit21(In[21],A[21],B[21],Op);
	OneToTwoMux bit22(In[22],A[22],B[22],Op);
	OneToTwoMux bit23(In[23],A[23],B[23],Op);
	OneToTwoMux bit24(In[24],A[24],B[24],Op);
	OneToTwoMux bit25(In[25],A[25],B[25],Op);
	OneToTwoMux bit26(In[26],A[26],B[26],Op);
	OneToTwoMux bit27(In[27],A[27],B[27],Op);
	OneToTwoMux bit28(In[28],A[28],B[28],Op);
	OneToTwoMux bit29(In[29],A[29],B[29],Op);
	OneToTwoMux bit30(In[30],A[30],B[30],Op);
	OneToTwoMux bit31(In[31],A[31],B[31],Op);*/
	
endmodule

module OneToTwoMux(In,A,B,Op);
	input In,Op;
	output A,B;
	
	not(Op_bar,Op);
	and(A,In,Op);
	and(B,In,Op_bar);
	
endmodule
