module LatchN(rst, clk, ctr, data_in, data_out);
  parameter N=32;
  
  input rst;
  input clk;
  input [1:0] ctr; //00:normal, 01:squash, 10:stall, 11:stall+bubble
  input [N-1:0] data_in;
  output [N-1:0] data_out;
  
  reg [N-1:0] data;
  ///reg bubble;
  
  always @(posedge clk) begin
    if (rst) begin
      data <= 0;
      //bubble <= 0;
    end else begin
      case (ctr)
        2'b00  : data <= data_in;
        2'b01  : data <= 32'b0;
        default: data <=  data;
      endcase
      
      //bubble <= (ctr == 2'b11) ? 1'b1 : 1'b0; 
    end  
  end
  
  assign data_out = data;
 // assign data_out = (bubble == 1'b1) ? 32'b0 : data;
endmodule