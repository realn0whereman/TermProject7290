module alu(op, A, B, Z);
  input [1:0] op;
  input [31:0] A;
  input [31:0] B;
  output reg [31:0] Z;
  
  always @(*) begin
    case (op)
      2'b01:
        begin
          Z <= A + B;      
        end
      2'b10:
        begin
          Z <= A - B;
        end
      default:
        begin
          Z <= 'bx;
        end
    endcase
  end
endmodule

module alu_jmp(op, pc_n, j_i, j_r, pc_jmp);
  input op;
  input [31:0] pc_n;
  input [31:0] j_i;
  input [31:0] j_r;
  output reg [31:0] pc_jmp;
  
  always @(*) begin
    case (op)
      1'b0: //JMPI
        begin
          //pc_jmp <= pc_n + {j_i[29:0], 2'b00}; //pc + imm << 2
          //pc_jmp <= pc_n + {{2{j_i[31]}}, j_i[31:2]}; //pc + imm >> 2
          pc_jmp <= pc_n + j_i;
        end
      1'b1: //JUMP
        begin
          pc_jmp <= j_r;
        end
      default:
        begin
          pc_jmp <= 'bx;
        end
    endcase
  end
endmodule

module exec(EX, R1, R2, imm_s, pc_n, result, pc_jmp, wdata);
  input [3:0] EX;
  input [31:0] R1;
  input [31:0] R2;
  input [31:0] pc_n;
  input [31:0] imm_s;
  output [31:0] result;
  output [31:0] pc_jmp;
  output [31:0] wdata;

  wire [31:0] ALU_src1;
  wire [31:0] ALU_src2;
  
  assign ALU_src1 = R1;
  assign ALU_src2 = (EX[0] == 0) ? R2 : imm_s;
  assign wdata = R2;
  
  alu a1(.op(EX[3:2]), .A(ALU_src1), .B(ALU_src2), .Z(result));
  alu_jmp a2(.op(EX[1]), .pc_n(pc_n), .j_i(imm_s), .j_r(R2), .pc_jmp(pc_jmp));
endmodule


  
  



