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
  wire [3:0] Z_id, Z_ex, Z_mm, Z_mm_buf, Z_wb;
  wire [1:0] MEM_id, MEM_ex, MEM_mm;
  wire [3:0] WB_id, WB_ex, WB_mm, WB_mm_buf;
  wire ResP_ex, ResP_mm;
  wire [31:0] ResI_ex, ResI_mm, ResI_mm_buf, ResI_wb, ResI_final;
  wire [31:0] ResF_ex, ResF_mm;
  wire [31:0] Wdata_ex, Wdata_mm;
  wire [31:0] Rdata_mm, Rdata_wb;
  wire [1:0] WB_wb;
  wire pval_id;
  wire [3:0] Y_id, Y_ex;
  wire [3:0] X_id, X_ex;
  wire p1_mux;
  wire p2_mux;
  wire f1_mux;
  wire f2_mux;
  wire [1:0] r1_mux;
  wire [1:0] r2_mux;
  wire [31:0] jmpi_id;
  wire [1:0] jmp_type;
  wire [1:0] JMP_id;
  wire [1:0] OPC_id;
  wire busy_ex, busy_mm;
  
  reg [2:0] ctrl;
  
  wire [1:0] ctrl_ifid;
  wire [1:0] ctrl_idex;
  wire [1:0] ctrl_exmm;
  wire [1:0] ctrl_mmwb;
  
  defparam preg_ifid.N = 64;
  defparam preg_idex.N = 219;
  defparam preg_exmm.N = 107;
  defparam preg_mmwb.N = 70;

  
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      ctrl <= 3'b0;
    end
  end
  
  //Pipeline control signal generation
  pipeline_ctrl pc(.rst(rst), .clk(clk), .pval(pval_id), .ex_busy(busy_ex), .mm_busy(busy_mm), .jmp(JMP_id), .intp(ctrl), .is_load(MEM_ex[0]), 
    .opc_type(OPC_id), .Rx_id(X_id), .Ry_id(Y_id), .Z_ex(Z_ex), .ifid_ctr(ctrl_ifid), .idex_ctr(ctrl_idex), .exmm_ctr(ctrl_exmm), .mmwb_ctr(ctrl_mmwb),
    .jmp_type(jmp_type));
  
  //Pipeline forward signal generation
  forward fwd(.clk(clk), .EX_ex(EX_ex), .RW_mm(WB_mm[3:1]), .RW_wb(WB_wb[1]), .Z_mm(Z_mm), .Z_wb(Z_wb), .Y_ex(Y_ex), .X_ex(X_ex), 
    .p1_mux(p1_mux), .p2_mux(p2_mux), .r1_mux(r1_mux), .r2_mux(r2_mux), .f1_mux(f1_mux), .f2_mux(f2_mux));
  
  //Fetch Stage + FE/ID Latch:
  FE_Stage fe_stage(.clk(clk), .rst(rst), .ctr(ctrl_ifid), .jmp_type(jmp_type), .jmp_r(Rx_id), .jmp_i(jmpi_id), .n_pc(pc_n_if), .isn(inst_if));
  LatchN preg_ifid(.rst(rst), .clk(clk), .ctr(ctrl_ifid), .data_in({pc_n_if, inst_if}), .data_out({pc_n_id, inst_id}));
  
  //Decode Stage + ID/EX Latch:
  decode dec(.rst(rst), .clk(clk), .pc_n(pc_n_id), .inst(inst_id), .Pz_id(Z_mm[1:0]), .Pz(ResP_mm), .Rz_id(Z_wb), .Rz(ResI_final),
    .Fz_id(Z_mm), .Fz(ResF_mm), .imm_s(imm_id), .rw({WB_mm[3], WB_wb[1], WB_mm[1]}), .Px(Px_id), .Py(Py_id), .Rx(Rx_id), .Ry(Ry_id),
    .Fx(Fx_id), .Fy(Fy_id), .Z(Z_id), .EX(EX_id), .MEM(MEM_id), .WB(WB_id), .JMP(JMP_id), .OPC(OPC_id), .Pval(pval_id), .Y_id(Y_id), .X_id(X_id), .jmp_i(jmpi_id));
  LatchN preg_idex(.rst(rst), .clk(clk), .ctr(ctrl_idex), .data_in({pc_n_id, imm_id, Z_id, Y_id, X_id, Fy_id, Fx_id, Ry_id, Rx_id, Py_id, Px_id, 
    EX_id, MEM_id, WB_id}), .data_out({pc_n_ex, imm_ex, Z_ex, Y_ex, X_ex, Fy_ex, Fx_ex, Ry_ex, Rx_ex, Py_ex, Px_ex, EX_ex, MEM_ex, WB_ex}));
  
  //Execute Stage + EX/MEM Latch:
   execution exe(.EX(EX_ex), .clk(clk), .Px(Px_ex), .Py(Py_ex), .Rx(Rx_ex), .Ry(Ry_ex), .Fx(Fx_ex), .Fy(Fy_ex), .imm_s(imm_ex), .pc_n(pc_n_ex), 
    .result_P(ResP_ex), .result_I(ResI_ex), .result_F(ResF_ex), .Wdata(Wdata_ex), .p1_mux(p1_mux), .p2_mux(p2_mux), .r1_mux(r1_mux), .r2_mux(r2_mux),
    .f1_mux(f1_mux), .f2_mux(f2_mux), .pval_mm(ResP_mm), .rval_mm(ResI_mm), .rval_wb(ResI_final), .fval_mm(ResF_mm), .BUSY(busy_ex));
    
  LatchN preg_exmm(.rst(rst), .clk(clk), .ctr(ctrl_exmm), .data_in({Z_ex, ResI_ex, ResF_ex, ResP_ex, Wdata_ex, MEM_ex, WB_ex}), 
    .data_out({Z_mm, ResI_mm, ResF_mm, ResP_mm, Wdata_mm, MEM_mm, WB_mm}));
  
  //Memory Stage + MEM/WB Latch:  
  MEM_Stage mem(.clk(clk), .rst(rst), .Z_in(Z_ex), .Z_in_buf(Z_mm), .alu_in(ResI_ex), .alu_in_buf(ResI_mm), .wdata_in(Wdata_ex), .cntrl_m_in(MEM_ex), .cntrl_w_in(WB_ex),
  .cntrl_w_in_buf(WB_mm), .alu_out(ResI_mm_buf), .mem_out(Rdata_mm), .Z_out(Z_mm_buf), .cntrl_w_out(WB_mm_buf), .stall_out(busy_mm));
//  data_cache mem(.clk(clk), .MEM(MEM_mm), .Wdata(Wdata_mm), .Addr(ResI_mm), .Rdata(Rdata_mm), .BUSY(busy_mm));

  LatchN preg_mmwb(.rst(rst), .clk(clk), .ctr(ctrl_mmwb), .data_in({Z_mm_buf, ResI_mm_buf, Rdata_mm, WB_mm_buf[2], WB_mm_buf[0]}), 
    .data_out({Z_wb, ResI_wb, Rdata_wb, WB_wb}));

  writeback  wrb(.WB(WB_wb[0]), .mem_data(Rdata_wb), .reg_data(ResI_wb), .result(ResI_final));  
  
  
endmodule