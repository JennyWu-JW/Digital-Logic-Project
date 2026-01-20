//========================================================================
// NotePlayerCtrl_GL
//========================================================================

`ifndef NOTE_PLAYER_CTRL_GL_V
`define NOTE_PLAYER_CTRL_GL_V

`include "DFFRE_GL.v"
`include "Counter_8b_GL.v"
`include "Mux2_1b_GL.v"

module NotePlayerCtrl_GL
(
  (* keep=1 *) input  wire       clk,
  (* keep=1 *) input  wire       rst,
  (* keep=1 *) input  wire       count_done,
  (* keep=1 *) output wire [3:0] state,
  (* keep=1 *) output wire       note,
  (* keep=1 *) output wire       count_load
);

  // You must use the following state encoding.

  // verilator lint_off UNUSEDPARAM
  localparam STATE_RESET     = 4'b0000;
  localparam STATE_LOAD_HIGH = 4'b1000;
  localparam STATE_WAIT_HIGH = 4'b0100;
  localparam STATE_LOAD_LOW  = 4'b0010;
  localparam STATE_WAIT_LOW  = 4'b0001;
  // verilator lint_on UNUSEDPARAM

  // created wires for current and next states
  wire load_high;
  wire load_low;
  wire wait_high;
  wire wait_low;
  wire reset_state;

  wire LH_next;
  wire LL_next;
  wire WH_next;
  wire WL_next;
  
  // assigning the states as a wire
  assign state[3] = load_high;
  assign state[2] = wait_high;
  assign state[1] = load_low;
  assign state[0] = wait_low;
  assign reset_state = ~( load_high | load_low | wait_high | wait_low);

  //all the next states
  assign LH_next = reset_state|(wait_low & count_done);
  assign WH_next = load_high|(~count_done & wait_high);
  assign LL_next = wait_high & count_done;
  assign WL_next = load_low | (wait_low & ~count_done);
  
  //state load high
  DFFRE_GL DFlipFlop1(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(LH_next),
    .q(load_high)
  );

  //state wait high
  DFFRE_GL DFlipFlop2(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(WH_next),
    .q(wait_high)
  );

  // state load low
  DFFRE_GL DFlipFlop3(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(LL_next),
    .q(load_low)
  );

  //state wait low  
  DFFRE_GL DFlipFlop4(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(WL_next),
    .q(wait_low)
  );

  assign count_load = (load_high | load_low);
  assign note = (wait_high | load_high);

endmodule

`endif /* NOTE_PLAYER_CTRL_GL_V */

