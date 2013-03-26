module pipeline_ctrl(rst, clk, pval, opcode, ctrl, ifid_ctr, idex_ctr, exmm_ctr, mmwb_ctr);
  input rst;
  input clk;
  input pval;
  input [5:0] opcode; //multi-cycle ops, INT
  input [2:0] ctrl; //interrupt, 0:ID (illegal), 1:EX(divided by 0): 0: normal, 1:interrupt; 2:MEM(lsq full) 0:normal, 1:full.
  output reg [1:0] ifid_ctr, idex_ctr, exmm_ctr, mmwb_ctr;
  
  //always @(posedge clk) begin
  always @(negedge clk) begin
    if (rst) begin
      ifid_ctr <= 2'b00;
      idex_ctr <= 2'b00;
      exmm_ctr <= 2'b00;
      mmwb_ctr <= 2'b00;
    end else begin
      if (pval) begin
        case ({ctrl, opcode})
          //9'b000_000000,
          default:
            begin
              ifid_ctr <= 2'b00;
              idex_ctr <= 2'b00;
              exmm_ctr <= 2'b00;
              mmwb_ctr <= 2'b00;              
            end
         endcase
      end else begin
        ifid_ctr <= 2'b00;
        idex_ctr <= 2'b01;
        exmm_ctr <= 2'b00;
        mmwb_ctr <= 2'b00;
      end
    end
  end
endmodule
  
  
  