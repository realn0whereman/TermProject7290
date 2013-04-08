module FE_Stage(clk, rst, ctr, jmp_type, jmp_r, jmp_i, n_pc, isn, pc_cur);
  input clk,rst;
  input [1:0] ctr; // if this is 10 then stall.
  input [1:0] jmp_type; // 00: normal, 01: jump reg, 10: jump imm, 11: int
  input [31:0] jmp_r;
  input [31:0] jmp_i;  
  output [31:0] n_pc;
  output [31:0] isn;
  output [31:0] pc_cur;
  
  reg[31:0] pc_r;
  reg[31:0] pc;
  
  //subtract 4 because of the always statement that increments it. 
  //This approach looks hacky, but it works.
  ICache4KB iCache(clk,rst,pc_r,isn);
  
  always @(posedge clk) begin
    if(rst == 1) begin
      pc_r <= 0;
    end else if(ctr !=  2'b10) begin
      pc_r <= pc;
    end else begin
      pc_r <= pc_r;
    end
  end
  
  always @(*) begin
    case (jmp_type)
      2'b00: pc = pc_r + 4;
      2'b01: pc = jmp_r;
      2'b10: pc = jmp_i;
      2'b11: pc = 32'h10; //faked interrupt entry
    endcase
  end
  
  assign n_pc = pc_r + 4;
  assign pc_cur = pc_r;
endmodule

