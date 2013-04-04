module MEM_Stage(clk,rst,Z_in,Z_in_buf,alu_in,alu_in_buf,wdata_in,cntrl_m_in,cntrl_w_in,cntrl_w_in_buf,alu_out,mem_out,Z_out,cntrl_w_out,stall_out);
  input clk,rst;
  input [3:0] Z_in,Z_in_buf;
  input [31:0] alu_in,alu_in_buf,wdata_in;
  input [1:0] cntrl_m_in;
  input [3:0] cntrl_w_in,cntrl_w_in_buf;
  output reg [31:0] alu_out;
  output [31:0] mem_out;
  output reg [3:0] Z_out;
  output reg [3:0] cntrl_w_out;
  output reg stall_out;
  //ready_out not yet used
  //output ready_out,empty_out,stall_out_lsq,lsqFull_out;
  
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
  wire [31:0] addr_out_C;
  
  //These go to the memory module from the LSQ
  wire rw_out_M, valid_out_M,stall_out_lsq;
  wire [3:0] ldstID_out_M;
  wire [31:0] addr_out_M,data_out_M;
  
  
  //These go to the LSQ from the memory module
  wire [31:0] data_in_M;
  wire [3:0] ldstID_in_M;
  
  wire [3:0] Z_out_wire;
  wire [3:0] cntrl_w_out_wire;
  
  wire empty_out;
  
  //stalls
  wire stall_in_M;
 LoadStoreQueue lsq(.rst(rst),.clk(clk),.memR(cntrl_m_in[0]),.memW(cntrl_m_in[1]),
.addr_in_C(alu_in),.data_in_C(wdata_in),.cntrl_in_C(cntrl_w_in),.Z_in_C(Z_in), // FROM core
.addr_out_C(addr_out_C),.data_out_C(mem_out),.cntrl_out_C(cntrl_w_out_wire),.Z_out_C(Z_out_wire),.ready_out_C(ready_out), // TO core
.addr_out_M(addr_out_M),.data_out_M(data_out_M),.rw_out_M(rw_out_M),.ldstID_out_M(ldstID_out_M),.valid_out_M(valid_out_M), //TO mem
.data_in_M(data_in_M),.ldstID_in_M(ldstID_in_M),.stall_in_M(stall_in_M),.ready_in_M(ready_in_M), //FROM mem
.stall_out_C(stall_out_lsq),.empty(empty_out),.full(lsqFull_out) // TODO implement these and ready signal
);
reg [1:0] Mem_Buf;
// module DCache4KB(clk,rst,memR,memW,ldstID,addr,Wdata,Rdata,ldstID_out,ready_out);
DCache4KB dCache(.clk(clk),.rst(rst),.memR(!rw_out_M & valid_out_M),.memW(rw_out_M & valid_out_M),.ldstID(ldstID_out_M),.addr(addr_out_M),.Wdata(data_out_M),.Rdata(data_in_M),.ldstID_out(ldstID_in_M),.ready_out(ready_in_M));

always @(posedge clk) begin
  if (stall_out  == 1'b0) begin
    Mem_Buf <= cntrl_m_in;
  end
end

always @(*) begin
  /*if(!empty_out && {cntrl_m_in,cntrl_w_in} == 0) begin // don't stall for nops
    stall_out = 0;
  end else*/
  if(!empty_out && !cntrl_m_in[0] && !cntrl_m_in[1]) begin //if LSQ is not empty, do not allow anything but mops through.
    stall_out = 1;
  end else if(stall_out_lsq || lsqFull_out) begin // if mem or lsq stall, stall the pipeline
    stall_out = 1;
  end else begin
    stall_out = 0;
  end
  
  
  if(empty_out && Mem_Buf == 2'b00) begin // non mop pass through
    Z_out = Z_in_buf;
    alu_out = alu_in_buf;
    cntrl_w_out = cntrl_w_in_buf;
  end else if(ready_out) begin
    cntrl_w_out = cntrl_w_out_wire;
    Z_out = Z_out_wire;
    alu_out = 0;
  end else begin
    Z_out = 0;
    alu_out = 0;
    cntrl_w_out = 0;
  end
end
  
endmodule
