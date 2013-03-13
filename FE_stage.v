module FE_Stage(clk,rst,stall,n_pc,isn);
  input clk,rst,stall;
  output reg [31:0] n_pc;
  output [31:0] isn;
  reg[31:0] pc;
  always @(posedge rst) begin
    pc = 0;
  end
  
  //subtract 4 because of the always statement that increments it. 
  //This approach looks hacky, but it works.
  ICache4KB iCache(clk,rst,pc-4,isn);
  
  always @(posedge clk) begin
    if(stall == 0) begin
      pc = pc + 4;
      n_pc = pc;
    end
    
    
  end
  
  
  
endmodule

