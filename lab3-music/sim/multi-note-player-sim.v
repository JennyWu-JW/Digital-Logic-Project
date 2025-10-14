//========================================================================
// note-player-sim +switches=000
//========================================================================
// Author : Christopher Batten (Cornell)
// Date   : September 7, 2024
//
// Here is the mapping from switch inputs to notes:
//
//              period period    freq
// sw  hex  dec (cycs)   (ms)    (Hz) note
// 000                                rest
// 001 0x7b 123    250   5.12  195.31 G3
// 010 0x6d 109    222   4.55  219.95 A3
// 011 0x61  97    198   4.06  246.61 B3
// 100 0x5b  91    186   3.81  262.52 C4
// 101 0x51  81    166   3.40  294.15 D4
// 110 0x48  72    148   3.03  329.92 E4
// 111 0x44  68    140   2.87  348.77 F4
//

// We use a timescale of 10s so that means the cycle time in Verilog
// timeunit is 20480/10 = 2048

`timescale 10ns/1ns
`define CYCLE_TIME 2048

`include "MultiNotePlayer_RTL.v"
`include "Display_GL.v"

//========================================================================
// SevenSegFL
//========================================================================
// Functional level model of a seven segment display.

module SevenSegFL
(
  input [6:0] in
);

  task write_row( int row_idx );

    if ( row_idx == 0 ) begin
      if ( ~in[0] )
        $write( " === " );
      else
        $write( "     " );
    end

    else if (( row_idx == 1 ) || ( row_idx == 2 )) begin

      if ( ~in[5] )
        $write( "|" );
      else
        $write( " " );

      $write( "   " );

      if ( ~in[1] )
        $write( "|" );
      else
        $write( " " );
    end

    else if ( row_idx == 3 ) begin
      if ( ~in[6] )
        $write( " === " );
      else
        $write( "     " );
    end

    else if (( row_idx == 4 ) || ( row_idx == 5 )) begin

      if ( ~in[4] )
        $write( "|" );
      else
        $write( " " );

      $write( "   " );

      if ( ~in[2] )
        $write( "|" );
      else
        $write( " " );
    end

    else if ( row_idx == 6 ) begin
      if ( ~in[3] )
        $write( " === " );
      else
        $write( "     " );
    end

  endtask

endmodule

//========================================================================
// Top
//========================================================================

module Top();

  //----------------------------------------------------------------------
  // Clock/Reset
  //----------------------------------------------------------------------

  // verilator lint_off BLKSEQ
  logic clk;
  initial clk = 1'b1;
  always #(`CYCLE_TIME/2) clk = ~clk;
  // verilator lint_on BLKSEQ

  logic rst;

  //----------------------------------------------------------------------
  // Instantiate modules
  //----------------------------------------------------------------------

  // verilator lint_off UNUSED
  logic       player_play_load;
  logic [2:0] player_play_note;
  logic       player_play_done;
  logic [2:0] player_note_sel;
  logic       note;
  // verilator lint_on UNUSED

  MultiNotePlayer_RTL player
  (
    .clk           (clk),
    .rst           (rst),

    .note1_period  (8'h7B),
    .note2_period  (8'h6D),
    .note3_period  (8'h61),
    .note4_period  (8'h5B),
    .note5_period  (8'h51),
    .note6_period  (8'h48),
    .note7_period  (8'h44),

    .play_load     (player_play_load),
    .play_note     (player_play_note),
    .play_duration (16'd1000),
    .play_done     (player_play_done),
    .note_sel      (player_note_sel),

    .note          (note)
  );

  // Input Display

  logic [6:0] player_note_seg_tens;
  logic [6:0] player_note_seg_ones;

  Display_GL player_note_display
  (
    .in       ({2'b0,player_play_note}),
    .seg_tens (player_note_seg_tens),
    .seg_ones (player_note_seg_ones)
  );

  //----------------------------------------------------------------------
  // Instantiate seven-segment display FL models
  //----------------------------------------------------------------------

  SevenSegFL player_note_seg_tens_fl
  (
    .in (player_note_seg_tens)
  );

  SevenSegFL player_note_seg_ones_fl
  (
    .in (player_note_seg_ones)
  );

  //----------------------------------------------------------------------
  // Perform the simulation
  //----------------------------------------------------------------------

  initial begin

    $dumpfile("multi-note-player-sim.vcd");
    $dumpvars();

    // Process command line arguments

    if ( !$value$plusargs( "switches=%b", player_play_note ) )
      player_play_note = 0;

    #100;

    // Reset sequence

    rst = 1;
    #(3*`CYCLE_TIME);
    rst = 0;
    #`CYCLE_TIME;

    // Load note

    player_play_load = 1;
    #`CYCLE_TIME;
    player_play_load = 0;

    // Display selected note

    $write( "\n" );
    for ( int i = 0; i < 7; i++ ) begin

      $write( "    " );
      player_note_seg_tens_fl.write_row( i );
      $write( "  " );
      player_note_seg_ones_fl.write_row( i );

      $write( "\n" );
    end
    $write( "\n" );

    // Simulate 1000 cycles

    #(`CYCLE_TIME*1000)

    // Finish

    $display( "Open multi-note-player-sim.vcd to see note waveform" );
    $finish;

  end

endmodule

