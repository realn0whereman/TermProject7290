module data_mem(clk, MEM, Wdata, Addr, Rdata);
  input clk;
  input [1:0] MEM;
  input [31:0] Wdata;
  input [31:0] Addr;
  output [31:0] Rdata;
  
  reg [31:0] d_mem [0:1023];
  //wire [9:0] index;
  integer i;
  
  initial begin
    for(i = 0; i < 1024; i = i + 1)
      begin
        d_mem[i] = 32'b0;
      end
  end
  
  //assign index = Addr[9:0];
  assign Rdata = (MEM[1] == 1) ? d_mem[Addr[9:0]] : 'bx;
  
  always @(posedge clk) begin
    if(MEM[0] == 1) begin
      d_mem[Addr[9:0]] <= Wdata;
    end
  end
endmodule