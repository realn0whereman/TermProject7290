module pipeline_ctrl(rst, clk, pval, ex_busy, mm_busy, intp, jmp, is_load, opc_type, Rx_id, Ry_id, Z_ex, ifid_ctr, idex_ctr, exmm_ctr, mmwb_ctr, jmp_type);
  input rst;
  input clk;
  input pval;
  input ex_busy; //multi-cycle ops
  input mm_busy; //mops
  input [1:0] jmp; // 0: is jmp? n/y; 1: r/i
  input [2:0] intp; //0:IF (INT), 1:ID (illegal), 2:EX(divided by 0). 0: normal, 1:interrupt.
  input is_load;
  input [1:0] opc_type;
  input [3:0] Rx_id, Ry_id, Z_ex;
  output reg [1:0] ifid_ctr, idex_ctr, exmm_ctr, mmwb_ctr;
  output reg [1:0] jmp_type; //00: normal, 01: jmpr, 10: jmpi, 11: int
  
  //always @(posedge clk) begin
  always @(negedge clk) begin
    if (rst) begin
      ifid_ctr <= 2'b00;
      idex_ctr <= 2'b00;
      exmm_ctr <= 2'b00;
      mmwb_ctr <= 2'b00;
      jmp_type <= 2'b00;
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
                  ifid_ctr <= {1'b0, jmp[0]};
                  idex_ctr <= 2'b00;
                  exmm_ctr <= 2'b00;
                  mmwb_ctr <= 2'b00;
                  jmp_type <= {jmp[0] & jmp[1], jmp[0] & (!jmp[1])};
                end              
              end
           endcase
        end
      end else begin //FIXME, interrupt solved here
        ifid_ctr <= 2'b00;
        idex_ctr <= 2'b00;
        exmm_ctr <= 2'b00;
        mmwb_ctr <= 2'b00;
        jmp_type <= 2'b11;      
      end
    end
  end
endmodule
  
  
  