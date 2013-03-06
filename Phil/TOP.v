

module TOP(clk,rst);
	input clk;
	input rst;
	wire squash = 0;
	wire stall = 0;
	
	defparam pc.N = 32;
	defparam feIdLatch.N = 64; //PC + isn
	defparam idExLatch.N = 32+13+3+32*3+32; //PC + cntl + Z + Rxyz + imm
	defparam exMemLatch.N = 13+3+32+32;
	defparam memWbLatch.N = 13+32+32+3;
	//fetch unit
	wire [31:0] pcAddressOut,addressIn,address_Mem,data_Out_Mem,pc_FE_Out,isn_FE_Out;
	wire [31:0] pc_Out_ID,Rz_Out_ID,Ry_Out_ID,Rx_Out_ID,imm32_Out_ID;
	RegisterN pc(addressIn,clk,rst,pcAddressOut);
	ALU32 nextPCIncrementor(pcAddressOut, 4, 0, addressIn);
	
	LatchN feIdLatch({pcAddressOut,data_Out_Mem},{pc_FE_Out,isn_FE_Out} ,clk,stall,squash);
	
	wire [12:0] cntrl_Out_ID,cntrl_In_EX,cntrl_Out_EX,cntrl_Out_MEM,cntrl_In_MEM,cntrl_In_WB;
	wire [2:0] Z_Out_ID,Z_In_EX,Z_Out_EX,Z_In_MEM,Z_Out_MEM,Z_In_WB,Z_Out_WB;
	wire [31:0] pc_In_EX,Rz_In_EX,Ry_In_EX,Rx_In_EX,imm32_In_EX,Rz_Out_EX,alu_Out_EX,Rz_In_MEM,alu_In_MEM;
	wire [31:0] JmpAddr,StData,alu_Out_MEM,alu_In_WB,Mem_Result_In_WB,Mem_Result,data_Out_WB;
	wire regWE;
	IDStage id(pc_FE_Out,isn_FE_Out[31],isn_FE_Out[30:28],isn_FE_Out[27:22],isn_FE_Out[21:19],isn_FE_Out[18:16],isn_FE_Out[2:0],isn_FE_Out[15:0],isn_FE_Out[21:0],regWE,Z_Out_WB,data_Out_WB,pc_Out_ID,cntrl_Out_ID,Z_Out_ID,Rz_Out_ID,Ry_Out_ID,Rx_Out_ID,imm32_Out_ID);
	//           pc          p              preg                op               z                  y	              x                 imm16              imm22
	
	LatchN idExLatch({pc_Out_ID,cntrl_Out_ID,Z_Out_ID,Rz_Out_ID,Ry_Out_ID,Rx_Out_ID,imm32_Out_ID},{pc_In_EX,cntrl_In_EX,Z_In_EX,Rz_In_EX,Ry_In_EX,Rx_In_EX,imm32_In_EX},clk,stall,squash);
	
	EXStage exStage(pc_In_EX,cntrl_In_EX,Z_In_EX,Rz_In_EX,Ry_In_EX,Rx_In_EX,imm32_In_EX,cntrl_Out_EX,Z_Out_EX,Rz_Out_EX,alu_Out_EX);
	
	LatchN exMemLatch({cntrl_Out_EX,Z_Out_EX,Rz_Out_EX,alu_Out_EX},{cntrl_In_MEM,Z_In_MEM,Rz_In_MEM,alu_In_MEM},clk,stall,squash);
	
	MEMStage memStage(cntrl_In_MEM,Z_In_MEM,Rz_In_MEM,alu_In_MEM,JmpAddr,StData,Z_Out_MEM,alu_Out_MEM,NextPCOrJmp,MemOp,MemWrite,IsnOrMem,Stall,cntrl_Out_MEM);
	
	LatchN memWbLatch({cntrl_Out_MEM,alu_Out_MEM,Mem_Result,Z_Out_MEM},{cntrl_In_WB,alu_In_WB,Mem_Result_In_WB,Z_In_WB},clk,stall,squash);
	
	WBStage wbStage(cntrl_In_WB,alu_In_WB,Mem_Result_In_WB,Z_In_WB,data_Out_WB,Z_Out_WB,regWE);
	
	//memory
	TwoToOneMux32 IsnOrMemSelector(pcAddressOut,0,0,address_Mem);
	Memory4KB memory(rst,0,address_Mem,0,data_Out_Mem);
	OneToTwoMux32 isnMemDemux(data_Out_Mem,inst_Mem,Mem_Result,IsnOrMem);
	
	
	
	
	/*wire [31:0] pcOut, pcAdderOut,addressIn;
	
	
	Register32B pc(addressIn,clk,rst,pcOut);
	ALU32 pcAdder(pcOut,4,0,pcAdderOut);
	
	TwoToOneMux32 pcOrJmpMux(pcAdderOut,JmpAddr_Out_MEM,NextPCOrJmp_Out_MEM,addressIn);
	
	wire [31:0]instOut_feId;
	FeIdLatch feIdLatch(pcOut,inst_Mem,pcOut_feId,instOut_feId,clk,stall,squash);
	
	
	
	IDStage idStage(pcOut_feId,instOut_feId[30:28],instOut_feId[27:22],instOut_feId[21:19],instOut_feId[18:16],instOut_feId[2:0],instOut_feId[15:0],instOut_feId[21:0],regWrite,Z_Out,data_Out,pc_Out_ID,cntrl_Out_ID,Z_Out_ID,Rz_Out_ID,Ry_Out_ID,Rx_Out_ID,imm32_Out_ID);
	//                               preg                     op               z                     y	             x                 imm16              imm22
	  
	IdExLatch idExLatch(pc_Out_ID,cntrl_Out_ID,Z_Out_ID,Rz_ID,Ry_ID,Rx_ID,imm32_ID,pc_In_EX,cntrl_In_EX,Z_In_EX,Rz_In_EX,Ry_In_EX,Rx_In_EX,imm32_In_EX,clk,stall,squash);
	
	EXStage exStage(pc_In_EX,cntrl_In_EX,Z_In_EX,Rz_In_EX,Ry_In_EX,Rx_In_EX,imm32_In_EX,alu_Out_EX,Rz_Out_EX,Z_Out_EX,cntrl_Out_EX);
	
	ExMemLatch exMemLatch(alu_Out_EX,Rz_Out_EX,Z_Out_EX,cntrl_Out_EX,alu_In_MEM,Rz_In_MEM,Z_In_MEM,cntrl_In_MEM,clk,stall,squash);
	
	MEMStage memStage(alu_In_MEM,Rz_In_MEM,Z_In_MEM,cntrl_In_MEM,JmpAddr_Out_MEM,StData_Out_MEM,Z_Out_MEM,alu_Out_MEM,NextPCOrJmp_Out_MEM,MemOp_Out_MEM,MemWrite_Out_MEM,IsnOrMem_Out_MEM,Stall_Out_MEM,cntrl_Out_MEM);

	MemWbLatch memWbLatch(cntrl_Out_MEM,alu_Out_MEM,Mem_Result,Z_Out_MEM,cntrl_In_WB,alu_In_WB,mem_In_WB,Z_In_WB,clk,stall,squash);
	
	 WBStage wbStage(cntrl_In_WB,alu_In_WB,mem_In_WB,Z_In_WB,data_Out,Z_Out,regWrite);
	
	//memory
	TwoToOneMux32 IsnOrMemSelector(pcOut,alu_Out_MEM,MemOp_Out_MEM,address_Mem);
	Memory4KB memory(clk,MemWrite_Out_MEM,address_Mem,StData_Out_MEM,data_Out_Mem);
	OneToTwoMux32 isnMemDemux(data_Out_Mem,inst_Mem,Mem_Result,IsnOrMem_Out_MEM);
	*/
endmodule

module WBStage(cntrl,alu,mem,Z,data_Out,Z_Out,regWrite);
	input [31:0] alu,mem;
	input [2:0] Z;
	input [12:0] cntrl;
	
	output [2:0] Z_Out;
	output [31:0] data_Out;
	output regWrite;
	
	TwoToOneMux32 ALUOrMemSelector(alu,mem,cntrl[1],data_Out);
	assign Z_Out = Z;
	assign regWrite = cntrl[0];
endmodule


module MEMStage(cntrl,Z,Rz,alu,JmpAddr,StData,Z_Out,alu_Out,NextPCOrJmp,MemOp,MemWrite,IsnOrMem,Stall,cntrl_Out);
  input [31:0] alu,Rz;
	input [2:0] Z;
	input [12:0] cntrl;
	
	output [31:0] JmpAddr,StData,alu_Out;
	output [2:0] Z_Out;
	output [12:0] cntrl_Out;
	output NextPCOrJmp,MemOp,MemWrite,IsnOrMem,Stall;
	
	wire [31:0] JmpData;
	OneToTwoMux32 jumpOrSt(Rz,JmpData,StData,cntrl[2]);
	TwoToOneMux32 jmprOrJmpi(JmpData,alu_Out,cntrl[3],JmpAddr);
	
	assign Z_Out = Z;
	assign alu_Out = alu;
	assign NextPCOrJmp = cntrl[8];
	assign MemOp = cntrl[6];
	assign MemWrite = cntrl[5];
	assign IsnOrMem = cntrl[4];
	assign Stall =  cntrl[7];
	assign cntrl_Out = cntrl;
endmodule

module EXStage(pc,cntrl,Z,Rz,Ry,Rx,imm32,cntrl_Out,Z_Out,Rz_Out,alu_Out);
  input [31:0] pc,Rz,Ry,Rx,imm32;
	input [2:0] Z;
	input [12:0] cntrl;
	
	output [12:0] cntrl_Out;
	output [2:0] Z_Out;
	output [31:0] Rz_Out;
	output [31:0] alu_Out;
	wire [31:0] topMux,botMux;
	
	
	TwoToOneMux32 pcOrRy(pc,Ry,cntrl[11],topMux);
	TwoToOneMux32 RxOrImm(Rx,imm32,cntrl[10],botMux);
	ALU32 mainALU(topMux, botMux, {2{cntrl[9]}}, alu_Out);
	
  assign Rz_Out = Rz;
	assign Z_Out = Z;
	assign cntrl_Out = cntrl;
	
endmodule

module IDStage (pc,p,preg,op,z,y,x,imm16,imm22,regWE,RzWE,data,pc_Out,cntrl_Out,Z_Out,Rz_Out,Ry_Out,Rx_Out,imm32_Out);
  input [31:0] pc;
  input p;
  input [2:0] preg;
  input [5:0] op;
	input [2:0] x,y,z;
	input [15:0] imm16;
	input [21:0] imm22;
	
	input regWE;
	input [2:0] RzWE;
	input [31:0] data;
	
	output [31:0] pc_Out,Rz_Out,Ry_Out,Rx_Out,imm32_Out;
	output [2:0] Z_Out;
	output [12:0] cntrl_Out;

  OpControl opcntrl(op,cntrl_Out);
  
  RegFile registerFile(regWE,RzWE,data,z,y,x,Rz_Out,Ry_Out,Rx_Out);

  wire [31:0] imm16Sexted,imm22Sexted;
  
  //TODO add support for predication -- not implemented because no relevant instructions in ISA.
  
  Sext16to32 sext16(imm16,imm16Sexted);
	Sext22to32 sext22(imm22,imm22Sexted);
	TwoToOneMux32 immMux(imm16Sexted,imm22Sexted,cntrl_Out[12],imm32_Out);

  assign pc_Out = pc;
	assign Z_Out = z;
endmodule
/*module IDStage(pc,preg,op,z,y,x,imm16,imm22,regWE,RzWE,data,pc_Out,cntrl_Out,Z_Out,Rz_Out,Ry_Out,Rx_Out,imm32_Out);
	input [31:0] pc;
	input [2:0] preg;
	input [5:0] op;
	input [2:0] x,y,z;
	input [15:0] imm16;
	input [21:0] imm22;
	
	input regWE;
	input [2:0] RzWE;
	input [31:0] data;
	
	
	output [31:0] pc_Out,Rz_Out,Ry_Out,Rx_Out,imm32_Out;
	output [2:0] Z_Out;
	output [12:0] cntrl_Out;
	
	OpControl opcntrl(op,cntrl_Out);
	
	
	regFile registerFile(clk,regWE,RzWE,data,z,y,x,Rz_Out,Ry_Out,Rx_Out);
	
	Sext16to32 sext16(imm16,imm16Sexted);
	Sext22to32 sext22(imm22,imm22Sexted);
	TwoToOneMux32 immMux(imm16Sexted,imm22Sexted,cntrl_Out[12],imm32_Out);
	
	
	
	assign pc_Out = pc;
	assign Z_Out = z;
endmodule

module EXStage(pc,cntrl,Z,Rz,Ry,Rx,imm32,alu_Out,Rz_Out,Z_Out,cntrl_Out);
	input [31:0] pc,Rz,Ry,Rx,imm32;
	input [2:0] Z;
	input [12:0] cntrl;
	
	output [31:0] alu_Out,Rz_Out;
	output [2:0] Z_Out;
	output [12:0] cntrl_Out;
	
	TwoToOneMux32 pcOrRy(pc,Ry,cntrl[11],topMux);
	TwoToOneMux32 RxOrImm(Rx,imm,cntrl[10],botMux);
	ALU32 mainALU(topMux, botMux, cntrl[10], alu_Out);
	
   assign Rz_Out = Rz;
	assign Z_Out = Z;
	assign cntrl_Out = cntrl;
	
	
endmodule

module MEMStage(alu,Rz,Z,cntrl,JmpAddr,StData,Z_Out,alu_Out,NextPCOrJmp,MemOp,MemWrite,IsnOrMem,Stall,cntrl_Out);
	input [31:0] alu,Rz;
	input [2:0] Z;
	input [12:0] cntrl;
	
	output [31:0] JmpAddr,StData,alu_Out;
	output [2:0] Z_Out;
	output [12:0] cntrl_Out;
	output NextPCOrJmp,MemOp,MemWrite,IsnOrMem,Stall;
	
	OneToTwoMux32 jmprOrStAddrSelector(Rz,JmprAddr,StData,cntrl[2]);
	TwoToOneMux32 JmprOrJmpiSelector(JmprAddr,alu,cntrl[3],JmpAddr);
	
	
	assign NextPCOrJmp = cntrl[8];
	assign MemOp = cntrl[6];   
	assign MemWrite =	cntrl[5];
	assign IsnOrMem = cntrl[4];
	assign Stall = cntrl[7];
	assign Z_Out = Z;
	assign alu_Out = alu;
	assign cntrl_Out = cntrl;
	
endmodule*/



module OpControl(op,cntrl_Out);
	input [5:0] op;
	
	reg [12:0] cntrl;
	output [12:0] cntrl_Out;
	
	always @(*)
	begin
		if(op  == 6'h14) // addi
		begin //0110000000001
		cntrl[12] <= 0;  //16or22imm
		cntrl[11] <= 1;  //PC/Ry
		cntrl[10] <= 1;  //Rx/Imm
		cntrl[9] <= 0;   //ALUOp (there's only 2 possible right now...? A+B, A-B ?)
		cntrl[8] <= 0;	  //NextPC/Jmp
		cntrl[7] <= 0;   //Stall
		cntrl[6] <= 0;   //MemOp
		cntrl[5] <= 0;   //MemWrite
		cntrl[4] <= 0;   //IsnOrMem
		cntrl[3] <= 0;   //Jmpr/Jmpi
		cntrl[2] <= 0;   //Jmpr/St
		cntrl[1] <= 0;   //Alu/Mem
		cntrl[0] <= 1;   //RegWrite
		end
		else if (op == 6'h0a) //add
		begin //0100000000001
		cntrl[12] <= 0;  //16or22imm
		cntrl[11] <= 1;  //PC/Ry
		cntrl[10] <= 0;  //Rx/Imm
		cntrl[9] <= 0;   //ALUOp
		cntrl[8] <= 0;	  //NextPC/Jmp
		cntrl[7] <= 0;   //Stall
		cntrl[6] <= 0;   //MemOp
		cntrl[5] <= 0;   //MemWrite
		cntrl[4] <= 0;   //IsnOrMem
		cntrl[3] <= 0;   //Jmpr/Jmpi
		cntrl[2] <= 0;   //Jmpr/St
		cntrl[1] <= 0;   //Alu/Mem
		cntrl[0] <= 1;   //RegWrite
		end
		else if (op == 2) //subi
		begin //0111000000001
		cntrl[12] <= 0;  //16or22imm
		cntrl[11] <= 1;  //PC/Ry
		cntrl[10] <= 1;  //Rx/Imm
		cntrl[9] <= 1;   //ALUOp
		cntrl[8] <= 0;	  //NextPC/Jmp
		cntrl[7] <= 0;   //Stall
		cntrl[6] <= 0;   //MemOp
		cntrl[5] <= 0;   //MemWrite
		cntrl[4] <= 0;   //IsnOrMem
		cntrl[3] <= 0;   //Jmpr/Jmpi
		cntrl[2] <= 0;   //Jmpr/St
		cntrl[1] <= 0;   //Alu/Mem
		cntrl[0] <= 1;   //RegWrite
		end
		else if (op == 6'h0b) //sub
		begin //0101000000001
		cntrl[12] <= 0;  //16or22imm
		cntrl[11] <= 1;  //PC/Ry
		cntrl[10] <= 0;  //Rx/Imm
		cntrl[9] <= 1;   //ALUOp
		cntrl[8] <= 0;	  //NextPC/Jmp
		cntrl[7] <= 0;   //Stall
		cntrl[6] <= 0;   //MemOp
		cntrl[5] <= 0;   //MemWrite
		cntrl[4] <= 0;   //IsnOrMem
		cntrl[3] <= 0;   //Jmpr/Jmpi
		cntrl[2] <= 0;   //Jmpr/St
		cntrl[1] <= 0;   //Alu/Mem
		cntrl[0] <= 1;   //RegWrite
		end
		else if (op == 4) //jmpi
		begin //1010100001000
		cntrl[12] <= 1;  //16or22imm
		cntrl[11] <= 0;  //PC/Ry
		cntrl[10] <= 1;  //Rx/Imm
		cntrl[9] <= 0;   //ALUOp
		cntrl[8] <= 1;	  //NextPC/Jmp
		cntrl[7] <= 0;   //Stall
		cntrl[6] <= 0;   //MemOp
		cntrl[5] <= 0;   //MemWrite
		cntrl[4] <= 0;   //IsnOrMem
		cntrl[3] <= 1;   //Jmpr/Jmpi
		cntrl[2] <= 0;   //Jmpr/St
		cntrl[1] <= 0;   //Alu/Mem
		cntrl[0] <= 0;   //RegWrite
		end
		else if (op == 5) //jmpr
		begin //0000100000000
		cntrl[12] <= 0;  //16or22imm
		cntrl[11] <= 0;  //PC/Ry
		cntrl[10] <= 0;  //Rx/Imm
		cntrl[9] <= 0;   //ALUOp
		cntrl[8] <= 1;	  //NextPC/Jmp
		cntrl[7] <= 0;   //Stall
		cntrl[6] <= 0;   //MemOp
		cntrl[5] <= 0;   //MemWrite
		cntrl[4] <= 0;   //IsnOrMem
		cntrl[3] <= 0;   //Jmpr/Jmpi
		cntrl[2] <= 0;   //Jmpr/St
		cntrl[1] <= 0;   //Alu/Mem
		cntrl[0] <= 0;   //RegWrite
		end
		else if (op == 6) //St
		begin //0110011110110
		cntrl[12] <= 0;  //16or22imm
		cntrl[11] <= 1;  //PC/Ry
		cntrl[10] <= 1;  //Rx/Imm
		cntrl[9] <= 0;   //ALUOp
		cntrl[8] <= 0;	  //NextPC/Jmp
		cntrl[7] <= 1;   //Stall
		cntrl[6] <= 1;   //MemOp
		cntrl[5] <= 1;   //MemWrite
		cntrl[4] <= 1;   //IsnOrMem
		cntrl[3] <= 0;   //Jmpr/Jmpi
		cntrl[2] <= 1;   //Jmpr/St
		cntrl[1] <= 1;   //Alu/Mem
		cntrl[0] <= 0;   //RegWrite
		end
		else if (op == 7) //ld
		begin //0110011010011
		cntrl[12] <= 0;  //16or22imm
		cntrl[11] <= 1;  //PC/Ry
		cntrl[10] <= 1;  //Rx/Imm
		cntrl[9] <= 0;   //ALUOp
		cntrl[8] <= 0;	  //NextPC/Jmp
		cntrl[7] <= 1;   //Stall
		cntrl[6] <= 1;   //MemOp
		cntrl[5] <= 0;   //MemWrite
		cntrl[4] <= 1;   //IsnOrMem
		cntrl[3] <= 0;   //Jmpr/Jmpi
		cntrl[2] <= 0;   //Jmpr/St
		cntrl[1] <= 1;   //Alu/Mem
		cntrl[0] <= 1;   //RegWrite
		end
		else // noop
		begin
		cntrl[12] <= 0;  //16or22imm
		cntrl[11] <= 0;  //PC/Ry
		cntrl[10] <= 0;  //Rx/Imm
		cntrl[9] <= 0;   //ALUOp (there's only 2 possible right now...? A+B, A-B ?)
		cntrl[8] <= 0;	  //NextPC/Jmp
		cntrl[7] <= 0;   //Stall
		cntrl[6] <= 0;   //MemOp
		cntrl[5] <= 0;   //MemWrite
		cntrl[4] <= 0;   //IsnOrMem
		cntrl[3] <= 0;   //Jmpr/Jmpi
		cntrl[2] <= 0;   //Jmpr/St
		cntrl[1] <= 0;   //Alu/Mem
		cntrl[0] <= 0;   //RegWrite
		end
	end
	assign cntrl_Out = cntrl;
	
endmodule

module HW2Thing(inA,inB,muxAOp,muxBOp,s,clk,O);
	input [15:0] inB;
	input [15:0] inA;
	input muxAOp,muxBOp;
	input [1:0] s;
	input clk;
	output [15:0] O;
	
	wire [15:0] aluOut;
	wire [15:0] aluinB;
	wire [15:0] aluinA;
	
	ALU alu(aluinA,aluinB,s,aluOut);
	
	wire [15:0] regOut;
	sixteenBitRegister register(aluOut,clk,regOut);

	sixteenBitTwoToOneMux muxA(inA,regOut,muxAOp,aluinA);
	sixteenBitTwoToOneMux muxB(inB,regOut,muxBOp,aluinB);
	
	assign O=aluOut;
endmodule

module ALU32 (a, b, s, out);
	input [31:0] a;
	input [31:0] b;
	input [1:0] s;
	output reg [31:0] out;
	
	always@(a or b or s) begin
		if(s == 2'b00) begin //add
			out = a+b;
		end
		if(s == 2'b01) begin
		  out = a-b;
		end
	end
	
endmodule


/*module ALU16 (a, b, s, out);
	input [15:0] a;
	input [15:0] b;
	input [1:0] s;
	output [15:0] out;
	
	wire Cout0,Cout1,Cout2,Cout3,Cout4,Cout5,Cout6,Cout7,Cout8,Cout9,Cout10,Cout11,Cout12,Cout13,Cout14,Cout15;
	singleBitALU alu0(a[0],b[0],1'b0,s,Cout0,out[0]);
	singleBitALU alu1(a[1],b[1],Cout0,s,Cout1,out[1]);
	singleBitALU alu2(a[2],b[2],Cout1,s,Cout2,out[2]);
	singleBitALU alu3(a[3],b[3],Cout2,s,Cout3,out[3]);
	singleBitALU alu4(a[4],b[4],Cout3,s,Cout4,out[4]);
	singleBitALU alu5(a[5],b[5],Cout4,s,Cout5,out[5]);
	singleBitALU alu6(a[6],b[6],Cout5,s,Cout6,out[6]);
	singleBitALU alu7(a[7],b[7],Cout6,s,Cout7,out[7]);
	singleBitALU alu8(a[8],b[8],Cout7,s,Cout8,out[8]);
	singleBitALU alu9(a[9],b[9],Cout8,s,Cout9,out[9]);
	singleBitALU alu10(a[10],b[10],Cout9,s,Cout10,out[10]);
	singleBitALU alu11(a[11],b[11],Cout10,s,Cout11,out[11]);
	singleBitALU alu12(a[12],b[12],Cout11,s,Cout12,out[12]);
	singleBitALU alu13(a[13],b[13],Cout12,s,Cout13,out[13]);
	singleBitALU alu14(a[14],b[14],Cout13,s,Cout14,out[14]);
	singleBitALU alu15(a[15],b[15],Cout14,s,Cout15,out[15]);
	
endmodule

module ALU32 (a, b, s, out);
	input [31:0] a;
	input [31:0] b;
	input [1:0] s;
	output [31:0] out;
	
	wire Cout0,Cout1,Cout2,Cout3,Cout4,Cout5,Cout6,Cout7,Cout8,Cout9,Cout10,Cout11,Cout12,Cout13,Cout14,Cout15;
	wire Cout16,Cout17,Cout18,Cout19,Cout20,Cout21,Cout22,Cout23,Cout24,Cout25,Cout26,Cout27,Cout28,Cout29,Cout30,Cout31;
	singleBitALU alu0(a[0],b[0],1'b0,s,Cout0,out[0]);
	singleBitALU alu1(a[1],b[1],Cout0,s,Cout1,out[1]);
	singleBitALU alu2(a[2],b[2],Cout1,s,Cout2,out[2]);
	singleBitALU alu3(a[3],b[3],Cout2,s,Cout3,out[3]);
	singleBitALU alu4(a[4],b[4],Cout3,s,Cout4,out[4]);
	singleBitALU alu5(a[5],b[5],Cout4,s,Cout5,out[5]);
	singleBitALU alu6(a[6],b[6],Cout5,s,Cout6,out[6]);
	singleBitALU alu7(a[7],b[7],Cout6,s,Cout7,out[7]);
	singleBitALU alu8(a[8],b[8],Cout7,s,Cout8,out[8]);
	singleBitALU alu9(a[9],b[9],Cout8,s,Cout9,out[9]);
	singleBitALU alu10(a[10],b[10],Cout9,s, Cout10,out[10]);
	singleBitALU alu11(a[11],b[11],Cout10,s,Cout11,out[11]);
	singleBitALU alu12(a[12],b[12],Cout11,s,Cout12,out[12]);
	singleBitALU alu13(a[13],b[13],Cout12,s,Cout13,out[13]);
	singleBitALU alu14(a[14],b[14],Cout13,s,Cout14,out[14]);
	singleBitALU alu15(a[15],b[15],Cout14,s,Cout15,out[15]);
	singleBitALU alu16(a[16],b[16],Cout15,s,Cout16,out[16]);
	singleBitALU alu17(a[17],b[17],Cout16,s,Cout17,out[17]);
	singleBitALU alu18(a[18],b[18],Cout17,s,Cout18,out[18]);
	singleBitALU alu19(a[19],b[19],Cout18,s,Cout19,out[19]);
	singleBitALU alu20(a[20],b[20],Cout19,s,Cout20,out[20]);
	singleBitALU alu21(a[21],b[21],Cout20,s,Cout21,out[21]);
	singleBitALU alu22(a[22],b[22],Cout21,s,Cout22,out[22]);
	singleBitALU alu23(a[23],b[23],Cout22,s,Cout23,out[23]);
	singleBitALU alu24(a[24],b[24],Cout23,s,Cout24,out[24]);
	singleBitALU alu25(a[25],b[25],Cout24,s,Cout25,out[25]);
	singleBitALU alu26(a[26],b[26],Cout25,s,Cout26,out[26]);
	singleBitALU alu27(a[27],b[27],Cout26,s,Cout27,out[27]);
	singleBitALU alu28(a[28],b[28],Cout27,s,Cout28,out[28]);
	singleBitALU alu29(a[29],b[29],Cout28,s,Cout29,out[29]);
	singleBitALU alu30(a[30],b[30],Cout29,s,Cout30,out[30]);
	singleBitALU alu31(a[31],b[31],Cout30,s,Cout31,out[31]);
	
	
endmodule

module singleBitALU(A,B,Cin,s,Cout,O);
	input A,B,Cin;
	input [1:0] s;
	output Cout,O;
	
	//A+B+Cin
	wire adderOut,adderCout,adderCoutFiltered;
	singleBitFullAdder adder(A,B,Cin,adderCout,adderOut);
	//make sure Cin only outputs when addition is selected
	wire s1Neg,s0Neg;
	nand adderNand1(s1Neg,s[1],s[1]);
	nand adderNand2(s0Neg,s[0],s[0]);
	threeWayAnd adderThreeWayAnd(adderCout,s1Neg,s0Neg,adderCoutFiltered);
	
	//A & B
	wire andOut1,andOut2;
	nand andNand1(andOut1,A,B);
	nand andNand2(andOut2,andOut1,andOut1);
	
	//~B
	wire notOut;
	nand notNand1(notOut,B,B);
	
	
	//mux output together
	wire muxOut;
	fourToOneMux test(adderOut,andOut2,A,notOut,s[1],s[0],muxOut);
	
	assign O=muxOut;
	assign Cout=adderCoutFiltered;
	
endmodule)*/
		
	