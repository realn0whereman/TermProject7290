module forward(clk, EX_ex, RW_mm, RW_wb, Z_mm, Z_wb, Y_ex, X_ex, p1_mux, p2_mux, r1_mux, r2_mux, f1_mux, f2_mux);
  input clk;
  input [6:0] EX_ex;
  input [2:0] RW_mm; //2:F, 1:I, 0:P
  input RW_wb; //I
  input [3:0] Z_mm;
  input [3:0] Z_wb;
  input [3:0] Y_ex;
  input [3:0] X_ex;
  
  output p1_mux;
  output p2_mux;
  output [1:0] r1_mux;
  output [1:0] r2_mux;
  output f1_mux;
  output f2_mux;  
  
  reg p1_mux_r;
  reg p2_mux_r;
  reg [1:0] r1_mux_r;
  reg [1:0] r2_mux_r;
  reg f1_mux_r;
  reg f2_mux_r;
  
  always @(*) begin
  //always @(posedge clk) begin
    //pred/fpu pipeline forward
    if (Z_mm == Y_ex) begin
      p1_mux_r = RW_mm[0];
      f1_mux_r= RW_mm[2];
    end else begin
      p1_mux_r = 1'b0;
      f1_mux_r = 1'b0;
    end
    if (Z_mm == X_ex) begin
      p2_mux_r = RW_mm[0];
      f2_mux_r = RW_mm[2];
    end else begin
      p2_mux_r = 1'b0;
      f2_mux_r = 1'b0;
    end
    
    //integer pipeline
    //src1, 00:normal, 01:EX forward, 10:MEM forward, 11:PC addr
    //src2, 00:REG, 01:EX forward, 10:MEM forward, 11:IMM
    if (EX_ex[6] == 1'b1) begin
      r1_mux_r = 2'b11;
    end else if (Z_mm == Y_ex) begin
      r1_mux_r = {1'b0, RW_mm[1]};
    end else if (Z_wb == Y_ex) begin
      r1_mux_r = {RW_wb, 1'b0};
    end else begin
      r1_mux_r = 2'b00;
    end
    if (EX_ex[5] == 1'b1) begin
      r2_mux_r = 2'b11;
    end else if (Z_mm == X_ex) begin
      r2_mux_r = {1'b0, RW_mm[1]};
    end else if (Z_wb == X_ex) begin
      r2_mux_r = {RW_wb, 1'b0};
    end else begin
      r2_mux_r = 2'b00;
    end    
  end
  
  assign p1_mux = (EX_ex[4:0] == 5'b0) ? 2'b00 : p1_mux_r;
  assign p2_mux = (EX_ex[4:0] == 5'b0) ? 2'b00 : p2_mux_r;
  assign r1_mux = (EX_ex[4:0] == 5'b0) ? 2'b00 : r1_mux_r;
  assign r2_mux = (EX_ex[4:0] == 5'b0) ? 2'b00 : r2_mux_r;
  assign f1_mux = (EX_ex[4:0] == 5'b0) ? 2'b00 : f1_mux_r;
  assign f2_mux = (EX_ex[4:0] == 5'b0) ? 2'b00 : f2_mux_r;
endmodule