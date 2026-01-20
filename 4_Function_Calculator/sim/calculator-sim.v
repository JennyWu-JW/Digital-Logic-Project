//========================================================================
// calc-sim +in0-switches=00000 +in1-switches=00000 +button=0
//========================================================================
// Author : Christopher Batten (Cornell)
// Date   : September 7, 2024

`include "Calculator_GL.v"
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
  // Instantiate calculator and displays
  //----------------------------------------------------------------------

  logic [4:0] in0;
  logic [4:0] in1;
  logic       op;
  logic [7:0] result;

  Calculator_GL calc
  (
    .in0    ({3'b0,in0}),
    .in1    ({3'b0,in1}),
    .op     (op),
    .result (result)
  );

  logic [6:0] in0_seg_tens;
  logic [6:0] in0_seg_ones;

  Display_GL display_in0
  (
    .in       (in0),
    .seg_tens (in0_seg_tens),
    .seg_ones (in0_seg_ones)
  );

  logic [6:0] in1_seg_tens;
  logic [6:0] in1_seg_ones;

  Display_GL display_in1
  (
    .in       (in1),
    .seg_tens (in1_seg_tens),
    .seg_ones (in1_seg_ones)
  );

  logic [6:0] result_seg_tens;
  logic [6:0] result_seg_ones;

  Display_GL display_result
  (
    .in       (result[4:0]),
    .seg_tens (result_seg_tens),
    .seg_ones (result_seg_ones)
  );

  //----------------------------------------------------------------------
  // Instantiate seven-segment FL models
  //----------------------------------------------------------------------

  SevenSegFL in0_seg_tens_fl
  (
    .in (in0_seg_tens)
  );

  SevenSegFL in0_seg_ones_fl
  (
    .in (in0_seg_ones)
  );

  SevenSegFL in1_seg_tens_fl
  (
    .in (in1_seg_tens)
  );

  SevenSegFL in1_seg_ones_fl
  (
    .in (in1_seg_ones)
  );

  SevenSegFL result_seg_tens_fl
  (
    .in (result_seg_tens)
  );

  SevenSegFL result_seg_ones_fl
  (
    .in (result_seg_ones)
  );

  //----------------------------------------------------------------------
  // Perform the simulation
  //----------------------------------------------------------------------

  initial begin

    // Process command line arguments

    if ( !$value$plusargs( "in0-switches=%b", in0 ) )
      in0 = 5'b00000;

    if ( !$value$plusargs( "in1-switches=%b", in1 ) )
      in1 = 5'b00000;

    if ( !$value$plusargs( "button=%b", op ) )
      op = 1'b0;

    // Advance time

    #10;

    // Display output

    $write( "\n" );
    $display( "in0-switches = %b", in0 );
    $display( "in1-switches = %b", in1 );
    $display( "op           = %b", op );
    $display( "result       = %b", result );

    $write( "\n" );
    for ( int i = 0; i < 7; i++ ) begin

      $write( "  " );
      in0_seg_tens_fl.write_row( i );
      $write( "  " );
      in0_seg_ones_fl.write_row( i );

      $write( "    " );
      in1_seg_tens_fl.write_row( i );
      $write( "  " );
      in1_seg_ones_fl.write_row( i );

      $write( "    " );
      result_seg_tens_fl.write_row( i );
      $write( "  " );
      result_seg_ones_fl.write_row( i );

      $write( "\n" );
    end
    $write( "\n" );

    $finish;
  end

endmodule

