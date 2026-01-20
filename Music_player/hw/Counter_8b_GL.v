//========================================================================
// Counter_8b_GL
//========================================================================

`ifndef COUNTER_8B_GL_V
`define COUNTER_8B_GL_V

`include "Subtractor_8b_GL.v"
`include "Register_8b_GL.v"
`include "Mux2_8b_GL.v"

module Counter_8b_GL
(
  (* keep=1 *) input  wire       clk,
  (* keep=1 *) input  wire       rst,
  (* keep=1 *) input  wire       load,
  (* keep=1 *) input  wire [7:0] in,
  (* keep=1 *) output wire [7:0] count,
  (* keep=1 *) output wire       done
);

  wire [7:0] mux1out;
  wire [7:0] muxload;
  wire [7:0] registerfin;
  wire [7:0] count1step;

  // max that resets
  Mux2_8b_GL mux1(
    .in0(count1step),
    .in1(8'b00000000),
    .sel(done),
    .out(mux1out)
  );

  //mux that loads in 
  Mux2_8b_GL mux2(
    .in0(mux1out),
    .in1(in),
    .sel(load),
    .out(muxload)
  );

  // register from mux load to subtractor
  Register_8b_GL register(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(muxload),
    .q(registerfin)
  );

  // subtract 1 from register output
  Subtractor_8b_GL Subtractor1(
    .in0(registerfin),
    .in1(8'b00000001),
    .diff(count1step)
  );

  // assign output from register to count (current state)
  assign count = registerfin;

  // assign done output with nor of each but of registerfin 
  nor(done, registerfin[0],registerfin[1],registerfin[2],registerfin[3],registerfin[4],registerfin[5], registerfin[6], registerfin[7]);


endmodule

`endif /* COUNTER_8B_GL_V */

