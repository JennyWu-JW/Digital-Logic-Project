//========================================================================
// CalculatorDisplay_GL-test
//========================================================================

`include "ece2300-test.v"
`include "CalculatorDisplay_GL.v"

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

  logic [4:0] dut_in0;
  logic [4:0] dut_in1;
  logic       dut_op;
  logic [6:0] dut_in0_seg_tens;
  logic [6:0] dut_in0_seg_ones;
  logic [6:0] dut_in1_seg_tens;
  logic [6:0] dut_in1_seg_ones;
  logic [6:0] dut_result_seg_tens;
  logic [6:0] dut_result_seg_ones;

  CalculatorDisplay_GL dut
  (
    .in0             (dut_in0),
    .in1             (dut_in1),
    .op              (dut_op),
    .in0_seg_tens    (dut_in0_seg_tens),
    .in0_seg_ones    (dut_in0_seg_ones),
    .in1_seg_tens    (dut_in1_seg_tens),
    .in1_seg_ones    (dut_in1_seg_ones),
    .result_seg_tens (dut_result_seg_tens),
    .result_seg_ones (dut_result_seg_ones)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic [4:0] in0,
    input logic [4:0] in1,
    input logic       op,
    input logic [6:0] in0_seg_tens,
    input logic [6:0] in0_seg_ones,
    input logic [6:0] in1_seg_tens,
    input logic [6:0] in1_seg_ones,
    input logic [6:0] result_seg_tens,
    input logic [6:0] result_seg_ones
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_op  = op;

      #8;

      if ( t.n != 0 ) begin
        if ( op == 0 ) begin
          $display( "%3d: %b + %b > %b %b | %b %b | %b %b", t.cycles,
                    dut_in0, dut_in1,
                    dut_in0_seg_tens, dut_in0_seg_ones,
                    dut_in1_seg_tens, dut_in1_seg_ones,
                    dut_result_seg_tens, dut_result_seg_ones );
        end
        else begin
          $display( "%3d: %b * %b > %b %b | %b %b | %b %b", t.cycles,
                    dut_in0, dut_in1,
                    dut_in0_seg_tens, dut_in0_seg_ones,
                    dut_in1_seg_tens, dut_in1_seg_ones,
                    dut_result_seg_tens, dut_result_seg_ones );
        end
      end

      `ECE2300_CHECK_EQ( dut_in0_seg_tens,    in0_seg_tens    );
      `ECE2300_CHECK_EQ( dut_in0_seg_ones,    in0_seg_ones    );
      `ECE2300_CHECK_EQ( dut_in1_seg_tens,    in1_seg_tens    );
      `ECE2300_CHECK_EQ( dut_in1_seg_ones,    in1_seg_ones    );
      `ECE2300_CHECK_EQ( dut_result_seg_tens, result_seg_tens );
      `ECE2300_CHECK_EQ( dut_result_seg_ones, result_seg_ones );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0   in1   op    in0_seg_tens in0_seg_ones in1_seg_tens in1_seg_ones res_seg_tens res_seg_tens
    check( 5'd0, 5'd0, 1'b0, 7'b100_0000, 7'b100_0000, 7'b100_0000, 7'b100_0000, 7'b100_0000, 7'b100_0000 ); // 0 + 0 = 0
    check( 5'd0, 5'd1, 1'b0, 7'b100_0000, 7'b100_0000, 7'b100_0000, 7'b111_1001, 7'b100_0000, 7'b111_1001 ); // 0 + 1 = 1
    check( 5'd1, 5'd0, 1'b0, 7'b100_0000, 7'b111_1001, 7'b100_0000, 7'b100_0000, 7'b100_0000, 7'b111_1001 ); // 1 + 0 = 1
    check( 5'd1, 5'd1, 1'b0, 7'b100_0000, 7'b111_1001, 7'b100_0000, 7'b111_1001, 7'b100_0000, 7'b010_0100 ); // 1 + 1 = 2

    check( 5'd0, 5'd0, 1'b1, 7'b100_0000, 7'b100_0000, 7'b100_0000, 7'b100_0000, 7'b100_0000, 7'b100_0000 ); // 0 * 0 = 0
    check( 5'd0, 5'd1, 1'b1, 7'b100_0000, 7'b100_0000, 7'b100_0000, 7'b111_1001, 7'b100_0000, 7'b100_0000 ); // 0 * 1 = 0
    check( 5'd1, 5'd0, 1'b1, 7'b100_0000, 7'b111_1001, 7'b100_0000, 7'b100_0000, 7'b100_0000, 7'b100_0000 ); // 1 * 0 = 0
    check( 5'd1, 5'd1, 1'b1, 7'b100_0000, 7'b111_1001, 7'b100_0000, 7'b111_1001, 7'b100_0000, 7'b111_1001 ); // 1 * 1 = 1

  endtask

  // NOTE: You do not need to add any more test cases; assuming you have
  // thoroughly unit tested all of your modules, we just need to do some
  // basic testing for the top-level module.

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();

    t.test_bench_end();
  end

endmodule
