

module MEM_Stage(clk,rst,stall,Z_in,alu_in,alu_p_in,alu_f_in,wdata_in,cntrl_m_in,cntrl_w_in,alu_out,mem_out,Z_out,cntrl_w_out);
  input clk,rst,stall,alu_p_in;
  input [3:0] Z_in;
  input [31:0] alu_in,alu_f_in,wdata_in;
  input [15:0] cntrl_m_in,cntrl_w_in;
  
  output reg [31:0] alu_out,mem_out;
  output reg [31:0] Z_out;
  output reg [15:0] cntrl_w_out;
  
  /*
  
  INSERT LSQ and Dcache here
  
  */

  
endmodule
