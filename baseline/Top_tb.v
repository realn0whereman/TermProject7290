`timescale 1ns/100ps
module pipeline_tb;
  reg clk;
  reg rst;
  
  initial begin
    clk = 0;
    rst = 1;
    #2 rst = 0;
  end
  
  always #1 clk = ~ clk;
  
  pipeline pl(clk, rst);
  
endmodule