module LatchN(data,data_Out,cp,stall,squash);
  parameter N=32;
	input [N-1:0] data;
	input cp,stall,squash;
	output reg [N-1:0] data_Out;
	
	//reg [N-1:0] dataReg;
	always @(posedge cp or posedge squash or posedge stall)
	begin
		data_Out = data;
		if(stall)
		  data_Out = data_Out;
		if(squash)
			data_Out = 0;
	end
endmodule

module FeIdLatch(pc,inst,pcOut,instOut,cp,stall,squash);
	input [31:0] pc;
	input [31:0] inst;
	input cp,stall,squash;
	output [31:0] pcOut;
	output [31:0]instOut;
	
	//pc
	OneBitLatch pc_bit0(pc[0],cp,stall,squash,pcOut[0]);
	OneBitLatch pc_bit1(pc[1],cp,stall,squash,pcOut[1]);
	OneBitLatch pc_bit2(pc[2],cp,stall,squash,pcOut[2]);
	OneBitLatch pc_bit3(pc[3],cp,stall,squash,pcOut[3]);
	OneBitLatch pc_bit4(pc[4],cp,stall,squash,pcOut[4]);
	OneBitLatch pc_bit5(pc[5],cp,stall,squash,pcOut[5]);
	OneBitLatch pc_bit6(pc[6],cp,stall,squash,pcOut[6]);
	OneBitLatch pc_bit7(pc[7],cp,stall,squash,pcOut[7]);
	OneBitLatch pc_bit8(pc[8],cp,stall,squash,pcOut[8]);
	OneBitLatch pc_bit9(pc[9],cp,stall,squash,pcOut[9]);
	OneBitLatch pc_bit10(pc[10],cp,stall,squash,pcOut[10]);
	OneBitLatch pc_bit11(pc[11],cp,stall,squash,pcOut[11]);
	OneBitLatch pc_bit12(pc[12],cp,stall,squash,pcOut[12]);
	OneBitLatch pc_bit13(pc[13],cp,stall,squash,pcOut[13]);
	OneBitLatch pc_bit14(pc[14],cp,stall,squash,pcOut[14]);
	OneBitLatch pc_bit15(pc[15],cp,stall,squash,pcOut[15]);
	OneBitLatch pc_bit16(pc[16],cp,stall,squash,pcOut[16]);
	OneBitLatch pc_bit17(pc[17],cp,stall,squash,pcOut[17]);
	OneBitLatch pc_bit18(pc[18],cp,stall,squash,pcOut[18]);
	OneBitLatch pc_bit19(pc[19],cp,stall,squash,pcOut[19]);
	OneBitLatch pc_bit20(pc[20],cp,stall,squash,pcOut[20]);
	OneBitLatch pc_bit21(pc[21],cp,stall,squash,pcOut[21]);
	OneBitLatch pc_bit22(pc[22],cp,stall,squash,pcOut[22]);
	OneBitLatch pc_bit23(pc[23],cp,stall,squash,pcOut[23]);
	OneBitLatch pc_bit24(pc[24],cp,stall,squash,pcOut[24]);
	OneBitLatch pc_bit25(pc[25],cp,stall,squash,pcOut[25]);
	OneBitLatch pc_bit26(pc[26],cp,stall,squash,pcOut[26]);
	OneBitLatch pc_bit27(pc[27],cp,stall,squash,pcOut[27]);
	OneBitLatch pc_bit28(pc[28],cp,stall,squash,pcOut[28]);
	OneBitLatch pc_bit29(pc[29],cp,stall,squash,pcOut[29]);
	OneBitLatch pc_bit30(pc[30],cp,stall,squash,pcOut[30]);
	OneBitLatch pc_bit31(pc[31],cp,stall,squash,pcOut[31]);
	
	
	//inst
	OneBitLatch inst_bit0(inst[0],cp,stall,squash,instOut[0]);
	OneBitLatch inst_bit1(inst[1],cp,stall,squash,instOut[1]);
	OneBitLatch inst_bit2(inst[2],cp,stall,squash,instOut[2]);
	OneBitLatch inst_bit3(inst[3],cp,stall,squash,instOut[3]);
	OneBitLatch inst_bit4(inst[4],cp,stall,squash,instOut[4]);
	OneBitLatch inst_bit5(inst[5],cp,stall,squash,instOut[5]);
	OneBitLatch inst_bit6(inst[6],cp,stall,squash,instOut[6]);
	OneBitLatch inst_bit7(inst[7],cp,stall,squash,instOut[7]);
	OneBitLatch inst_bit8(inst[8],cp,stall,squash,instOut[8]);
	OneBitLatch inst_bit9(inst[9],cp,stall,squash,instOut[9]);
	OneBitLatch inst_bit10(inst[10],cp,stall,squash,instOut[10]);
	OneBitLatch inst_bit11(inst[11],cp,stall,squash,instOut[11]);
	OneBitLatch inst_bit12(inst[12],cp,stall,squash,instOut[12]);
	OneBitLatch inst_bit13(inst[13],cp,stall,squash,instOut[13]);
	OneBitLatch inst_bit14(inst[14],cp,stall,squash,instOut[14]);
	OneBitLatch inst_bit15(inst[15],cp,stall,squash,instOut[15]);
	OneBitLatch inst_bit16(inst[16],cp,stall,squash,instOut[16]);
	OneBitLatch inst_bit17(inst[17],cp,stall,squash,instOut[17]);
	OneBitLatch inst_bit18(inst[18],cp,stall,squash,instOut[18]);
	OneBitLatch inst_bit19(inst[19],cp,stall,squash,instOut[19]);
	OneBitLatch inst_bit20(inst[20],cp,stall,squash,instOut[20]);
	OneBitLatch inst_bit21(inst[21],cp,stall,squash,instOut[21]);
	OneBitLatch inst_bit22(inst[22],cp,stall,squash,instOut[22]);
	OneBitLatch inst_bit23(inst[23],cp,stall,squash,instOut[23]);
	OneBitLatch inst_bit24(inst[24],cp,stall,squash,instOut[24]);
	OneBitLatch inst_bit25(inst[25],cp,stall,squash,instOut[25]);
	OneBitLatch inst_bit26(inst[26],cp,stall,squash,instOut[26]);
	OneBitLatch inst_bit27(inst[27],cp,stall,squash,instOut[27]);
	OneBitLatch inst_bit28(inst[28],cp,stall,squash,instOut[28]);
	OneBitLatch inst_bit29(inst[29],cp,stall,squash,instOut[29]);
	OneBitLatch inst_bit30(inst[30],cp,stall,squash,instOut[30]);
	OneBitLatch inst_bit31(inst[31],cp,stall,squash,instOut[31]);
endmodule

module IdExLatch(pc,cntrl,Z,Rz,Ry,Rx,imm32,pc_Out,cntrl_Out,Z_Out,Rz_Out,Ry_Out,Rx_Out,imm32_Out,cp,stall,squash);
	input [31:0] pc,Rz,Ry,Rx,imm32;
	input [2:0] Z;
	input [12:0] cntrl;
	input cp,stall,squash;
	output [31:0] pc_Out,Rz_Out,Ry_Out,Rx_Out,imm32_Out;
	output [2:0] Z_Out;
	output [12:0] cntrl_Out;
	
	//pc
	OneBitLatch pc_bit0(pc[0],cp,stall,squash,pc_Out[0]);
	OneBitLatch pc_bit1(pc[1],cp,stall,squash,pc_Out[1]);
	OneBitLatch pc_bit2(pc[2],cp,stall,squash,pc_Out[2]);
	OneBitLatch pc_bit3(pc[3],cp,stall,squash,pc_Out[3]);
	OneBitLatch pc_bit4(pc[4],cp,stall,squash,pc_Out[4]);
	OneBitLatch pc_bit5(pc[5],cp,stall,squash,pc_Out[5]);
	OneBitLatch pc_bit6(pc[6],cp,stall,squash,pc_Out[6]);
	OneBitLatch pc_bit7(pc[7],cp,stall,squash,pc_Out[7]);
	OneBitLatch pc_bit8(pc[8],cp,stall,squash,pc_Out[8]);
	OneBitLatch pc_bit9(pc[9],cp,stall,squash,pc_Out[9]);
	OneBitLatch pc_bit10(pc[10],cp,stall,squash,pc_Out[10]);
	OneBitLatch pc_bit11(pc[11],cp,stall,squash,pc_Out[11]);
	OneBitLatch pc_bit12(pc[12],cp,stall,squash,pc_Out[12]);
	OneBitLatch pc_bit13(pc[13],cp,stall,squash,pc_Out[13]);
	OneBitLatch pc_bit14(pc[14],cp,stall,squash,pc_Out[14]);
	OneBitLatch pc_bit15(pc[15],cp,stall,squash,pc_Out[15]);
	OneBitLatch pc_bit16(pc[16],cp,stall,squash,pc_Out[16]);
	OneBitLatch pc_bit17(pc[17],cp,stall,squash,pc_Out[17]);
	OneBitLatch pc_bit18(pc[18],cp,stall,squash,pc_Out[18]);
	OneBitLatch pc_bit19(pc[19],cp,stall,squash,pc_Out[19]);
	OneBitLatch pc_bit20(pc[20],cp,stall,squash,pc_Out[20]);
	OneBitLatch pc_bit21(pc[21],cp,stall,squash,pc_Out[21]);
	OneBitLatch pc_bit22(pc[22],cp,stall,squash,pc_Out[22]);
	OneBitLatch pc_bit23(pc[23],cp,stall,squash,pc_Out[23]);
	OneBitLatch pc_bit24(pc[24],cp,stall,squash,pc_Out[24]);
	OneBitLatch pc_bit25(pc[25],cp,stall,squash,pc_Out[25]);
	OneBitLatch pc_bit26(pc[26],cp,stall,squash,pc_Out[26]);
	OneBitLatch pc_bit27(pc[27],cp,stall,squash,pc_Out[27]);
	OneBitLatch pc_bit28(pc[28],cp,stall,squash,pc_Out[28]);
	OneBitLatch pc_bit29(pc[29],cp,stall,squash,pc_Out[29]);
	OneBitLatch pc_bit30(pc[30],cp,stall,squash,pc_Out[30]);
	OneBitLatch pc_bit31(pc[31],cp,stall,squash,pc_Out[31]);
	
	//cntrl
	OneBitLatch cntrl_bit0(cntrl[0],cp,stall,squash,cntrl_Out[0]);
	OneBitLatch cntrl_bit1(cntrl[1],cp,stall,squash,cntrl_Out[1]);
	OneBitLatch cntrl_bit2(cntrl[2],cp,stall,squash,cntrl_Out[2]);
	OneBitLatch cntrl_bit3(cntrl[3],cp,stall,squash,cntrl_Out[3]);
	OneBitLatch cntrl_bit4(cntrl[4],cp,stall,squash,cntrl_Out[4]);
	OneBitLatch cntrl_bit5(cntrl[5],cp,stall,squash,cntrl_Out[5]);
	OneBitLatch cntrl_bit6(cntrl[6],cp,stall,squash,cntrl_Out[6]);
	OneBitLatch cntrl_bit7(cntrl[7],cp,stall,squash,cntrl_Out[7]);
	OneBitLatch cntrl_bit8(cntrl[8],cp,stall,squash,cntrl_Out[8]);
	OneBitLatch cntrl_bit9(cntrl[9],cp,stall,squash,cntrl_Out[9]);
	OneBitLatch cntrl_bit10(cntrl[10],cp,stall,squash,cntrl_Out[10]);
	OneBitLatch cntrl_bit11(cntrl[11],cp,stall,squash,cntrl_Out[11]);
	OneBitLatch cntrl_bit12(cntrl[12],cp,stall,squash,cntrl_Out[12]);
	
	//Z
	OneBitLatch Z_bit0(Z[0],cp,stall,squash,Z_Out[0]);
	OneBitLatch Z_bit1(Z[1],cp,stall,squash,Z_Out[1]);
	OneBitLatch Z_bit2(Z[2],cp,stall,squash,Z_Out[2]);
	
	//Rz
	OneBitLatch Rz_bit0(Rz[0],cp,stall,squash,Rz_Out[0]);
	OneBitLatch Rz_bit1(Rz[1],cp,stall,squash,Rz_Out[1]);
	OneBitLatch Rz_bit2(Rz[2],cp,stall,squash,Rz_Out[2]);
	OneBitLatch Rz_bit3(Rz[3],cp,stall,squash,Rz_Out[3]);
	OneBitLatch Rz_bit4(Rz[4],cp,stall,squash,Rz_Out[4]);
	OneBitLatch Rz_bit5(Rz[5],cp,stall,squash,Rz_Out[5]);
	OneBitLatch Rz_bit6(Rz[6],cp,stall,squash,Rz_Out[6]);
	OneBitLatch Rz_bit7(Rz[7],cp,stall,squash,Rz_Out[7]);
	OneBitLatch Rz_bit8(Rz[8],cp,stall,squash,Rz_Out[8]);
	OneBitLatch Rz_bit9(Rz[9],cp,stall,squash,Rz_Out[9]);
	OneBitLatch Rz_bit10(Rz[10],cp,stall,squash,Rz_Out[10]);
	OneBitLatch Rz_bit11(Rz[11],cp,stall,squash,Rz_Out[11]);
	OneBitLatch Rz_bit12(Rz[12],cp,stall,squash,Rz_Out[12]);
	OneBitLatch Rz_bit13(Rz[13],cp,stall,squash,Rz_Out[13]);
	OneBitLatch Rz_bit14(Rz[14],cp,stall,squash,Rz_Out[14]);
	OneBitLatch Rz_bit15(Rz[15],cp,stall,squash,Rz_Out[15]);
	OneBitLatch Rz_bit16(Rz[16],cp,stall,squash,Rz_Out[16]);
	OneBitLatch Rz_bit17(Rz[17],cp,stall,squash,Rz_Out[17]);
	OneBitLatch Rz_bit18(Rz[18],cp,stall,squash,Rz_Out[18]);
	OneBitLatch Rz_bit19(Rz[19],cp,stall,squash,Rz_Out[19]);
	OneBitLatch Rz_bit20(Rz[20],cp,stall,squash,Rz_Out[20]);
	OneBitLatch Rz_bit21(Rz[21],cp,stall,squash,Rz_Out[21]);
	OneBitLatch Rz_bit22(Rz[22],cp,stall,squash,Rz_Out[22]);
	OneBitLatch Rz_bit23(Rz[23],cp,stall,squash,Rz_Out[23]);
	OneBitLatch Rz_bit24(Rz[24],cp,stall,squash,Rz_Out[24]);
	OneBitLatch Rz_bit25(Rz[25],cp,stall,squash,Rz_Out[25]);
	OneBitLatch Rz_bit26(Rz[26],cp,stall,squash,Rz_Out[26]);
	OneBitLatch Rz_bit27(Rz[27],cp,stall,squash,Rz_Out[27]);
	OneBitLatch Rz_bit28(Rz[28],cp,stall,squash,Rz_Out[28]);
	OneBitLatch Rz_bit29(Rz[29],cp,stall,squash,Rz_Out[29]);
	OneBitLatch Rz_bit30(Rz[30],cp,stall,squash,Rz_Out[30]);
	OneBitLatch Rz_bit31(Rz[31],cp,stall,squash,Rz_Out[31]);
	
	//Ry
	OneBitLatch Ry_bit0(Ry[0],cp,stall,squash,Ry_Out[0]);
	OneBitLatch Ry_bit1(Ry[1],cp,stall,squash,Ry_Out[1]);
	OneBitLatch Ry_bit2(Ry[2],cp,stall,squash,Ry_Out[2]);
	OneBitLatch Ry_bit3(Ry[3],cp,stall,squash,Ry_Out[3]);
	OneBitLatch Ry_bit4(Ry[4],cp,stall,squash,Ry_Out[4]);
	OneBitLatch Ry_bit5(Ry[5],cp,stall,squash,Ry_Out[5]);
	OneBitLatch Ry_bit6(Ry[6],cp,stall,squash,Ry_Out[6]);
	OneBitLatch Ry_bit7(Ry[7],cp,stall,squash,Ry_Out[7]);
	OneBitLatch Ry_bit8(Ry[8],cp,stall,squash,Ry_Out[8]);
	OneBitLatch Ry_bit9(Ry[9],cp,stall,squash,Ry_Out[9]);
	OneBitLatch Ry_bit10(Ry[10],cp,stall,squash,Ry_Out[10]);
	OneBitLatch Ry_bit11(Ry[11],cp,stall,squash,Ry_Out[11]);
	OneBitLatch Ry_bit12(Ry[12],cp,stall,squash,Ry_Out[12]);
	OneBitLatch Ry_bit13(Ry[13],cp,stall,squash,Ry_Out[13]);
	OneBitLatch Ry_bit14(Ry[14],cp,stall,squash,Ry_Out[14]);
	OneBitLatch Ry_bit15(Ry[15],cp,stall,squash,Ry_Out[15]);
	OneBitLatch Ry_bit16(Ry[16],cp,stall,squash,Ry_Out[16]);
	OneBitLatch Ry_bit17(Ry[17],cp,stall,squash,Ry_Out[17]);
	OneBitLatch Ry_bit18(Ry[18],cp,stall,squash,Ry_Out[18]);
	OneBitLatch Ry_bit19(Ry[19],cp,stall,squash,Ry_Out[19]);
	OneBitLatch Ry_bit20(Ry[20],cp,stall,squash,Ry_Out[20]);
	OneBitLatch Ry_bit21(Ry[21],cp,stall,squash,Ry_Out[21]);
	OneBitLatch Ry_bit22(Ry[22],cp,stall,squash,Ry_Out[22]);
	OneBitLatch Ry_bit23(Ry[23],cp,stall,squash,Ry_Out[23]);
	OneBitLatch Ry_bit24(Ry[24],cp,stall,squash,Ry_Out[24]);
	OneBitLatch Ry_bit25(Ry[25],cp,stall,squash,Ry_Out[25]);
	OneBitLatch Ry_bit26(Ry[26],cp,stall,squash,Ry_Out[26]);
	OneBitLatch Ry_bit27(Ry[27],cp,stall,squash,Ry_Out[27]);
	OneBitLatch Ry_bit28(Ry[28],cp,stall,squash,Ry_Out[28]);
	OneBitLatch Ry_bit29(Ry[29],cp,stall,squash,Ry_Out[29]);
	OneBitLatch Ry_bit30(Ry[30],cp,stall,squash,Ry_Out[30]);
	OneBitLatch Ry_bit31(Ry[31],cp,stall,squash,Ry_Out[31]);
	
	//Rx
	OneBitLatch Rx_bit0(Rx[0],cp,stall,squash,Rx_Out[0]);
	OneBitLatch Rx_bit1(Rx[1],cp,stall,squash,Rx_Out[1]);
	OneBitLatch Rx_bit2(Rx[2],cp,stall,squash,Rx_Out[2]);
	OneBitLatch Rx_bit3(Rx[3],cp,stall,squash,Rx_Out[3]);
	OneBitLatch Rx_bit4(Rx[4],cp,stall,squash,Rx_Out[4]);
	OneBitLatch Rx_bit5(Rx[5],cp,stall,squash,Rx_Out[5]);
	OneBitLatch Rx_bit6(Rx[6],cp,stall,squash,Rx_Out[6]);
	OneBitLatch Rx_bit7(Rx[7],cp,stall,squash,Rx_Out[7]);
	OneBitLatch Rx_bit8(Rx[8],cp,stall,squash,Rx_Out[8]);
	OneBitLatch Rx_bit9(Rx[9],cp,stall,squash,Rx_Out[9]);
	OneBitLatch Rx_bit10(Rx[10],cp,stall,squash,Rx_Out[10]);
	OneBitLatch Rx_bit11(Rx[11],cp,stall,squash,Rx_Out[11]);
	OneBitLatch Rx_bit12(Rx[12],cp,stall,squash,Rx_Out[12]);
	OneBitLatch Rx_bit13(Rx[13],cp,stall,squash,Rx_Out[13]);
	OneBitLatch Rx_bit14(Rx[14],cp,stall,squash,Rx_Out[14]);
	OneBitLatch Rx_bit15(Rx[15],cp,stall,squash,Rx_Out[15]);
	OneBitLatch Rx_bit16(Rx[16],cp,stall,squash,Rx_Out[16]);
	OneBitLatch Rx_bit17(Rx[17],cp,stall,squash,Rx_Out[17]);
	OneBitLatch Rx_bit18(Rx[18],cp,stall,squash,Rx_Out[18]);
	OneBitLatch Rx_bit19(Rx[19],cp,stall,squash,Rx_Out[19]);
	OneBitLatch Rx_bit20(Rx[20],cp,stall,squash,Rx_Out[20]);
	OneBitLatch Rx_bit21(Rx[21],cp,stall,squash,Rx_Out[21]);
	OneBitLatch Rx_bit22(Rx[22],cp,stall,squash,Rx_Out[22]);
	OneBitLatch Rx_bit23(Rx[23],cp,stall,squash,Rx_Out[23]);
	OneBitLatch Rx_bit24(Rx[24],cp,stall,squash,Rx_Out[24]);
	OneBitLatch Rx_bit25(Rx[25],cp,stall,squash,Rx_Out[25]);
	OneBitLatch Rx_bit26(Rx[26],cp,stall,squash,Rx_Out[26]);
	OneBitLatch Rx_bit27(Rx[27],cp,stall,squash,Rx_Out[27]);
	OneBitLatch Rx_bit28(Rx[28],cp,stall,squash,Rx_Out[28]);
	OneBitLatch Rx_bit29(Rx[29],cp,stall,squash,Rx_Out[29]);
	OneBitLatch Rx_bit30(Rx[30],cp,stall,squash,Rx_Out[30]);
	OneBitLatch Rx_bit31(Rx[31],cp,stall,squash,Rx_Out[31]);
	
	//imm32
	OneBitLatch imm32_bit0(imm32[0],cp,stall,squash,imm32_Out[0]);
	OneBitLatch imm32_bit1(imm32[1],cp,stall,squash,imm32_Out[1]);
	OneBitLatch imm32_bit2(imm32[2],cp,stall,squash,imm32_Out[2]);
	OneBitLatch imm32_bit3(imm32[3],cp,stall,squash,imm32_Out[3]);
	OneBitLatch imm32_bit4(imm32[4],cp,stall,squash,imm32_Out[4]);
	OneBitLatch imm32_bit5(imm32[5],cp,stall,squash,imm32_Out[5]);
	OneBitLatch imm32_bit6(imm32[6],cp,stall,squash,imm32_Out[6]);
	OneBitLatch imm32_bit7(imm32[7],cp,stall,squash,imm32_Out[7]);
	OneBitLatch imm32_bit8(imm32[8],cp,stall,squash,imm32_Out[8]);
	OneBitLatch imm32_bit9(imm32[9],cp,stall,squash,imm32_Out[9]);
	OneBitLatch imm32_bit10(imm32[10],cp,stall,squash,imm32_Out[10]);
	OneBitLatch imm32_bit11(imm32[11],cp,stall,squash,imm32_Out[11]);
	OneBitLatch imm32_bit12(imm32[12],cp,stall,squash,imm32_Out[12]);
	OneBitLatch imm32_bit13(imm32[13],cp,stall,squash,imm32_Out[13]);
	OneBitLatch imm32_bit14(imm32[14],cp,stall,squash,imm32_Out[14]);
	OneBitLatch imm32_bit15(imm32[15],cp,stall,squash,imm32_Out[15]);
	OneBitLatch imm32_bit16(imm32[16],cp,stall,squash,imm32_Out[16]);
	OneBitLatch imm32_bit17(imm32[17],cp,stall,squash,imm32_Out[17]);
	OneBitLatch imm32_bit18(imm32[18],cp,stall,squash,imm32_Out[18]);
	OneBitLatch imm32_bit19(imm32[19],cp,stall,squash,imm32_Out[19]);
	OneBitLatch imm32_bit20(imm32[20],cp,stall,squash,imm32_Out[20]);
	OneBitLatch imm32_bit21(imm32[21],cp,stall,squash,imm32_Out[21]);
	OneBitLatch imm32_bit22(imm32[22],cp,stall,squash,imm32_Out[22]);
	OneBitLatch imm32_bit23(imm32[23],cp,stall,squash,imm32_Out[23]);
	OneBitLatch imm32_bit24(imm32[24],cp,stall,squash,imm32_Out[24]);
	OneBitLatch imm32_bit25(imm32[25],cp,stall,squash,imm32_Out[25]);
	OneBitLatch imm32_bit26(imm32[26],cp,stall,squash,imm32_Out[26]);
	OneBitLatch imm32_bit27(imm32[27],cp,stall,squash,imm32_Out[27]);
	OneBitLatch imm32_bit28(imm32[28],cp,stall,squash,imm32_Out[28]);
	OneBitLatch imm32_bit29(imm32[29],cp,stall,squash,imm32_Out[29]);
	OneBitLatch imm32_bit30(imm32[30],cp,stall,squash,imm32_Out[30]);
	OneBitLatch imm32_bit31(imm32[31],cp,stall,squash,imm32_Out[31]);
	
	

endmodule

module ExMemLatch(alu,Rz,Z,cntrl,alu_Out,Rz_Out,Z_Out,cntrl_Out,cp,stall,squash);
	input [31:0] alu,Rz;
	input [2:0] Z;
	input [12:0] cntrl;
	input cp,stall,squash;
	
	output [31:0] alu_Out,Rz_Out;
	output [2:0] Z_Out;
	output [12:0] cntrl_Out;
	
	//alu
	OneBitLatch alu_bit0(alu[0],cp,stall,squash,alu_Out[0]);
	OneBitLatch alu_bit1(alu[1],cp,stall,squash,alu_Out[1]);
	OneBitLatch alu_bit2(alu[2],cp,stall,squash,alu_Out[2]);
	OneBitLatch alu_bit3(alu[3],cp,stall,squash,alu_Out[3]);
	OneBitLatch alu_bit4(alu[4],cp,stall,squash,alu_Out[4]);
	OneBitLatch alu_bit5(alu[5],cp,stall,squash,alu_Out[5]);
	OneBitLatch alu_bit6(alu[6],cp,stall,squash,alu_Out[6]);
	OneBitLatch alu_bit7(alu[7],cp,stall,squash,alu_Out[7]);
	OneBitLatch alu_bit8(alu[8],cp,stall,squash,alu_Out[8]);
	OneBitLatch alu_bit9(alu[9],cp,stall,squash,alu_Out[9]);
	OneBitLatch alu_bit10(alu[10],cp,stall,squash,alu_Out[10]);
	OneBitLatch alu_bit11(alu[11],cp,stall,squash,alu_Out[11]);
	OneBitLatch alu_bit12(alu[12],cp,stall,squash,alu_Out[12]);
	OneBitLatch alu_bit13(alu[13],cp,stall,squash,alu_Out[13]);
	OneBitLatch alu_bit14(alu[14],cp,stall,squash,alu_Out[14]);
	OneBitLatch alu_bit15(alu[15],cp,stall,squash,alu_Out[15]);
	OneBitLatch alu_bit16(alu[16],cp,stall,squash,alu_Out[16]);
	OneBitLatch alu_bit17(alu[17],cp,stall,squash,alu_Out[17]);
	OneBitLatch alu_bit18(alu[18],cp,stall,squash,alu_Out[18]);
	OneBitLatch alu_bit19(alu[19],cp,stall,squash,alu_Out[19]);
	OneBitLatch alu_bit20(alu[20],cp,stall,squash,alu_Out[20]);
	OneBitLatch alu_bit21(alu[21],cp,stall,squash,alu_Out[21]);
	OneBitLatch alu_bit22(alu[22],cp,stall,squash,alu_Out[22]);
	OneBitLatch alu_bit23(alu[23],cp,stall,squash,alu_Out[23]);
	OneBitLatch alu_bit24(alu[24],cp,stall,squash,alu_Out[24]);
	OneBitLatch alu_bit25(alu[25],cp,stall,squash,alu_Out[25]);
	OneBitLatch alu_bit26(alu[26],cp,stall,squash,alu_Out[26]);
	OneBitLatch alu_bit27(alu[27],cp,stall,squash,alu_Out[27]);
	OneBitLatch alu_bit28(alu[28],cp,stall,squash,alu_Out[28]);
	OneBitLatch alu_bit29(alu[29],cp,stall,squash,alu_Out[29]);
	OneBitLatch alu_bit30(alu[30],cp,stall,squash,alu_Out[30]);
	OneBitLatch alu_bit31(alu[31],cp,stall,squash,alu_Out[31]);
	
	//Rz
	OneBitLatch Rz_bit0(Rz[0],cp,stall,squash,Rz_Out[0]);
	OneBitLatch Rz_bit1(Rz[1],cp,stall,squash,Rz_Out[1]);
	OneBitLatch Rz_bit2(Rz[2],cp,stall,squash,Rz_Out[2]);
	OneBitLatch Rz_bit3(Rz[3],cp,stall,squash,Rz_Out[3]);
	OneBitLatch Rz_bit4(Rz[4],cp,stall,squash,Rz_Out[4]);
	OneBitLatch Rz_bit5(Rz[5],cp,stall,squash,Rz_Out[5]);
	OneBitLatch Rz_bit6(Rz[6],cp,stall,squash,Rz_Out[6]);
	OneBitLatch Rz_bit7(Rz[7],cp,stall,squash,Rz_Out[7]);
	OneBitLatch Rz_bit8(Rz[8],cp,stall,squash,Rz_Out[8]);
	OneBitLatch Rz_bit9(Rz[9],cp,stall,squash,Rz_Out[9]);
	OneBitLatch Rz_bit10(Rz[10],cp,stall,squash,Rz_Out[10]);
	OneBitLatch Rz_bit11(Rz[11],cp,stall,squash,Rz_Out[11]);
	OneBitLatch Rz_bit12(Rz[12],cp,stall,squash,Rz_Out[12]);
	OneBitLatch Rz_bit13(Rz[13],cp,stall,squash,Rz_Out[13]);
	OneBitLatch Rz_bit14(Rz[14],cp,stall,squash,Rz_Out[14]);
	OneBitLatch Rz_bit15(Rz[15],cp,stall,squash,Rz_Out[15]);
	OneBitLatch Rz_bit16(Rz[16],cp,stall,squash,Rz_Out[16]);
	OneBitLatch Rz_bit17(Rz[17],cp,stall,squash,Rz_Out[17]);
	OneBitLatch Rz_bit18(Rz[18],cp,stall,squash,Rz_Out[18]);
	OneBitLatch Rz_bit19(Rz[19],cp,stall,squash,Rz_Out[19]);
	OneBitLatch Rz_bit20(Rz[20],cp,stall,squash,Rz_Out[20]);
	OneBitLatch Rz_bit21(Rz[21],cp,stall,squash,Rz_Out[21]);
	OneBitLatch Rz_bit22(Rz[22],cp,stall,squash,Rz_Out[22]);
	OneBitLatch Rz_bit23(Rz[23],cp,stall,squash,Rz_Out[23]);
	OneBitLatch Rz_bit24(Rz[24],cp,stall,squash,Rz_Out[24]);
	OneBitLatch Rz_bit25(Rz[25],cp,stall,squash,Rz_Out[25]);
	OneBitLatch Rz_bit26(Rz[26],cp,stall,squash,Rz_Out[26]);
	OneBitLatch Rz_bit27(Rz[27],cp,stall,squash,Rz_Out[27]);
	OneBitLatch Rz_bit28(Rz[28],cp,stall,squash,Rz_Out[28]);
	OneBitLatch Rz_bit29(Rz[29],cp,stall,squash,Rz_Out[29]);
	OneBitLatch Rz_bit30(Rz[30],cp,stall,squash,Rz_Out[30]);
	OneBitLatch Rz_bit31(Rz[31],cp,stall,squash,Rz_Out[31]);
	
	//Z
	OneBitLatch Z_bit0(Z[0],cp,stall,squash,Z_Out[0]);
	OneBitLatch Z_bit1(Z[1],cp,stall,squash,Z_Out[1]);
	OneBitLatch Z_bit2(Z[2],cp,stall,squash,Z_Out[2]);
	
	//cntrl
	OneBitLatch cntrl_bit0(cntrl[0],cp,stall,squash,cntrl_Out[0]);
	OneBitLatch cntrl_bit1(cntrl[1],cp,stall,squash,cntrl_Out[1]);
	OneBitLatch cntrl_bit2(cntrl[2],cp,stall,squash,cntrl_Out[2]);
	OneBitLatch cntrl_bit3(cntrl[3],cp,stall,squash,cntrl_Out[3]);
	OneBitLatch cntrl_bit4(cntrl[4],cp,stall,squash,cntrl_Out[4]);
	OneBitLatch cntrl_bit5(cntrl[5],cp,stall,squash,cntrl_Out[5]);
	OneBitLatch cntrl_bit6(cntrl[6],cp,stall,squash,cntrl_Out[6]);
	OneBitLatch cntrl_bit7(cntrl[7],cp,stall,squash,cntrl_Out[7]);
	OneBitLatch cntrl_bit8(cntrl[8],cp,stall,squash,cntrl_Out[8]);
	OneBitLatch cntrl_bit9(cntrl[9],cp,stall,squash,cntrl_Out[9]);
	OneBitLatch cntrl_bit10(cntrl[10],cp,stall,squash,cntrl_Out[10]);
	OneBitLatch cntrl_bit11(cntrl[11],cp,stall,squash,cntrl_Out[11]);
	OneBitLatch cntrl_bit12(cntrl[12],cp,stall,squash,cntrl_Out[12]);
endmodule

module MemWbLatch(cntrl,alu,mem,Z,cntrl_Out,alu_Out,mem_Out,Z_Out,cp,stall,squash);
	input [31:0] alu,mem;
	input [2:0] Z;
	input [12:0] cntrl;
	input cp,stall,squash;
	
	output [31:0] alu_Out,mem_Out;
	output [2:0] Z_Out;
	output [12:0] cntrl_Out;
	
	//alu
	OneBitLatch alu_bit0(alu[0],cp,stall,squash,alu_Out[0]);
	OneBitLatch alu_bit1(alu[1],cp,stall,squash,alu_Out[1]);
	OneBitLatch alu_bit2(alu[2],cp,stall,squash,alu_Out[2]);
	OneBitLatch alu_bit3(alu[3],cp,stall,squash,alu_Out[3]);
	OneBitLatch alu_bit4(alu[4],cp,stall,squash,alu_Out[4]);
	OneBitLatch alu_bit5(alu[5],cp,stall,squash,alu_Out[5]);
	OneBitLatch alu_bit6(alu[6],cp,stall,squash,alu_Out[6]);
	OneBitLatch alu_bit7(alu[7],cp,stall,squash,alu_Out[7]);
	OneBitLatch alu_bit8(alu[8],cp,stall,squash,alu_Out[8]);
	OneBitLatch alu_bit9(alu[9],cp,stall,squash,alu_Out[9]);
	OneBitLatch alu_bit10(alu[10],cp,stall,squash,alu_Out[10]);
	OneBitLatch alu_bit11(alu[11],cp,stall,squash,alu_Out[11]);
	OneBitLatch alu_bit12(alu[12],cp,stall,squash,alu_Out[12]);
	OneBitLatch alu_bit13(alu[13],cp,stall,squash,alu_Out[13]);
	OneBitLatch alu_bit14(alu[14],cp,stall,squash,alu_Out[14]);
	OneBitLatch alu_bit15(alu[15],cp,stall,squash,alu_Out[15]);
	OneBitLatch alu_bit16(alu[16],cp,stall,squash,alu_Out[16]);
	OneBitLatch alu_bit17(alu[17],cp,stall,squash,alu_Out[17]);
	OneBitLatch alu_bit18(alu[18],cp,stall,squash,alu_Out[18]);
	OneBitLatch alu_bit19(alu[19],cp,stall,squash,alu_Out[19]);
	OneBitLatch alu_bit20(alu[20],cp,stall,squash,alu_Out[20]);
	OneBitLatch alu_bit21(alu[21],cp,stall,squash,alu_Out[21]);
	OneBitLatch alu_bit22(alu[22],cp,stall,squash,alu_Out[22]);
	OneBitLatch alu_bit23(alu[23],cp,stall,squash,alu_Out[23]);
	OneBitLatch alu_bit24(alu[24],cp,stall,squash,alu_Out[24]);
	OneBitLatch alu_bit25(alu[25],cp,stall,squash,alu_Out[25]);
	OneBitLatch alu_bit26(alu[26],cp,stall,squash,alu_Out[26]);
	OneBitLatch alu_bit27(alu[27],cp,stall,squash,alu_Out[27]);
	OneBitLatch alu_bit28(alu[28],cp,stall,squash,alu_Out[28]);
	OneBitLatch alu_bit29(alu[29],cp,stall,squash,alu_Out[29]);
	OneBitLatch alu_bit30(alu[30],cp,stall,squash,alu_Out[30]);
	OneBitLatch alu_bit31(alu[31],cp,stall,squash,alu_Out[31]);
	
	//mem
	OneBitLatch mem_bit0(mem[0],cp,stall,squash,mem_Out[0]);
	OneBitLatch mem_bit1(mem[1],cp,stall,squash,mem_Out[1]);
	OneBitLatch mem_bit2(mem[2],cp,stall,squash,mem_Out[2]);
	OneBitLatch mem_bit3(mem[3],cp,stall,squash,mem_Out[3]);
	OneBitLatch mem_bit4(mem[4],cp,stall,squash,mem_Out[4]);
	OneBitLatch mem_bit5(mem[5],cp,stall,squash,mem_Out[5]);
	OneBitLatch mem_bit6(mem[6],cp,stall,squash,mem_Out[6]);
	OneBitLatch mem_bit7(mem[7],cp,stall,squash,mem_Out[7]);
	OneBitLatch mem_bit8(mem[8],cp,stall,squash,mem_Out[8]);
	OneBitLatch mem_bit9(mem[9],cp,stall,squash,mem_Out[9]);
	OneBitLatch mem_bit10(mem[10],cp,stall,squash,mem_Out[10]);
	OneBitLatch mem_bit11(mem[11],cp,stall,squash,mem_Out[11]);
	OneBitLatch mem_bit12(mem[12],cp,stall,squash,mem_Out[12]);
	OneBitLatch mem_bit13(mem[13],cp,stall,squash,mem_Out[13]);
	OneBitLatch mem_bit14(mem[14],cp,stall,squash,mem_Out[14]);
	OneBitLatch mem_bit15(mem[15],cp,stall,squash,mem_Out[15]);
	OneBitLatch mem_bit16(mem[16],cp,stall,squash,mem_Out[16]);
	OneBitLatch mem_bit17(mem[17],cp,stall,squash,mem_Out[17]);
	OneBitLatch mem_bit18(mem[18],cp,stall,squash,mem_Out[18]);
	OneBitLatch mem_bit19(mem[19],cp,stall,squash,mem_Out[19]);
	OneBitLatch mem_bit20(mem[20],cp,stall,squash,mem_Out[20]);
	OneBitLatch mem_bit21(mem[21],cp,stall,squash,mem_Out[21]);
	OneBitLatch mem_bit22(mem[22],cp,stall,squash,mem_Out[22]);
	OneBitLatch mem_bit23(mem[23],cp,stall,squash,mem_Out[23]);
	OneBitLatch mem_bit24(mem[24],cp,stall,squash,mem_Out[24]);
	OneBitLatch mem_bit25(mem[25],cp,stall,squash,mem_Out[25]);
	OneBitLatch mem_bit26(mem[26],cp,stall,squash,mem_Out[26]);
	OneBitLatch mem_bit27(mem[27],cp,stall,squash,mem_Out[27]);
	OneBitLatch mem_bit28(mem[28],cp,stall,squash,mem_Out[28]);
	OneBitLatch mem_bit29(mem[29],cp,stall,squash,mem_Out[29]);
	OneBitLatch mem_bit30(mem[30],cp,stall,squash,mem_Out[30]);
	OneBitLatch mem_bit31(mem[31],cp,stall,squash,mem_Out[31]);
	
	
	//Z
	OneBitLatch Z_bit0(Z[0],cp,stall,squash,Z_Out[0]);
	OneBitLatch Z_bit1(Z[1],cp,stall,squash,Z_Out[1]);
	OneBitLatch Z_bit2(Z[2],cp,stall,squash,Z_Out[2]);
	
	//cntrl
	OneBitLatch cntrl_bit0(cntrl[0],cp,stall,squash,cntrl_Out[0]);
	OneBitLatch cntrl_bit1(cntrl[1],cp,stall,squash,cntrl_Out[1]);
	OneBitLatch cntrl_bit2(cntrl[2],cp,stall,squash,cntrl_Out[2]);
	OneBitLatch cntrl_bit3(cntrl[3],cp,stall,squash,cntrl_Out[3]);
	OneBitLatch cntrl_bit4(cntrl[4],cp,stall,squash,cntrl_Out[4]);
	OneBitLatch cntrl_bit5(cntrl[5],cp,stall,squash,cntrl_Out[5]);
	OneBitLatch cntrl_bit6(cntrl[6],cp,stall,squash,cntrl_Out[6]);
	OneBitLatch cntrl_bit7(cntrl[7],cp,stall,squash,cntrl_Out[7]);
	OneBitLatch cntrl_bit8(cntrl[8],cp,stall,squash,cntrl_Out[8]);
	OneBitLatch cntrl_bit9(cntrl[9],cp,stall,squash,cntrl_Out[9]);
	OneBitLatch cntrl_bit10(cntrl[10],cp,stall,squash,cntrl_Out[10]);
	OneBitLatch cntrl_bit11(cntrl[11],cp,stall,squash,cntrl_Out[11]);
	OneBitLatch cntrl_bit12(cntrl[12],cp,stall,squash,cntrl_Out[12]);
	
	
endmodule


module OneBitLatch(d,cp,stall,squash,o);
	input d,cp,stall,squash;
	output o;
	wire latchOut,mux1Out;
	twoToOneMux inputOrStall(d,latchOut,stall,mux1Out);
	edgeTriggeredLatch dataLatch(mux1Out,cp,latchOut);
	twoToOneMux squashOrOut(latchOut,1'b0,squash,o);
	
endmodule