`timescale 1 ns / 100 ps
module a_MEM_test();
  reg clk,rst;
  reg [3:0] Z_in;
  reg [31:0] alu_in,wdata_in;
  reg [1:0] cntrl_m_in;
  reg [3:0] cntrl_w_in;
  
  wire [31:0] alu_out,mem_out;
  wire [3:0] Z_out;
  wire [3:0] cntrl_w_out;
  wire stall_out;
  
initial begin
  clk = 0;
  rst = 1;
  #1 rst = 0;
  //cntrl_m_in = memW memR
  #3 Z_in = 3; alu_in = 12; wdata_in = 2; cntrl_m_in = 2'b10; cntrl_w_in = 1; // ld
  #2 Z_in = 0; alu_in = 0; wdata_in = 0; cntrl_m_in = 0; cntrl_w_in = 0; //nop
  //#2 Z_in = 4; alu_in = 12; wdata_in = 2; cntrl_m_in = 2'b01; cntrl_w_in = 2; // ST
  //#2 Z_in = 6; alu_in = 12; wdata_in = 2; cntrl_m_in = 2'b01; cntrl_w_in = 2; // ST
  //#2 Z_in = 5; alu_in = 15; wdata_in = 2; cntrl_m_in = 2'b00; cntrl_w_in = 4; // non mop (should stall)
  //#2 Z_in = 9; alu_in = 15; wdata_in = 2; cntrl_m_in = 2'b00; cntrl_w_in = 4; // non mop (should stall)
  //#12 Z_in = 3; alu_in = 12; wdata_in = 2; cntrl_m_in = 2'b10; cntrl_w_in = 1; // ld
  //#2 Z_in = 4; alu_in = 12; wdata_in = 2; cntrl_m_in = 2'b01; cntrl_w_in = 2; // ST
  //#2 Z_in = 6; alu_in = 12; wdata_in = 2; cntrl_m_in = 2'b01; cntrl_w_in = 2; // ST
end
  
  
  always begin
   #1 clk = ~clk;
  end
  
  MEM_Stage mem(clk,rst,Z_in,alu_in,wdata_in,cntrl_m_in,cntrl_w_in,alu_out,mem_out,Z_out,cntrl_w_out,stall_out);
  
endmodule

module a_mul_test();
  reg clk;
  reg rst;
  reg sel;
  wire [31:0] Z ;
  wire stall;
  reg [31:0] A,B;
  reg [2:0] op;
initial begin
  clk = 0;
  rst = 1;
  #3 rst = 0;
  #2 op=3'b110; A= 32'h00000007; B=32'h00000003;
 
end
  always begin
   #1 clk = ~clk;
  end
  wire [31:0] mulResult;
  
  IMul imul(
	.clock(clk),
	.dataa(A),
	.datab(B),
	.result(mulResult));
endmodule

module a_fpu_test();
  reg clk;
  reg rst;
  reg sel;
  wire [31:0] Z ;
  wire stall;
  reg [31:0] A,B;
  reg [2:0] op;
initial begin
  clk = 0;
  rst = 1;
  #3 rst = 0;
  #2 op=3'b110; A= 32'h41200000; B=32'h00000000; sel = 1;
  #6 op=3'b110; A= 32'h41200000; B=32'h40000000; sel = 1;
end
  always begin
   #1 clk = ~clk;
  end
  
  wire exception_wire;
  wire [31:0] divResult;
  
  FPDiv divFU(
	.aclr(1'b0),
	.clock(clk),
	.dataa(A),
	.datab(B),
	.division_by_zero(exception_wire),
	.result(divResult));
endmodule

module a_pipeline_test();
  reg clk;
  reg rst;
  

initial begin
  clk = 0;
  rst = 1;
  #2 rst = 0;
end
  always begin
   #1 clk = ~clk;
  end
  
  pipeline TOP(clk, rst);
  
endmodule

module a_LSQ_test();
  
reg clk;
reg rst;
reg memR,memW;
reg [31:0] addr_in_C,data_in_C;
reg [15:0] cntrl_in_C;
reg [3:0] Z_in_C;


wire [31:0] addr_out_C,addr_out_M,data_out_C,data_out_M,data_in_M;
wire [15:0] cntrl_out_C;
wire [3:0] Z_out_C,ldstID_out_M,ldstID_in_M;
wire ready_out_C,rw_out_M,ready_in_M;
  integer i;
initial begin
  
  clk = 1;
  addr_in_C = 0;
  data_in_C = 0;
  cntrl_in_C = 0;
  
  memR = 0;
  memW = 0;
  rst = 1;
  #1 rst = 0;
  
  for(i=0;i<3;i=i+1) begin
  fork
  #1 addr_in_C = 1;
  #1 memW = 1;
  #1 memR = 0;
  #1 cntrl_in_C = 2;
  #1 data_in_C = 3;
  #1 Z_in_C = 4;
  join
  
  fork
  #2 addr_in_C = 5;
  #2 memR = 1;
  #2 memW = 0;
  #2 cntrl_in_C = 6;
  #2 data_in_C = 7;
  #2 Z_in_C = 8;
  join
  
  fork
  #2 addr_in_C = 10;
  #2 memW = 1;
  #2 memR = 0;
  #2 cntrl_in_C = 11;
  #2 data_in_C = 12;
  #2 Z_in_C = 13;
  join
  
  fork
  #2 addr_in_C = 15;
  #2 memR = 1;
  #2 memW = 0;
  #2 cntrl_in_C = 16;
  #2 data_in_C = 17;
  #2 Z_in_C = 3;
  join
  
  fork
  #1 memR = 0;
  #1 memW = 0;
  join
end
end

  
  always begin
   #1 clk = ~clk;
  end
  
  
  LoadStoreQueue lsq(rst,clk,memR,memW,
addr_in_C,data_in_C,cntrl_in_C,Z_in_C, // FROM core
addr_out_C,data_out_C,cntrl_out_C,Z_out_C,ready_out_C, // TO core
addr_out_M,data_out_M,rw_out_M,ldstID_out_M,valid_out_M, //TO mem
data_in_M,ldstID_in_M,stall_in_M,ready_in_M, //FROM mem
stall_out_C,empty
);

DCache4KB dCache(clk,rst,!rw_out_M & valid_out_M,rw_out_M & valid_out_M,ldstID_out_M,addr_out_M,data_out_M,data_in_M,ldstID_in_M,ready_in_M);
//modulDCache4KB(clk,rst, memR,       memW,    ldstID,     addr,       Wdata,   Rdata,     ldstID_out,  ready_out);

  
endmodule




module a_dcache_test();
reg clk;
reg rst;
reg memR,memW;
reg [31:0] addr_in,data_in,ldstID;
wire [31:0] data_out,ldstID_out;
wire empty;

initial begin
  clk = 1;
  
  addr_in = 0;
  data_in = 0;
  memR = 0;
  memW = 0;
  #1 rst = 1;
  #1 rst = 0;
  fork
  #2 ldstID = 4001;
  #2 addr_in = 40;
  #2 memW = 1;
  #2 memR = 0;
  #2 data_in = 9000;
  join
  
  fork
  #2 ldstID = 4002;
  #2 addr_in = 44;
  #2 memW = 1;
  #2 memR = 0;
  #2 data_in = 9001;
  join
  
  fork
  #2 ldstID = 4003;
  #2 addr_in=40;
  #2 memR = 1;
  #2 memW = 0;
  join
  
  fork
  #2 ldstID = 4004;
  #2 addr_in=44;
  #2 memR = 1;
  #2 memW = 0;
  join
end
  always begin
   #1 clk = ~clk;
  end
  
  DCache4KB dCache(clk,rst,memR,memW,ldstID,addr_in,data_in,data_out,ldstID_out,empty);
endmodule



