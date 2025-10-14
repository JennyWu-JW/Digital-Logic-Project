//========================================================================
// NotePlayer_RTL
//========================================================================
// Used ChatGPT to instantiate the note player control and counter

`ifndef NOTEPLAYER_RTL_V
`define NOTEPLAYER_RTL_V

`include "Counter_8b_RTL.v"
`include "NotePlayerCtrl_RTL.v"

module NotePlayer_RTL
(
  (* keep=1 *) input  logic       clk,
  (* keep=1 *) input  logic       rst,
  (* keep=1 *) input  logic [7:0] period,
  (* keep=1 *) output logic [3:0] state,
  (* keep=1 *) output logic       note
);

  // Internal signals
  logic       count_done;    // Signal indicating that the countdown has finished
  logic       count_load;    // Signal from control logic to load the counter
  logic [7:0] unused_counter_out;   // Counter output

  // Instantiate the control logic
  NotePlayerCtrl_RTL notectrl (
    .clk        (clk),
    .rst        (rst),
    .count_done (count_done),
    .state      (state),
    .note       (note),
    .count_load (count_load)
  );

  // Instantiate the 8-bit counter
  Counter_8b_RTL counter (
    .clk        (clk),
    .rst        (rst),
    .load       (count_load),    // Load signal from control logic
    .in         (period),        // Input period
    .count      (unused_counter_out),   // Counter output
    .done       (count_done)     // Asserted when the countdown reaches zero
  );

endmodule

`endif /* NOTEPLAYER_RTL_V */

