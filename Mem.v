//faked
module data_cache(clk, MEM, Wdata, Addr, Rdata, BUSY);
  input clk;
  input [1:0] MEM;
  input [31:0] Wdata;
  input [31:0] Addr;
  output [31:0] Rdata;
  output BUSY;
  
  reg [2:0] state;
  reg [31:0] d_mem [0:1023];
  integer i;
  
  parameter init = 3'b000, Read1 = 3'b001, Write1 = 3'b010, Read2 = 3'b011, Write2 = 3'b110, 
    Read3 = 3'b111, Write3 = 3'b100, Read4 = 3'b101;
  
  reg [9:0] addr_int;
  reg [31:0] Wdata_int;
  
  initial begin
    state <= init;
    d_mem[0] = 32'b1;
    for(i = 1; i < 1024; i = i + 1)
      begin
        d_mem[i] = 32'b0;
      end
  end
  
  always @(posedge clk) begin
    case (state)
      init: 
        begin
          if (MEM[1] == 1) begin
            state <= Write1;
            addr_int <= Addr[9:0]; 
            Wdata_int <= Wdata;
          end else if (MEM[0] == 1) begin
            state <= Read1;
            addr_int <= Addr[9:0];
          end else begin
            state <= init;
          end
        end
      Read1: state <= Read2;
      Write1: state <= Write2;
      Read2: state <= Read3;
      Write2: state <= Write3;
      Read3: state <= Read4;
      Write3:
        begin
          state <= init;
          d_mem[addr_int] <= Wdata_int;
        end    
    endcase
  end
  
  assign BUSY = (state == init) || (state == Read4) || (state == Write3);
  assign Rdata = (state == Read4) ? d_mem[addr_int] : 'bx;

endmodule

/*
module data_cache(clk, MEM, Wdata, Addr, Rdata, BUSY);
  input clk;
  input [1:0] MEM;
  input [31:0] Wdata;
  input [31:0] Addr;
  output [31:0] Rdata;
  output BUSY;
  
  reg [31:0] d_mem [0:1023];
  integer i;
  
  initial begin
    d_mem[0] = 32'b1;
    for(i = 1; i < 1024; i = i + 1)
      begin
        d_mem[i] = 32'b0;
      end
  end
  
  assign BUSY = 1'b0;
  assign Rdata = (MEM[0] == 1) ? d_mem[Addr[9:0]] : 'bx;
  
  always @(posedge clk) begin
    if(MEM[1] == 1) begin
      d_mem[Addr[9:0]] <= Wdata;
    end
  end
endmodule
*/