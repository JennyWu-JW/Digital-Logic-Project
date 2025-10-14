//========================================================================
// AdderRippleCarry_4b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "AdderRippleCarry_4b_GL.v"

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

  logic [3:0] dut_in0;
  logic [3:0] dut_in1;
  logic       dut_cin;
  logic       dut_cout;
  logic [3:0] dut_sum;

  AdderRippleCarry_4b_GL dut
  (
    .in0  (dut_in0),
    .in1  (dut_in1),
    .cin  (dut_cin),
    .cout (dut_cout),
    .sum  (dut_sum)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic [3:0] in0,
    input logic [3:0] in1,
    input logic       cin,
    input logic       cout,
    input logic [3:0] sum
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_cin = cin;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b + %b + %b (%2d + %2d + %b) > %b %b (%2d)", t.cycles,
                dut_in0, dut_in1, dut_cin,
                dut_in0, dut_in1, dut_cin,
                dut_cout, dut_sum, dut_sum );
      end

      `ECE2300_CHECK_EQ( dut_cout, cout );
      `ECE2300_CHECK_EQ( dut_sum,  sum  );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0      in1      cin   cout  sum
    check( 4'b0000, 4'b0000, 1'b0, 1'b0, 4'b0000 );
    check( 4'b0001, 4'b0000, 1'b0, 1'b0, 4'b0001 );
    check( 4'b0000, 4'b0001, 1'b0, 1'b0, 4'b0001 );
    check( 4'b0001, 4'b0001, 1'b0, 1'b0, 4'b0010 );

  endtask

  task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );

    check( 4'b0000, 4'b0000, 1'b0, 1'b0, 4'b0000  );
    check( 4'b0001, 4'b0001, 1'b0, 1'b0, 4'b0010  );
    check( 4'b0001, 4'b0001, 1'b1, 1'b0, 4'b0011  );
    check( 4'b0011, 4'b0011, 1'b0, 1'b0, 4'b0110 );

  endtask

  logic [3:0] random_in0;
  logic [3:0] random_in1;
  logic       random_cin;
  logic       cout;
  logic [3:0] sum;
  logic [4:0] result;

  task test_case_3_random();
    t.test_case_begin( "test_case_3_random" );

    // Generate 20 random input values

    for ( int i = 0; i < 20; i = i+1 ) begin

      // Generate a 4-bit random value for in0 and in1, 1-bit random for cout

      random_in0 = 4'($urandom(t.seed));
      random_in1 = 4'($urandom(t.seed));
      random_cin = 1'($urandom(t.seed));

      // Find 5 bit sum, most significant being the cout and remaining being sum

      result = random_in0 + random_in1 + {3'b0, random_cin};
      cout   = result[4];
      sum    = result[3:0];

      check( random_in0, random_in1, random_cin, cout, sum );

    end

  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();

    //''' LAB ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''''
    // Add calls to new directed and random test cases here
    //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    t.test_bench_end();
  end

endmodule
