//Interface provided by the cache team
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

module tag_compute (flag, valid, index, avail, v);
  input [14:0] flag, valid;
  output reg [3:0] index, avail;
  output v;
  
  always @(*) begin
    case (flag)
      15'b000000000000001 : index = 4'h0;
      15'b000000000000010 : index = 4'h1;
      15'b000000000000100 : index = 4'h2;
      15'b000000000001000 : index = 4'h3;
      15'b000000000010000 : index = 4'h4;
      15'b000000000100000 : index = 4'h5;
      15'b000000001000000 : index = 4'h6;
      15'b000000010000000 : index = 4'h7;
      15'b000000100000000 : index = 4'h8;
      15'b000001000000000 : index = 4'h9;
      15'b000010000000000 : index = 4'ha;
      15'b000100000000000 : index = 4'hb;
      15'b001000000000000 : index = 4'hc;
      15'b010000000000000 : index = 4'hd;
      15'b100000000000000 : index = 4'he;
      default: index = 4'hf;
    endcase
  end

  always @(*) begin
    case (valid)
      15'bxxxxxxxxxxxxxx0 : avail = 4'h0;
      15'bxxxxxxxxxxxxx01 : avail = 4'h1;
      15'bxxxxxxxxxxxx011 : avail = 4'h2;
      15'bxxxxxxxxxxx0111 : avail = 4'h3;
      15'bxxxxxxxxxx01111 : avail = 4'h4;
      15'bxxxxxxxxx011111 : avail = 4'h5;
      15'bxxxxxxxx0111111 : avail = 4'h6;
      15'bxxxxxxx01111111 : avail = 4'h7;
      15'bxxxxxx011111111 : avail = 4'h8;
      15'bxxxxx0111111111 : avail = 4'h9;
      15'bxxxx01111111111 : avail = 4'ha;
      15'bxxx011111111111 : avail = 4'hb;
      15'bxx0111111111111 : avail = 4'hc;
      15'bx01111111111111 : avail = 4'hd;
      15'b011111111111111 : avail = 4'he;
      default: avail = 4'hf;
    endcase
  end  
  
  assign v = (flag == 15'b111111111111111) ? 1 : 0;
endmodule

module LSQ (clk, rst, memR, memW, addr_in_C, data_in_C, WB_in_C, Z_in_C, //From Core
            data_out_C, WB_out_C, Z_out_C, ready_out_C, stall_out_C, full, empty, //To Core
            data_in_M, lsqID_in_M, stall_in_M, ready_in_M, //From Mem
            addr_out_M, data_out_M, rw_out_M, lsqID_out_M, valid_out_M //To Mem
            );
  input clk, rst;
  input memR, memW;
  input [31:0] addr_in_C, data_in_C, data_in_M;
  input [3:0] WB_in_C;
  input [3:0] Z_in_C, lsqID_in_M;
  input stall_in_M, ready_in_M;
  
  output [31:0] data_out_C, addr_out_M, data_out_M;
  output [3:0] WB_out_C;
  output [3:0] Z_out_C, lsqID_out_M;
  output stall_out_C, empty, full, rw_out_M, valid_out_M, ready_out_C;
  
  //State maintaining parallel arrays, 15 entries
  reg [14:0] valid;
  reg [31:0] addr[14:0]; 
  reg [31:0] data[14:0];
  reg [3:0]  WB[14:0];
  reg [3:0]  Z[14:0];
  reg        RW[14:0];
  reg [3:0]  tag[14:0];
  reg        ready[14:0];
  
  reg [1:0] valid_forward;
  reg [31:0] addr_forward[14:0];
  reg [3:0] tag_forward[14:0];
  reg [31:0] data_forward[14:0];
  reg write_forward[14:0];
  reg [3:0] avail_ptr, avail_ptr_d;
  wire [14:0] valid_forward_wire;
    
  reg [3:0] head_ptr, tail_ptr, read_ptr, write_ptr, write_ptr_d;
  reg [3:0] Q_size;
  reg [14:0] flag;
  
  reg [1:0] rw_d;
  reg [31:0] addr_d, data_d;
  
  wire [3:0] index, avail;
  wire v;
  
  integer i;
  
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      for (i=0;i<15;i=i+1) begin
        valid[i] <= 1'b0;
        addr[i] <= 32'b0;
        data[i] <= 32'b0;
        WB[i] <= 2'b0;
        Z[i] <= 4'b0;
        RW[i] <= 1'b0;
        tag[i] <= 4'b1111;
        ready[i] <= 1'b0;
        
        valid_forward[i] <= 1'b0;
        addr_forward[i] <= 32'b0;
        tag_forward[i] <= 4'b1111;
        data_forward[i] <= 32'b0;
        write_forward[i] <= 1'b0;
        
      end
      
      head_ptr <= 4'b0;
      tail_ptr <= 4'b0;
      read_ptr <= 4'b0;
      write_ptr <= 4'b0;
      avail_ptr <= 4'b0;
      Q_size <= 0;
      flag <= 15'b0;
      rw_d <= 0;
      addr_d <= 0;
      data_d <= 0;
      
    end else begin
      if ((memR == 1'b1) || (memW == 1'b1)) begin
        valid[tail_ptr] <= 1'b1;
        addr[tail_ptr] <= addr_in_C;
        WB[tail_ptr] <= WB_in_C;
        Z[tail_ptr] <= Z_in_C;
        RW[tail_ptr] <= memW;

        if ((rw_d == 2'b01) && (addr_d == addr_in_C)) begin
          flag <= 15'b111111111111111;
          data[tail_ptr] <= data_d;
          ready[tail_ptr] <= 1'b1;
        end else if (rw_d == 2'b10 && (addr_d == addr_in_C)) begin
          flag <= 15'b111111111111111;
          ready[tail_ptr] <= 1'b0;
          data[tail_ptr] <= data_in_C;
        end else begin
          for(i=0;i<16;i=i+1) begin
            if ((valid_forward[i] == 1'b1) && (addr_forward[i] == addr_in_C)) begin
              flag[i] <= 1'b1;
            end else begin
              flag[i] <= 1'b0;
            end
          end
          ready[tail_ptr] <= 1'b0;
          data[tail_ptr] <= data_in_C;
        end
        
        write_ptr <= tail_ptr;
        if (tail_ptr == 4'b1110) begin
          tail_ptr <= 4'b0;
        end else begin
          tail_ptr <= tail_ptr + 4'b1;
        end
      end
      
      if (ready_in_M == 1'b1) begin
 			  ready[lsqID_in_M] <= ready_in_M;
			  data[lsqID_in_M] <= data_in_M; 
      end
        
      if ((valid[head_ptr] == 1'b1) && (ready[head_ptr] == 1'b1)) begin
        valid[head_ptr] <= 1'b0;
        tag[head_ptr] <= 4'b1111;

        for (i=0;i<16;i=i+1) begin
          if ((valid[i] == 1'b1) && (tag[i] == head_ptr) && (i != head_ptr)) begin
   			      ready[i] <= ready[head_ptr];
			       data[i] <= data[head_ptr]; 
          end
        end
        
        for (i=0;i<16;i=i+1) begin
          if (valid_forward[i] == 1'b1 && (i != index) && (tag_forward[i] == head_ptr)) begin
            valid_forward[i] <= 1'b0;
          end
        end
        
        read_ptr <= head_ptr;
        if (Q_size != 0) begin
          if (head_ptr == 4'b1110) begin
            head_ptr <= 4'b0;
          end else begin
            head_ptr <= head_ptr + 4'b1;
          end
        end
        
        if ((memR != 1'b1) && (memW != 1'b1)) begin
          Q_size <= Q_size - 4'b1;
        end
        
      end else if ((memR == 1'b1) || (memW == 1'b1)) begin
        Q_size <= Q_size + 4'b1;
      end

      case (rw_d)
        2'b01 : //write
          begin
            if ((index == 4'b1111) && (v == 0)) begin
              tag[write_ptr] <= 4'b1111;
              valid_forward[avail_ptr] <= 1'b1;
              addr_forward[avail_ptr] <= addr_d;
              tag_forward[avail_ptr] <= write_ptr; 
              data_forward[avail_ptr] <= data_d;
              write_forward[avail_ptr] <= 1'b1;
              avail_ptr <= avail;           
            end else if (v == 1) begin
              tag[write_ptr] <= 4'b1111;
              tag_forward[avail_ptr_d] <= write_ptr;
              data_forward[avail_ptr_d] <= data_d;
              write_forward[avail_ptr_d] <= 1'b1;
            end else begin
              tag[write_ptr] <= 4'b1111;
              tag_forward[index] <= write_ptr; 
              data_forward[index] <= data_d;
              write_forward[index] <= 1'b1;
            end
          end
            
        2'b10 : //read
          begin
            if ((index == 4'b1111) && (v == 0)) begin
              tag[write_ptr] <= write_ptr;
              valid_forward[avail_ptr] <= 1'b1;
              addr_forward[avail_ptr] <= addr_d;
              tag_forward[avail_ptr] <= write_ptr;
              write_forward[avail_ptr] <= 1'b0;
              avail_ptr <= avail;
            end else if (v == 1) begin
              tag[write_ptr] <= write_ptr_d;
              tag_forward[avail_ptr_d] <= write_ptr;
              write_forward[avail_ptr] <= 1'b0;
            end else begin
              tag[write_ptr] <= tag_forward[index];
              tag_forward[index] <= write_ptr;
              write_forward[index] <= 1'b0;
              if (write_forward[index] == 1'b1) begin
                data[write_ptr] <= data_forward[index];
                ready[write_ptr] <= 1'b1;
              end
            end
          end
          
        default: ;
      endcase
      
      rw_d <= {memR, memW};
      addr_d <= addr_in_C;
      data_d <= data_in_C;
      write_ptr_d <= write_ptr;
      if (v == 0) begin
        avail_ptr_d <= avail_ptr;
      end
    end
  end
  
  tag_compute tc(.flag(flag), .valid(valid_forward_wire), .index(index), .avail(avail), .v(v));
  
  assign addr_out_M = addr[write_ptr];
  assign data_out_M = data[write_ptr];
  assign rw_out_M = RW[write_ptr];
  assign valid_out_M = ((flag == 15'b0) && (rw_d[1] == 1'b1)) || (rw_d[0] == 1'b1);
  assign lsqID_out_M = write_ptr;
  assign data_out_C = data[head_ptr];
  assign WB_out_C = WB[head_ptr];
  assign Z_out_C = Z[head_ptr];
  assign ready_out_C = ready[head_ptr];
  assign empty = ((Q_size == 4'b0) || ((Q_size == 4'b1) && (ready[head_ptr] == 1))) ? 1 : 0;
  assign full = (Q_size == 4'b1110) ? 1 : 0;
endmodule


//Load store queue which simply behaves as a FIFO queue
//TODO  Add forwarding from ST -> LD inside of the LSQ 
//TODO  Add full signal to the LSQ
module LoadStoreQueue(rst,clk,memR,memW,
addr_in_C,data_in_C,cntrl_in_C,Z_in_C, // FROM core
addr_out_C,data_out_C,cntrl_out_C,Z_out_C,ready_out_C, // TO core
addr_out_M,data_out_M,rw_out_M,ldstID_out_M,valid_out_M, //TO mem
data_in_M,ldstID_in_M,stall_in_M,ready_in_M, //FROM mem
stall_out_C,empty,full
);
  input memR,memW,rst,clk;
  input[31:0] addr_in_C,data_in_C,data_in_M;
  input[3:0] cntrl_in_C; 
  input[3:0] Z_in_C,ldstID_in_M;
  input stall_in_M,ready_in_M;
  output reg [31:0] addr_out_C,data_out_C,addr_out_M;
  output reg [31:0] data_out_M;
  output reg [3:0] cntrl_out_C; 
  output reg [3:0] Z_out_C,ldstID_out_M;
  output reg stall_out_C,empty,full,rw_out_M,valid_out_M,ready_out_C;
  
  //State maintaining parallel arrays
  reg       valid[15:0];
  reg       rw[15:0];
  reg[31:0] addr[15:0]; 
  reg[31:0] data[15:0];
  reg[15:0] cntrl[15:0];
  reg[3:0] Z[15:0];
  
  //counters and state variables
  reg[10:0] QtailIdx,Qlength;

  

  integer i;
  reg found;
  integer id;
  always @(posedge clk) begin
    
	   //reset/init logic
	 if(rst == 1) begin
		for(i=0;i<16;i=i+1) begin
			addr[i] = 0;
			data[i] = 0;
			cntrl[i] = 0;
			Z[i] = 0;
			valid[i] = 0;
			rw[i] = 0;
      
		end
		QtailIdx=0;
		Qlength=0;
	 end else begin
	 
		 //Input from core and memory issuing
		 if(memW || memR) begin //on st input
			id = (QtailIdx + Qlength)%16;
			//put entry into the store queue
			addr[id] = addr_in_C;
			data[id] = data_in_C;
			cntrl[id] = cntrl_in_C;
			Z[id] = Z_in_C;
			rw[id] = memW;
			
			//LD/ST forwarding
			
			found = 0;
			for(i=0;i<16;i=i+1) begin
					if(addr[i] == addr[id]) begin
					  found = 1;
					  if(memR)begin // current op is ld
					   if(rw[i] == 1) begin // older op is st
					     data[id] = data[i];
					     valid[id] = valid[i];
					   end else if (rw[i] == 0 && valid[i] == 1) begin // older op is ld
					     data[id] = data[i];
					   end
					  end else if(memW) begin // current op is st
					   if(rw[i] == 0) begin // older op is ld
					     //?
					   end
					  end
					end 
			end
			
			if(!found) begin
    			 //send request to mem 
    			addr_out_M = addr_in_C;
    			data_out_M = data_in_C;
    			if(memW) begin
    			  rw_out_M = 1;
    			  
    			end else begin
    			  rw_out_M = 0;
    			end
    			valid_out_M = 1;
    			ldstID_out_M = id;
    			
    			Qlength = Qlength + 1;
			end
			
		 end else begin
			valid_out_M = 0;  
		 end
			
		 //processing input from mem/output to core
		 if(ready_in_M) begin
			//mark entry as received
			valid[ldstID_in_M] = ready_in_M;
			data[ldstID_in_M] = data_in_M;
	 
		 end
		 //process the oldest memory if it is ready.
		 if(valid[QtailIdx] == 1) begin
			ready_out_C = valid[QtailIdx];
			addr_out_C = addr[QtailIdx];
			data_out_C = data[QtailIdx];
			cntrl_out_C = cntrl[QtailIdx];
			Z_out_C = Z[QtailIdx];
			
			//mark as serviced
			valid[QtailIdx] = 0;
			Qlength = Qlength - 1;
			QtailIdx = (QtailIdx +1)%16;
		 end else begin 
		   ready_out_C = 0;
		   end
		   
		 
		 if(Qlength == 0) begin //TODO add full logic here
			empty = 1;
			full = 0;
			//ready_out_C = 0;
		 end else begin
			empty = 0;
			if(Qlength >= 16) begin
			   full = 1;
			end else begin
			   full = 0;
			end
		 end
			  
		 stall_out_C = stall_in_M;
	  end
  end
  
  
endmodule

//Dummy modules
//
module ICache4KB(clk,rst,addr_in,data_out);
        input clk,rst;
        input[31:0] addr_in;
        output reg [31:0] data_out;
        reg[31:0] i_mem[1023:0];
        integer i; 
        
        always @(rst) begin
//          for(i=0;i<1024;i=i+1)
//              memory[i] = 0;
          //memory[0] = 32'h05110003;
//          memory[0] = 32'b0_00_010100_0000_0000_100000000001000;
          //              P Pr  Op     Rz   Ry      Imm

//i_mem[0] = 32'b0_00_100111_0010_0001_0000_00000000000; //andp p2, p1, p0
    //i_mem[0] = 32'b0_00_101000_0010_0010_0001_00000000000; //orp p2, p2, p1
    //i_mem[0] = 32'b0_00_101001_0010_0010_0001_00000000000; //xorp p2, p2, p1
    //i_mem[0] = 32'b0_00_101010_0010_0010_0000_00000000000; //nop p2, p2
    //i_mem[1] = 32'b0_00_100111_0010_0001_0010_00000000000; //andp p2, p1, p2
    //i_mem[0] = 32'h09380000;
    //i_mem[1] = 32'b0_00_101100_0011_0000_0000_00000000000; //iszero p3, r0
    //i_mem[1] = 32'b1_11_101100_0011_0000_0000_00000000000; //iszero p3, r0
    //i_mem[0] = 32'b0_00_100101_0011_0000000000000000000; //ldi r3, 0 
    //i_mem[0] = 32'b0_00_010100_0001_0011_000000000000111; //addi r1, r3, 12
    //i_mem[0] = 32'b0_00_100011_0110_0000_000000000001000; //ld r6, r0, 4
    //i_mem[1] = 32'b0_00_
    //i_mem[0] = 32'b0_00_100011_0110_0000_000000000001000; //ld r6, r0, 8
    //i_mem[1] = 32'b1_00_010100_0001_0110_000000000000111; //addi r1, r6, 7
   // i_mem[0] = 32'b0_00_100100_0010_0000_000000000000100; //st r2, r0, 4
    //i_mem[1] = 32'b0;
    //i_mem[2] = 32'b0;
    //i_mem[2] = 32'b0_00_010100_0001_0011_000000000000111; //jali r1, r3, #7

    i_mem[0] = 32'b0_00_100011_0000_0000_000000000001000; //ld r0, r0, 8
    i_mem[1] = 32'b0_00_100011_0001_0000_000000000001000; //ld r1, r0, 8
    i_mem[2] = 32'b0_00_100011_0010_0000_000000000001000; //ld r2, r0, 8
    i_mem[3] = 32'b0_00_100011_0011_0000_000000000001000; //ld r3, r0, 8
    i_mem[4] = 32'b0_00_100011_0100_0000_000000000001000; //ld r4, r0, 8
    i_mem[5] = 32'b0_00_100011_0101_0000_000000000001000; //ld r5, r0, 8
    i_mem[6] = 32'b0_00_100011_0110_0000_000000000001000; //ld r6, r0, 8
    i_mem[7] = 32'b0_00_100011_0111_0000_000000000001000; //ld r7, r0, 8
    i_mem[8] = 32'b0_00_100011_1000_0000_000000000001000; //ld r8, r0, 8
    i_mem[9] = 32'b0_00_100011_1001_0000_000000000001000; //ld r9, r0, 8
    i_mem[10] = 32'b0_00_100011_1010_0000_000000000001000; //ld r10, r0, 8
    i_mem[11] = 32'b0_00_100011_1011_0000_000000000001000; //ld r11, r0, 8
    i_mem[12] = 32'b0_00_100011_1100_0000_000000000001000; //ld r12, r0, 8
    i_mem[13] = 32'b0_00_100011_1101_0000_000000000001000; //ld r13, r0, 8
    i_mem[14] = 32'b0_00_100011_1110_0000_000000000001000; //ld r14, r0, 8
    i_mem[15] = 32'b0_00_100011_1111_0000_000000000001000; //ld r15, r0, 8

    i_mem[16] = 32'b0_00_100011_0000_0000_000000000000100; //ld r0, r0, 4
    i_mem[17] = 32'b0_00_100011_0001_0000_000000000000100; //ld r1, r0, 4
    i_mem[18] = 32'b0_00_100011_0010_0000_000000000000100; //ld r2, r0, 4
    i_mem[19] = 32'b0_00_100011_0011_0000_000000000000100; //ld r3, r0, 4
    i_mem[20] = 32'b0_00_100011_0100_0000_000000000000100; //ld r4, r0, 4
    i_mem[21] = 32'b0_00_100011_0101_0000_000000000000100; //ld r5, r0, 4
    i_mem[22] = 32'b0_00_100011_0110_0000_000000000000100; //ld r6, r0, 4
    i_mem[23] = 32'b0_00_100011_0111_0000_000000000000100; //ld r7, r0, 4
    i_mem[24] = 32'b0_00_100011_1000_0000_000000000000100; //ld r8, r0, 4
    i_mem[25] = 32'b0_00_100011_1001_0000_000000000000100; //ld r9, r0, 4
    i_mem[26] = 32'b0_00_100011_1010_0000_000000000000100; //ld r10, r0, 4
    i_mem[27] = 32'b0_00_100011_1011_0000_000000000000100; //ld r11, r0, 4
    i_mem[28] = 32'b0_00_100011_1100_0000_000000000000100; //ld r12, r0, 4
    i_mem[29] = 32'b0_00_100011_1101_0000_000000000000100; //ld r13, r0, 4
    i_mem[30] = 32'b0_00_100011_1110_0000_000000000000100; //ld r14, r0, 4
    i_mem[31] = 32'b0_00_100011_1111_0000_000000000000100; //ld r15, r0, 4

    //i_mem[0] = 32'b0_00_100011_0110_0000_000000000001000; //ld r6, r0, 8
    //i_mem[1] = 32'b0_00_100100_0111_0000_000000000000100; //st r7, r0, 8
    //i_mem[1] = 32'b0_00_100011_0111_0000_000000000001000; //ld r7, r0, 8
    //i_mem[2] = 32'b0_00_100011_1000_0000_000000000001000; //ld r8, r0, 8
    //i_mem[1] = 32'b0_00_010100_0101_0110_000000000000111; // addi r5, r6, 7
    //i_mem[1] = 32'b0;
    //i_mem[2] = 32'b0;
   // i_mem[3] = 32'b0;
    //i_mem[4] = 32'b0;
    //i_mem[5] = 32'b0;
    //i_mem[6] = 32'b0;

    //i_mem[1] = 32'b0_00_100011_0110_0000_000000000001000; //ld r6, r0, 4

    
    //i_mem[2] = 32'b0_00_010100_0001_0011_000000000000111; //addi r1, r3, 12
    //i_mem[3] = 32'b0;   
    //i_mem[1] = 32'b0_00_100110_0011_0011_0000_00000000000; //rtop p3, r3
    //i_mem[1] = 32'b0_00_101011_0011_0001_0000_00000000000; //isneg p3, r0
    //i_mem[2] = 32'b0_00_100011_0001_0000_000000000000010; //ld r1, r0, 2
    //i_mem[3] = 32'b0_00_100100_0010_0000_000000000000001; //st r2, r0, 1
    //i_mem[4] = 32'b0_00_100101_0011_0000000000000000100; //ldi r3, 4
    //i_mem[5] = 32'b0;
    //i_mem[6] = 32'b0;
    //i_mem[5] = 32'b1_00_011101_00000000000000000000000; //jmpi #0
    //i_mem[5] = 32'b1_00_011110_0000_0000000000000000000; //jmpr r0
    //i_mem[5] = 32'b1_00_011011_0111_1111111111111101000; //jali r7, -24
    //i_mem[5] = 32'b1_00_011100_0111_0000_000000000000000; //jalr r7, r0
    //i_mem[5] = 32'b0_00_000101_0100_0011_000000000000000; //neg r4, r3
    //i_mem[6] = 32'b0_00_000110_0101_0011_000000000000000; //not r5, r3
    
    //i_mem[7] = 32'b0_00_010100_0110_0011_000000000000111; //addi r6, r3, 7
    //i_mem[8] = 32'b0_00_001010_1000_0111_0101_00000000000; //add r8, r7, r5
    //i_mem[7] = 32'b0_00_010101_0110_0011_000000000000001; //subi r6, r3, 1
    //i_mem[8] = 32'b0_00_001011_1000_0111_0101_00000000000; //sub r8, r7, r5
    //i_mem[7] = 32'b0_00_011001_0110_0011_000000000000111; //shli r6, r3, 7
    //i_mem[8] = 32'b0_00_001111_1000_0111_0010_00000000000; //shl r8, r7, r2
    //i_mem[7] = 32'b0_00_011010_0110_0011_000000000000001; //shri r6, r3, 1
    //i_mem[8] = 32'b0_00_010000_1000_0111_0010_00000000000; //shr r8, r7, r2
    //i_mem[7] = 32'b0_00_010001_0110_0011_000000000000111; //andi r6, r3, 7
    //i_mem[8] = 32'b0_00_000111_1000_0111_0010_00000000000; //and r8, r7, r2
    //i_mem[7] = 32'b0_00_010010_0110_0011_000000000000111; //ori r6, r3, 7
    //i_mem[8] = 32'b0_00_001000_1000_0111_0010_00000000000; //or r8, r7, r2
    //i_mem[7] = 32'b0_00_010011_0110_0011_000000000000111; //xori r6, r3, 7
    //i_mem[8] = 32'b0_00_001001_1000_0111_0010_00000000000; //xor r8, r7, r2
    
    //i_mem[9] = 32'b0;
    //i_mem[10] = 32'b0;
    //i_mem[11] = 32'b0;
    //i_mem[12] = 32'b0;
    //i_mem[13] = 32'b0_00_001010_0111_0110_0001_00000000000; //add r7, r6, r1
    //i_mem[14] = 32'b0;
    //i_mem[15] = 32'b0;
   // i_mem[16] = 32'b0;
    //i_mem[17] = 32'b0;
    //i_mem[18] = 32'b0;
    //i_mem[19] = 32'b0;
    //i_mem[20] = 32'b0_00_000101_0100_0111_000000000000000; //neg r4, r7
    //i_mem[20] = 32'b1_01_000101_0100_0111_000000000000000; //neg r4, r7
    //i_mem[20] = 32'b1_11_000101_0100_0111_000000000000000; //neg r4, r7

        end
        
        always @(addr_in,clk) begin
          data_out <= i_mem[addr_in[9:0]/4];
        end
 endmodule
 
 module DCache4KBNew(clk,rst,addr_in, data_in, rw_in, id_in, valid_in, data_out, id_out, ready_out, stall_out);

input [31:0] addr_in, data_in;
input clk,rst,rw_in, valid_in; // r/w, valid input on the addr, data buses
input [3:0] id_in; // ld/st Q id for request
output reg [31:0] data_out;
output reg [3:0] id_out; // ld/st Q id for request being satisfied
output reg ready_out; // the oldest memory request data is ready
output stall_out; // the memory system cannot accept anymore requests
// stall the pipeline when this line is high

  reg[31:0] memory[1023:0];
        
  //buffers to introduc 2 cycle delay
  reg[3:0] artificialDelayID[1:0];
  reg[31:0] artificialDelayData[1:0];
  reg       artificialDelayReady[1:0];
        
  //initialize all state
  integer i;
        
        
        
  always @(posedge clk) begin
			if(rst == 1) begin
				 for(i=0;i<1024;i=i+1) begin
					memory[i] <= 20;
			   end
			artificialDelayData[0] = 0; 
			artificialDelayData[1] = 0; 
			artificialDelayID[0] = 0; 
			artificialDelayID[1] = 0;
			artificialDelayReady[0] = 0;
			artificialDelayReady[1] = 0;
			
			end else begin
			//perform a "shift" on all the state arrays
      //this simulates a multi cycle (2 in this case) 
			 data_out <= artificialDelayData[1];
			 id_out <= artificialDelayID[1];
			 ready_out <= artificialDelayReady[1];
				 
			 artificialDelayData[1] <= artificialDelayData[0];
			 artificialDelayID[1] <= artificialDelayID[0];
			 artificialDelayReady[1] <= artificialDelayReady[0];
				 
			 //if LD or ST is fed into the memory, complete it and buffer it
			 if(valid_in) begin
			    if(rw_in == 1) begin
						memory[addr_in[9:0]/4] <= data_in;
						artificialDelayData[0] <= 0;
					end else begin
						artificialDelayData[0] <= memory[addr_in[9:0]/4];  
					end
					artificialDelayID[0] = id_in;
					artificialDelayReady[0] = 1;
			 end else begin
			     artificialDelayData[0] <= 0;
			     artificialDelayID[0] <= 0;
			     artificialDelayReady[0] <= 0;
			 end	    
		end
  end

endmodule
 
 
 module DCache4KB(clk, rst, valid, rw, ldstID, addr, Wdata, Rdata, ldstID_out, ready_out);
        input clk, rst;
        input valid, rw;
        input[31:0] addr,Wdata;
        input [3:0] ldstID;
        output reg [31:0] Rdata;
        output reg [3:0] ldstID_out;
        output reg ready_out;
        reg[31:0] memory[0:1023];
        
        //buffers to introduc 2 cycle delay
        reg[31:0] artificialDelayID[1:0];
        reg[31:0] artificialDelayData[1:0];
        reg       artificialDelayReady[1:0];
        
        //initialize all state
        integer i;
        
        
        

  always @(posedge clk) begin
 			if(rst == 1) begin
				for(i=0;i<1024;i=i+1) begin
					memory[i] <= i;
				end
				
				artificialDelayData[0] <= 0; 
				artificialDelayData[1] <= 0; 
				artificialDelayID[0] <= 0; 
				artificialDelayID[1] <= 0;
				artificialDelayReady[0] <= 0;
				artificialDelayReady[1] <= 0;
			end else begin
			//perform a "shift" on all the state arrays
        //this simulates a multi cycle (2 in this case)
			  artificialDelayData[1] <= artificialDelayData[0];
				artificialDelayID[1] <= artificialDelayID[0];
				artificialDelayReady[1] <= artificialDelayReady[0];
				
        if((addr[9:0]/4)%2 == 0 || (valid == 0)) begin
  				  Rdata <= artificialDelayData[1];
  				  ldstID_out <= artificialDelayID[1];
  				  ready_out <= artificialDelayReady[1];
  				 
  				  //if LD or ST is fed into the memory, complete it and buffer it
 					if((valid == 1'b1) && (rw == 1'b1)) begin
 					  memory[addr[9:0]/4] <= Wdata;
						artificialDelayData[0] <= 0;
						artificialDelayID[0] <= ldstID;
  						artificialDelayReady[0] <= 1;
 					end else if((valid == 1'b1) && (rw == 1'b0)) begin
						artificialDelayData[0] <= memory[addr[9:0]/4]; 
						artificialDelayID[0] <= ldstID;
  						artificialDelayReady[0] <= 1; 
 					end else begin
  				    artificialDelayData[0] <= 0;
  				    artificialDelayID[0] <= 0;
  				    artificialDelayReady[0] <= 0;    					    
					end
  					  
			 end else begin// end variable latency hack (addr[9:0]/4)%2 == 0)
 					if((valid == 1) && (rw == 1)) begin
 					  memory[addr[9:0]/4] <= Wdata;
						ldstID_out <= ldstID;
						ready_out <= 1;
 					end else if(valid == 1) begin
						Rdata <= memory[addr[9:0]/4]; 
						ldstID_out <= ldstID;
						ready_out <= 1;
 					end else begin
 					  ldstID_out <= 0;
 					  ready_out <= 0; 					    
					end
					
					artificialDelayData[0] <= 0;
				  artificialDelayID[0] <= 0;
				  artificialDelayReady[0] <= 0; 
 			 end

		end // end if rst
  end // end always
 endmodule
 
 
 /*
 module LoadStoreQueue(rst,clk,memR,memW,
addr_in_C,data_in_C,cntrl_in_C,Z_in_C,
addr_out_C,data_out_C,cntrl_out_C,Z_out_C,ready_out_C,
addr_out_M,data_out_M,rw_out_M,ldstID_out_M,
data_in_M,ldstID_in_M,stall_in_M,ready_in_M,
stall_out_C,empty
);
  input memR,memW,rst,clk;
  input[31:0] addr_in_C,data_in_C,data_in_M;
  input[15:0] cntrl_in_C; // TODO change to proper cntrl signal width
  input[3:0] Z_in_C,ldstID_in_M;
  input stall_in_M,ready_in_M;
  output reg [31:0] addr_out_C,data_out_C,addr_out_M,data_out_M;
  output reg [15:0] cntrl_out_C; // TODO change to proper cntrl signal width
  output reg [3:0] Z_out_C,ldstID_out_M;
  output reg stall_out_C,empty,rw_out_M,ready_out_C;
  
  //State maintaining parallel arrays
  //reg[3:0] lsqID[15:0];

  
  
  reg       valid[15:0]; 
  reg[31:0] addr[15:0];
  reg[31:0] data[15:0];
  reg[15:0] cntrl[15:0];
  reg[3:0] Z[15:0];
  
  //counters and state variables
  reg[10:0] ldQtailIdx,ldQlength,stQtailIdx,stQlength;

  
  //reset logic
  integer i;
  always @(rst) begin
    for(i=0;i<16;i=i+1) begin
      addr_ld[i] = 0;
      data_ld[i] = 0;
      cntrl_ld[i] = 0;
      Z_ld[i] = 0;
      valid_ld[i] = 0;
      
      addr_st[i] = 0;
      data_st[i] = 0;
      cntrl_st[i] = 0;
      Z_st[i] = 0;
      valid_st[i] = 0;
    end
    ldQtailIdx=0;
    ldQlength=0;
    stQtailIdx=0;
    stQlength=0;
    
  end

  
  
  integer id;
  always @(posedge clk) begin
    
    //Input from core and memory issuing
    if(memW) begin //on st input
      id = (stQtailIdx + stQlength)%16;
      //put entry into the store queue
      addr_st[id] = addr_in_C;
      data_st[id] = data_in_C;
      cntrl_st[id] = cntrl_in_C;
      Z_st[id] = Z_in_C;
      valid_st[id] = 1;
      
      //send request to mem 
      addr_out_M = addr_in_C;
      data_out_M = data_out_M;
      rw_out_M = 1;
      ldstID_out_M = id;
      
      stQlength = stQlength + 1;
    end
    
    if(memR) begin //on ld input
      id = (ldQtailIdx + ldQlength)%16;
      //put entry into the load queue
      addr_ld[id] = addr_in_C;
      data_ld[id] = data_in_C;
      cntrl_ld[id] = cntrl_in_C;
      Z_ld[id] = Z_in_C;
      valid_ld[id] = 1;
      
      //send request to mem
      addr_out_M = addr_in_C;
      data_out_M = data_out_M;
      rw_out_M = 0;
      ldstID_out_M = id;
      
      ldQlength = ldQlength + 1;
    end
    
    //processing input from mem/output to core
    if(ready_in_M) begin
      ready_out_C = ready_in_M;
      addr_out_C =  
      data_out_C = data_in_M;
      cntrl_out_C
      Z_out_C
      ,ldstID_in_M,stall_in_M,ready_in_M,
    end
    
    
  end
 
 */
 