//========================================================================
// EqComparator_32b_RTL-test
//========================================================================
// Used ChatGPT to generate directed and random test cases

`include "ece2300-test.v"
`include "EqComparator_32b_RTL.v"

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

  logic [31:0] dut_in0;
  logic [31:0] dut_in1;
  logic        dut_eq;

  EqComparator_32b_RTL dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .eq  (dut_eq)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic [31:0] in0,
    input logic [31:0] in1,
    input logic        eq
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %h == %h (%10d == %10d) > %b", t.cycles,
                  dut_in0, dut_in1, dut_in0, dut_in1,
                  dut_eq );
      end

      `ECE2300_CHECK_EQ( dut_eq, eq );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0    in1    eq
    check( 32'd0, 32'd0, 1 );
    check( 32'd0, 32'd1, 0 );
    check( 32'd1, 32'd0, 0 );
    check( 32'd1, 32'd1, 1 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_directed_zero_one
  //----------------------------------------------------------------------

  task test_case_2_directed_zero_one();
    t.test_case_begin("test_case_2_directed_zero_one");

    // Directed test cases for equality and non-equality
    //     in0           in1           eq
    check( 32'd0,        32'd0,        1 );
    check( 32'd0,        32'd1,        0 );
    check( 32'd1,        32'd0,        0 );
    check( 32'd1,        32'd1,        1 );
    
  endtask

  //----------------------------------------------------------------------
  // test_case_3_directed_edge
  //----------------------------------------------------------------------

  task test_case_3_directed_edge();
    t.test_case_begin("test_case_3_directed_edge");

    // Edge cases: minimum and maximum 32-bit values
    //     in0           in1          eq
    check( 32'hFFFFFFFF, 32'hFFFFFFFF, 1 ); // Both max unsigned 32-bit values
    check( 32'hFFFFFFFF, 32'd0,        0 ); // Max vs zero
    check( 32'd0,        32'hFFFFFFFF, 0 ); // Zero vs max
    check( 32'h00000001, 32'h00000001, 1 ); // Single bit match

    // Patterns with different Hamming distances
    check( 32'hAAAAAAAA, 32'hAAAAAAAA, 1 ); // Same alternating pattern
    check( 32'hAAAAAAAA, 32'h55555555, 0 ); // Complementary pattern
    check( 32'h12345678, 32'h12345678, 1 ); // Random matching pattern
    check( 32'h12345678, 32'h87654321, 0 ); // Random non-matching pattern

  endtask

  //----------------------------------------------------------------------
  // test_case_4_random
  //----------------------------------------------------------------------

  logic [31:0] rand_in0;
  logic [31:0] rand_in1;
  logic rand_eq;

  task test_case_4_random();
    t.test_case_begin("test_case_4_random");

    for (int i = 0; i < 20; i++) begin

      // Generate random values for in0 and in1, then checks for equality
      rand_in0 = 32'($urandom());
      rand_in1 = 32'($urandom());
      rand_eq = (rand_in0 == rand_in1) ? 1'b1 : 1'b0;
      check(rand_in0, rand_in1, rand_eq);
    end
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 1)) test_case_2_directed_zero_one();
    if ((t.n <= 0) || (t.n == 1)) test_case_3_directed_edge();
    if ((t.n <= 0) || (t.n == 1)) test_case_4_random();

    t.test_bench_end();
  end

endmodule

