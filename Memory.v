module memory_system(addr_in, data_in, rw_in, id_in, valid_in, data_out, id_out, ready_out, stall_out);

input [31:0] addr_in, data_in;
input rw_in, valid_in; // r/w, valid input on the addr, data buses
input [3:0] id_in; // ld/st Q id for request
output [31:0] data_out;
output [3:0] id_out; // ld/st Q id for request being satisfied
output ready_out; // the oldest memory request data is ready
output stall_out; // the memory system cannot accept anymore requests
// stall the pipeline when this line is
// high

endmodule

/*
Ex/Mem
    -clk
    -Z
    -alu_out (also the address)
    -alu_p_out
    -alu_f_out
    -wdata
    -cntrl.m
    -cntrl.w

mem/Wb
    -clk
    -alu_out
    -mem_out
    -Z
    -cntr.w

*/

module LoadStoreQueue(rw_in,addr_in,data_in,cntrl_in,Z_in,data_out,cntrl_out,Z_out,stall_out);
  input rw_in;
  input[31:0] addr_in,data_in;
  input[15:0] cntrl_in; // TODO change to proper cntrl signal width
  input[3:0] Z_in;
  output reg [31:0] data_out;
  output reg [15:0] cntrl_out; // TODO change to proper cntrl signal width
  output reg [3:0] Z_out;
  output reg stall_out;
endmodule

//Dummy modules
module ICache4KB(rw_in,addr_in,data_in,data_out);
        input rw_in;
        input[31:0] addr_in,data_in;
        output reg [31:0] data_out;
        reg[31:0] memory[1023:0];
        integer i;
        initial begin 
    
         $readmemh("test.hex", memory);
         for(i=10;i<1024;i=i+1) begin //TODO get number dynamically
             memory[i] <= 0;
         end 
        end 
    
        always @(*) begin
                if(rw_in) begin
                        memory[addr_in[9:0]/4] <= data_in; 
          end 
        data_out <= memory[addr_in[9:0]/4];
  end 
 endmodule
 
 
 module DCache4KB(rw_in,addr_in,data_in,data_out);
        input rw_in;
        input[31:0] addr_in,data_in;
        output reg [31:0] data_out;
        reg[31:0] memory[1023:0];
        integer i;
        initial begin 
         for(i=0;i<1024;i=i+1) begin
             memory[i] <= 0;
         end 
        end 
    
        always @(*) begin
                if(rw_in) begin
                        memory[addr_in[9:0]/4] <= data_in; 
          end 
        data_out <= memory[addr_in[9:0]/4];
  end 
 endmodule