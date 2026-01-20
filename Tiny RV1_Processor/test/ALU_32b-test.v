//========================================================================
// ALU_32b-test
//========================================================================
// Used ChatGPT to generate directed and random test cases

`include "ece2300-test.v"
`include "ALU_32b.v"

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
  logic        dut_op;
  logic [31:0] dut_out;

  ALU_32b dut
  (
    .in0 (dut_in0),
    .in1 (dut_in1),
    .op  (dut_op),
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
    input logic [31:0] in0,
    input logic [31:0] in1,
    input logic        op,
    input logic [31:0] out
  );
    if ( !t.failed ) begin

      dut_in0 = in0;
      dut_in1 = in1;
      dut_op  = op;

      #8;

      if ( t.n != 0 ) begin
        if ( op == 0 ) begin
          $display( "%3d: %h +  %h (%10d +  %10d) > %h (%10d)", t.cycles,
                    dut_in0, dut_in1, dut_in0, dut_in1,
                    dut_out, dut_out );
        end
        else begin
          $display( "%3d: %h == %h (%10d == %10d) > %h (%10d)", t.cycles,
                    dut_in0, dut_in1, dut_in0, dut_in1,
                    dut_out, dut_out );
        end
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

    //     in0    in1    op out
    check( 32'd0, 32'd0, 0, 32'd0 );
    check( 32'd0, 32'd1, 0, 32'd1 );
    check( 32'd1, 32'd0, 0, 32'd1 );
    check( 32'd1, 32'd1, 0, 32'd2 );

    check( 32'd0, 32'd0, 1, 32'd1 );
    check( 32'd0, 32'd1, 1, 32'd0 );
    check( 32'd1, 32'd0, 1, 32'd0 );
    check( 32'd1, 32'd1, 1, 32'd1 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_addition
  //----------------------------------------------------------------------

  task test_case_2_addition();
    t.test_case_begin("test_case_2_addition");

    // Directed test cases for addition (op = 0)
    //     in0           in1           op  out
    check( 32'd0,        32'd0,        0,  32'd0 );
    check( 32'd0,        32'd1,        0,  32'd1 );
    check( 32'd1,        32'd0,        0,  32'd1 );
    check( 32'd1,        32'd1,        0,  32'd2 );
    check( 32'd15,       32'd5,        0,  32'd20 );
    check( 32'hFFFFFFFF, 32'd1,        0,  32'd0 ); // Overflow case (wrap-around)
    check( 32'd1000,     32'd2000,     0,  32'd3000 );

  endtask

  //----------------------------------------------------------------------
  // test_case_3_equality
  //----------------------------------------------------------------------

  task test_case_3_equality();
    t.test_case_begin("test_case_3_equality");

    // Directed test cases for equality check (op = 1)
    check( 32'd0,        32'd0,        1,  32'd1 );
    check( 32'd0,        32'd1,        1,  32'd0 );
    check( 32'd1,        32'd0,        1,  32'd0 );
    check( 32'd1,        32'd1,        1,  32'd1 );
    check( 32'hABCD1234, 32'hABCD1234, 1,  32'd1 ); // Same value
    check( 32'h12345678, 32'h87654321, 1,  32'd0 ); // Different value
    check( 32'd100,      32'd100,      1,  32'd1 );

  endtask

  //----------------------------------------------------------------------
  // test_case_4_random
  //----------------------------------------------------------------------
  
  logic [31:0] rand_in0;
  logic [31:0] rand_in1;
  logic [31:0] out;
  logic rand_op;

  task test_case_4_random();
    t.test_case_begin("test_case_4_random");
    for (int i = 0; i < 20; i++) begin

      // Random values for the 2 inputs and operator
      rand_in0 = 32'($urandom());
      rand_in1 = 32'($urandom());
      rand_op = 1'($urandom());

      // Select which output is expected depending on op input
      if (rand_op == 0)
        out = rand_in0 + rand_in1; // Addition
      else
        out = (rand_in0 == rand_in1) ? 32'd1 : 32'd0; // Equality

      check(rand_in0, rand_in1, rand_op, out);

    end
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_addition();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_equality();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_random();

    t.test_bench_end();
  end

endmodule

