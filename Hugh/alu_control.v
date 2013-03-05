module alu_control(opcode, alu_control_signals);
  input [5:0] opcode; 
  output reg [10:0] alu_control_signals; // ID (mux2:1b, mux3:1b), EX (ALUOP:2b, mux4:1b, mux5:1b), MM(memR:1b, memW:1b, mux1:1b), WB(RegW, mux6:1b)
  
  always @(*) begin
    case(opcode)
      6'h0a: //add
        begin
          alu_control_signals[10:9] <= 2'b0x;
          alu_control_signals[8:5] <= 4'b01x_0;
          alu_control_signals[4:2] <= 3'b000;
          alu_control_signals[1:0] <= 2'b10; 
        end
      6'h0b: //sub
        begin
          alu_control_signals[10:9] <= 2'b0x;
          alu_control_signals[8:5] <= 4'b10x_0;
          alu_control_signals[4:2] <= 3'b000;
          alu_control_signals[1:0] <= 2'b10; 
        end
      6'h14: //addi
        begin
          alu_control_signals[10:9] <= 2'bx_0;
          alu_control_signals[8:5] <= 4'b01x_1;
          alu_control_signals[4:2] <= 3'b000;
          alu_control_signals[1:0] <= 2'b10; 
        end
      6'h15: //subi
        begin
          alu_control_signals[10:9] <= 2'bx_0;
          alu_control_signals[8:5] <= 4'b10x_1;
          alu_control_signals[4:2] <= 3'b000;
          alu_control_signals[1:0] <= 2'b10; 
        end
      6'h1d: //jumpi
        begin
          alu_control_signals[10:9] <= 2'bx_1;
          alu_control_signals[8:5] <= 4'b110x;
          alu_control_signals[4:2] <= 3'b001;
          alu_control_signals[1:0] <= 2'b0x; 
        end
      6'h1e: //jumpr
        begin
          alu_control_signals[10:9] <= 2'b1x;
          alu_control_signals[8:5] <= 4'b111x;
          alu_control_signals[4:2] <= 3'b001;
          alu_control_signals[1:0] <= 2'b0x; 
        end
      6'h23: //ld
        begin
          alu_control_signals[10:9] <= 2'b10;
          alu_control_signals[8:5] <= 4'b01x_1;
          alu_control_signals[4:2] <= 3'b100;
          alu_control_signals[1:0] <= 2'b11; 
        end
      6'h24: //st
        begin
          alu_control_signals[10:9] <= 2'b10;
          alu_control_signals[8:5] <= 4'b01x_1;
          alu_control_signals[4:2] <= 3'b010;
          alu_control_signals[1:0] <= 2'b0x; 
        end
      default: //nop
        begin
          alu_control_signals[10:9] <= 2'b00;
          alu_control_signals[8:5] <= 4'b0000;
          alu_control_signals[4:2] <= 3'b000;
          alu_control_signals[1:0] <= 2'b00;          
        end
    endcase
  end
endmodule
  
