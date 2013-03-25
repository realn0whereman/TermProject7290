module pipeline(clk, rst);
  input clk;
  input rst;
  
  wire [31:0] pc_n_if, pc_n_id, pc_n_ex;
  wire [31:0] inst_if, inst_id;
  wire [31:0] imm_id, imm_ex;
  wire Px_id, Px_ex; 
  wire Py_id, Py_ex;
  wire [31:0] Rx_id, Rx_ex;
  wire [31:0] Ry_id, Ry_ex;
  wire [31:0] Fx_id, Fx_ex;
  wire [31:0] Fy_id, Fy_ex;
  wire [6:0] EX_id, EX_ex;
  wire [3:0] Z_id, Z_ex, Z_mm, Z_wb;
  wire [1:0] MEM_id, MEM_ex, MEM_mm;
  wire [3:0] WB_id, WB_ex, WB_mm;
  wire ResP_ex, ResP_mm;
  wire [31:0] ResI_ex, ResI_mm, ResI_wb, ResI_final;
  wire [31:0] ResF_ex, ResF_mm;
  wire [31:0] Wdata_ex, Wdata_mm;
  wire [31:0] Rdata_mm, Rdata_wb;
  wire [1:0] WB_wb;
  
  reg [1:0] ctrl_ifid;
  reg [1:0] ctrl_idex;
  reg [1:0] ctrl_exmm;
  reg [1:0] ctrl_mmwb;
  
  defparam preg_ifid.N = 64;
  defparam preg_idex.N = 211;
  defparam preg_exmm.N = 107;
  defparam preg_mmwb.N = 70;
  
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      ctrl_ifid = 0;
      ctrl_idex = 0;
      ctrl_exmm = 0;
      ctrl_mmwb = 0;
    end
  end
  
  //ifid:
  latch preg_ifid(.rst(rst), .clk(clk), .ctr(ctrl_ifid), .data_in({pc_n_if, inst_if}), .data_out({pc_n_id, inst_id}));
  //idex: 
  latch preg_idex(.rst(rst), .clk(clk), .ctr(ctrl_idex), .data_in({pc_n_id, imm_id, Z_id, Fy_id, Fx_id, Ry_id, Rx_id, Py_id, Px_id, 
    EX_id, MEM_id, WB_id}), .data_out({pc_n_ex, imm_ex, Z_ex, Fy_ex, Fx_ex, Ry_ex, Rx_ex, Py_ex, Px_ex, EX_ex, MEM_ex, WB_ex}));
  //exmm:
  latch preg_exmm(.rst(rst), .clk(clk), .ctr(ctrl_exmm), .data_in({Z_ex, ResI_ex, ResF_ex, ResP_ex, Wdata_ex, MEM_ex, WB_ex}), 
    .data_out({Z_mm, ResI_mm, ResF_mm, ResP_mm, Wdata_mm, MEM_mm, WB_mm}));
  //mmwb:
  latch preg_mmwb(.rst(rst), .clk(clk), .ctr(ctrl_mmwb), .data_in({Z_mm, ResI_mm, Rdata_mm, WB_mm[2], WB_mm[0]}), 
    .data_out({Z_wb, ResI_wb, Rdata_wb, WB_wb}));
  
  inst_cache fet(.rst(rst), .clk(clk), .pc_n(pc_n_if), .inst(inst_if));
  
  decode dec(.rst(rst), .clk(clk), .pc_n(pc_n_id), .inst(inst_id), .Pz_id(Z_mm[1:0]), .Pz(ResP_mm), .Rz_id(Z_wb), .Rz(ResI_final),
    .Fz_id(Z_mm), .Fz(ResF_mm), .imm_s(imm_id), .rw({WB_mm[3], WB_wb[1], WB_mm[1]}), .Px(Px_id), .Py(Py_id), .Rx(Rx_id), .Ry(Ry_id),
    .Fx(Fx_id), .Fy(Fy_id), .Z(Z_id), .EX(EX_id), .MEM(MEM_id), .WB(WB_id));
    
  execution exe(.EX(EX_ex), .Px(Px_ex), .Py(Py_ex), .Rx(Rx_ex), .Ry(Ry_ex), .Fx(Fx_ex), .Fy(Fy_ex), .imm_s(imm_ex), .pc_n(pc_n_ex), 
    .result_P(ResP_ex), .result_I(ResI_ex), .result_F(ResF_ex), .Wdata(Wdata_ex));
    
  data_cache mem(.clk(clk), .MEM(MEM_mm), .Wdata(Wdata_mm), .Addr(ResI_mm), .Rdata(Rdata_mm));
  
  writeback  wrb(.WB(WB_wb[0]), .mem_data(Rdata_wb), .reg_data(ResI_wb), .result(ResI_final));  
  
endmodule