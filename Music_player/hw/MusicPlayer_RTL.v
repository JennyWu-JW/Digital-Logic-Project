//========================================================================
// MusicPlayer_RTL
//========================================================================

`ifndef MUSIC_PLAYER_RTL_V
`define MUSIC_PLAYER_RTL_V

`include "MultiNotePlayer_RTL.v"
`include "MusicPlayerCtrl_RTL.v"

module MusicPlayer_RTL
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,
  (* keep=1 *) input  logic  [4:0] song_sel,
  (* keep=1 *) input  logic        start_song,
  (* keep=1 *) output logic  [1:0] state,
  (* keep=1 *) output logic        idle,

  (* keep=1 *) input  logic [15:0] note_duration,
  (* keep=1 *) input  logic  [7:0] note1_period,
  (* keep=1 *) input  logic  [7:0] note2_period,
  (* keep=1 *) input  logic  [7:0] note3_period,
  (* keep=1 *) input  logic  [7:0] note4_period,
  (* keep=1 *) input  logic  [7:0] note5_period,
  (* keep=1 *) input  logic  [7:0] note6_period,
  (* keep=1 *) input  logic  [7:0] note7_period,
  (* keep=1 *) output logic  [2:0] note_sel,
  (* keep=1 *) output logic        note,

  // Memory Interface

  (* keep=1 *) output logic        memreq_val,
  (* keep=1 *) output logic [15:0] memreq_addr,
  (* keep=1 *) input  logic [31:0] memresp_data
);

  wire pload;
  wire [2:0] pnote;
  wire pdone;

  // Instantiated MultiNotePlayer
  MultiNotePlayer_RTL MultiNote(
    .clk(clk),
    .rst(rst),

    .note1_period(note1_period),
    .note2_period(note2_period),
    .note3_period(note3_period),
    .note4_period(note4_period),
    .note5_period(note5_period),
    .note6_period(note6_period),
    .note7_period(note7_period),

    .play_load(pload),
    .play_note(pnote),
    .play_duration(note_duration),
    .play_done(pdone),
    .note_sel(note_sel),
    .note(note)
  );

  // Instantiated MusicPlayerCtrl
  MusicPlayerCtrl_RTL MusicPlayer(
    .clk(clk),
    .rst(rst),
    .song_sel(song_sel),
    .start_song(start_song),
    .state(state),
    .idle(idle),

    // MultiNotePlayer Interface
    .play_note(pnote),
    .play_load(pload),
    .play_done(pdone),

    // Memory Interface
    .memreq_val(memreq_val),
    .memreq_addr(memreq_addr),
    .memresp_data(memresp_data)
  );

endmodule

`endif /* MUSIC_PLAYER_RTL_V */

