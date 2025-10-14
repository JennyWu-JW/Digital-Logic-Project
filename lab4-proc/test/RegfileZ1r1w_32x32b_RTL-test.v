//========================================================================
// RegfileZ1r1w_32x32b_RTL-test
//========================================================================
// Used ChatGPT to generate directed and random test cases

`include "ece2300-test.v"
`include "RegfileZ1r1w_32x32b_RTL.v"

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

  logic        dut_wen;
  logic  [4:0] dut_waddr;
  logic [31:0] dut_wdata;
  logic  [4:0] dut_raddr;
  logic [31:0] dut_rdata;

  RegfileZ1r1w_32x32b_RTL dut
  (
    .clk   (clk),
    .wen   (dut_wen),
    .waddr (dut_waddr),
    .wdata (dut_wdata),
    .raddr (dut_raddr),
    .rdata (dut_rdata)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  task check
  (
    input logic        wen,
    input logic  [4:0] waddr,
    input logic [31:0] wdata,
    input logic  [4:0] raddr,
    input logic [31:0] rdata
  );
    if ( !t.failed ) begin

      dut_wen   = wen;
      dut_waddr = waddr;
      dut_wdata = wdata;
      dut_raddr = raddr;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %2d %h | %2d > %h", t.cycles,
                  dut_wen, dut_waddr, dut_wdata, dut_raddr, dut_rdata );
      end

      `ECE2300_CHECK_EQ( dut_rdata, rdata );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //    wen waddr wdata  raddr rdata
    check( 1, 1,    32'h0, 1,    32'hx );
    check( 1, 1,    32'h1, 1,    32'h0 );
    check( 0, 1,    32'h0, 1,    32'h1 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_zero
  //----------------------------------------------------------------------

  task test_case_2_zero();
    t.test_case_begin( "test_case_2_zero" );

    //    wen waddr   wdata        raddr  rdata
    check( 1,   0,    32'hDEADBEEF,  0,   32'h0 ); // Write to reg 0, should be ignored
    check( 1,   0,    32'h12345678,  0,   32'h0 ); // Write another value, still ignored
    check( 0,   0,    32'h0,         0,   32'h0 ); // Read reg 0, still zero

  endtask

  //----------------------------------------------------------------------
  // test_case_3_diff_regs
  //----------------------------------------------------------------------

  task test_case_3_diff_regs();
    t.test_case_begin( "test_case_3_diff_regs" );

    //    wen waddr   wdata         raddr  rdata
    check( 1,   4,    32'h11111111,  4,    32'hx ); // Write to reg 4
    check( 1,   5,    32'h22222222,  5,    32'hx ); // Write to reg 5
    check( 1,   6,    32'h33333333,  6,    32'hx ); // Write to reg 6
    check( 1,   7,    32'h44444444,  7,    32'hx ); // Write to reg 7

    // Read back each register to verify correct values
    check( 0,   0,    32'h0,         4,    32'h11111111 );
    check( 0,   0,    32'h0,         5,    32'h22222222 );
    check( 0,   0,    32'h0,         6,    32'h33333333 );
    check( 0,   0,    32'h0,         7,    32'h44444444 );

  endtask

  //----------------------------------------------------------------------
  // test_case_4_enable_check
  //----------------------------------------------------------------------

  task test_case_4_enable_check();
    t.test_case_begin("test_case_4_enable_check");

    // Initial write to set a known value in the register
    //   wen waddr wdata     raddr  rdata
    check( 1,   12,   32'hAAAA5555,  12,    32'hx ); // Write 0xAAAA5555 to reg 12

    // Disable write enable and attempt to write a new value
    check( 0,   12,   32'hBBBB6666,  12,    32'hAAAA5555 ); // wen is low, expect old value 0xAAAA5555

    // Verify that register 12 still holds the old value
    check( 0,   12,   32'h0,         12,    32'hAAAA5555 ); // Read reg 12, expect 0xAAAA5555

    // Additional checks to ensure `wen` low keeps the old value
    check( 1,   15,   32'hCCCC7777,  15,    32'hx );       // Write 0xCCCC7777 to reg 15
    check( 0,   15,   32'hDDDD8888,  15,    32'hCCCC7777 ); // wen low, expect reg 15 to retain 0xCCCC7777
    check( 0,   15,   32'h0,         15,    32'hCCCC7777 ); // Read reg 15, expect 0xCCCC7777

    // Verify the register file is still holding the expected values after multiple cycles with wen low
    check( 0,   12,   32'h0,         12,    32'hAAAA5555 ); // Verify reg 12 is still 0xAAAA5555
    check( 0,   15,   32'h0,         15,    32'hCCCC7777 ); // Verify reg 15 is still 0xCCCC7777

  endtask

  //----------------------------------------------------------------------
  // test_case_5_random
  //----------------------------------------------------------------------

  logic [31:0] expected_data [31:0]; // Track expected data for each register
  logic wen;
  logic [4:0] waddr, raddr;
  logic [31:0] wdata, rdata_exp;

  task test_case_5_random();
    t.test_case_begin( "test_case_5_random" );
    // Initialize all registers to zero
    for (int i = 0; i < 32; i++) begin
      expected_data[i] = 32'hX;
    end

    for (int i = 0; i < 20; i++) begin

      // Randomly generate inputs
      wen = 1'($urandom(t.seed));
      waddr = 5'($urandom(t.seed));
      wdata = 32'($urandom(t.seed));
      raddr = 5'($urandom(t.seed));

      // Determine the expected output for subsequent cycles
      if (raddr == 0) begin
        rdata_exp = 32'h0; // Register 0 always reads as 0
      end 
      else if (raddr == waddr && wen) begin
        rdata_exp = expected_data[raddr]; // Read old data if read and write are to the same register
      end 
      else begin
        rdata_exp = expected_data[raddr]; // Otherwise, read the current value
      end

      // Call check with the expected data
      check(wen, waddr, wdata, raddr, rdata_exp);

      // Update the expected data if a write occurred
      if (wen && waddr != 0) begin
        expected_data[waddr] = wdata;
      end
    end
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_zero();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_diff_regs();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_enable_check();
    if ((t.n <= 0) || (t.n == 5)) test_case_5_random();

    t.test_bench_end();
  end

endmodule

