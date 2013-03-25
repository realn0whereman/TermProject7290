module alu_control(opcode, alu_control_signals);
  input [5:0] opcode; 
  output reg [17:0] alu_control_signals; 
  //     0 : Reg ID sel
  //   2:1 : sign extension
  //   4:3 : jump signal (reserved); 3: is jump, 4: direct or indirect
  //  11:5 : EX; 5: PF or I, 6:9: AluOP, 10: Src2 sel, 11: link?
  // 13:12 : MEM; 12: MemR, 13: MemW
  // 17:14 : WB; 14: RegMem, 15: rw_P, 16: rw_R, 17: rw_F 
  
  always @(*) begin
    case(opcode)
      //5.3 Memory Loads/Stores
      6'h23: //ld
        begin
          alu_control_signals[17:14] = 4'b010_1;         
          alu_control_signals[13:12] = 2'b0_1;
          alu_control_signals[11:5] = 7'b0_1_0001_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h24: //st
        begin
          alu_control_signals[17:14] = 4'b000_x;         
          alu_control_signals[13:12] = 2'b1_0;
          alu_control_signals[11:5] = 7'b0_1_0001_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'b1;
        end
      //5.4 Predicate Manipulation        
      6'h27: //andp
        begin
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_x_0001_0;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h28: //orp
        begin
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_x_0010_0;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h29: //xorp
        begin
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_x_0011_0;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h2a: //not
        begin
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_x_0100_0;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      //5.5 Value Test        
      6'h26: //rtop
        begin
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_x_0101_0;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h2b: //isneg
        begin
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_x_0110_0;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h2c: //iszero
        begin
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_x_0111_0;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      //5.6 Immediate Integer Arithmetic/Logic        
      6'h25: //ldi
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_1_1101_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b11;
          alu_control_signals[0] = 1'bx;
        end
      6'h14: //add
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0001_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h15: //subi
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0010_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h16: //muli
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0011_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h17: //divi
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0100_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end        
      6'h18: //modi
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0101_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h19: //shli
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0110_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h1a: //shri
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0111_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h11: //andi
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_1000_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h12: //ori
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_1001_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h13: //xori
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_1010_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      //5.7 Register Integer Arithmetic/Logic        
      6'h0a: //add
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0001_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h0b: //sub
        begin
          alu_control_signals[17:14] = 4'b010_0;        
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0010_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h0c: //mul
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0011_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h0d: //div
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0100_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end        
      6'h0e: //mod
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0101_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h0f: //shl
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0110_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h10: //shr
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0111_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h07: //and
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_1000_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h08: //or
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_1001_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h09: //xor
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_1010_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h05: //neg
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_x_1011_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'bx;
        end
      6'h06: //not
        begin
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_x_1100_1;
          alu_control_signals[4:3] = 2'bx_x;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'bx;
        end   
      //5.2 Privileged Instruction
      //5.8 Floating Point Arhithmethic
      //5.9 Control Flow
      //5.11 User/Kernel Interaction  
        
      default: //nop
        begin
          alu_control_signals[17:14] = 2'b0;         
          alu_control_signals[13:12] = 2'b0;
          alu_control_signals[11:5] = 4'b0;
          alu_control_signals[4:3] = 2'b0;
          alu_control_signals[2:1] = 2'b0;
          alu_control_signals[0] = 1'b0;        
        end
    endcase
  end
endmodule

module preg_file(rst, rw, X, Y, Z, Pset, Pid, Pz, Px, Py, Pval);
  input rst;
  input rw; //0, read; 1, write
  input [1:0] X;
  input [1:0] Y;
  input [1:0] Z;
  input [1:0] Pid;
  input Pz;
  input Pset;
  output Px;
  output Py;
  output Pval;
  
  reg pregs [3:0];
  integer i;
  
  always @ (*) begin
    if (rst) begin
      //for(i=0; i<4; i=i+1) begin
        //pregs[i] <= 0;
      //end
      pregs[0] <= 1;
      pregs[1] <= 1;
      pregs[2] <= 0;
      pregs[3] <= 0;
    end else begin 
      if(rw == 1)
        pregs[Z] <= Pz;
    end
  end
  
  assign Px = pregs[X];
  assign Py = pregs[Y];
  assign Pval = (Pset == 1) ? pregs[Pid] : 1'b1;
endmodule

module greg_file(rst, rw, X, Y, Z, Rz, Rx, Ry);
  input rst;
  input rw; //0, read; 1, write
  input [3:0] X;
  input [3:0] Y;
  input [3:0] Z;
  input [31:0] Rz;
  output [31:0] Rx;
  output [31:0] Ry;
  
  reg [31:0] gregs [15:0];
  integer i;
  
  always @ (*) begin
    if (rst) begin
      for(i=0; i<16; i=i+1) begin
        gregs[i] <= 0;
      end
    end else begin 
      if(rw == 1)
        gregs[Z] <= Rz;
    end
  end
  
  assign Rx = gregs[X];
  assign Ry = gregs[Y];
endmodule

module freg_file(rst, rw, X, Y, Z, Fz, Fx, Fy);
  input rst;
  input rw; //0, read; 1, write
  input [3:0] X;
  input [3:0] Y;
  input [3:0] Z;
  input [31:0] Fz;
  output [31:0] Fx;
  output [31:0] Fy;
  
  reg [31:0] fregs [15:0];
  integer i;
  
  always @ (*) begin
    if (rst) begin
      for(i=0; i<16; i=i+1) begin
        fregs[i] <= 0;
      end
    end else begin 
      if(rw == 1)
        fregs[Z] <= Fz;
    end
  end
  
  assign Fx = fregs[X];
  assign Fy = fregs[Y];
endmodule

module imm_extend(ctr, field, imm_s);
  input [1:0] ctr;
  input [22:0] field;
  output reg [31:0] imm_s;
  
  always @(*) begin
    case (ctr)
      2'b01: imm_s = {{17{field[14]}}, field[14:0]};
      2'b10: imm_s = {{9{field[22]}}, field[22:0]};
      2'b11: imm_s = {{13{field[18]}}, field[18:0]};
      default: imm_s = 32'b0;
    endcase
  end
endmodule

module decode(clk, rst, pc_n, inst, Pz_id, Pz, Rz_id, Rz, Fz_id, Fz, imm_s, rw, Px, Py, Rx, Ry, Fx, Fy, Z, EX, MEM, WB); //jump target is computed here
  input clk;
  input rst;
  input [31:0] pc_n;
  input [31:0] inst;
  input [2:0] rw; //0:preg, 1:greg, 2:freg
  input Pz;
  input [1:0] Pz_id;
  input [31:0] Rz;
  input [3:0] Rz_id;
  input [31:0] Fz;
  input [3:0] Fz_id;
 
  output Px;
  output Py;
  output [31:0] Rx;
  output [31:0] Ry; 
  output [31:0] Fx;
  output [31:0] Fy;
  output [3:0] Z;
  output [31:0] imm_s;
  output [6:0] EX;
  output [1:0] MEM;
  output [3:0] WB;
  
  wire [3:0] X;
  wire [3:0] Y;
  wire [1:0] Pid;
  wire [17:0] signals;
  wire Pset;
  wire Pval;
  
  assign X = (signals[0] == 0) ? inst[14:11] : inst[22:19];
  assign Y = inst[18:15];
  assign Z = inst[22:19];
  assign Pset = inst[31];
  assign Pid = inst[30:29];
  
  preg_file pregs(.rst(rst), .rw(rw[0]), .X(X[1:0]), .Y(Y[1:0]), .Z(Pz_id), .Pset(Pset), .Pid(Pid), .Pz(Pz), .Px(Px), .Py(Py), .Pval(Pval));
  greg_file gregs(.rst(rst), .rw(rw[1]), .X(X), .Y(Y), .Z(Rz_id), .Rz(Rz), .Rx(Rx), .Ry(Ry));
  //freg_file fregs(.rst(rst), .rw(rw[2]), .X(X), .Y(Y), .Z(Z), .Fz(Fz), .Fx(Fy), .Fy(Fy));
  
  imm_extend immse(.ctr(signals[2:1]), .field(inst[22:0]), .imm_s(imm_s));
  
  alu_control ac(.opcode(inst[28:23]), .alu_control_signals(signals));

  assign EX = (Pval == 1) ? signals[11:5] : 0;
  assign MEM = (Pval == 1) ? signals[13:12] : 0;
  assign WB = (Pval == 1) ? signals[17:14] : 0;
  
endmodule
