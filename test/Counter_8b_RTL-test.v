//========================================================================
// Counter_8b_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "Counter_8b_RTL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk;
  logic reset;

  ece2300_TestUtils t( .* );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic       dut_rst;
  logic       dut_load;
  logic [7:0] dut_in;
  logic [7:0] dut_count;
  logic       dut_done;

  Counter_8b_RTL counter
  (
    .clk   (clk),
    .rst   (reset || dut_rst),
    .in    (dut_in),
    .load  (dut_load),
    .count (dut_count),
    .done  (dut_done)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic       rst,
    input logic       load,
    input logic [7:0] in,
    input logic [7:0] count,
    input logic       done
  );
    if ( !t.failed ) begin

      dut_rst  = rst;
      dut_in   = in;
      dut_load = load;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %b %b (%3d) > %b (%3d) %b", t.cycles,
                  dut_rst, dut_load, dut_in, dut_in,
                  dut_count, dut_count, dut_done );
      end

      `ECE2300_CHECK_EQ( dut_count, count );
      `ECE2300_CHECK_EQ( dut_done,  done  );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // Include test cases
  //----------------------------------------------------------------------

  `include "Counter_8b-test-cases.v"

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed_small();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_directed_max();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_directed_consecutive_loads();

    t.test_bench_end();
  end

endmodule

