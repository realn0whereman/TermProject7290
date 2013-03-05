`timescale 1ns/100ps
module pipeline_tb;
  reg clk;
  
  initial begin
    clk = 0;
  end
  
  always #1 clk = ~ clk;
  
  pipeline pl(clk);
  
endmodule
