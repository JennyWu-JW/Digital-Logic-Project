//========================================================================
// MultiNotePlayer_RTL
//========================================================================

`ifndef MULTI_NOTE_PLAYER_RTL_V
`define MULTI_NOTE_PLAYER_RTL_V

`include "Counter_16b_RTL.v"
`include "Mux2_8b_RTL.v"
`include "Register_8b_RTL.v"
`include "NotePlayer_RTL.v"
`include "Mux8_1b_RTL.v"

module MultiNotePlayer_RTL
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  (* keep=1 *) input  logic  [7:0] note1_period,
  (* keep=1 *) input  logic  [7:0] note2_period,
  (* keep=1 *) input  logic  [7:0] note3_period,
  (* keep=1 *) input  logic  [7:0] note4_period,
  (* keep=1 *) input  logic  [7:0] note5_period,
  (* keep=1 *) input  logic  [7:0] note6_period,
  (* keep=1 *) input  logic  [7:0] note7_period,

  (* keep=1 *) input  logic        play_load,
  (* keep=1 *) input  logic  [2:0] play_note,
  (* keep=1 *) input  logic [15:0] play_duration,
  (* keep=1 *) output logic        play_done,
  (* keep=1 *) output logic  [2:0] note_sel,
  (* keep=1 *) output logic        note
);

  logic [15:0] count_unused;
  logic countdown_done;

  // Instantiate counter that counts down for certain duration and then outputs when it is done when 
  // there is a load
  Counter_16b_RTL counter_down_counter(
    .clk(clk),
    .rst(rst),
    .load(play_load),
    .in(play_duration),
    .count(count_unused),
    .done(countdown_done)
  );

  assign play_done = countdown_done;
  
  logic [7:0] desired_note;

  // Mux that will output 1-7 in 8 bit binary corresponding to a note if play_load is 
  // high, otherwise 0 (rest)
  Mux2_8b_RTL playnote_mux(
    .in0(8'b0000_0000),
    .in1({5'b0_0000, play_note}),
    .sel(play_load),
    .out(desired_note)
  );


  logic [7:0] note_played;

  // Register that outputs (based on input from prior cycle) when either play_load if high 
  // or if countdown is finished
  Register_8b_RTL reg8(
    .clk(clk),
    .rst(rst),
    .en(play_load | countdown_done),
    .d(desired_note),
    .q(note_played)
  );

  // Displays the note played, with a 1 cycle due to register
  assign note_sel = note_played[2:0];

  logic note1, note2, note3, note4, note5, note6, note7;
  logic [3:0] unused_state1;
  logic [3:0] unused_state2;
  logic [3:0] unused_state3;
  logic [3:0] unused_state4;
  logic [3:0] unused_state5;
  logic [3:0] unused_state6;
  logic [3:0] unused_state7;

  // Instantiate 7 note players for notes 1 through 7 with corresponding periods
  NotePlayer_RTL np1(
    .clk(clk),
    .rst(rst),
    .period(note1_period),
    .state(unused_state1),
    .note(note1)
  );
  
  NotePlayer_RTL np2(
    .clk(clk),
    .rst(rst),
    .period(note2_period),
    .state(unused_state2),
    .note(note2)
  );

  NotePlayer_RTL np3(
    .clk(clk),
    .rst(rst),
    .period(note3_period),
    .state(unused_state3),
    .note(note3)
  );

  NotePlayer_RTL np4(
    .clk(clk),
    .rst(rst),
    .period(note4_period),
    .state(unused_state4),
    .note(note4)
  );

  NotePlayer_RTL np5(
    .clk(clk),
    .rst(rst),
    .period(note5_period),
    .state(unused_state5),
    .note(note5)
  );
  
  NotePlayer_RTL np6(
    .clk(clk),
    .rst(rst),
    .period(note6_period),
    .state(unused_state6),
    .note(note6)
  );

  NotePlayer_RTL np7(
    .clk(clk),
    .rst(rst),
    .period(note7_period),
    .state(unused_state7),
    .note(note7)
  );

  // Mux that outputs the note based on the play_note input through a 3 bit selector that represents 
  // 0-7 corresponding to the note, register results in a 1 cycle delay in the correct output
  Mux8_1b_RTL desirednote_mux(
    .in0(1'b0),
    .in1(note1),
    .in2(note2),
    .in3(note3),
    .in4(note4),
    .in5(note5),
    .in6(note6),
    .in7(note7),
    .sel(note_played[2:0]),
    .out(note)
  );

  // Only 3 least significant used to select note, remaining assigned to unused
  logic [4:0] unused_note_played;
  assign unused_note_played = note_played[7:3];

endmodule

`endif /* MULTI_NOTE_PLAYER_RTL_V */

