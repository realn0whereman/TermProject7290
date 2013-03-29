module forward(clk, EX_id, RW_ex, RW_mm, Z_ex, Z_mm, Y_id, X_id, p1_mux, p2_mux, r1_mux, r2_mux, f1_mux, f2_mux);
  input clk;
  input [1:0] EX_id;
  input [2:0] RW_ex; //2:F, 1:I, 0:P
  input RW_mm; //I
  input [3:0] Z_ex;
  input [3:0] Z_mm;
  input [3:0] Y_id;
  input [3:0] X_id;
  output reg p1_mux;
  output reg p2_mux;
  output reg [1:0] r1_mux;
  output reg [1:0] r2_mux;
  output reg f1_mux;
  output reg f2_mux;
  
  always @(posedge clk) begin
    //pred/fpu pipeline forward
    if (Z_ex == Y_id) begin
      p1_mux = RW_ex[0];
      f1_mux = RW_ex[2];
    end else begin
      p1_mux = 1'b0;
      f1_mux = 1'b0;
    end
    if (Z_ex == X_id) begin
      p2_mux = RW_ex[0];
      f2_mux = RW_ex[2];
    end else begin
      p2_mux = 1'b0;
      f2_mux = 1'b0;
    end
    
    //integer pipeline
    //src1, 00:normal, 01:EX forward, 10:MEM forward, 11:PC addr
    //src2, 00:REG, 01:EX forward, 10:MEM forward, 11:IMM
    if (EX_id[1] == 1'b1) begin
      r1_mux = 2'b11;
    end else if (Z_ex == Y_id) begin
      r1_mux = {1'b0, RW_ex[1]};
    end else if (Z_mm == Y_id) begin
      r1_mux = {RW_mm, 1'b0};
    end else begin
      r1_mux = 2'b00;
    end
    if (EX_id[0] == 1'b1) begin
      r2_mux = 2'b11;
    end else if (Z_ex == X_id) begin
      r2_mux = {1'b0, RW_ex[1]};
    end else if (Z_mm == X_id) begin
      r2_mux = {RW_mm, 1'b0};
    end else begin
      r2_mux = 2'b00;
    end    
  end
endmodule