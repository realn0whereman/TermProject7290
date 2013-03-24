module pipeline(clk, rst);
  input clk;
  input rst;
  
  wire [31:0] pc_n_if, pc_n_id;
  wire [31:0] inst_if, inst_id;
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
  
  //Additions by Phil
  wire [31:0] imm_id,imm_ex;
  wire [31:0] pc_n_ex;
  
  
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
  //TODO implement stalls
  reg stall;
  initial begin
    stall = 0;
  end
  
  
  //Fetch Stage + FE/ID Latch:
  FE_Stage fe_stage(.clk(clk),.rst(rst),.stall(stall),.n_pc(pc_n_if),.isn(inst_if));
  latch preg_ifid(.rst(rst), .clk(clk), .stall(stall), .data_in({pc_n_if, inst_if}), .data_out({pc_n_id, inst_id}));
  
  //Decode Stage + ID/EX Latch:
  decode dec(.rst(rst), .clk(clk), .pc_n(pc_n_id), .inst(inst_id), .Pz_id(Z_mm[1:0]), .Pz(ResP_mm), .Rz_id(Z_rb), .Rz(ResI_final),
    .Fz_id(Z_mm), .Fz(ResF_mm), .imm_s(imm_id), .rw({WB_mm[3], WB_wb[1], WB_mm[1]}), .Px(Px_id), .Py(Py_id), .Rx(Rx_id), .Ry(Ry_id),
    .Fx(Fx_id), .Fy(Fy_id), .Z(Z_id), .EX(EX_id), .MEM(MEM_id), .WB(WB_id)); 
  latch preg_idex(.rst(rst), .clk(clk), .stall(stall), .data_in({pc_n_id, imm_id, Z_id, Fy_id, Fx_id, Ry_id, Rx_id, Py_id, Px_id, 
    EX_id, MEM_id, WB_id}), .data_out({pc_n_ex, imm_ex, Z_ex, Fy_ex, Fx_ex, Ry_ex, Rx_ex, Py_ex, Px_ex, EX_ex, MEM_ex, WB_ex}));
  
  
  //Execute Stage + EX/MEM Latch:
   execution exe(.EX(EX_ex), .Px(Px_ex), .Py(Py_ex), .Rx(Rx_ex), .Ry(Ry_ex), .Fx(Fx_ex), .Fy(Fy_ex), .imm_s(imm_ex), .pc_n(pc_n_ex), 
    .result_P(ResP_ex), .result_I(ResI_ex), .result_F(ResF_ex), .Wdata(Wdata_ex));
  latch preg_exmm(.rst(rst), .clk(clk), .stall(stall), .data_in({Z_ex, ResI_ex, ResF_ex, ResP_ex, Wdata_ex, MEM_ex, WB_ex}), 
    .data_out({Z_mm, ResI_mm, ResF_mm, ResP_mm, Wdata_mm, MEM_mm, WB_mm}));
  
  
  //Memory Stage + MEM/WB Latch:
  //Note: ready_out,empty_out,stall_out signals not in use yet
  wire ready_out_M,stall_out_M,empty_out_M;
  MEM_Stage mem(.clk(clk),.rst(rst),.stall(stall),.Z_in(Z_mm),.alu_in(ResI_mm),.alu_p_in(ResP_mm),.alu_f_in(ResF_mm),
  .wdata_in(Wdata_mm),.cntrl_m_in(MEM_mm),.cntrl_w_in(WB_mm),.alu_out(ResI_mm),.mem_out(Rdata_mm),.Z_out(Z_mm),
  .cntrl_w_out(WB_mm),.ready_out(ready_out_M),.empty_out(empty_out_M),.stall_out(stall_out_M));
  latch preg_mmwb(.rst(rst), .clk(clk), .stall(stall), .data_in({Z_mm, ResI_mm, Rdata_mm, WB_mm[2], WB_mm[0]}), 
    .data_out({Z_wb, ResI_wb, Rdata_wb, WB_wb}));
  
  writeback  wrb(.WB(WB_wb[0]), .mem_data(Rdata_wb), .reg_data(ResI_wb), .result(ResI_final));  
  
  
endmodule