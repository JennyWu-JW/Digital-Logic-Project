//========================================================================
// counter-sim +switches=00000
//========================================================================
// Author : Christopher Batten (Cornell)
// Date   : September 7, 2024

`include "Counter_8b_RTL.v"
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
  always #5 clk = ~clk;
  // verilator lint_on BLKSEQ

  logic rst;

  //----------------------------------------------------------------------
  // Instantiate modules
  //----------------------------------------------------------------------

  logic       counter_load;
  logic [4:0] counter_in;
  logic [7:0] counter_count;
  logic       counter_done;

  Counter_8b_RTL counter
  (
    .clk   (clk),
    .rst   (rst),
    .load  (counter_load),
    .in    ({3'b0,counter_in}),
    .count (counter_count),
    .done  (counter_done)
  );

  logic [2:0] counter_count_unused;
  assign counter_count_unused = counter_count[7:5];

  // Input Display

  logic [6:0] counter_in_seg_tens;
  logic [6:0] counter_in_seg_ones;

  Display_GL counter_in_display
  (
    .in       (counter_in),
    .seg_tens (counter_in_seg_tens),
    .seg_ones (counter_in_seg_ones)
  );

  // Output Display

  logic [6:0] counter_count_seg_tens;
  logic [6:0] counter_count_seg_ones;

  Display_GL counter_count_display
  (
    .in       (counter_count[4:0]),
    .seg_tens (counter_count_seg_tens),
    .seg_ones (counter_count_seg_ones)
  );

  //----------------------------------------------------------------------
  // Instantiate seven-segment display FL models
  //----------------------------------------------------------------------

  SevenSegFL counter_in_seg_tens_fl
  (
    .in (counter_in_seg_tens)
  );

  SevenSegFL counter_in_seg_ones_fl
  (
    .in (counter_in_seg_ones)
  );

  SevenSegFL counter_count_seg_tens_fl
  (
    .in (counter_count_seg_tens)
  );

  SevenSegFL counter_count_seg_ones_fl
  (
    .in (counter_count_seg_ones)
  );

  //----------------------------------------------------------------------
  // Perform the simulation
  //----------------------------------------------------------------------

  integer c;

  initial begin

    // Process command line arguments

    if ( !$value$plusargs( "switches=%b", counter_in ) )
      counter_in = 0;

    #1;

    // Reset sequence

    rst = 1;
    #10;
    rst = 0;

    // Load counter input

    counter_load = 1;
    #10;
    counter_load = 0;

    // Simulate up to 100 cycles

    for ( int cycles = 0; cycles < 100; cycles = cycles+1 ) begin

      // Display output

      $write( "\n" );
      for ( int i = 0; i < 7; i++ ) begin

        $write( "    " );
        counter_in_seg_tens_fl.write_row( i );
        $write( "  " );
        counter_in_seg_ones_fl.write_row( i );

        $write( "    " );
        counter_count_seg_tens_fl.write_row( i );
        $write( "  " );
        counter_count_seg_ones_fl.write_row( i );

        if ( i == 0 ) begin
          if ( counter_done )
            $write( "    LED: ON " );
          else
            $write( "    LED: OFF" );
        end

        $write( "\n" );
      end
      $write( "\n" );

      // Simulation is finished

      if ( counter_done )
        $finish;

      // Advance time

      #10;

      // Wait for key press

      $display( "Press enter for toggle the clock." );
      $display( "Enter q then press enter to quit." );

      c = $fgetc( 'h8000_0000 );
      if ( c == "q" )
        $finish;

      // Redraw the console

      for ( int i = 0; i < 12; i++ ) begin
        $write("\x1b[A");
      end

    end

    $finish;
  end

endmodule

