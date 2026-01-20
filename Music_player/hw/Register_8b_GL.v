//========================================================================
// Register_8b_GL
//========================================================================

`ifndef REGISTER_8B_GL_V
`define REGISTER_8B_GL_V

`include "DFFRE_GL.v"

module Register_8b_GL
(
  (* keep=1 *) input  wire       clk,
  (* keep=1 *) input  wire       rst,
  (* keep=1 *) input  wire       en,
  (* keep=1 *) input  wire [7:0] d,
  (* keep=1 *) output wire [7:0] q
);

  //8 DFFRE with corresponding input and output from and into the array
  DFFRE_GL bit0(
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d[0]),
    .q(q[0])
  );

  DFFRE_GL bit1(
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d[1]),
    .q(q[1])
  );

  DFFRE_GL bit2(
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d[2]),
    .q(q[2])
  );

  DFFRE_GL bit3(
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d[3]),
    .q(q[3])
  );

  DFFRE_GL bit4(
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d[4]),
    .q(q[4])
  );
  
  DFFRE_GL bit5(
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d[5]),
    .q(q[5])
  );

  DFFRE_GL bit6(
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d[6]),
    .q(q[6])
  );

  DFFRE_GL bit7(
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d[7]),
    .q(q[7])
  );

endmodule

`endif /* REGISTER_8B_GL_V */

