//========================================================================
// Mux8_1b_RTL-test
//========================================================================
// Used ChatGPT to generate directed and random test cases

`include "ece2300-test.v"
`include "Mux8_1b_RTL.v"

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

  logic       dut_in0;
  logic       dut_in1;
  logic       dut_in2;
  logic       dut_in3;
  logic       dut_in4;
  logic       dut_in5;
  logic       dut_in6;
  logic       dut_in7;
  logic [2:0] dut_sel;
  logic       dut_out;

  Mux8_1b_RTL dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .in2 (dut_in2),
    .in3 (dut_in3),
    .in4 (dut_in4),
    .in5 (dut_in5),
    .in6 (dut_in6),
    .in7 (dut_in7),
    .sel (dut_sel),
    .out (dut_out)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic       in0,
    input logic       in1,
    input logic       in2,
    input logic       in3,
    input logic       in4,
    input logic       in5,
    input logic       in6,
    input logic       in7,
    input logic [2:0] sel,
    input logic       out
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_in2 = in2;
      dut_in3 = in3;
      dut_in4 = in4;
      dut_in5 = in5;
      dut_in6 = in6;
      dut_in7 = in7;
      dut_sel = sel;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %b %b %b %b %b %b %b %b > %b", t.cycles,
                  dut_in0, dut_in1, dut_in2, dut_in3,
                  dut_in4, dut_in5, dut_in6, dut_in7,
                  dut_sel, dut_out );
      end

      `ECE2300_CHECK_EQ( dut_out, out );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0 in1 in2 in3 in4 in5 in6 in7 sel out
    check( 0,  0,  0,  0,  0,  0,  0,  0,  0,  0 );
    check( 0,  0,  0,  0,  0,  0,  0,  0,  1,  0 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_directed_more
  //----------------------------------------------------------------------

  task test_case_2_directed_more();
    t.test_case_begin( "test_case_2_directed_more" );
    //     in0 in1 in2 in3 in4 in5 in6 in7 sel out
    check( 0,  0,  0,  0,  0,  0,  0,  0,  0,  0 ); // sel = 000, expect out = in0 = 0
    check( 1,  0,  0,  0,  0,  0,  0,  0,  0,  1 ); // sel = 000, expect out = in0 = 1
    check( 0,  1,  0,  0,  0,  0,  0,  0,  1,  1 ); // sel = 001, expect out = in1 = 1
    check( 0,  0,  1,  0,  0,  0,  0,  0,  2,  1 ); // sel = 010, expect out = in2 = 1
    check( 0,  0,  0,  1,  0,  0,  0,  0,  3,  1 ); // sel = 011, expect out = in3 = 1
    check( 0,  0,  0,  0,  1,  0,  0,  0,  4,  1 ); // sel = 100, expect out = in4 = 1
    check( 0,  0,  0,  0,  0,  1,  0,  0,  5,  1 ); // sel = 101, expect out = in5 = 1
    check( 0,  0,  0,  0,  0,  0,  1,  0,  6,  1 ); // sel = 110, expect out = in6 = 1
    check( 0,  0,  0,  0,  0,  0,  0,  1,  7,  1 ); // sel = 111, expect out = in7 = 1
  endtask

  //----------------------------------------------------------------------
  // test_case_3_edge_selection
  //----------------------------------------------------------------------

  task test_case_3_edge_selection();

    t.test_case_begin("test_case_edge_selection_8to1");

    //     in0 in1 in2 in3 in4 in5 in6 in7 sel out
    check( 0,  0,  0,  0,  1,  0,  0,  0,  4,  1 ); // sel = 100, expect out = in4 = 1
    check( 0,  0,  0,  0,  0,  1,  0,  0,  5,  1 ); // sel = 101, expect out = in5 = 1
    check( 0,  0,  0,  0,  0,  0,  1,  0,  6,  1 ); // sel = 110, expect out = in6 = 1
    check( 0,  0,  0,  0,  0,  0,  0,  1,  7,  1 ); // sel = 111, expect out = in7 = 1
    check( 0,  0,  0,  0,  0,  0,  0,  0,  7,  0 ); // sel = 111, expect out = in7 = 0

  endtask

  //----------------------------------------------------------------------
  // test_case_3_random
  //----------------------------------------------------------------------

  logic [7:0] random_in;  // 8-bit input, representing 8 inputs for 1-bit 8-to-1 Mux
  logic [2:0] random_sel; // 3-bit select signal
  logic       out;        // Output of the Mux

  task test_case_4_random();
    t.test_case_begin( "test_case_4_random" );

    // Generate 20 random input values
    for ( int i = 0; i < 20; i = i+1 ) begin

      // Generate random values for the 8 inputs and 3-bit select signal
      random_in = 8'($urandom(t.seed));        // Random 8-bit input for in0 to in7
      random_sel = 3'($urandom(t.seed));   // Random 3-bit select signal (0 to 7)

      // Use the RTL model to select the correct output
      case (random_sel)
        3'b000: out = random_in[0];
        3'b001: out = random_in[1];
        3'b010: out = random_in[2];
        3'b011: out = random_in[3];
        3'b100: out = random_in[4];
        3'b101: out = random_in[5];
        3'b110: out = random_in[6];
        3'b111: out = random_in[7];
        default: out = 1'b0;  // Default case to avoid latch
      endcase

      // Check the output for the given inputs and select signal
      check( random_in[0], random_in[1], random_in[2], random_in[3], random_in[4], random_in[5], random_in[6], random_in[7], random_sel, out );

    end

  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed_more();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_edge_selection();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_random();

    t.test_bench_end();

  end

endmodule

