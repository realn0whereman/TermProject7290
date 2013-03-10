`timescale 1ns / 1ps

module a_test_circuit();

reg clk;
reg rst;
reg rw_in;
reg [31:0] addr_in,data_in;
wire [31:0] data_out;
initial begin
  clk = 1;
  rw_in = 0;
  addr_in = 0;
  data_in = 0;
  #5 rst = 1;
  #5 rst = 0;
  
end

always begin
   #50 clk = ~clk;
   
end
ICache4KB iCache(rw_in,addr_in,data_in,data_out);

endmodule
