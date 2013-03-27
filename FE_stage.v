module FE_Stage(clk,rst,ctr,n_pc,isn);
  input clk,rst;
  input [1:0] ctr; // if this is 10 then stall.
  output [31:0] n_pc;
  output [31:0] isn;
  reg[31:0] pc;
  
  //subtract 4 because of the always statement that increments it. 
  //This approach looks hacky, but it works.
  ICache4KB iCache(clk,rst,pc,isn);
  
  always @(posedge clk) begin
	 if(rst == 1) begin
		pc <= 0;
	 end 
	 else if(ctr !=  2'b10) begin
      pc <= pc + 4;
    end
    
    
  end
  
  assign n_pc = pc;
  
  
  
endmodule

