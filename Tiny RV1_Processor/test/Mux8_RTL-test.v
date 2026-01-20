//========================================================================
// Mux8_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "Mux8_RTL.v"

//========================================================================
// Parameterized Test Suite
//========================================================================

module TestSuiteMux8
#(
  parameter p_test_suite,
  parameter p_nbits
)();

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

  logic [p_nbits-1:0] dut_in0;
  logic [p_nbits-1:0] dut_in1;
  logic [p_nbits-1:0] dut_in2;
  logic [p_nbits-1:0] dut_in3;
  logic [p_nbits-1:0] dut_in4;
  logic [p_nbits-1:0] dut_in5;
  logic [p_nbits-1:0] dut_in6;
  logic [p_nbits-1:0] dut_in7;
  logic         [2:0] dut_sel;
  logic [p_nbits-1:0] dut_out;

  Mux8_RTL
  #(
    .p_nbits (p_nbits)
  )
  dut
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
    input logic [p_nbits-1:0] in0,
    input logic [p_nbits-1:0] in1,
    input logic [p_nbits-1:0] in2,
    input logic [p_nbits-1:0] in3,
    input logic [p_nbits-1:0] in4,
    input logic [p_nbits-1:0] in5,
    input logic [p_nbits-1:0] in6,
    input logic [p_nbits-1:0] in7,
    input logic         [2:0] sel,
    input logic [p_nbits-1:0] out
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
        if ( p_nbits <= 8 )
          $display( "%3d: %b %b %b %b %b %b %b %b %b > %b", t.cycles,
                    dut_in0, dut_in1, dut_in2, dut_in3,
                    dut_in4, dut_in5, dut_in6, dut_in7,
                    dut_sel, dut_out );
        else
          $display( "%3d: %h %h %h %h %h %h %h %h %b > %h", t.cycles,
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
    check( 0,  0,  0,  0,  0,  0,  0,  0,  2,  0 );
    check( 0,  0,  0,  0,  0,  0,  0,  0,  3,  0 );

  endtask

  // Test case for 1bit in values 
  task test_case_2_directed_output_1bit();
    t.test_case_begin( "test_case_2_directed_output_1bit" );

    //     in0 in1 in2 in3 in4 in5 in6 in7 sel out
    check( 1,  0,  0,  0,  0,  0,  0,  0,  0,  1 );
    check( 0,  1,  0,  0,  0,  0,  0,  0,  1,  1 );
    check( 0,  0,  1,  0,  0,  0,  0,  0,  2,  1 );
    check( 0,  0,  0,  1,  0,  0,  0,  0,  3,  1 );

    check( 0,  0,  0,  0,  1,  0,  0,  0,  4,  1 );
    check( 0,  0,  0,  0,  0,  1,  0,  0,  5,  1 );
    check( 0,  0,  0,  0,  0,  0,  1,  0,  6,  1 );
    check( 0,  0,  0,  0,  0,  0,  0,  1,  7,  1 );

  endtask


  // Created wires for directed test case to reduce the size
  wire [p_nbits-1:0] in0_num;
  wire [p_nbits-1:0] in1_num;
  wire [p_nbits-1:0] in2_num;
  wire [p_nbits-1:0] in3_num;

  wire [p_nbits-1:0] in4_num;
  wire [p_nbits-1:0] in5_num;
  wire [p_nbits-1:0] in6_num;
  wire [p_nbits-1:0] in7_num;
  wire [p_nbits-1:0] in_zero;
  wire [p_nbits-1:0] in_ones;

  assign in0_num = p_nbits'(47);
  assign in1_num = p_nbits'(24);
  assign in2_num = p_nbits'(20);
  assign in3_num = p_nbits'(16);

  assign in4_num = p_nbits'(10);
  assign in5_num = p_nbits'(8);
  assign in6_num = p_nbits'(5);
  assign in7_num = p_nbits'(2);

  assign in_zero = p_nbits'(32'b0);
  assign in_ones = p_nbits'({32{1'b1}});

  // Test case for 4 bit truncated in values 
  task test_case_3_directed_output_4bit();
    t.test_case_begin( "test_case_3_directed_output_4bit" );

    //         in0    in1      in2      in3     in4       in5      in6      in7   sel   out
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 0, in0_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 1, in1_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 2, in2_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 3, in3_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 4, in4_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 5, in5_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 6, in6_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 7, in7_num );

  endtask

  // Test case for 32 bit in values 
  task test_case_4_directed_output_32bit();
    t.test_case_begin( "test_case_4_directed_output_32bit" );

    //         in0    in1      in2      in3     in4       in5      in6      in7   sel   out
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 0, in0_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 1, in1_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 2, in2_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 3, in3_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 4, in4_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 5, in5_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 6, in6_num );
    check( in0_num, in1_num, in2_num, in3_num, in4_num, in5_num, in6_num, in7_num, 7, in7_num );

    // Edge cases with all zeros and ones 
    //         in0    in1      in2      in3     in4       in5      in6      in7   sel   out
    check( in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, 0, in_zero );
    check( in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, 1, in_zero );
    check( in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, 2, in_zero );
    check( in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, 3, in_zero );
    check( in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, 4, in_zero );
    check( in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, 5, in_zero );
    check( in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, 6, in_zero );
    check( in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, in_zero, 7, in_zero );

    //         in0    in1      in2      in3     in4       in5      in6      in7   sel   out
    check( in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, 0, in_ones );
    check( in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, 1, in_ones );
    check( in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, 2, in_ones );
    check( in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, 3, in_ones );
    check( in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, 4, in_ones );
    check( in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, 5, in_ones );
    check( in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, 6, in_ones );
    check( in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, in_ones, 7, in_ones );


  endtask

  logic [p_nbits-1:0] ran_in0;
  logic [p_nbits-1:0] ran_in1;
  logic [p_nbits-1:0] ran_in2;
  logic [p_nbits-1:0] ran_in3;
  logic [p_nbits-1:0] ran_in4;
  logic [p_nbits-1:0] ran_in5;
  logic [p_nbits-1:0] ran_in6;
  logic [p_nbits-1:0] ran_in7;
  logic         [2:0] ran_sel;
  logic [p_nbits-1:0] ran_out;
  
  task test_case_5_random();
    t.test_case_begin( "test_case_5_random" );

    for ( int i = 0; i < 50; i = i+1 ) begin

      // Generate random values for inputs and sel
      ran_in0 = p_nbits'($urandom(t.seed));
      ran_in1 = p_nbits'($urandom(t.seed));
      ran_in2 = p_nbits'($urandom(t.seed));
      ran_in3 = p_nbits'($urandom(t.seed));
      ran_in4 = p_nbits'($urandom(t.seed));
      ran_in5 = p_nbits'($urandom(t.seed));
      ran_in6 = p_nbits'($urandom(t.seed));
      ran_in7 = p_nbits'($urandom(t.seed));
      ran_sel = 3'($urandom(t.seed));

      // Determine correct answer 
      if( ran_sel == 0)
        ran_out = ran_in0;
      else if ( ran_sel == 1)
        ran_out = ran_in1;
      else if ( ran_sel == 2)
        ran_out = ran_in2;
      else if ( ran_sel == 3)
        ran_out = ran_in3;
      else if ( ran_sel == 4)
        ran_out = ran_in4;
      else if ( ran_sel == 5)
        ran_out = ran_in5;
      else if ( ran_sel == 6)
        ran_out = ran_in6;
      else
        ran_out = ran_in7;
      
      //      in0     in1       in2       in3     in4       in5     in6     in7       sel    out
      check(ran_in0, ran_in1, ran_in2, ran_in3, ran_in4, ran_in5, ran_in6, ran_in7, ran_sel, ran_out );
    
    end
  endtask


  //----------------------------------------------------------------------
  // run_test_suite
  //----------------------------------------------------------------------

  string test_suite_name;

  task run_test_suite( input int test_suite, input int n );
    if (( test_suite <= 0 ) || ( test_suite == p_test_suite )) begin
      $sformat( test_suite_name, "TestSuite: %0d\nMux8(.p_nbits(%0d))", p_test_suite, p_nbits );
      t.test_suite_begin( test_suite_name );

      if ((n <= 0) || (n == 1)) test_case_1_basic();
      if ((n <= 0) || (n == 2)) test_case_2_directed_output_1bit();
      if ((n <= 0) || (n == 3)) test_case_3_directed_output_4bit();
      if ((n <= 0) || (n == 4)) test_case_4_directed_output_32bit();
      if ((n <= 0) || (n == 5)) test_case_5_random();

      t.test_suite_end();
    end
  endtask

endmodule

//========================================================================
// Top
//========================================================================

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
  // Parameterized Test Suites
  //----------------------------------------------------------------------

  TestSuiteMux8
  #(
    .p_test_suite(1),
    .p_nbits(1)
  )
  test_suite_mux8_nbits_1();

  // Testing 4 bit width wide 
  TestSuiteMux8
  #(
    .p_test_suite(4),
    .p_nbits(4)
  )
  test_suite_mux8_nbits_4();

  // Testing 32 bit width wide 
  TestSuiteMux8
  #(
    .p_test_suite(32),
    .p_nbits(32)
  )
  test_suite_mux8_nbits_32();

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    test_suite_mux8_nbits_1.run_test_suite ( t.test_suite, t.test_case );
    test_suite_mux8_nbits_4.run_test_suite ( t.test_suite, t.test_case );
    test_suite_mux8_nbits_32.run_test_suite ( t.test_suite, t.test_case );

    t.test_bench_end();
  end

endmodule

