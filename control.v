module pipeline_ctrl(rst, clk, pval, ex_busy, mm_busy, intp, jmp, is_load, opc_type, pc_id, pc_ex, set_mask, Rx_id, Ry_id, Z_ex, ifid_ctr, idex_ctr, exmm_ctr, mmwb_ctr, jmp_type, epc);
  input rst;
  input clk;
  input pval;
  input ex_busy; //multi-cycle ops
  input mm_busy; //mops
  input [1:0] jmp; // 0: is jmp? n/y; 1: r/i
  input [2:0] intp; //0:ID (INT), 1:ID (illegal), 2:EX(divided by 0). 0: normal, 1:interrupt.
  input is_load;
  input [1:0] opc_type;
  input [3:0] Rx_id, Ry_id, Z_ex;
  input [31:0] pc_id, pc_ex;
  input [1:0] set_mask;
  output reg [1:0] ifid_ctr, idex_ctr, exmm_ctr, mmwb_ctr;
  output reg [1:0] jmp_type; //00: normal, 01: jmpr, 10: jmpi, 11: int
  output [31:0] epc;
  
  reg mask; //int enable
  reg [2:0] cause;
  reg [31:0] epc_r;
  
  //always @(posedge clk) begin
  always @(negedge clk) begin
    if (rst) begin
      ifid_ctr <= 2'b00;
      idex_ctr <= 2'b00;
      exmm_ctr <= 2'b00;
      mmwb_ctr <= 2'b00;
      jmp_type <= 2'b00;
      mask <= 1'b0;
      cause <= 3'b0;
      epc_r <= 32'b0;
    end else begin
      if (intp == 3'b000) begin //no interrupt
        if (pval == 1'b0) begin
          ifid_ctr <= 2'b00;
          idex_ctr <= 2'b01;
          exmm_ctr <= 2'b00;
          mmwb_ctr <= 2'b00;
          jmp_type <= 2'b00;
        end else begin
          case ({mm_busy, ex_busy})
            2'b01:
                begin
                  ifid_ctr <= 2'b10;
                  idex_ctr <= 2'b10;
                  exmm_ctr <= 2'b00;
                  mmwb_ctr <= 2'b00;
                  jmp_type <= 2'b00;
                end
            2'b10,
            2'b11:
                begin
                  ifid_ctr <= 2'b10;
                  idex_ctr <= 2'b10;
                  exmm_ctr <= 2'b10;
                  mmwb_ctr <= 2'b00;
                  jmp_type <= 2'b00;
                end
            default:
              begin
                if (is_load == 1'b1) begin
                  if (((Rx_id == Z_ex) && (opc_type[1] == 1)) || ((Ry_id == Z_ex) && (opc_type[0] == 1))) begin
                    ifid_ctr <= 2'b10;
                    idex_ctr <= 2'b01;                  
                  end else begin
                    ifid_ctr <= {1'b0, jmp[0]};
                    idex_ctr <= 2'b00;
                  end
                  exmm_ctr <= 2'b00;
                  mmwb_ctr <= 2'b00;
                  jmp_type <= {jmp[0] & jmp[1], jmp[0] & (!jmp[1])};
                end else begin
                  if (set_mask == 2'b11) begin //halt
                    ifid_ctr <= 2'b10;
                    idex_ctr <= 2'b00;
                    exmm_ctr <= 2'b00;
                    mmwb_ctr <= 2'b00;
                    jmp_type <= 2'b00;                    
                  end else begin
                    ifid_ctr <= {1'b0, jmp[0]};
                    idex_ctr <= 2'b00;
                    exmm_ctr <= 2'b00;
                    mmwb_ctr <= 2'b00;
                    jmp_type <= {jmp[0] & jmp[1], jmp[0] & (!jmp[1])};
                  end
                end
                 
                if (set_mask == 2'b01) begin //ei
                  mask <= 1'b1;
                end else if (set_mask == 2'b10) begin//di
                  mask <= 1'b0;
                end             
              end
           endcase
        end
      end else if (mask == 1'b1) begin //interrupt solved here
        casex (intp)
          3'b100:
            begin
              ifid_ctr <= 2'b01;
              idex_ctr <= 2'b00;
              exmm_ctr <= 2'b00;
              mmwb_ctr <= 2'b00;          
              mask <= 1'b0;
              cause <= 3'b001;
              epc_r <= pc_id;
            end          
          3'bx10:
            begin
              ifid_ctr <= 2'b01;
              idex_ctr <= 2'b00;
              exmm_ctr <= 2'b00;
              mmwb_ctr <= 2'b00;
              mask <= 1'b0;
              cause <= 3'b010;
              epc_r <= pc_id;          
            end
           3'bxx1:
             begin
              ifid_ctr <= 2'b01;
              idex_ctr <= 2'b01;
              exmm_ctr <= 2'b00;
              mmwb_ctr <= 2'b00;
              mask <= 1'b0;
              cause <= 3'b100;
              epc_r <= pc_ex;               
             end
           default: ;
         endcase
        jmp_type <= 2'b11;      
      end else begin //mask == 0, int treated as nop
        casex (intp)
          3'b100:
            begin
              ifid_ctr <= 2'b00;
              idex_ctr <= 2'b01;
              exmm_ctr <= 2'b00;
              mmwb_ctr <= 2'b00;          
            end          
          3'bx10:
            begin
              ifid_ctr <= 2'b00;
              idex_ctr <= 2'b01;
              exmm_ctr <= 2'b00;
              mmwb_ctr <= 2'b00;          
            end
           3'bxx1:
             begin
              ifid_ctr <= 2'b00;
              idex_ctr <= 2'b00;
              exmm_ctr <= 2'b01;
              mmwb_ctr <= 2'b00;               
             end
           default: ;
         endcase
        jmp_type <= 2'b00;        
      end
    end
  end
  
  assign epc = epc_r;
endmodule