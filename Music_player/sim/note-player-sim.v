//========================================================================
// note-player-sim +switches=0000_0000
//========================================================================
// Author : Christopher Batten (Cornell)
// Date   : September 7, 2024
//
// Switches set the period of the note.
//
// To be more specific, the switches set how long the note is high, and
// there are four additional cycles due to the note player FSM. So if the
// switches are set to the value p, then actual note period is 2*(p+2).
//
// We are using a 50MHz clock (20ns clock period) clock divided by 2^10
// which means the effective clock period is 20ns * 2^10 = 20480ns. So
// For example, if the swithes are set to 0000_0011 (3) then the actual
// note period would be 2*(3+2) = 10 cycles * 20480ns/cycle = 204800ns or
// 203.8us which is 1/0.0002038 = 4.9KHz which is a very high frequency
// tone.
//
// Here is the mapping from switch inputs to notes.
//
//                    period period    freq
// switches  hex  dec (cycs)   (ms)    (Hz) note
// 0111_1011 0x7b 123    250   5.12  195.31 G3
// 0110_1101 0x6d 109    222   4.55  219.95 A3
// 0110_0001 0x61  97    198   4.06  246.61 B3
// 0101_1011 0x5b  91    186   3.81  262.52 C4
// 0101_0001 0x51  81    166   3.40  294.15 D4
// 0100_1000 0x48  72    148   3.03  329.92 E4
// 0100_0100 0x44  68    140   2.87  348.77 F4
//

// We use a timescale of 10s so that means the cycle time in Verilog
// timeunit is 20480/10 = 2048

`timescale 10ns/1ns
`define CYCLE_TIME 2048

`include "NotePlayer_RTL.v"
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
  logic [7:0] player_period;
  logic [3:0] player_state;
  logic       note;
  // verilator lint_on UNUSED

  NotePlayer_RTL player
  (
    .clk    (clk),
    .rst    (rst),
    .period (player_period),
    .state  (player_state),
    .note   (note)
  );

  //----------------------------------------------------------------------
  // Perform the simulation
  //----------------------------------------------------------------------

  initial begin

    $dumpfile("note-player-sim.vcd");
    $dumpvars();

    // Process command line arguments

    if ( !$value$plusargs( "switches=%b", player_period ) )
      player_period = 0;

    #1;

    // Reset sequence

    rst = 1;
    #(3*`CYCLE_TIME);
    rst = 0;
    #`CYCLE_TIME;

    // Simulate 1000 cycles

    #(`CYCLE_TIME*1000)

    // Finish

    $display( "Open note-player-sim.vcd to see note waveform" );
    $finish;

  end

endmodule

