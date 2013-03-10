`timescale 1ns / 1ps

module a_test_circuit();

reg clk;
reg rst;
reg rw_in;
reg [31:0] addr_in,data_in;
reg [15:0] cntrl_in;
reg [3:0] Z_in;
wire [31:0] data_out;
wire [15:0] cntrl_out;
wire [3:0] Z_out;
wire stall_out;

initial begin
  clk = 1;
  rw_in = 0;
  addr_in = 0;
  data_in = 0;
  cntrl_in = 0;
  #5 rst = 1;
  #5 rst = 0;
  
end

always begin
   #50 clk = ~clk;
   
end
LoadStoreQueue lsq(rst,clk,rw_in,addr_in,data_in,cntrl_in,Z_in,data_out,cntrl_out,Z_out,stall_out);
//ICache4KB iCache(rw_in,addr_in,data_in,data_out);

endmodule
