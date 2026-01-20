//========================================================================
// NotePlayer_GL
//========================================================================

`ifndef NOTEPLAYER_GL_V
`define NOTEPLAYER_GL_V

`include "Counter_8b_GL.v"
`include "NotePlayerCtrl_GL.v"

module NotePlayer_GL
(
  (* keep=1 *) input  wire       clk,
  (* keep=1 *) input  wire       rst,
  (* keep=1 *) input  wire [7:0] period,
  (* keep=1 *) output wire [3:0] state,
  (* keep=1 *) output wire       note
);
wire count_load;
wire count_done;
wire [7:0] unused;

//Instatuated the Counter
Counter_8b_GL CountDown(
  .clk(clk),
  .rst(rst),
  .load(count_load),
  .in(period),
  .count(unused),
  .done(count_done)
);

//Instatuated the NotePlayerCtrl
NotePlayerCtrl_GL NoteCtrl(
  .clk(clk),
  .rst(rst),
  .count_done(count_done),
  .state(state),
  .note(note),
  .count_load(count_load)
);

endmodule

`endif /* NOTEPLAYER_GL_V */

