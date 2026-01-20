//========================================================================
// Multiplier_1x8b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "Multiplier_1x8b_GL.v"

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
  logic       dut_in1;
  logic [7:0] dut_prod;

  Multiplier_1x8b_GL dut
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
    input logic       in1,
    input logic [7:0] prod
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b * %b (%3d * %b) > %b (%3d)", t.cycles,
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

    //     in0          in1   prod
    check( 8'b00000000, 1'b0, 8'b00000000 ); // 0 * 0 = 0
    check( 8'b00000001, 1'b0, 8'b00000000 ); // 1 * 0 = 0
    check( 8'b00000001, 1'b1, 8'b00000001 ); // 1 * 1 = 1

  endtask

  //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''
  // Add directed test cases
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );

    //     in0          in1   prod
    check( 8'b00000000, 1'b1, 8'b00000000 ); // 0 * 1 = 0
    check( 8'b00000001, 1'b0, 8'b00000000 ); // 1 * 0 = 0
    check( 8'b00000001, 1'b1, 8'b00000001 ); // 1 * 1 = 1

  endtask


  //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''''
  // Add random test case
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  logic [7:0] random_in0;
  logic       random_in1;
  logic [7:0] prod;

  task test_case_3_random();
    t.test_case_begin( "test_case_3_random" );

    // Generate 20 random input values

    for ( int i = 0; i < 20; i = i+1 ) begin

      // Generate a 8-bit random value for in0 and in1, 1-bit random for cout

      random_in0 = 8'($urandom(t.seed));
      random_in1 = 1'($urandom(t.seed));

      // Check using boolean equations from K-map from each individual bit of the out

      assign prod[0] = random_in1 & random_in0[0];
      assign prod[1] = random_in1 & random_in0[1];
      assign prod[2] = random_in1 & random_in0[2];
      assign prod[3] = random_in1 & random_in0[3];
      assign prod[4] = random_in1 & random_in0[4];
      assign prod[5] = random_in1 & random_in0[5];
      assign prod[6] = random_in1 & random_in0[6];
      assign prod[7] = random_in1 & random_in0[7];

      check( random_in0, random_in1, prod );
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

