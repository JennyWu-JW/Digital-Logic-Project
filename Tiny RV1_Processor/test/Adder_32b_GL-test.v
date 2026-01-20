//========================================================================
// Adder_32b_GL-test
//========================================================================

`include "ece2300-test.v"
`include "Adder_32b_GL.v"

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
  logic [31:0] dut_sum;

  Adder_32b_GL dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .sum (dut_sum)
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
    input logic [31:0] sum
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %h + %h (%10d + %10d) > %h (%10d)", t.cycles,
                  dut_in0, dut_in1, dut_in0, dut_in1,
                  dut_sum, dut_sum );
      end

      `ECE2300_CHECK_EQ( dut_sum, sum );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     in0    in1    sum
    check( 32'd0, 32'd0, 32'd0 );
    check( 32'd0, 32'd1, 32'd1 );
    check( 32'd1, 32'd0, 32'd1 );
    check( 32'd1, 32'd1, 32'd2 );

  endtask

  // Used ChatGPT for directed test neg values 
  task test_case_2_directed_negative_values();
    t.test_case_begin( "test_case_2_directed_negative_values" );

    // testing negative values
    //     in0           in1   sum
    check(32'hFFFFFFFF, 32'd1, 32'd0);  // -1 + 1 = 0
    check(32'hFFFFFFFE, 32'd2, 32'd0);  // -2 + 2 = 0
    check(32'hFFFFFFF6,   32'hFFFFFFEC,  32'hFFFFFFE2); // -10 + -20 = -30
    check(32'h80000000, 32'h80000000, 32'd0);  // Minimum negative number + itself (overflow)

    // Test combinations with zero
    check(32'hFFFFFFF6,   32'd0,         32'hFFFFFFF6);   // -10 + 0 = -10
    check(32'd0,          32'hFFFFFFEC,  32'hFFFFFFEC);   // 0 + -20 = -20

  endtask

  // Used ChatGPT for directed test large values 
  task test_case_3_directed_large_values();
    t.test_case_begin( "test_case_3_directed_large_values" );

    // Testing large numbers 
    //     in0             in1      sum
    check(32'd2147483647, 32'd1, 32'd2147483648);  // Max positive 32-bit int + 1
    check(32'd4294967295, 32'd1, 32'd0);  // Max 32-bit unsigned int + 1 (overflow)
    check(32'd2147483648, 32'd2147483648, 32'd0);  // Overflow case
    
  endtask

  logic [31:0]random_in0;
  logic [31:0]random_in1;
  logic [31:0]result;
  logic [31:0]sum;

  task test_case_4_random();
    t.test_case_begin( "test_case_4_random " );
  
    for ( int i = 0; i < 20; i = i+1 ) begin

      // Generate a 32-bit random value for in0 and in1, 1-bit random for cin

      random_in0 = 32'($urandom(t.seed));
      random_in1 = 32'($urandom(t.seed));

      // Find 9 bit sum, most significant being the cout and remaining being sum
      
      result = random_in0 + random_in1;
      sum    = result[31:0];

      //     in0             in1      sum 
      check( random_in0, random_in1, sum );

    end


  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed_negative_values();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_directed_large_values();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_random();


    t.test_bench_end();
  end

endmodule

