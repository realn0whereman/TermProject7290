module inst_mem(pc, inst);
  input [9:0] pc;
  output reg [31:0] inst;
  
  reg [31:0] i_mem [1023:0];
  
  initial begin
    i_mem[0] = 32'b0_00_100111_0010_0001_0000_00000000000; //andp p2, p1, p0
    //i_mem[0] = 32'h09380000;
    //i_mem[1] = 32'b0_00_101100_0011_0000_0000_00000000000; //iszero p3, r0
    i_mem[1] = 32'b1_11_101100_0011_0000_0000_00000000000; //iszero p3, r0
    i_mem[2] = 32'b0_00_100011_0001_0000_000000000000000; //ld r1, r0, 0
    i_mem[3] = 32'b0_00_100100_0010_0000_000000000000000; //st r2, r0, 0
    i_mem[4] = 32'b0_00_100101_0011_0000000000000000011; //ldi r3, 3
    i_mem[5] = 32'b0_00_000101_0100_0000_000000000000000; //neg r4, r0
    i_mem[6] = 32'b0_00_000110_0101_0000_000000000000000; //not r5, r0
    i_mem[7] = 32'b0_00_010100_0110_0000_000000000000110; //addi r6, r0, 6
    i_mem[8] = 32'b0;
    i_mem[9] = 32'b0;
    i_mem[10] = 32'b0;
    i_mem[11] = 32'b0;
    i_mem[12] = 32'b0;
    i_mem[13] = 32'b0_00_001010_0111_0110_0001_00000000000; //add r7, r6, r1
    i_mem[14] = 32'b0;
    i_mem[15] = 32'b0;
    i_mem[16] = 32'b0;
    i_mem[17] = 32'b0;
    i_mem[18] = 32'b0;
    i_mem[19] = 32'b0;
    //i_mem[20] = 32'b0_00_000101_0100_0111_000000000000000; //neg r4, r7
    //i_mem[20] = 32'b1_01_000101_0100_0111_000000000000000; //neg r4, r7
    i_mem[20] = 32'b1_11_000101_0100_0111_000000000000000; //neg r4, r7
  end
  
  always @(*) begin
    //inst <= {i_mem[pc+3], i_mem[pc+2], i_mem[pc+1], i_mem[pc]};
    inst <= i_mem[pc];
  end
endmodule

module inst_cache(rst, clk, pc_n, inst);
  input rst;
  input clk;
  output [31:0] pc_n;
  output [31:0] inst;
  
  wire [31:0] pc_cur;
  reg [31:0] pc_r;
  
  assign pc_n = pc_r + 1;
  assign pc_cur = pc_r + 1;
  
  always @(posedge clk) begin
    if (rst) begin
        pc_r <= 0;
    end else begin
        pc_r <= pc_cur;
    end
  end
  
  inst_mem i_mem(.pc(pc_r[9:0]), .inst(inst));
endmodule
/*
module inst_cache(rst, clk, is_jmp, pc_jmp, pc_n, inst);
  input rst;
  input clk;
  input is_jmp;
  input [31:0] pc_jmp;
  output [31:0] pc_n;
  output [31:0] inst;
  
  wire [31:0] pc_cur;
  reg [31:0] pc_r;
  
  assign pc_n = pc_r + 1;
  assign pc_cur = (is_jmp == 0) ? pc_r + 1 : pc_jmp;
  
  always @(posedge clk) begin
    if (rst) begin
        pc_r <= 0;
    end else begin
        pc_r <= pc_cur;
    end
  end
  
  inst_mem i_mem(.pc(pc_r[9:0]), .inst(inst));
endmodule
*/
