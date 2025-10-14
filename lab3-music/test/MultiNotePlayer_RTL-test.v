//========================================================================
// MultiNotePlayer_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "MultiNotePlayer_RTL.v"
`include "NotePlayer_RTL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk;
  logic reset;

  ece2300_TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic        dut_rst;
  logic        dut_play_load;
  logic  [2:0] dut_play_note;
  logic [15:0] dut_play_duration;
  logic        dut_play_done;
  logic  [2:0] dut_note_sel;
  logic        dut_note;

  MultiNotePlayer_RTL multi_note_player
  (
    .clk           (clk),
    .rst           (reset || dut_rst),

    .note1_period  (8'd1),
    .note2_period  (8'd2),
    .note3_period  (8'd3),
    .note4_period  (8'd4),
    .note5_period  (8'd5),
    .note6_period  (8'd6),
    .note7_period  (8'd7),

    .play_load     (dut_play_load),
    .play_note     (dut_play_note),
    .play_duration (dut_play_duration),
    .play_done     (dut_play_done),
    .note_sel      (dut_note_sel),
    .note          (dut_note)
  );

  //----------------------------------------------------------------------
  // Instantiate already tested NotePlayers for reference
  //----------------------------------------------------------------------

  logic [3:0] unused_ref_note1_state, unused_ref_note2_state,
              unused_ref_note3_state, unused_ref_note4_state,
              unused_ref_note5_state, unused_ref_note6_state,
              unused_ref_note7_state;

  // verilator lint_off UNUSEDSIGNAL
  logic       ref_note1, ref_note2, ref_note3, ref_note4,
              ref_note5, ref_note6, ref_note7;
  // verilator lint_on UNUSEDSIGNAL

  NotePlayer_RTL ref_note1_player
  (
    .clk    (clk),
    .rst    (reset || dut_rst),
    .period (8'd1),
    .state  (unused_ref_note1_state),
    .note   (ref_note1)
  );

  NotePlayer_RTL ref_note2_player
  (
    .clk    (clk),
    .rst    (reset || dut_rst),
    .period (8'd2),
    .state  (unused_ref_note2_state),
    .note   (ref_note2)
  );

  NotePlayer_RTL ref_note3_player
  (
    .clk    (clk),
    .rst    (reset || dut_rst),
    .period (8'd3),
    .state  (unused_ref_note3_state),
    .note   (ref_note3)
  );

  NotePlayer_RTL ref_note4_player
  (
    .clk    (clk),
    .rst    (reset || dut_rst),
    .period (8'd4),
    .state  (unused_ref_note4_state),
    .note   (ref_note4)
  );

  NotePlayer_RTL ref_note5_player
  (
    .clk    (clk),
    .rst    (reset || dut_rst),
    .period (8'd5),
    .state  (unused_ref_note5_state),
    .note   (ref_note5)
  );

  NotePlayer_RTL ref_note6_player
  (
    .clk    (clk),
    .rst    (reset || dut_rst),
    .period (8'd6),
    .state  (unused_ref_note6_state),
    .note   (ref_note6)
  );

  NotePlayer_RTL ref_note7_player
  (
    .clk    (clk),
    .rst    (reset || dut_rst),
    .period (8'd7),
    .state  (unused_ref_note7_state),
    .note   (ref_note7)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  logic ref_note;

  task check
  (
    input logic        rst,
    input logic        play_load,
    input logic  [2:0] play_note,
    input logic [15:0] play_duration,
    input logic        play_done,
    input logic  [2:0] note_sel
  );
    if ( !t.failed ) begin

      dut_rst           = rst;
      dut_play_note     = play_note;
      dut_play_duration = play_duration;
      dut_play_load     = play_load;

      if( note_sel == 0 )
        ref_note = 1'b0;
      else if( note_sel == 1 )
        ref_note = ref_note1;
      else if( note_sel == 2 )
        ref_note = ref_note2;
      else if( note_sel == 3 )
        ref_note = ref_note3;
      else if( note_sel == 4 )
        ref_note = ref_note4;
      else if( note_sel == 5 )
        ref_note = ref_note5;
      else if( note_sel == 6 )
        ref_note = ref_note6;
      else
        ref_note = ref_note7;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %b %b %b > %b %b %b", t.cycles,
                  dut_rst, dut_play_load, dut_play_note,
                  dut_play_duration, dut_play_done,
                  dut_note_sel, dut_note );
      end

      `ECE2300_CHECK_EQ( dut_play_done, play_done );
      `ECE2300_CHECK_EQ( dut_note_sel,  note_sel  );
      `ECE2300_CHECK_EQ( dut_note,      ref_note  );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //        play play    play                     play note
    //    rst load note    duration                 done sel
    check( 0, 1,   3'b001, 16'b0000_0000_0000_0010, 1,   3'd0 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,   3'd1 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,   3'd1 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 1,   3'd1 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 1,   3'd0 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 1,   3'd0 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 1,   3'd0 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_extended
  //----------------------------------------------------------------------

  task test_case_2_extended();
    t.test_case_begin( "test_case_2_extended" );

    // Play note 2 for 4 cycles
    //        play play    play                     play note
    //    rst load note    duration                 done sel
    check( 0, 1,   3'b010, 16'b0000_0000_0000_0100, 1,  3'd0 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd2 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd2 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd2 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd2 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 1,  3'd2 );

    // Test the rest condition for 3 cycles
    //        play play    play                     play note
    //    rst load note    duration                 done sel
    check( 0, 1,   3'b000, 16'b0000_0000_0000_0011, 1,  3'd0 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd0 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd0 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd0 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 1,  3'd0 );

    // Play note 7 for 1 cycle
    //        play play    play                     play note
    //    rst load note    duration                 done sel
    check( 0, 1,   3'b111, 16'b0000_0000_0000_0001, 1,  3'd0 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd7 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 1,  3'd7 );

  endtask

  //----------------------------------------------------------------------
  // test_case_3_varied_notes
  //----------------------------------------------------------------------

  task test_case_3_varied_notes();
    t.test_case_begin("test_case_3_varied_notes");

    // Test minimum duration (1 cycle) for note 1
    //        play play    play                     play note
    //    rst load note    duration                 done sel
    check( 0, 1,   3'b001, 16'b0000_0000_0000_0001, 1,  3'd0 ); // Start note 1 for 1 cycle
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd1 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 1,  3'd1 ); 

    // Test note 3 for a random duration (8 cycles)
    //        play play    play                     play note
    //    rst load note    duration                 done sel
    check( 0, 1,   3'b011, 16'b0000_0000_0000_1000, 1,  3'd0 ); // Start note 3 for 8 cycles
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd3 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd3 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd3 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd3 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd3 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd3 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd3 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 0,  3'd3 );
    check( 0, 0,   3'b000, 16'b0000_0000_0000_0000, 1,  3'd3 );

  endtask

  //----------------------------------------------------------------------
  // test_case_4_reset_handling
  //----------------------------------------------------------------------

  task test_case_4_reset_handling();
    t.test_case_begin("test_case_4_reset_handling");

    // Test reset behavior at the start
    //        play play    play                     play note
    //    rst load note    duration                 done sel
    check( 0, 1, 3'b010,   16'b0000_0000_0000_0100, 1,  3'd0 ); // Play note 2 for 4 cycles
    check( 0, 0, 3'b000,   16'b0000_0000_0000_0000, 0,  3'd2 );
    check( 1, 0, 3'b000,   16'b0000_0000_0000_0000, 0,  3'd2 ); // Apply reset
    check( 0, 0, 3'b000,   16'b0000_0000_0000_0000, 1,  3'd0 );
    
    // Test reset during playback
    //        play play    play                     play note
    //    rst load note    duration                 done sel
    check( 0, 1, 3'b011,   16'b0000_0000_0000_0110, 1,  3'd0 ); // Start note 3 for 6 cycles
    check( 0, 0, 3'b000,   16'b0000_0000_0000_0000, 0,  3'd3 );
    check( 1, 0, 3'b000,   16'b0000_0000_0000_0000, 0,  3'd3 ); // Apply reset during playback
    check( 0, 0, 3'b000,   16'b0000_0000_0000_0000, 1,  3'd0 ); // Check if reset cleared playback

  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_extended();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_varied_notes();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_reset_handling();

    t.test_bench_end();
  end

endmodule

