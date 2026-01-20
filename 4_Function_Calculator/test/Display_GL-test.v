//========================================================================
// Display_GL-test
//========================================================================
// Used ChatGPT to generate exhaustive test cases

`include "ece2300-test.v"
`include "Display_GL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  // verilator lint_off UNUSED
  logic clk;
  logic reset;
  // verilator lint_on UNUSED

  ece2300_TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic [4:0] dut_in;
  logic [6:0] dut_seg_tens;
  logic [6:0] dut_seg_ones;

  Display_GL dut
  (
    .in       (dut_in),
    .seg_tens (dut_seg_tens),
    .seg_ones (dut_seg_ones)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic [4:0] in,
    input logic [6:0] seg_tens,
    input logic [6:0] seg_ones
  );
    if ( !t.failed ) begin

      dut_in = in;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b (%d) > %b %b", t.cycles,
                  dut_in, dut_in, dut_seg_tens, dut_seg_ones );
      end

      `ECE2300_CHECK_EQ( dut_seg_tens, seg_tens );
      `ECE2300_CHECK_EQ( dut_seg_ones, seg_ones );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    check( 5'b00000, 7'b100_0000, 7'b100_0000 );
    check( 5'b00001, 7'b100_0000, 7'b111_1001 );
    check( 5'b01111, 7'b111_1001, 7'b001_0010 );
    check( 5'b11111, 7'b011_0000, 7'b111_1001 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_exhaustive
  //----------------------------------------------------------------------

  task test_case_2_exhaustive();
    t.test_case_begin( "test_case_2_exhaustive" );

    check( 5'b00000, 7'b100_0000, 7'b100_0000 ); // 0 tens, 0 ones
    check( 5'b00001, 7'b100_0000, 7'b111_1001 ); // 0 tens, 1 ones
    check( 5'b00010, 7'b100_0000, 7'b010_0100 ); // 0 tens, 2 ones
    check( 5'b00011, 7'b100_0000, 7'b011_0000 ); // 0 tens, 3 ones
    check( 5'b00100, 7'b100_0000, 7'b001_1001 ); // 0 tens, 4 ones
    check( 5'b00101, 7'b100_0000, 7'b001_0010 ); // 0 tens, 5 ones
    check( 5'b00110, 7'b100_0000, 7'b000_0010 ); // 0 tens, 6 ones
    check( 5'b00111, 7'b100_0000, 7'b111_1000 ); // 0 tens, 7 ones
    check( 5'b01000, 7'b100_0000, 7'b000_0000 ); // 0 tens, 8 ones
    check( 5'b01001, 7'b100_0000, 7'b001_1000 ); // 0 tens, 9 ones
    check( 5'b01010, 7'b111_1001, 7'b100_0000 ); // 1 tens, 0 ones
    check( 5'b01011, 7'b111_1001, 7'b111_1001 ); // 1 tens, 1 ones
    check( 5'b01100, 7'b111_1001, 7'b010_0100 ); // 1 tens, 2 ones
    check( 5'b01101, 7'b111_1001, 7'b011_0000 ); // 1 tens, 3 ones
    check( 5'b01110, 7'b111_1001, 7'b001_1001 ); // 1 tens, 4 ones
    check( 5'b01111, 7'b111_1001, 7'b001_0010 ); // 1 tens, 5 ones
    check( 5'b10000, 7'b111_1001, 7'b000_0010 ); // 1 tens, 6 ones
    check( 5'b10001, 7'b111_1001, 7'b111_1000 ); // 1 tens, 7 ones
    check( 5'b10010, 7'b111_1001, 7'b000_0000 ); // 1 tens, 8 ones
    check( 5'b10011, 7'b111_1001, 7'b001_1000 ); // 1 tens, 9 ones
    check( 5'b10100, 7'b010_0100, 7'b100_0000 ); // 2 tens, 0 ones
    check( 5'b10101, 7'b010_0100, 7'b111_1001 ); // 2 tens, 1 ones
    check( 5'b10110, 7'b010_0100, 7'b010_0100 ); // 2 tens, 2 ones
    check( 5'b10111, 7'b010_0100, 7'b011_0000 ); // 2 tens, 3 ones
    check( 5'b11000, 7'b010_0100, 7'b001_1001 ); // 2 tens, 4 ones
    check( 5'b11001, 7'b010_0100, 7'b001_0010 ); // 2 tens, 5 ones
    check( 5'b11010, 7'b010_0100, 7'b000_0010 ); // 2 tens, 6 ones
    check( 5'b11011, 7'b010_0100, 7'b111_1000 ); // 2 tens, 7 ones
    check( 5'b11100, 7'b010_0100, 7'b000_0000 ); // 2 tens, 8 ones
    check( 5'b11101, 7'b010_0100, 7'b001_1000 ); // 2 tens, 9 ones
    check( 5'b11110, 7'b011_0000, 7'b100_0000 ); // 3 tens, 0 ones
    check( 5'b11111, 7'b011_0000, 7'b111_1001 ); // 3 tens, 1 ones

  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_exhaustive();

    t.test_bench_end();
  end

endmodule
