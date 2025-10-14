//========================================================================
// Counter_16b_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "Counter_16b_RTL.v"

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

  logic        dut_rst;
  logic        dut_load;
  logic [15:0] dut_in;
  logic [15:0] dut_count;
  logic        dut_done;

  Counter_16b_RTL counter
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
  task check
  (
    input logic        rst,
    input logic        load,
    input logic [15:0] in,
    input logic [15:0] count,
    input logic        done
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
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //    rst ld in                       count                   done
    check( 0, 0, 16'b0000_0000_0000_0000, 16'b0000_0000_0000_0000, 1 );
    check( 0, 1, 16'b0000_0000_0000_0011, 16'b0000_0000_0000_0000, 1 );
    check( 0, 0, 16'b0000_0000_0000_0000, 16'b0000_0000_0000_0011, 0 );
    check( 0, 0, 16'b0000_0000_0000_0000, 16'b0000_0000_0000_0010, 0 );
    check( 0, 0, 16'b0000_0000_0000_0000, 16'b0000_0000_0000_0001, 0 );
    check( 0, 0, 16'b0000_0000_0000_0000, 16'b0000_0000_0000_0000, 1 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_directed_small
  //----------------------------------------------------------------------

  task test_case_2_directed_small();
    t.test_case_begin( "test_case_2_directed_small" );

    // Load counter with 5
    //    rst ld in count done
    check( 0, 1, 5, 0, 1 );
    for ( int i = 5; i > 0; i = i-1 )
      check( 0, 0, 0, 16'(i), 0 );
    check( 0, 0, 0, 0, 1 );

    // Check count down from 10
    //    rst ld in count done
    check( 0, 1, 10,  0,   1 );
    for ( int i = 10; i > 0; i = i-1 )
      check( 0, 0, 0, 16'(i), 0 );
    check( 0, 0, 0, 0, 1 );

    // Check count down from 16
    //    rst ld in count done
    check( 0, 1, 16, 0, 1 );
    for ( int i = 16; i > 0; i = i-1 )
      check( 0, 0, 0, 16'(i), 0 );
    check( 0, 0, 0, 0, 1 );

  endtask

  //----------------------------------------------------------------------
  // test_case_3_directed_more
  //----------------------------------------------------------------------

  task test_case_3_directed_more();
    t.test_case_begin( "test_case_3_directed_more" ); 
    //checks when rst = 1 
    //    rst ld in                       count                   done
    check( 1, 0, 16'b0000_0000_0000_0011, 16'b0000_0000_0000_0000, 1 );

    // checks when rst = 1, load = 1
    //    rst ld in                       count                   done
    check( 1, 1, 16'b0000_0000_0000_0011, 16'b0000_0000_0000_0000, 1 );

    // Load counter from 20
    //   rst ld in count done
    check( 0, 1, 20, 0, 1 );
    for ( int i = 20; i > 0; i = i-1 )
      //    rst ld in count done
      check( 0, 0, 0, 16'(i), 0 );
    check( 0, 0, 0, 0, 1 );

  endtask


  //----------------------------------------------------------------------
  // test_case_4_random
  //----------------------------------------------------------------------

  logic [15:0] random_in;
  task test_case_4_random();
    t.test_case_begin("test_case_4_random");  
    for ( int i = 0; i < 1; i = i+1 ) begin
      // assign in with random 16'b value 
      random_in = 16'($urandom(t.seed));
      //   rst ld   in    count done
      check(0, 1, random_in, 0, 1);
      for(int j = {16'b0, random_in}; j> 0; j = j - 1) begin
      //     rst ld in count done
        check(0, 0, 0, 16'(j), 0);
      end 
    end
    //   rst ld in count done
      check(0,0,0,0,1);

  endtask


  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed_small();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_directed_more();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_random();


    t.test_bench_end();
  end

endmodule
