//========================================================================
// Multiplier_32x32b_RTL-test
//========================================================================
// Used ChatGPT to generate directed and random test cases

`include "ece2300-test.v"
`include "Multiplier_32x32b_RTL.v"

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
  logic [31:0] dut_prod;

  Multiplier_32x32b_RTL dut
  (
    .in0  (dut_in0),
    .in1  (dut_in1),
    .prod (dut_prod)
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
    input logic [31:0] prod
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %h * %h (%10d * %10d) > %h (%10d)", t.cycles,
                  dut_in0, dut_in1, dut_in0, dut_in1,
                  dut_prod, dut_prod );
      end

      `ECE2300_CHECK_EQ( dut_prod, prod );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0    in1    prod
    check( 32'd0, 32'd0, 32'd0 ); // 0 * 0 = 0
    check( 32'd1, 32'd0, 32'd0 ); // 1 * 0 = 0
    check( 32'd1, 32'd1, 32'd1 ); // 1 * 1 = 1
    check( 32'd1, 32'd2, 32'd2 ); // 1 * 2 = 2
    check( 32'd1, 32'd3, 32'd3 ); // 1 * 3 = 3

  endtask

  //----------------------------------------------------------------------
  // test_case_2_powers_of_two
  //----------------------------------------------------------------------

  task test_case_2_powers_of_two();
    t.test_case_begin("test_case_2_powers_of_two");

    // Powers of two multiplications to test bit shifts and basic scaling
    //     in0            in1            prod
    check( 32'd1,         32'd1,         32'd1 );          // 1 * 1 = 1
    check( 32'd2,         32'd2,         32'd4 );          // 2 * 2 = 4
    check( 32'd4,         32'd4,         32'd16 );         // 4 * 4 = 16
    check( 32'd16,        32'd16,        32'd256 );        // 16 * 16 = 256
    check( 32'd32,        32'd64,        32'd2048 );       // 32 * 64 = 2048
    check( 32'd1024,      32'd1024,      32'd1048576 );    // 1024 * 1024 = 1048576

  endtask

  //----------------------------------------------------------------------
  // test_case_3_edge_cases
  //----------------------------------------------------------------------

  task test_case_3_edge_cases();
    t.test_case_begin("test_case_3_edge_cases");

    // Edge cases to test the limits of 32-bit multiplication
    //     in0            in1            prod
    check( 32'hFFFFFFFF,  32'd1,         32'hFFFFFFFF );   // Max * 1 = Max
    check( 32'hFFFFFFFF,  32'd0,         32'd0 );          // Max * 0 = 0
    check( 32'd0,         32'hFFFFFFFF,  32'd0 );          // 0 * Max = 0
    check( 32'hFFFFFFFF,  32'hFFFFFFFF,  32'h1 );   // Max * Max (lower 32 bits only)
    check( 32'h80000000,  32'h2,         32'h00000000 );   // Min * 2 (lower 32 bits)

  endtask

  //----------------------------------------------------------------------
  // test_case_4_overflow_cases
  //----------------------------------------------------------------------

  task test_case_4_overflow_cases();
    t.test_case_begin("test_case_4_overflow_cases");

    // Cases that will cause overflow and test lower 32-bit truncation
    //     in0            in1            prod
    check( 32'd100000,    32'd100000,    32'h540BE400 ); // 100000 * 100000 = 0x3B9ACA00 (lower 32 bits)
    check( 32'd65536,     32'd65536,     32'h00000000 );   // 65536 * 65536 = 0x00000000 (lower 32 bits)
    check( 32'hFFFF,      32'hFFFF,      32'hFFFE0001 );   // 65535 * 65535 = 0xFFFE0001 (lower 32 bits)
    check( 32'd50000,     32'd60000,     32'hB2D05E00 );   // 50000 * 60000 = 0xB2D05E00 (lower 32 bits)

  endtask

  //----------------------------------------------------------------------
  // test_case_5_negative_numbers
  //----------------------------------------------------------------------

  task test_case_5_negative_numbers();
    t.test_case_begin("test_case_5_negative_numbers");

    // Multiplications involving negative numbers (2's complement)
    //     in0            in1            prod
    check( 32'hFFFFFFFE,  32'd2,         32'hFFFFFFFC );   // -2 * 2 = -4 (lower 32 bits)
    check( 32'hFFFFFFFE,  32'hFFFFFFFE,  32'h00000004 );   // -2 * -2 = 4 (lower 32 bits)
    check( 32'h80000000,  32'd2,         32'h00000000 );   // Min * 2 (overflow case)
    check( 32'h80000000,  32'h80000000,  32'h00000000 );   // Min * Min (overflow in signed)

  endtask

  //----------------------------------------------------------------------
  // test_case_6_random
  //----------------------------------------------------------------------

  logic [31:0] rand_in0;
  logic [31:0] rand_in1;
  logic [31:0] product;

  task test_case_6_random();
    t.test_case_begin("test_case_5_negative_numbers");

    for (int i = 0; i < 20; i++) begin

      //Generate random values for both inputs and finds product
      rand_in0 = 32'($urandom());
      rand_in1 = 32'($urandom());
      product = rand_in0 * rand_in1; // Truncated to lower 32 bits

      check(rand_in0, rand_in1, product);

    end
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_powers_of_two();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_edge_cases();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_overflow_cases();
    if ((t.n <= 0) || (t.n == 5)) test_case_5_negative_numbers();
    if ((t.n <= 0) || (t.n == 6)) test_case_6_random();

    t.test_bench_end();
  end

endmodule

