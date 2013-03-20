module writeback(WB, mem_data, reg_data, result);
  input WB;
  input [31:0] mem_data;
  input [31:0] reg_data;
  output [31:0] result;
  
  assign result = (WB == 0) ? reg_data : mem_data;
endmodule
