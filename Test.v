`timescale 1ns / 100ps




module a_fpu_test();
  reg clk;
  reg rst;
  wire [31:0] Z ;
  wire stall;
  reg [31:0] A,B;
  reg [3:0] op;
initial begin
  clk = 0;
  rst = 1;
  #2 rst = 0;
  #18 op=4'b1011; A= 32'h41200000; B=32'h40000000;
  #12 op=4'b1101; A= 32'h41200000; B=32'h41000000;
end
  always begin
   #1 clk = ~clk;
  end
  
                  
  alu_F fpu(1'b1,clk,rst, op, A, B, Z,stall);
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


/*module a_test_circuit();

reg clk;
reg rst;
reg rw_in,memR,memW;
reg [31:0] addr_in,data_in;
reg [15:0] cntrl_in;
reg [3:0] Z_in;
wire [31:0] data_out,n_pc,isn;
wire [15:0] cntrl_out;
wire [3:0] Z_out;
wire stall_out,empty;
reg stall;



initial begin
  clk = 0;
  rw_in = 0;
  addr_in = 0;
  data_in = 0;
  cntrl_in = 0;
  stall = 0;
  memR = 0;
  memW = 0;
  rst = 1;
  #1 rst = 0;

end

always begin
   #1 clk = ~clk;
   
end
FE_Stage fe(clk,rst,stall,n_pc,isn);
//LoadStoreQueue lsq(rst,clk,memR,memW,ldstID,addr_in,data_in,cntrl_in,Z_in,data_out,cntrl_out,Z_out,stall_out,ldstID_out,empty);
//ICache4KB iCache(clk,rst,addr_in,data_in,data_out);
endmodule*/


