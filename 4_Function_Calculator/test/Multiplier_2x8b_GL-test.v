//========================================================================
// Multiplier_2x8b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "Multiplier_2x8b_GL.v"

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

  logic [7:0] dut_in0;
  logic [1:0] dut_in1;
  logic [7:0] dut_prod;

  Multiplier_2x8b_GL dut
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
    input logic [7:0] in0,
    input logic [1:0] in1,
    input logic [7:0] prod
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b * %b (%3d * %d) > %b (%3d)", t.cycles,
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

    //     in0           in1    prod
    check( 8'b0000_0000, 2'b00, 8'b0000_0000 ); // 0 * 0 = 0
    check( 8'b0000_0001, 2'b00, 8'b0000_0000 ); // 1 * 0 = 0
    check( 8'b0000_0001, 2'b01, 8'b0000_0001 ); // 1 * 1 = 1
    check( 8'b0000_0001, 2'b10, 8'b0000_0010 ); // 1 * 2 = 2
    check( 8'b0000_0001, 2'b11, 8'b0000_0011 ); // 1 * 3 = 3

  endtask

    task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );

    //     in0           in1    prod
    check( 8'b0000_0001, 2'b10, 8'b0000_0010 ); // 1 * 2 = 2
    check( 8'b0000_0000, 2'b10, 8'b0000_0000 ); // 0 * 2 = 0
    check( 8'b0000_0101, 2'b10, 8'b0000_1010 ); // 5 * 2 = 10
    check( 8'b0000_0011, 2'b11, 8'b0000_1001 ); // 3 * 3 = 9

  endtask

  logic [7:0] random_in0;
  logic [1:0] random_in1;
  logic [7:0] prod;

  task test_case_3_random();
    t.test_case_begin( "test_case_3_random" );

    // Generate 50 random input values

    for ( int i = 0; i < 50; i = i+1 ) begin

      // Generate a 8-bit random value for in0, and generates a random 2-bit for in1

      random_in0 = 8'($urandom(t.seed));
      random_in1 = 2'($urandom(t.seed));

      // assigning the logic 8-bit prod with the Multiplier prod output
      assign prod = prod;

      check( random_in0, random_in1, prod);
    end 
  endtask


  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_random();

    //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''
    // Add calls to new directed and random test cases here
    //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    t.test_bench_end();
  end

endmodule

