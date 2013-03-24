/*module inst_mem(pc, inst);
  input [9:0] pc;
  output reg [31:0] inst;
  
  reg [31:0] i_mem [1023:0];
  
  initial begin
    i_mem[0] = 32'h05110003;
    //i_mem[0] = 32'h09380000;
    i_mem[1] = 32'h055d0001;
    //i_mem[1] = 32'h08f00001;
    //i_mem[2] = 32'h00000000;
    //i_mem[2] = 32'h07400006;
    i_mem[2] = 32'h07b80000;
    i_mem[3] = 32'h00000000;
    i_mem[4] = 32'h00000000;
    i_mem[5] = 32'h00000000;
    i_mem[6] = 32'h00000000;
    i_mem[7] = 32'h00000000;
    i_mem[8] = 32'h02a26000;
    i_mem[9] = 32'h02eb4000;
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
*/

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
