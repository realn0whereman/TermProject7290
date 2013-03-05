module pipeline(clk);
  input clk;
  
  wire [31:0] inst;
  wire [31:0] pc_n;
  
  wire [31:0] R1;
  wire [31:0] R2;
  wire [31:0] imm_s;
  wire [3:0] EX;
  wire [2:0] MEM;
  wire [1:0] WB;
  
  wire [31:0] result;
  wire [31:0] wdata;
  wire [31:0] pc_jmp;
  
  wire [31:0] rdata;
  
  wire [31:0] dst_data;
  
  reg [63:0] p_reg_ifid;
  reg [139:0] p_reg_idex;
  reg [103:0] p_reg_exmm;
  reg [68:0] p_reg_mmwb;
  
  initial begin
    p_reg_ifid = {32'b0, 32'b0};
    p_reg_idex = {32'b0, 32'b0, 32'b0, 3'b0, 32'b0, 4'b0, 3'b0, 2'b0};
    p_reg_exmm = {32'b0, 32'b0, 32'b0, 3'b0, 5'b0};
    p_reg_mmwb = {32'b0, 3'b0, 32'b0, 2'b0};
  end
  
  always @ (posedge clk) begin
    p_reg_ifid <= {pc_n, inst};
    p_reg_idex <= {p_reg_ifid[63:32], R1, R2, p_reg_ifid[21:19], imm_s, EX, MEM, WB};
    p_reg_exmm <= {pc_jmp, wdata, result, p_reg_idex[43:41], p_reg_idex[4:0]};
    p_reg_mmwb <= {p_reg_exmm[39:8], p_reg_exmm[7:5], rdata, p_reg_exmm[1:0]};
  end  
  
  //fetch fet(.clk(clk), .pc_jmp(p_reg_exmm[103:72]), .isjmp(p_reg_exmm[2]), .pc_n(pc_n), .inst(inst));
  fetch fet(.clk(clk), .pc_jmp(pc_jmp), .isjmp(p_reg_idex[2]), .pc_n(pc_n), .inst(inst));
  decode dec(.clk(clk), .inst(p_reg_ifid[31:0]), .dst(p_reg_mmwb[36:34]), .rw(p_reg_mmwb[1]), .W1(dst_data), .R1(R1), .R2(R2), .imm_s(imm_s), .EX(EX), .MEM(MEM), .WB(WB));
  exec exe(.EX(p_reg_idex[8:5]), .R1(p_reg_idex[107:76]), .R2(p_reg_idex[75:44]), .imm_s(p_reg_idex[40:9]), .pc_n(p_reg_idex[139:108]), .result(result), .pc_jmp(pc_jmp), .wdata(wdata));
  data_mem dmm(.clk(clk), .MEM(p_reg_exmm[4:3]), .Wdata(p_reg_exmm[71:40]), .Addr(p_reg_exmm[39:8]), .Rdata(rdata));  
  write_back wrb(.WB(p_reg_mmwb[0]), .mem_data(p_reg_mmwb[33:2]), .reg_data(p_reg_mmwb[68:37]), .dst_data(dst_data));
endmodule