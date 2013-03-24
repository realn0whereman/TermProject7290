

module MEM_Stage(clk,rst,stall,Z_in,alu_in,alu_p_in,alu_f_in,wdata_in,cntrl_m_in,cntrl_w_in,alu_out,mem_out,Z_out,cntrl_w_out);
  input clk,rst,stall,alu_p_in;
  input [3:0] Z_in;
  input [31:0] alu_in,alu_f_in,wdata_in;
  input [15:0] cntrl_m_in,cntrl_w_in;
  //Note: alu_p_in and alu_f_in are to be written back in this stage.
  output reg [31:0] alu_out,mem_out;
  output reg [31:0] Z_out;
  output reg [15:0] cntrl_w_out;
  /*
    output reg [17:0] alu_control_signals; 
  //     0 : Reg ID sel
  //   2:1 : sign extension
  //   4:3 : jump signal (reserved); 3: is jump, 4: direct or indirect
  //  11:5 : EX; 5: PF or I, 6:9: AluOP, 10: Src2 sel, 11: link?
  // 13:12 : MEM; 12: MemR, 13: MemW
  // 17:14 : WB; 14: RegMem, 15: rw_P, 16: rw_R, 17: rw_F 
  */
//Note: addr_out_C not useful  
  
 LoadStoreQueue lsq(.rst(rst),.clk(clk),.memR(cntrl_w_in[12]),.memW(cntrl_w_in[13]),
.addr_in_C(alu_in),.data_in_C(wdata_in),.cntrl_in_C(cntrl_w_in),.Z_in_C(Z_in), // FROM core
.data_out_C(mem_out),.cntrl_out_C(cntrl_w_out),.Z_out_C(Z_out),ready_out_C, // TO core
addr_out_M,data_out_M,rw_out_M,ldstID_out_M,valid_out_M, //TO mem
data_in_M,ldstID_in_M,stall_in_M,ready_in_M, //FROM mem
stall_out_C,empty // TODO implement these
);

DCache4KB dCache(clk,rst,!rw_out_M & valid_out_M,rw_out_M & valid_out_M,ldstID_out_M,addr_out_M,data_out_M,data_in_M,ldstID_in_M,ready_in_M);

  
endmodule
