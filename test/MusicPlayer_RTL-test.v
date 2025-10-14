//========================================================================
// MusicPlayer_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "ece2300-test-mem.v"
`include "MultiNotePlayer_RTL.v"
`include "MusicPlayer_RTL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk;
  logic reset;

  ece2300_TestUtils t( .* );

  // verilator lint_off UNUSED
  logic        memreq_val;
  logic [15:0] memreq_addr;
  logic        memresp_wait;
  logic [31:0] memresp_data;
  // verilator lint_on UNUSED

  ece2300_TestMem mem( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic        dut_rst;
  logic  [4:0] dut_song_sel;
  logic        dut_start_song;
  logic  [1:0] dut_state;
  logic        dut_idle;
  logic [15:0] dut_note_duration;
  logic  [2:0] dut_note_sel;
  logic        dut_note;

  MusicPlayer_RTL music_player
  (
    .clk           (clk),
    .rst           (reset || dut_rst),
    .song_sel      (dut_song_sel),
    .start_song    (dut_start_song),
    .state         (dut_state),
    .idle          (dut_idle),

    .note_duration (dut_note_duration),
    .note1_period  (8'd1),
    .note2_period  (8'd2),
    .note3_period  (8'd3),
    .note4_period  (8'd4),
    .note5_period  (8'd5),
    .note6_period  (8'd6),
    .note7_period  (8'd7),
    .note_sel      (dut_note_sel),
    .note          (dut_note),

    .memreq_val    (memreq_val),
    .memreq_addr   (memreq_addr),
    .memresp_data  (memresp_data)
  );

  //----------------------------------------------------------------------
  // Instantiate already tested NotePlayers for reference
  //----------------------------------------------------------------------

  logic [3:0] unused_ref_note1_state, unused_ref_note2_state,
              unused_ref_note3_state, unused_ref_note4_state,
              unused_ref_note5_state, unused_ref_note6_state,
              unused_ref_note7_state;

  // verilator lint_off UNUSEDSIGNAL
  logic ref_note1, ref_note2, ref_note3, ref_note4;
  logic ref_note5, ref_note6, ref_note7;
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

  string state_str;
  localparam STATE_RESET     = 2'b00;
  localparam STATE_IDLE      = 2'b01;
  localparam STATE_SET_NOTE  = 2'b10;
  localparam STATE_WAIT_NOTE = 2'b11;

  string mem_str;

  logic ref_note;

  task check
  (
    input logic        rst,
    input logic  [4:0] song_sel,
    input logic        start_song,
    input logic        idle,
    input logic [15:0] note_duration,
    input logic  [2:0] note_sel
  );
    if ( !t.failed ) begin

      dut_rst           = rst;
      dut_song_sel      = song_sel;
      dut_start_song    = start_song;
      dut_note_duration = note_duration;

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

        case ( dut_state )
          STATE_RESET:     state_str = "RESET    ";
          STATE_IDLE:      state_str = "IDLE     ";
          STATE_SET_NOTE:  state_str = "SET_NOTE ";
          STATE_WAIT_NOTE: state_str = "WAIT_NOTE";
          default:         state_str = "?        ";
        endcase

        if ( memreq_val )
          $sformat( mem_str, "rd:%x:%x", memreq_addr, memresp_data );
        else
          mem_str = "                ";

        $display( "%3d: %b %b %b %b %b > %b (%s) %b %b | %s", t.cycles,
                  dut_rst, dut_song_sel, dut_start_song,
                  dut_note_duration, note_sel,
                  dut_state, state_str, dut_idle, dut_note, mem_str );
      end

      `ECE2300_CHECK_EQ( dut_idle,     idle     );
      `ECE2300_CHECK_EQ( dut_note_sel, note_sel );
      `ECE2300_CHECK_EQ( dut_note,     ref_note );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //               addr           data
    mem.set_mem( 16'h0000, 32'h0000_0003 );
    mem.set_mem( 16'h0004, 32'h0000_0001 ); 

    //         song start                note
    //    rst   sel  song idle  duration  sel
    check( 0, 5'h00,    0,   0, 16'h0004,   0 ); // Reset
    check( 0, 5'h00,    0,   1, 16'h0004,   0 ); // Idle
    check( 0, 5'h00,    0,   1, 16'h0004,   0 );
    check( 0, 5'h00,    1,   1, 16'h0004,   0 ); // Start Song

    // Note 1
    check( 0, 5'h00,    0,   0, 16'h0004,   0 ); // Load -> Note 3
    check( 0, 5'h00,    0,   0, 16'h0004,   3 ); // Duration = 0004
    check( 0, 5'h00,    0,   0, 16'h0004,   3 ); // Duration = 0003
    check( 0, 5'h00,    0,   0, 16'h0004,   3 ); // Duration = 0002
    check( 0, 5'h00,    0,   0, 16'h0004,   3 ); // Duration = 0001
    check( 0, 5'h00,    0,   0, 16'h0004,   3 ); // Duration = 0000

    // Note 2
    check( 0, 5'h00,    0,   0, 16'h0004,   0 ); // Load -> Note 1
    check( 0, 5'h00,    0,   0, 16'h0004,   1 ); // Duration = 0004
    check( 0, 5'h00,    0,   0, 16'h0004,   1 ); // Duration = 0003
    check( 0, 5'h00,    0,   0, 16'h0004,   1 ); // Duration = 0002
    check( 0, 5'h00,    0,   0, 16'h0004,   1 ); // Duration = 0001
    check( 0, 5'h00,    0,   0, 16'h0004,   1 ); // Duration = 0000

  endtask

  //----------------------------------------------------------------------
  // test_case_2_song_end
  //----------------------------------------------------------------------

  task test_case_2_song_end();
    t.test_case_begin( "test_case_2_song_end" );

    //               addr           data
    mem.set_mem( 16'h0000, 32'h0000_0003 );
    mem.set_mem( 16'h0004, 32'hffff_ffff );

    //         song start                note
    //    rst   sel  song idle  duration  sel
    check( 0, 5'h00,    0,   0, 16'h0004,   0 ); // Reset
    check( 0, 5'h00,    0,   1, 16'h0004,   0 ); // Idle
    check( 0, 5'h00,    0,   1, 16'h0004,   0 );
    check( 0, 5'h00,    1,   1, 16'h0004,   0 ); // Start Song

    // Note 1
    check( 0, 5'h00,    0,   0, 16'h0004,   0 ); // Load -> Note 3
    check( 0, 5'h00,    0,   0, 16'h0004,   3 ); // Duration = 0004
    check( 0, 5'h00,    0,   0, 16'h0004,   3 ); // Duration = 0003
    check( 0, 5'h00,    0,   0, 16'h0004,   3 ); // Duration = 0002
    check( 0, 5'h00,    0,   0, 16'h0004,   3 ); // Duration = 0001
    check( 0, 5'h00,    0,   0, 16'h0004,   3 ); // Duration = 0000

    // Note 2
    check( 0, 5'h00,    0,   0, 16'h0004,   0 ); // Load -> End Song
    check( 0, 5'h00,    0,   1, 16'h0004,   0 ); // Idle
    check( 0, 5'h00,    0,   1, 16'h0004,   0 );
    check( 0, 5'h00,    0,   1, 16'h0004,   0 );

  endtask

  //----------------------------------------------------------------------
  // test_case_3_reset
  //----------------------------------------------------------------------

  task test_case_3_reset();
    t.test_case_begin( "test_case_3_reset" );

    mem.set_mem( 16'h0000, 32'h0000_0004 );
    mem.set_mem( 16'h0004, 32'h0000_0000 );

    //         song start                note
    //    rst   sel  song idle  duration  sel
    check( 0, 5'h00,    0,   0, 16'h0000,   0 ); // Reset
    check( 0, 5'h00,    0,   1, 16'h0000,   0 ); // Idle
    check( 0, 5'h00,    0,   1, 16'h0000,   0 );
    check( 1, 5'h00,    0,   1, 16'h0000,   0 );
    check( 0, 5'h00,    1,   0, 16'h0000,   0 ); // Reset
    check( 0, 5'h00,    0,   1, 16'h0000,   0 ); // Idle
    check( 0, 5'h00,    0,   1, 16'h0000,   0 );
    check( 0, 5'h00,    1,   1, 16'h0000,   0 ); // Start Song

    // Note 1
    check( 0, 5'h00,    0,   0, 16'h0006,   0 ); // Load -> Note 4
    check( 0, 5'h00,    0,   0, 16'h0000,   4 ); // Duration = 0006
    check( 0, 5'h00,    0,   0, 16'h0000,   4 ); // Duration = 0005
    check( 0, 5'h00,    0,   0, 16'h0000,   4 ); // Duration = 0004
    check( 1, 5'h00,    0,   0, 16'h0000,   4 ); // Duration = 0003
    check( 0, 5'h00,    1,   0, 16'h0000,   0 ); // Reset
    check( 0, 5'h00,    0,   1, 16'h0000,   0 ); // Idle
    check( 0, 5'h00,    0,   1, 16'h0000,   0 );
    check( 0, 5'h00,    1,   1, 16'h0000,   0 ); // Start Song
    check( 0, 5'h00,    0,   0, 16'h0003,   0 ); // Load -> Note 4
    check( 0, 5'h00,    0,   0, 16'h0000,   4 ); // Duration = 0003
    check( 0, 5'h00,    0,   0, 16'h0000,   4 ); // Duration = 0002
    check( 0, 5'h00,    0,   0, 16'h0000,   4 ); // Duration = 0001
    check( 0, 5'h00,    0,   0, 16'h0000,   4 ); // Duration = 0000

    // Note 2
    check( 0, 5'h00,    0,   0, 16'h0003,   0 ); // Load -> Note 0
    check( 0, 5'h00,    0,   0, 16'h0000,   0 ); // Duration = 0003
    check( 0, 5'h00,    0,   0, 16'h0000,   0 ); // Duration = 0002
    check( 0, 5'h00,    0,   0, 16'h0000,   0 ); // Duration = 0001
    check( 0, 5'h00,    0,   0, 16'h0000,   0 ); // Duration = 0000

  endtask

  //----------------------------------------------------------------------
  // test_case_4_addr_offset
  //----------------------------------------------------------------------

  task test_case_4_addr_offset();
    t.test_case_begin( "test_case_4_addr_offset" );

    mem.set_mem( 16'h0600, 32'h0000_0005 );
    mem.set_mem( 16'h0604, 32'h0000_0007 );

    //         song start                note
    //    rst   sel  song idle  duration  sel
    check( 0, 5'h03,    0,   0, 16'h0000,   0 ); // Reset
    check( 0, 5'h03,    0,   1, 16'h0000,   0 ); // Idle
    check( 0, 5'h03,    0,   1, 16'h0000,   0 );
    check( 0, 5'h03,    1,   1, 16'h0000,   0 ); // Start Song

    // Note 1
    check( 0, 5'h03,    0,   0, 16'h0007,   0 ); // Load -> Note 5
    check( 0, 5'h03,    0,   0, 16'h0000,   5 ); // Duration = 0007
    check( 0, 5'h03,    0,   0, 16'h0000,   5 ); // Duration = 0006
    check( 0, 5'h03,    0,   0, 16'h0000,   5 ); // Duration = 0005
    check( 0, 5'h03,    0,   0, 16'h0000,   5 ); // Duration = 0004
    check( 0, 5'h03,    0,   0, 16'h0000,   5 ); // Duration = 0003
    check( 0, 5'h03,    0,   0, 16'h0000,   5 ); // Duration = 0002
    check( 0, 5'h03,    0,   0, 16'h0000,   5 ); // Duration = 0001
    check( 0, 5'h03,    0,   0, 16'h0000,   5 ); // Duration = 0000

    // Note 2
    check( 0, 5'h03,    0,   0, 16'h0002,   0 ); // Load -> Note 7
    check( 0, 5'h03,    0,   0, 16'h0000,   7 ); // Duration = 0002
    check( 0, 5'h03,    0,   0, 16'h0000,   7 ); // Duration = 0001
    check( 0, 5'h03,    0,   0, 16'h0000,   7 ); // Duration = 0000

  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_song_end();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_reset();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_addr_offset();

    t.test_bench_end();
  end

endmodule

