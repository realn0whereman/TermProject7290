module alu_P(sel, op, A, B, C, Z);
  input sel;
  input [2:0] op;
  input A;
  input B;
  input [31:0] C;
  output reg Z;
  
  always @(*) begin
    if (sel == 1'b1) begin
      case (op)
        3'b001://and
          begin
            Z = A & B;      
          end
        3'b010://or
          begin
            Z = A | B;
          end
        3'b011://xor
          begin
            Z = A ^ B;
          end
        3'b100://not
          begin
            Z = ~A;
          end
        3'b101://rtop
          begin
            Z = (C == 32'b0) ? 1'b0 : 1'b1;
          end
        3'b110://isneg
          begin
            Z = C[31];
          end
        3'b111://iszero
          begin
            Z = (C == 32'b0) ? 1'b1 : 1'b0;
          end
        default:
          begin
            Z = 'bx;
          end
      endcase
    end else begin
      Z = 'bx;
    end
  end
endmodule

module alu_I(sel, op, A, B, Z);
  input sel;
  input [3:0] op;
  input [31:0] A;
  input [31:0] B;
  output reg [31:0] Z;
  
  always @(*) begin
    if (sel == 1'b1) begin
      case (op)
        4'b0001: //add
          begin
            Z = A + B;      
          end
        4'b0010: //sub
          begin
            Z = A - B;
          end
        4'b0011: //mul FIXME
          begin
            Z = 'bx;
          end
        4'b0100: //div FIXME
          begin
            Z = 'bx;
          end
        4'b0101: //mod FIXME
          begin
            Z = 'bx;
          end
        4'b0110: //shl
          begin
            Z = A << B;
          end
        4'b0111: //shr
          begin
            Z = A >> B;
          end
        4'b1000: //and
          begin
            Z = A & B;
          end
        4'b1001: //or
          begin
            Z = A | B;
          end        
        4'b1010: //xor
          begin
            Z = A ^ B;
          end
        4'b1011: //neg
          begin
            Z = ~A + 1;
          end
        4'b1100: //not
          begin
            Z = ~A;
          end
        4'b1101: //ldi
          begin
            Z = B;
          end
        4'b1110: //jump link FIXME
          begin
            Z = A;
          end
        default:
          begin
            Z = 'bx;
          end
      endcase
    end else begin
      Z = 'bx;
    end
  end
endmodule

//This module keeps track of the number of stalls to introduce
//for multi cycle operations.
//Behavior: Every time a latency input is drive, stall will be high
// for that many cycles, and then read in a new latency once it has stalled 
//(the original) latency amount of times.
module stall_counter(clk,latency,stall);
  input clk;
  input [3:0] latency;
  output reg stall;
  
  reg [3:0] cyclesLeft;
  initial begin
    cyclesLeft = 0;
  end
  
  always @(posedge clk) begin
    if(cyclesLeft == 0) begin
      stall = 0;
      cyclesLeft = latency;
    end else begin
      cyclesLeft = cyclesLeft - 1;
      stall = 1;
    end
      
  end
  
endmodule

module alu_F(sel,clk, op, A, B, Z,stall);
  input sel,clk;
  input [3:0] op;
  input [31:0] A;
  input [31:0] B;
  output reg [31:0] Z;
  output reg stall;
  
  wire [31:0] addSubResult;
  wire stallWire;
  reg [3:0] latency;
  reg addSub; // 0 == add, 1 == sub
  
  
  
  stall_counter stalls(.clk(clk),.latency(latency),.stall(stallWire));
  
	FPAddSub addSubFU(
	.add_sub(addSub),
	.clock(clk),
	.dataa(A),
	.datab(B),
	.result(addSubResult));
	
	//do we need reset for multi cycle ops?
  always@(posedge clk) begin
    if (sel == 1'b1) begin
      stall = stallWire;
      case(op)
        //itof
        //ftoi
        4'b1010: //fneg
          begin
            Z[30:0] = A[30:0];
            Z[31] = ~A[31];  
            latency = 0;  
          end
        4'b1011: //fadd     
          begin
            //maybe set Z = to x?
            addSub = 0;
            latency = 7;
            Z = addSubResult;  
          end      
        default:
          begin
            Z = 'bx;
          end
      endcase
    end else begin
      Z = 'bx;
    end
  end
  
	

	
	
	
	
endmodule


module execution(EX,clk, Px, Py, Rx, Ry, Fx, Fy, imm_s, pc_n, p1_mux, p2_mux, r1_mux, r2_mux, f1_mux, f2_mux, pval_mm, rval_mm, rval_wb, fval_mm, result_P, result_I, result_F, Wdata);
  input [6:0] EX;
  input clk;
  input Px;
  input Py;
  input [31:0] Rx;
  input [31:0] Ry;
  input [31:0] Fx;
  input [31:0] Fy;
  input [31:0] pc_n;
  input [31:0] imm_s;
  input p1_mux;
  input p2_mux;
  input f1_mux;
  input f2_mux;
  input [1:0] r1_mux;
  input [1:0] r2_mux;
  input pval_mm;
  input [31:0] rval_mm;
  input [31:0] rval_wb;
  input [31:0] fval_mm;
  output result_P;
  output [31:0] result_I;
  output [31:0] result_F;
  output [31:0] Wdata;

  reg PPU_src1;
  reg PPU_src2;
  reg [31:0] ALU_src1;
  reg [31:0] ALU_src2;
  //wire [31:0] FPU_src1;
  //wire [31:0] FPU_src2;
  
  always @(*) begin
    case (p1_mux)
      1'b0: PPU_src1 = Py;
      1'b1: PPU_src1 = pval_mm;
      default: PPU_src1 = 'bx;
    endcase
  end
  
  always @(*) begin
    case (p2_mux)
      1'b0: PPU_src2 = Px;
      1'b1: PPU_src2 = pval_mm;
      default: PPU_src2 = 'bx;
    endcase
  end
  
  always @(*) begin
    case (r1_mux)
      2'b00: ALU_src1 = Ry;
      2'b01: ALU_src1 = rval_mm;
      2'b10: ALU_src1 = rval_wb;
      2'b11: ALU_src1 = pc_n;
      default: ALU_src1 = 'bx;
    endcase
  end
  
  always @(*) begin
    case (r2_mux)
      2'b00: ALU_src2 = Rx;
      2'b01: ALU_src2 = rval_mm;
      2'b10: ALU_src2 = rval_wb;
      2'b11: ALU_src2 = imm_s;
      default: ALU_src1 = 'bx;
    endcase
  end
  
  assign Wdata = Rx;
  
  alu_P P1(.sel(!EX[0] & (!EX[4])), .op(EX[3:1]), .A(PPU_src1), .B(PPU_src2), .C(ALU_src1), .Z(result_P));
  alu_I I1(.sel(EX[0]), .op(EX[4:1]), .A(ALU_src1), .B(ALU_src2), .Z(result_I));
  //alu_F F1()
  //FIXME
  assign result_F = 'bx;
  
endmodule
