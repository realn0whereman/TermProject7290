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

module alu_I(clk,sel, op, A, B, Z,stall);
  input clk,sel;
  input [3:0] op;
  input [31:0] A;
  input [31:0] B;
  output reg [31:0] Z;
  output stall;
  
  wire [31:0] mulResult,modResult,divResult,shiftResult;
  reg [3:0] latency;
  stall_counter stalls(.clk(clk),.sel(sel),.latency(latency),.stall(stall));
  
  initial begin
    latency = 0;
  end
  
  IMul imul(
	.clock(clk),
	.dataa(A),
	.datab(B),
	.result(mulResult));
	
	/*module IDiv (
	.clock(clk),
	denom,
	.numer,
	quotient,
	remain);*/
	
  always @(*) begin
    if (sel == 1'b1) begin
      case (op)
        4'b0001: //add
          begin
            Z = A + B; 
            latency = 0;     
          end
        4'b0010: //sub
          begin
            Z = A - B;
          end
        4'b0011: //mul FIXME
          begin
            latency = 6+1;
            Z = mulResult;
          end
        4'b0100: //div FIXME
          begin
            // Z = A/B  
            //latency <= 6;
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
            latency = 0;
            Z = 'bx;
          end
      endcase
    end else begin
      latency = 0;
      Z = 'bx;
    end
  end
endmodule

//This module keeps track of the number of stalls to introduce
//for multi cycle operations.
//Behavior: Every time a latency input is drive, stall will be high
// for that many cycles, and then read in a new latency once it has stalled 
//(the original) latency amount of times.
module stall_counter(clk,sel,latency,stall);
  input clk,sel;
  input [3:0] latency;
  output stall;
  
  reg [2:0] state;
  reg isEnd;
  parameter init = 3'b000, Stall1 = 3'b001, Stall2 = 3'b010, Stall3 = 3'b011, Stall4 = 3'b100, 
    Stall5 = 3'b101, Stall6 = 3'b110, Stall7 = 3'b111;
  
  initial begin
    state <= init;
    isEnd <= 0;
  end
  /*always @(latency) begin
    state <= init;
  end*/
  
  always @(posedge clk or latency) begin
    case(state)
        init:
          begin
            if(latency == 7) begin
              state <= Stall7; 
              isEnd <= 0;
            end else if(latency == 6) begin
              state <= Stall6;
              isEnd <= 0;
            end else if(latency == 5) begin
              state <= Stall5;
              isEnd <= 0;
            end else if(latency == 4) begin
              state <= Stall4;
              isEnd <= 0;
            end else if(latency == 0) begin
              state <= init;
              isEnd <= 1; // maybe 1?
            end
            
          end
        Stall7: state <= Stall6;
        Stall6: state <= Stall5;
        Stall5: state <= Stall4;
        Stall4: state <= Stall3;
        Stall3: state <= Stall2;
        Stall2: state <= Stall1;
        Stall1: begin
         state <= init; 
         isEnd <= 1;
        end
    endcase    
  end  
  
  always @(*) begin
    if(latency == 0)
        state <= init;
  end
  assign stall = (((state != init) | ((state == init) && sel)) && !isEnd);
  
  
endmodule

module alu_F(sel,clk, op, A, B, C, Z,stall,exception);
  input sel,clk;
  input [2:0] op;
  input [31:0] A;
  input [31:0] B;
  input [31:0] C;
  output reg [31:0] Z;
  output stall;
  output exception;
  
  wire stall_wire;
  
  wire [31:0] addSubResult,mulResult,divResult,itofResult,ftoiResult;
  reg [3:0] latency;
  reg addSub; // 1 == add, 0 == sub
  reg stall_buf;
  stall_counter stalls(.clk(clk),.sel(sel),.latency(latency),.stall(stall_wire));
  
  initial begin
    latency = 0;
  end
  
  reg exception_real;
  wire exception_wire;  
  assign exception = exception_wire;
	FPAddSub addSubFU(
	.add_sub(addSub),
	.clock(clk),
	.dataa(A),
	.datab(B),
	.result(addSubResult));
      
  FPMul mulFU(
	.clock(clk),
	.dataa(A),
	.datab(B),
	.result(mulResult));
	
	reg clear_reg;
  FPDiv divFU(
	.aclr(clear_reg),
	.clock(clk),
	.dataa(A),
	.datab(B),
	.division_by_zero(exception_wire),
	.result(divResult));
	
	
	
	FPFtoI ftoi(
	.clock(clk),
	.dataa(A),
	.result(ftoiResult));
  
  FPItoF itof(
	.clock(clk),
	.dataa(C),
	.result(itofResult));
	
	
	/*always @(posedge clk) begin
	 if(exception_wire == 1'b1)  begin
	   clear_reg = 1; 
	 end else begin
	   clear_reg = 0;
	 end
	end*/
	
 
	assign stall = stall_wire;
	//do we need reset for multi cycle ops?
  always@(*) begin
    if (sel == 1'b1) begin
      case(op)
        3'b000: //itof
        begin
          latency = 6;
          Z = itofResult;
        end
        3'b001: //ftoi
        begin
          latency = 6;
          Z = ftoiResult;
        end
        3'b010: //fneg
        begin
          Z[30:0] = A[30:0];
          Z[31] = ~A[31];  
          latency = 0;  
        end
        3'b011: //fadd     
        begin
          addSub = 1;
          latency = 7-1;
          Z = addSubResult;  
        end
        3'b100: //fsub
        begin
          addSub = 0;
          latency = 7-1;
          Z = addSubResult;
        end
        3'b101: //fmul
        begin
          latency = 5-1;
          Z = mulResult;
        end
        3'b110: //fdiv          
        begin
          latency = 6;
          Z = divResult;
        end
        default:
          begin
            latency = 0;
            Z = 'bx;
          end
      endcase
    end else begin
      latency = 0;
      Z = 'bx;
    end
    
  end

endmodule



module execution(EX, clk, rst, Px, Py, Rx, Ry, Fx, Fy, imm_s, pc_n, WB_in, p1_mux, p2_mux, r1_mux, r2_mux, wdata_mux, f1_mux, f2_mux, pval_mm, rval_mm, rval_wb, fval_mm, result_P, result_I, result_F, Wdata, BUSY, WB_out,exception);
  input [6:0] EX;
  input clk,rst;
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
  input [1:0] wdata_mux;
  input pval_mm;
  input [3:0] WB_in;
  input [31:0] rval_mm;
  input [31:0] rval_wb;
  input [31:0] fval_mm;
  output result_P;
  output [31:0] result_I;
  output [31:0] result_F;
  output reg [31:0] Wdata;
  output BUSY;
  output reg [3:0] WB_out;
  output exception;
  
  reg PPU_src1;
  reg PPU_src2;
  reg [31:0] ALU_src1;
  reg [31:0] ALU_src2;
  reg [31:0] FPU_src1;
  reg [31:0] FPU_src2;
  wire BUSY_I,BUSY_F;
  
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
      default: ALU_src2 = 'bx;
    endcase
  end
  
  always @(*) begin
    case (f1_mux)
      1'b0: FPU_src1 = Fy;
      1'b1: FPU_src1 = fval_mm;
      default: FPU_src1 = 'bx;
    endcase
  end
  
  always @(*) begin
    case (f2_mux)
      1'b0: FPU_src2 = Fx;
      1'b1: FPU_src2 = fval_mm;
      default: FPU_src2 = 'bx;
    endcase
  end

  always @(*) begin
    case (wdata_mux)
      2'b00: Wdata = Rx;
      2'b01: Wdata = rval_mm;
      2'b10: Wdata = rval_wb;
      2'b11: Wdata = imm_s;
      default: Wdata = 'bx;
    endcase
  end
  
  reg [3:0] WB_buf;
  always @(*) begin
      WB_buf <= WB_in;
  end
  
  always @(*) begin
    if(BUSY == 1'b1) begin
      WB_out = 3'b000;
    end else begin
      WB_out = WB_in; 
    end
  end
  
  wire exception_wire;
  wire [31:0] result_I_buf,result_F_buf;
  alu_P P1(.sel(!EX[0] & (!EX[4])), .op(EX[3:1]), .A(PPU_src1), .B(PPU_src2), .C(ALU_src1), .Z(result_P));
  alu_I I1(.sel(EX[0]), .op(EX[4:1]),.clk(clk), .A(ALU_src1), .B(ALU_src2), .Z(result_I_buf),.stall(BUSY_I));
  alu_F F1(.sel(!EX[0] & EX[4]),.clk(clk), .op(EX[3:1]), .A(FPU_src1), .B(FPU_src2),.C(Ry), .Z(result_F_buf),.stall(BUSY_F),.exception(exception_wire));

  assign BUSY = ((BUSY_I & EX[0]) | (BUSY_F & !EX[0] & EX[4])) ;
  assign exception = exception_wire & (EX[3:1] == 3'b110);
  assign result_I = (EX[4:1] == 4'b1001) ? result_F_buf : result_I_buf;
  assign result_F = result_F_buf;
endmodule
