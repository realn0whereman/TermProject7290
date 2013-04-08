module alu_control(opcode, alu_control_signals);
  input [5:0] opcode; 
  output reg [19:0] alu_control_signals; 
  //     0 : Reg ID sel
  //   2:1 : sign extension
  //   4:3 : jump signal (reserved); 3: is jump, 4: r/i
  //  11:5 : EX; 5: PF or I, 6:9: AluOP, 10: Src2 sel, 11: link?
  // 13:12 : MEM; 12: MemR, 13: MemW
  // 17:14 : WB; 14: RegMem, 15: rw_P, 16: rw_R, 17: rw_F 
  // 19:18 : opc_type: 0: contains Ry ?, 1: contains Rx ?
  always @(*) begin
    case(opcode)
      //5.3 Memory Loads/Stores
      6'h23: //ld
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_1;         
          alu_control_signals[13:12] = 2'b0_1;
          alu_control_signals[11:5] = 7'b0_1_0001_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h24: //st
        begin
          alu_control_signals[19:18] = 2'b11;
          alu_control_signals[17:14] = 4'b000_x;         
          alu_control_signals[13:12] = 2'b1_0;
          alu_control_signals[11:5] = 7'b0_1_0001_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'b1;
        end
      //5.4 Predicate Manipulation        
      6'h27: //andp
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_x_0001_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h28: //orp
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_x_0010_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h29: //xorp
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_x_0011_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h2a: //notp
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_x_0100_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      //5.5 Value Test        
      6'h26: //rtop
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_x_0101_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h2b: //isneg
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_x_0110_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h2c: //iszero
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b001_x;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_x_0111_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      //5.6 Immediate Integer Arithmetic/Logic        
      6'h25: //ldi
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'bx_1_1101_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b11;
          alu_control_signals[0] = 1'bx;
        end
      6'h14: //add
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0001_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h15: //subi
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0010_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h16: //muli
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0011_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h17: //divi
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0100_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end        
      6'h18: //modi
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0101_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h19: //shli
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0110_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h1a: //shri
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_0111_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h11: //andi
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_1000_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h12: //ori
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_1001_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      6'h13: //xori
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_1_1010_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'b01;
          alu_control_signals[0] = 1'bx;
        end
      //5.7 Register Integer Arithmetic/Logic        
      6'h0a: //add
        begin
          alu_control_signals[19:18] = 2'b11;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0001_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h0b: //sub
        begin
          alu_control_signals[19:18] = 2'b11;
          alu_control_signals[17:14] = 4'b010_0;        
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0010_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h0c: //mul
        begin
          alu_control_signals[19:18] = 2'b11;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0011_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h0d: //div
        begin
          alu_control_signals[19:18] = 2'b11;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0100_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end        
      6'h0e: //mod
        begin
          alu_control_signals[19:18] = 2'b11;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0101_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h0f: //shl
        begin
          alu_control_signals[19:18] = 2'b11;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0110_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h10: //shr
        begin
          alu_control_signals[19:18] = 2'b11;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0111_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h07: //and
        begin
          alu_control_signals[19:18] = 2'b11;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_1000_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h08: //or
        begin
          alu_control_signals[19:18] = 2'b11;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_1001_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h09: //xor
        begin
          alu_control_signals[19:18] = 2'b11;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_1010_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end
      6'h05: //neg
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_x_1011_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'bx;
        end
      6'h06: //not
        begin
          alu_control_signals[19:18] = 2'b01;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_x_1100_1;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'bx;
        end  
      //5.2 Privileged Instruction
      6'h01: //di
        begin
          alu_control_signals[19:18] = 2'b0;
          alu_control_signals[17:14] = 4'b0;         
          alu_control_signals[13:12] = 2'b0;
          alu_control_signals[11:5] = 7'b0;
          alu_control_signals[4:3] = 2'b0;
          alu_control_signals[2:1] = 2'b0;
          alu_control_signals[0] = 1'b0;
        end
      6'h02: //ei
        begin
          alu_control_signals[19:18] = 2'b0;
          alu_control_signals[17:14] = 4'b0;         
          alu_control_signals[13:12] = 2'b0;
          alu_control_signals[11:5] = 7'b0;
          alu_control_signals[4:3] = 2'b0;
          alu_control_signals[2:1] = 2'b0;
          alu_control_signals[0] = 1'b0;
        end
      6'h31: //reti
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b000_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0000_0;
          alu_control_signals[4:3] = 2'b1_1;
          alu_control_signals[2:1] = 2'b10;
          alu_control_signals[0] = 1'b0;
        end
      6'h2d: //halt
        begin
          alu_control_signals[19:18] = 2'b0;
          alu_control_signals[17:14] = 4'b0;         
          alu_control_signals[13:12] = 2'b0;
          alu_control_signals[11:5] = 7'b0;
          alu_control_signals[4:3] = 2'b0;
          alu_control_signals[2:1] = 2'b0;
          alu_control_signals[0] = 1'b0;
        end        
      //5.11 User/Kernel Interaction 
      6'h2e: //trap
        begin
          alu_control_signals[19:18] = 2'b0;
          alu_control_signals[17:14] = 4'b0;         
          alu_control_signals[13:12] = 2'b0;
          alu_control_signals[11:5] = 7'b0;
          alu_control_signals[4:3] = 2'b0;
          alu_control_signals[2:1] = 2'b0;
          alu_control_signals[0] = 1'b0;
        end       
      //5.8 Floating Point Arhithmethic
      //itof 1000
      //ftoi 1001
      6'h39: //fneg
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b100_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_1010_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end 
      6'h35: //fadd
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b100_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_1011_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end 
      6'h36: //fsub
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b100_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_1100_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end 
      6'h37: //fmul
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b100_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_1101_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end 
      6'h38: //fdiv
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b100_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_1110_0;
          alu_control_signals[4:3] = 2'bx_0;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end 
      //5.9 Control Flow
      6'h1d: //jmpi
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b000_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0000_0;
          alu_control_signals[4:3] = 2'b1_1;
          alu_control_signals[2:1] = 2'b10;
          alu_control_signals[0] = 1'b0;
        end
      6'h1e: //jmpr
        begin
          alu_control_signals[19:18] = 2'b10;
          alu_control_signals[17:14] = 4'b000_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b0_0_0000_0;
          alu_control_signals[4:3] = 2'b0_1;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b1;
        end
      6'h1b: //jali
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b1_0_1110_1;
          alu_control_signals[4:3] = 2'b1_1;
          alu_control_signals[2:1] = 2'b11;
          alu_control_signals[0] = 1'b0;
        end
      6'h1c: //jalr
        begin
          alu_control_signals[19:18] = 2'b10;
          alu_control_signals[17:14] = 4'b010_0;         
          alu_control_signals[13:12] = 2'b0_0;
          alu_control_signals[11:5] = 7'b1_0_1110_1;
          alu_control_signals[4:3] = 2'b0_1;
          alu_control_signals[2:1] = 2'bxx;
          alu_control_signals[0] = 1'b0;
        end 
        
      default: //nop
        begin
          alu_control_signals[19:18] = 2'b00;
          alu_control_signals[17:14] = 2'b0;         
          alu_control_signals[13:12] = 2'b0;
          alu_control_signals[11:5] = 4'b0;
          alu_control_signals[4:3] = 2'b0;
          alu_control_signals[2:1] = 2'b0;
          alu_control_signals[0] = 1'b0;        
        end
    endcase
  end
endmodule

module preg_file(rst, rw, X, Y, Z, Pset, Pid, Pz, Px, Py, Pval);
  input rst;
  input rw; //0, read; 1, write
  input [1:0] X;
  input [1:0] Y;
  input [1:0] Z;
  input [1:0] Pid;
  input Pz;
  input Pset;
  output Px;
  output Py;
  output Pval;
  
  reg pregs [3:0];
  integer i;
  
  always @ (*) begin
    if (rst) begin
      /*
      for(i=0; i<4; i=i+1) begin
        pregs[i] <= 0;
      end
      */
      pregs[0] <= 1;
      pregs[1] <= 1;
      pregs[2] <= 0;
      pregs[3] <= 0;
    end else begin
      if(rw == 1)
        pregs[Z] <= Pz;
    end
  end
  
  assign Px = pregs[X];
  assign Py = pregs[Y];
  assign Pval = (Pset == 1) ? pregs[Pid] : 1'b1;
endmodule

module greg_file(rst, rw, X, Y, Z, Rz, Rx, Ry);
  input rst;
  input rw; //0, read; 1, write
  input [3:0] X;
  input [3:0] Y;
  input [3:0] Z;
  input [31:0] Rz;
  output [31:0] Rx;
  output [31:0] Ry;
  
  reg [31:0] gregs [15:0];
  integer i;
  
  always @ (*) begin
    if (rst) begin
      for(i=0; i<16; i=i+1) begin
        gregs[i] <= i;
      end
    end else begin 
      if(rw == 1)
        gregs[Z] <= Rz;
    end
  end
  
  assign Rx = gregs[X];
  assign Ry = gregs[Y];
endmodule

module freg_file(rst, rw, X, Y, Z, Fz, Fx, Fy);
  input rst;
  input rw; //0, read; 1, write
  input [3:0] X;
  input [3:0] Y;
  input [3:0] Z;
  input [31:0] Fz;
  output [31:0] Fx;
  output [31:0] Fy;
  
  reg [31:0] fregs [15:0];
  integer i;
  
  always @ (*) begin
    if (rst) begin
      for(i=0; i<16; i=i+1) begin
        fregs[i] <= 0;
      end
      fregs[0] <=  32'h40000000;
      fregs[1] <=  32'h40800000;
      
    end else begin 
      if(rw == 1)
        fregs[Z] <= Fz;
    end
  end
  
  assign Fx = fregs[X];
  assign Fy = fregs[Y];
endmodule

module imm_extend(ctr, field, imm_s);
  input [1:0] ctr;
  input [22:0] field;
  output reg [31:0] imm_s;
  
  always @(*) begin
    case (ctr)
      2'b01: imm_s = {{17{field[14]}}, field[14:0]};
      2'b10: imm_s = {{9{field[22]}}, field[22:0]};
      2'b11: imm_s = {{13{field[18]}}, field[18:0]};
      default: imm_s = 32'b0;
    endcase
  end
endmodule

module decode(clk, rst, pc_n, inst, Pz_id, Pz, Rz_id, Rz, Fz_id, Fz, imm_s, rw, Px, Py, Rx, Ry, Fx, Fy, Z, EX, MEM, WB, JMP, OPC, Pval, Y_id, X_id, jmp_i, set_mask, epc, interrupt1, interrupt0); //jump target is computed here
  input clk;
  input rst;
  input [31:0] pc_n;
  input [31:0] inst;
  input [2:0] rw; //0:preg, 1:greg, 2:freg
  input Pz;
  input [1:0] Pz_id;
  input [31:0] Rz;
  input [3:0] Rz_id;
  input [31:0] Fz;
  input [3:0] Fz_id;
  input [31:0] epc;
 
  output Px;
  output Py;
  output [31:0] Rx;
  output [31:0] Ry; 
  output [31:0] Fx;
  output [31:0] Fy;
  output [3:0] Z;
  output [31:0] imm_s;
  output [6:0] EX;
  output [1:0] MEM;
  output [3:0] WB;
  output [1:0] JMP;
  output [1:0] OPC;
  output Pval;
  output [3:0] Y_id;
  output [3:0] X_id;
  output [31:0] jmp_i;
  output reg [1:0] set_mask;
  output interrupt1, interrupt0;
  
  wire [3:0] X;
  wire [3:0] Y;
  wire [1:0] Pid;
  wire [19:0] signals;
  wire Pset;
  
  assign X = (signals[0] == 0) ? inst[14:11] : inst[22:19];
  assign Y = inst[18:15];
  assign Z = inst[22:19];
  assign Pset = inst[31];
  assign Pid = inst[30:29];
  assign Y_id = Y;
  assign X_id = X;
  
  always @(*) begin
    case (inst[28:23])
      6'h01 : set_mask = 2'b10; //di
      6'h02 : set_mask = 2'b01; //ei
      6'h2d : set_mask = 2'b11; //halt
      default: set_mask = 2'b00;
    endcase
  end
  
  assign interrupt1 = (inst[28:23] > 6'b111001) ? 1 : 0; //unknown opcode;
  assign interrupt0 = (inst[28:23] == 6'b101110) ? 1 : 0; //TRAP
  
  preg_file pregs(.rst(rst), .rw(rw[0]), .X(X[1:0]), .Y(Y[1:0]), .Z(Pz_id), .Pset(Pset), .Pid(Pid), .Pz(Pz), .Px(Px), .Py(Py), .Pval(Pval));
  greg_file gregs(.rst(rst), .rw(rw[1]), .X(X), .Y(Y), .Z(Rz_id), .Rz(Rz), .Rx(Rx), .Ry(Ry));
  freg_file fregs(.rst(rst), .rw(rw[2]), .X(X), .Y(Y), .Z(Fz_id), .Fz(Fz), .Fx(Fx), .Fy(Fy));
  
  imm_extend immse(.ctr(signals[2:1]), .field(inst[22:0]), .imm_s(imm_s));
  
  alu_control ac(.opcode(inst[28:23]), .alu_control_signals(signals));

  assign EX = signals[11:5];
  assign MEM = signals[13:12];
  assign WB = signals[17:14];
  assign JMP = signals[4:3];
  
  assign OPC = signals[19:18];
  
  assign jmp_i = (inst[28:23] == 6'b110001) ? epc : pc_n + imm_s; //reti is a kind of jmpi
  
endmodule
