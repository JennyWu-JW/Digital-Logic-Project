//========================================================================
// MusicPlayerCtrl_RTL
//========================================================================

`ifndef MUSIC_PLAYER_CTRL_RTL_V
`define MUSIC_PLAYER_CTRL_RTL_V

`include "Register_8b_RTL.v"
`include "Register_16b_RTL.v"

module MusicPlayerCtrl_RTL
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,
  (* keep=1 *) input  logic  [4:0] song_sel,
  (* keep=1 *) input  logic        start_song,
  (* keep=1 *) output logic  [1:0] state,
  (* keep=1 *) output logic        idle,

  // MultiNotePlayer Interface

  (* keep=1 *) output logic  [2:0] play_note,
  (* keep=1 *) output logic        play_load,
  (* keep=1 *) input  logic        play_done,

  // Memory Interface

  (* keep=1 *) output logic        memreq_val,
  (* keep=1 *) output logic [15:0] memreq_addr,
  (* keep=1 *) input  logic [31:0] memresp_data
);

  // You must use the following state encoding.

  localparam STATE_RESET     = 2'b00;
  localparam STATE_IDLE      = 2'b01;
  localparam STATE_SET_NOTE  = 2'b10;
  localparam STATE_WAIT_NOTE = 2'b11;

  // Instantiate Two DFFRE for two bits of state
  logic [1:0] state_next;

  DFFRE_RTL statebit0(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(state_next[0]),
    .q(state[0])
  );

  DFFRE_RTL statebit1(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(state_next[1]),
    .q(state[1])
  );

  logic [15:0] next_mem_addr;
  logic [15:0] current;
  assign memreq_addr = current;

  // Register for storing memory
  Register_16b_RTL Register(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(next_mem_addr),
    .q(current)  
  );

  // Signal for when song is over
  logic end_song;

  always_comb begin
    end_song = 1'b0;
    case (memresp_data)
      32'h00000000: play_note = 3'b000; // REST
      32'h00000001: play_note = 3'b001; // NOTE_G
      32'h00000002: play_note = 3'b010; // NOTE_A
      32'h00000003: play_note = 3'b011; // NOTE_B
      32'h00000004: play_note = 3'b100; // NOTE_C
      32'h00000005: play_note = 3'b101; // NOTE_D
      32'h00000006: play_note = 3'b110; // NOTE_E
      32'h00000007: play_note = 3'b111; // NOTE_F
      32'hffffffff: end_song = 1'b1; // SONG_END (mapped to own signal)
      default:      play_note = 3'b000; // Default to REST
    endcase
  end

  // memory transitions
  always_comb begin
    if (state == STATE_IDLE)
      next_mem_addr = { 2'b0, song_sel, 9'b0 };
    else if (state == STATE_SET_NOTE)
      next_mem_addr = memreq_addr + 16'd4;
    else
      next_mem_addr = memreq_addr;
  end

  // output signals
  always_comb begin
    idle = (state == STATE_IDLE);
    play_load = (state == STATE_SET_NOTE) & !end_song;
    memreq_val = (state == STATE_SET_NOTE);
  end

  // Always comb block for States 
  always_comb begin

    // state transitions from state Idle
    if ( STATE_IDLE == state ) begin // 2'b01
      if (start_song) begin
        state_next= STATE_SET_NOTE;
      end
      else
        state_next = STATE_IDLE;
    end

    // state transitions from State Setnote
    else if ( STATE_SET_NOTE == state) begin // 2'b10
      if ( end_song )
        state_next = STATE_IDLE;
      else
        state_next = STATE_WAIT_NOTE;
    end 

    // state transitions from state WaitNote
    else if (STATE_WAIT_NOTE == state) begin // 2'b11
      if (~play_done)
        state_next = STATE_WAIT_NOTE;
      else
        state_next = STATE_SET_NOTE;
    end

    // state transitions from Reset state
    else if (STATE_RESET == state) begin
      state_next = STATE_IDLE;
    end

    // state transition default to Reset State
    else begin
      state_next = STATE_RESET;
    end
  end

endmodule

`endif /* MUSIC_PLAYER_CTRL_RTL_V */

