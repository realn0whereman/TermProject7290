module flipFlop(data,enable,O);
	input data,enable;
	output O;
	
	nand gate1(w1,data,enable);
	nand gate2(w2,data,data);
	nand gate3(w3,w2,enable);
	nand gate4(w4,w5,w1);
	nand gate5(w5,w4,w3);
	
	assign O=w4;
	
endmodule

module edgeTriggeredLatch(data,enable,O);
	input data,enable;
	output O;
	
	wire q1,q2,leftFlopData;
	nand inverter(notEnable,enable,enable);
	flipFlop leftFlop(data,notEnable,q1);
	flipFlop rightFlop(q1,enable,q2);
	
	assign O=q2;

endmodule

module sixteenBitRegister(data,enable,O);
	input [15:0] data;
	input enable;
	output [15:0] O;
	
	
	
	edgeTriggeredLatch latch0(data[0],enable,O[0]);
	edgeTriggeredLatch latch1(data[1],enable,O[1]);
	edgeTriggeredLatch latch2(data[2],enable,O[2]);
	edgeTriggeredLatch latch3(data[3],enable,O[3]);
	edgeTriggeredLatch latch4(data[4],enable,O[4]);
	edgeTriggeredLatch latch5(data[5],enable,O[5]);
	edgeTriggeredLatch latch6(data[6],enable,O[6]);
	edgeTriggeredLatch latch7(data[7],enable,O[7]);
	edgeTriggeredLatch latch8(data[8],enable,O[8]);
	edgeTriggeredLatch latch9(data[9],enable,O[9]);
	edgeTriggeredLatch latch10(data[10],enable,O[10]);
	edgeTriggeredLatch latch11(data[11],enable,O[11]);
	edgeTriggeredLatch latch12(data[12],enable,O[12]);
	edgeTriggeredLatch latch13(data[13],enable,O[13]);
	edgeTriggeredLatch latch14(data[14],enable,O[14]);
	edgeTriggeredLatch latch15(data[15],enable,O[15]);

endmodule


/*module Register32(data,enable,O);
	input [31:0] data;
	input enable;
	output [31:0] O;
	

	edgeTriggeredLatch latch0(data[0],enable,O[0]);
	edgeTriggeredLatch latch1(data[1],enable,O[1]);
	edgeTriggeredLatch latch2(data[2],enable,O[2]);
	edgeTriggeredLatch latch3(data[3],enable,O[3]);
	edgeTriggeredLatch latch4(data[4],enable,O[4]);
	edgeTriggeredLatch latch5(data[5],enable,O[5]);
	edgeTriggeredLatch latch6(data[6],enable,O[6]);
	edgeTriggeredLatch latch7(data[7],enable,O[7]);
	edgeTriggeredLatch latch8(data[8],enable,O[8]);
	edgeTriggeredLatch latch9(data[9],enable,O[9]);
	edgeTriggeredLatch latch10(data[10],enable,O[10]);
	edgeTriggeredLatch latch11(data[11],enable,O[11]);
	edgeTriggeredLatch latch12(data[12],enable,O[12]);
	edgeTriggeredLatch latch13(data[13],enable,O[13]);
	edgeTriggeredLatch latch14(data[14],enable,O[14]);
	edgeTriggeredLatch latch15(data[15],enable,O[15]);
	edgeTriggeredLatch latch16(data[16],enable,O[16]);
	edgeTriggeredLatch latch17(data[17],enable,O[17]);
	edgeTriggeredLatch latch18(data[18],enable,O[18]);
	edgeTriggeredLatch latch19(data[19],enable,O[19]);
	edgeTriggeredLatch latch20(data[20],enable,O[20]);
	edgeTriggeredLatch latch21(data[21],enable,O[21]);
	edgeTriggeredLatch latch22(data[22],enable,O[22]);
	edgeTriggeredLatch latch23(data[23],enable,O[23]);
	edgeTriggeredLatch latch24(data[24],enable,O[24]);
	edgeTriggeredLatch latch25(data[25],enable,O[25]);
	edgeTriggeredLatch latch26(data[26],enable,O[26]);
	edgeTriggeredLatch latch27(data[27],enable,O[27]);
	edgeTriggeredLatch latch28(data[28],enable,O[28]);
	edgeTriggeredLatch latch29(data[29],enable,O[29]);
	edgeTriggeredLatch latch30(data[30],enable,O[30]);
	edgeTriggeredLatch latch31(data[31],enable,O[31]);

endmodule*/

module RegisterN(data,enable,rst,O);
  parameter N=32;
	input [N-1:0] data;
	input enable,rst;
	output reg [N-1:0] O;
	
	always @(posedge enable or posedge rst)
	begin
	  if(rst) begin
			O <= 0;
		end else begin
		  O <= data;
		end
		
	end
endmodule



module RegFile(regWE,RzWE,data,Z,Y,X,Rz,Ry,Rx);
	input regWE;
	input[2:0] RzWE,Z,Y,X;
	input[31:0] data;
	output reg[31:0] Rz,Ry,Rx;

	reg[31:0] registers[7:0];
	
	initial begin
	 registers[0] = 0;
	 registers[1] = 0;
	 registers[2] = 0;
	 registers[3] = 0;
	 registers[4] = 0;
	 registers[5] = 0;
	 registers[6] = 0;
	 registers[7] = 0;
	end
	  
	
	always @(*)
	begin
		if(regWE)
			registers[RzWE] = data;
			
		Rz = registers[Z];
		Ry = registers[Y];
		Rx = registers[X];
	end


endmodule


module Memory4KB(rst,memW,address,dataIn,dataOut);
	input memW,rst;
	input[31:0] address,dataIn;
	output reg [31:0] dataOut;
	reg[31:0] memory[1023:0];
	integer i;
	initial begin 
	 
	 $readmemh("test.hex", memory);
	 for(i=10;i<1024;i=i+1) begin //TODO get number dynamically
	     memory[i] <= 0;
	 end
	end
	
	always @(*) begin
		if(memW) begin
			memory[address[9:0]/4] <= dataIn; 
	  end
	dataOut <= memory[address[9:0]/4];
  end
endmodule
