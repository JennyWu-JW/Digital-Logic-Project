//========================================================================
// note-player-sim +switches=0000
//========================================================================
// Author : Christopher Batten (Cornell)
// Date   : September 7, 2024
//

// We use a timescale of 10s so that means the cycle time in Verilog
// timeunit is 20480/10 = 2048

`timescale 10ns/1ns
`define CYCLE_TIME 2048

`include "MusicMem_RTL.v"
`include "MusicPlayer_RTL.v"
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

  logic        memreq_val;
  logic [15:0] memreq_addr;
  logic [31:0] memresp_data;

  MusicMem_RTL mem
  (
    .memreq_val    (memreq_val),
    .memreq_addr   (memreq_addr),
    .memresp_data  (memresp_data)
  );

  // verilator lint_off UNUSED
  logic [4:0] player_song_sel;
  logic       player_start_song;
  logic       player_idle;
  logic [2:0] player_note_sel;
  logic [1:0] player_state_unused;
  logic       note;
  // verilator lint_on UNUSED

  MusicPlayer_RTL player
  (
    .clk           (clk),
    .rst           (rst),

    .note_duration (16'd1000),
    .note1_period  (8'h7B),
    .note2_period  (8'h6D),
    .note3_period  (8'h61),
    .note4_period  (8'h5B),
    .note5_period  (8'h51),
    .note6_period  (8'h48),
    .note7_period  (8'h44),

    .song_sel      (player_song_sel),
    .start_song    (player_start_song),
    .idle          (player_idle),
    .note_sel      (player_note_sel),
    .state         (player_state_unused),
    .note          (note),

    .memreq_val    (memreq_val),
    .memreq_addr   (memreq_addr),
    .memresp_data  (memresp_data)
  );

  // Input Display

  logic [6:0] player_song_sel_seg_tens;
  logic [6:0] player_song_sel_seg_ones;

  Display_GL player_song_sel_display
  (
    .in       (player_song_sel),
    .seg_tens (player_song_sel_seg_tens),
    .seg_ones (player_song_sel_seg_ones)
  );

  //----------------------------------------------------------------------
  // Instantiate seven-segment display FL models
  //----------------------------------------------------------------------

  SevenSegFL player_song_sel_seg_tens_fl
  (
    .in (player_song_sel_seg_tens)
  );

  SevenSegFL player_song_sel_seg_ones_fl
  (
    .in (player_song_sel_seg_ones)
  );

  //----------------------------------------------------------------------
  // Perform the simulation
  //----------------------------------------------------------------------

  initial begin

    $dumpfile("music-player-sim.vcd");
    $dumpvars();

    // Process command line arguments

    if ( !$value$plusargs( "switches=%b", player_song_sel ) )
      player_song_sel = 0;

    if ( player_song_sel > 1 )
      player_song_sel = 0;

    #100;

    // Reset sequence

    rst = 1;
    #(3*`CYCLE_TIME);
    rst = 0;
    #`CYCLE_TIME;

    // Load note

    player_start_song = 1;
    #`CYCLE_TIME;
    player_start_song = 0;

    // Display selected note

    $write( "\n" );
    for ( int i = 0; i < 7; i++ ) begin

      $write( "    " );
      player_song_sel_seg_tens_fl.write_row( i );
      $write( "  " );
      player_song_sel_seg_ones_fl.write_row( i );

      $write( "\n" );
    end
    $write( "\n" );

    // Simulate 64,000 cycles

    #(`CYCLE_TIME*64*1000)

    // Finish

    $display( "Open music-player-sim.vcd to see note waveform" );
    $finish;

  end

endmodule

