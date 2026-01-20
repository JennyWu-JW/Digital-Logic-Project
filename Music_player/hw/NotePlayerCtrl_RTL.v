//========================================================================
// NotePlayerCtrl_RTL
//========================================================================

`ifndef NOTE_PLAYER_CTRL_RTL_V
`define NOTE_PLAYER_CTRL_RTL_V

`include "DFFRE_RTL.v"

module NotePlayerCtrl_RTL
(
  (* keep=1 *) input  logic       clk,
  (* keep=1 *) input  logic       rst,
  (* keep=1 *) input  logic       count_done,
  (* keep=1 *) output logic [3:0] state,
  (* keep=1 *) output logic       note,
  (* keep=1 *) output logic       count_load
);

  // You must use the following state encoding.

  // verilator lint_off UNUSEDPARAM
  localparam STATE_RESET     = 4'b0000;
  localparam STATE_LOAD_HIGH = 4'b1000;
  localparam STATE_WAIT_HIGH = 4'b0100;
  localparam STATE_LOAD_LOW  = 4'b0010;
  localparam STATE_WAIT_LOW  = 4'b0001;
  // verilator lint_on UNUSEDPARAM

  // Instantiated 4 DFFRE for each state of wait and load
  logic load_high_next, load_high;

  DFFRE_RTL load_high_dff(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(load_high_next),
    .q(load_high)
  );

  logic wait_high_next, wait_high;
  
  DFFRE_RTL wait_high_dff(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(wait_high_next),
    .q(wait_high)
  );

  logic load_low_next, load_low;
  
  DFFRE_RTL load_low_dff(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(load_low_next),
    .q(load_low)
  );

  logic wait_low_next, wait_low;
  
  DFFRE_RTL wait_low_dff(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(wait_low_next),
    .q(wait_low)
  );

  // state transition 
  always_comb begin

    load_high_next = 0;
    wait_high_next = 0;
    load_low_next = 0;
    wait_low_next = 0;

    // state transitions from state Load High
    if ( load_high ) begin
        wait_high_next = 1;
    end

    // state transitions from Wait High
    else if ( wait_high ) begin
      if ( count_done )
        load_low_next = 1;
      else
        wait_high_next = 1;
    end

    // state transitions from state Load Low
    else if ( load_low ) begin
        wait_low_next = 1;
    end

    // state transitions from state Wait Low
    else if ( wait_low ) begin
      if ( count_done )
        load_high_next = 1;
      else
        wait_low_next = 1;
    end

    // state transitions from reset state
    else begin
      load_high_next = 1;
    end

  end

  // output signals
  always_comb begin

    note       = 1'b0;
    count_load = 1'b0;
    state      = 4'b0000;

    if ( load_high ) begin
      note = 1;
      count_load = 1;
      state = 4'b1000;
    end
    
    else if ( wait_high ) begin
      note = 1;
      count_load = 0;
      state = 4'b0100;
    end

    else if ( load_low ) begin
      note = 0;
      count_load = 1;
      state = 4'b0010;
    end

    else if ( wait_low ) begin
      note = 0;
      count_load = 0;
      state = 4'b0001;
    end

  end

endmodule

`endif // NOTEPLAYER_CTRL_RTL
