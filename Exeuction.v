module alu_P(sel, op, A, B, C, Z);
  input sel;
  input [3:0] op;
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

module execution(EX, Px, Py, Rx, Ry, Fx, Fy, imm_s, pc_n, result_P, result_I, result_F, Wdata);
  input [6:0] EX;
  input Px;
  input Py;
  input [31:0] Rx;
  input [31:0] Ry;
  input [31:0] Fx;
  input [31:0] Fy;
  input [31:0] pc_n;
  input [31:0] imm_s;
  output result_P;
  output [31:0] result_I;
  output [31:0] result_F;
  output [31:0] Wdata;

  wire [31:0] ALU_src1;
  wire [31:0] ALU_src2;
  
  assign ALU_src1 = (EX[6] == 0) ? Ry : pc_n;
  assign ALU_src2 = (EX[5] == 0) ? Rx : imm_s;
  assign Wdata = Rx;
  
  alu_P P1(.sel(!EX[0] & (!EX[4])), .op(EX[3:1]), .A(Py), .B(Px), .C(Ry), .Z(result_P));
  alu_I I1(.sel(EX[0]), .op(EX[4:1]), .A(ALU_src1), .B(ALU_src2), .Z(result_I));
  
  //FIXME
  assign result_F = 'bx;
endmodule
