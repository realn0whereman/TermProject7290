module inst_mem(pc, inst);
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


module fetch(clk, pc_jmp, isjmp, pc_n, inst);
  input clk;
  input [31:0] pc_jmp;
  input isjmp;
  output [31:0] pc_n;
  output [31:0] inst;
  
  wire [31:0] pc;
  reg [31:0] pc_r;
  
  initial begin
    pc_r = 0;
  end
  
  assign pc_n = pc_r + 1;
  assign pc = (isjmp == 0) ? pc_r + 1 : pc_jmp;
  
  always @(posedge clk) begin 
        pc_r <= pc;
  end
  
  inst_mem i_mem(.pc(pc_r[9:0]), .inst(inst));
endmodule