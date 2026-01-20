//========================================================================
// Mux2_8b_GL-test
//========================================================================
// Used ChatGPT to generate directed test cases

`include "ece2300-test.v"
`include "Mux2_8b_GL.v"

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
  logic       dut_sel;
  logic [7:0] dut_out;

  Mux2_8b_GL dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
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
    input logic [7:0] in0,
    input logic [7:0] in1,
    input logic       sel,
    input logic [7:0] out
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_sel = sel;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %b %b > %b", t.cycles,
                  dut_in0, dut_in1, dut_sel, dut_out );
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

    //     in0          in1          sel   out
    check( 8'b00000000, 8'b00000000, 1'b0, 8'b00000000 );
    check( 8'b00000000, 8'b00000000, 1'b1, 8'b00000000 );

  endtask

  task test_case_2_directed();
    t.test_case_begin( "test_case_2_directed" );

    //     in0          in1          sel   out
    check( 8'b11111111, 8'b00000000, 1'b0, 8'b11111111 );
    check( 8'b00000000, 8'b11111111, 1'b1, 8'b11111111 );
    check( 8'b10101010, 8'b01010101, 1'b0, 8'b10101010 );
    check( 8'b10101010, 8'b01010101, 1'b1, 8'b01010101 );
    check( 8'b11001100, 8'b00110011, 1'b0, 8'b11001100 );
    check( 8'b11001100, 8'b00110011, 1'b1, 8'b00110011 );
    check( 8'b11110000, 8'b00001111, 1'b0, 8'b11110000 );
    check( 8'b11110000, 8'b00001111, 1'b1, 8'b00001111 );

  endtask

  logic [7:0] random_in0;
  logic [7:0] random_in1;
  logic       random_sel;
  logic [7:0] out;

  task test_case_3_random();
    t.test_case_begin( "test_case_3_random" );

    // Generate 20 random input values

    for ( int i = 0; i < 20; i = i+1 ) begin

      // Generate a 8-bit random value for in0 and in1, 1-bit random for cout

      random_in0 = 8'($urandom(t.seed));
      random_in1 = 8'($urandom(t.seed));
      random_sel = 1'($urandom(t.seed));

      // Check using boolean equations from K-map from each individual bit of the out
      
      assign out[0] = (random_in0[0] & random_in1[0]) | (~random_sel & random_in0[0]) | (random_sel & random_in1[0]);
      assign out[1] = (random_in0[1] & random_in1[1]) | (~random_sel & random_in0[1]) | (random_sel & random_in1[1]);
      assign out[2] = (random_in0[2] & random_in1[2]) | (~random_sel & random_in0[2]) | (random_sel & random_in1[2]);
      assign out[3] = (random_in0[3] & random_in1[3]) | (~random_sel & random_in0[3]) | (random_sel & random_in1[3]);
      assign out[4] = (random_in0[4] & random_in1[4]) | (~random_sel & random_in0[4]) | (random_sel & random_in1[4]);
      assign out[5] = (random_in0[5] & random_in1[5]) | (~random_sel & random_in0[5]) | (random_sel & random_in1[5]);
      assign out[6] = (random_in0[6] & random_in1[6]) | (~random_sel & random_in0[6]) | (random_sel & random_in1[6]);
      assign out[7] = (random_in0[7] & random_in1[7]) | (~random_sel & random_in0[7]) | (random_sel & random_in1[7]);
      
      check( random_in0, random_in1, random_sel, out );

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

