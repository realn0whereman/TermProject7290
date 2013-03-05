module reg_file(clk, rw, id1, id2, id3, W1, R1, R2);
  input clk;
  input rw; //0, read; 1, write
  input [2:0] id1;
  input [2:0] id2;
  input [2:0] id3;
  input [31:0] W1;
  output [31:0] R1;
  output [31:0] R2;
  
  reg [31:0] registers [7:0];
  
  initial begin
    registers[0] = 0;
    registers[1] = 1;
    registers[2] = 2;
    registers[3] = 3;
    registers[4] = 4;
    registers[5] = 5;
    registers[6] = 6;
    registers[7] = 9;
  end
  
  always @(*) begin
  //always @ (posedge clk) begin
   if (rw == 1) 
     begin
       registers[id3] <= W1;
     end
   else
     begin
       registers[id3] <= registers[id3];
     end
  end
  
  assign R1 = registers[id1];
  assign R2 = registers[id2];
endmodule

module decode(clk, inst, rw, dst, W1, R1, R2, imm_s, EX, MEM, WB);
  input clk;
  input [31:0] inst;
  input rw;
  input [2:0] dst;
  input [31:0] W1;
  output [31:0] R1;
  output [31:0] R2;
  output [31:0] imm_s;
  output [3:0] EX;
  output [2:0] MEM;
  output [1:0] WB;
  
  wire [2:0] id1;
  wire [2:0] id2;
  //wire [2:0] id3;
  wire [10:0] signals;
  
  assign id1 = inst[18:16];
  assign id2 = (signals[10] == 0) ? inst[15:13] : inst[21:19];
  //assign id3 = inst[21:19];
  
  assign imm_s = (signals[9] == 0) ? {{16{inst[15]}}, inst[15:0]} : {{10{inst[21]}}, inst[21:0]};
  
  assign EX = signals[8:5];
  assign MEM = signals[4:2];
  assign WB = signals[1:0];
  
  reg_file regs(.clk(clk), .rw(rw), .id1(id1), .id2(id2), .id3(dst), .W1(W1), .R1(R1), .R2(R2));
  alu_control ac(.opcode(inst[27:22]), .alu_control_signals(signals));
endmodule
