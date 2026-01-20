//========================================================================
// Calculator_GL-test
//========================================================================

`include "ece2300-test.v"
`include "Calculator_GL.v"

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
  logic [7:0] dut_in1;
  logic       dut_op;
  logic [7:0] dut_result;

  Calculator_GL dut
  (
    .in0    (dut_in0),
    .in1    (dut_in1),
    .op     (dut_op),
    .result (dut_result)
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
    input logic [7:0] in1,
    input logic       op,
    input logic [7:0] result
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_op  = op;

      #8;

      if ( t.n != 0 ) begin
        if ( op == 0 ) begin
          $display( "%3d: %b + %b (%3d + %3d) > %b (%3d)", t.cycles,
                    dut_in0, dut_in1, dut_in0, dut_in1,
                    dut_result, dut_result );
        end
        else begin
          $display( "%3d: %b * %b (%3d * %3d) > %b (%3d)", t.cycles,
                    dut_in0, dut_in1, dut_in0, dut_in1,
                    dut_result, dut_result );
        end
      end

      `ECE2300_CHECK_EQ( dut_result, result );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0   in1   op    result
    check( 8'd0, 8'd0, 1'b0, 8'd0 ); // 0 + 0 = 0
    check( 8'd0, 8'd1, 1'b0, 8'd1 ); // 0 + 1 = 1
    check( 8'd1, 8'd0, 1'b0, 8'd1 ); // 1 + 0 = 1
    check( 8'd1, 8'd1, 1'b0, 8'd2 ); // 1 + 1 = 2

    check( 8'd0, 8'd0, 1'b1, 8'd0 ); // 0 * 0 = 0
    check( 8'd0, 8'd1, 1'b1, 8'd0 ); // 0 * 1 = 0
    check( 8'd1, 8'd0, 1'b1, 8'd0 ); // 1 * 0 = 0
    check( 8'd1, 8'd1, 1'b1, 8'd1 ); // 1 * 1 = 1

  endtask

  task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );

    //     in0   in1   op    result
    check( 8'd4, 8'd04, 1'b0, 8'd8 ); // 4 + 4 = 8
    check( 8'd12, 8'd2, 1'b0, 8'd14 ); // 12 + 2 = 14
    check( 8'd1, 8'd9, 1'b0, 8'd10 ); // 1 + 9 = 10
    check( 8'd2, 8'd1, 1'b0, 8'd3 ); // 2 + 1 = 3

    check( 8'd8, 8'd0, 1'b1, 8'd0 ); // 8 * 0 = 0
    check( 8'd10, 8'd1, 1'b1, 8'd10 ); // 10 * 1 = 0
    check( 8'd2, 8'd1, 1'b1, 8'd2 ); // 2 * 1 = 2
    check( 8'd1, 8'd2, 1'b1, 8'd2 ); // 1 * 2 = 2

  endtask

  logic [7:0]random_in0;
  logic [7:0]random_in1;
  logic random_op;
  logic [7:0]result;

    task test_case_3_random();
    t.test_case_begin( "test_case_3_random" );

    // Generate 50 random input values

    for ( int i = 0; i < 50; i = i+1 ) begin

      // Generate a 8-bit random value for in0 and in1, 1-bit random for cout

      random_in0 = 8'($urandom(t.seed));
      random_in1 = 8'($urandom(t.seed));
      random_op = 1'($urandom(t.seed));

      assign result = result;

      check( random_in0, random_in1, random_op, result);
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



    t.test_bench_end();
  end

endmodule
