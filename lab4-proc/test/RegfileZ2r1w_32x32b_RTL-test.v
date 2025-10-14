//========================================================================
// RegfileZ2r1w_32x32b_RTL-test
//========================================================================

`include "ece2300-test.v"
`include "RegfileZ2r1w_32x32b_RTL.v"

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
  logic  [4:0] dut_raddr0;
  logic [31:0] dut_rdata0;
  logic  [4:0] dut_raddr1;
  logic [31:0] dut_rdata1;

  RegfileZ2r1w_32x32b_RTL dut
  (
    .clk    (clk),
    .wen    (dut_wen),
    .waddr  (dut_waddr),
    .wdata  (dut_wdata),
    .raddr0 (dut_raddr0),
    .rdata0 (dut_rdata0),
    .raddr1 (dut_raddr1),
    .rdata1 (dut_rdata1)
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
    input logic  [4:0] raddr0,
    input logic [31:0] rdata0,
    input logic  [4:0] raddr1,
    input logic [31:0] rdata1
  );
    if ( !t.failed ) begin

      dut_wen    = wen;
      dut_waddr  = waddr;
      dut_wdata  = wdata;
      dut_raddr0 = raddr0;
      dut_raddr1 = raddr1;

      #8;

      if ( t.n != 0 ) begin
        $display( "%3d: %b %2d %h | %2d %2d > %h %h", t.cycles,
                  dut_wen, dut_waddr, dut_wdata,
                  dut_raddr0, dut_raddr1, dut_rdata0, dut_rdata1 );
      end

      `ECE2300_CHECK_EQ( dut_rdata0, rdata0 );
      `ECE2300_CHECK_EQ( dut_rdata1, rdata1 );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //    wen wa wdata  ra0 rdata0 ra1 rdata1
    check( 1, 1, 32'h0, 1,  32'hx, 1,  32'hx );
    check( 1, 1, 32'h1, 1,  32'h0, 1,  32'h0 );
    check( 0, 1, 32'h0, 1,  32'h1, 1,  32'h1 );

  endtask

  //----------------------------------------------------------------------
  // test_case_2_zero
  //----------------------------------------------------------------------

  task test_case_2_zero();
    t.test_case_begin("test_case_2_zero");

    //    wen waddr wdata     raddr0 rdata0  raddr1  rdata1
    check( 1,   0,    32'hDEADBEEF,  0,     32'h0,   1,      32'hx ); // Write to reg 0 (ignored)
    check( 1,   0,    32'h12345678,  0,     32'h0,   1,      32'hx ); // Write another value, ignored
    check( 0,   0,    32'h0,         0,     32'h0,   1,      32'hx ); // Read reg 0, still zero

  endtask

  //----------------------------------------------------------------------
  // test_case_3_read_after_write_same_address
  //----------------------------------------------------------------------

  task test_case_3_read_after_write_same_address();
    t.test_case_begin("test_case_3_read_after_write_same_address");

    //    wen waddr wdata      raddr0 rdata0       raddr1 rdata1
    check( 1,   2,    32'h1234ABCD,  2,     32'hx,       2,     32'hx ); // Write to reg 2
    check( 1,   2,    32'h5678EF12,  2,     32'h1234ABCD, 2,     32'h1234ABCD ); // Read old data on both ports
    check( 0,   2,    32'h0,         2,     32'h5678EF12, 2,     32'h5678EF12 ); // Verify new data in reg 2

  endtask

  //----------------------------------------------------------------------
  // test_case_4_read_during_write_different_address
  //----------------------------------------------------------------------

  task test_case_4_read_during_write_different_address();
    t.test_case_begin("test_case_4_read_during_write_different_address");

    //    wen waddr wdata      raddr0 rdata0       raddr1 rdata1
    check( 1,   8,    32'h55555555,  9,     32'hx,       8,     32'hx ); // Write to reg 8, read reg 9 (undefined)
    check( 1,   9,    32'h66666666,  8,     32'h55555555, 9,     32'hx ); // Write to reg 9, read reg 8
    check( 0,   0,    32'h0,         8,     32'h55555555, 9,     32'h66666666 ); // Verify data in reg 8 and 9

    // Additional verification to ensure independence of reads and writes
    check( 1,   10,   32'h77777777,  10,    32'hx,       11,    32'hx ); // Write to reg 10, read reg 11
    check( 1,   11,   32'h88888888,  10,    32'h77777777, 11,    32'hx ); // Write to reg 11, read reg 10
    check( 0,   0,    32'h0,         10,    32'h77777777, 11,    32'h88888888 ); // Verify data in reg 10 and 11

  endtask

  //----------------------------------------------------------------------
  // test_case_5_enable_check
  //----------------------------------------------------------------------

  task test_case_5_enable_check();
    t.test_case_begin("test_case_5_enable_check");

    // Initial write to set known values in some registers
    //    wen waddr wdata       raddr0 rdata0       raddr1 rdata1
    check( 1,   12,   32'hAAAA5555,  12,    32'hx,       13,    32'hx ); // Write 0xAAAA5555 to reg 12
    check( 1,   13,   32'hBBBB6666,  12,    32'hAAAA5555, 13,    32'hx ); // Write 0xBBBB6666 to reg 13

    // Disable write enable and attempt to write new values
    check( 0,   12,   32'hCCCC7777,  12,    32'hAAAA5555, 13,    32'hBBBB6666 ); // wen is low, reg 12 retains 0xAAAA5555
    check( 0,   13,   32'hDDDD8888,  12,    32'hAAAA5555, 13,    32'hBBBB6666 ); // wen is low, reg 13 retains 0xBBBB6666

    // Verify that the registers still hold the old values
    check( 0,   12,   32'h0,         12,    32'hAAAA5555, 13,    32'hBBBB6666 ); // Read reg 12 and 13, expect original values
    check( 0,   13,   32'h0,         12,    32'hAAAA5555, 13,    32'hBBBB6666 ); // Re-verify the same to confirm stability

    // Enable write and update the registers again
    check( 1,   12,   32'hEEEE9999,  12,    32'hAAAA5555, 13,    32'hBBBB6666 ); // Write 0xEEEE9999 to reg 12
    check( 1,   13,   32'hFFFFAAAA,  12,    32'hEEEE9999, 13,    32'hBBBB6666 ); // Write 0xFFFFAAAA to reg 13

    // Verify that the new values are updated after enabling write
    check( 0,   12,   32'h0,         12,    32'hEEEE9999, 13,    32'hFFFFAAAA ); // Read reg 12 and 13 to check updated values

  endtask

  //----------------------------------------------------------------------
  // test_case_6_random
  //----------------------------------------------------------------------

  logic [31:0] expected_data [31:0]; // Track expected data for each register
  logic wen;
  logic [4:0] waddr, raddr0, raddr1;
  logic [31:0] wdata, rdata0_exp, rdata1_exp;

  task test_case_6_random();
    t.test_case_begin("test_case_6_random");

    // Initialize all registers to undefined (X) for simulation
    for (int i = 0; i < 32; i++) begin
      expected_data[i] = 32'hX;
    end

    // Perform 20 random read/write operations
    for (int i = 0; i < 20; i++) begin

      // Randomly generate inputs
      wen = 1'($urandom(t.seed));
      waddr = 5'($urandom(t.seed));
      wdata = 32'($urandom(t.seed));
      raddr0 = 5'($urandom(t.seed));
      raddr1 = 5'($urandom(t.seed));  

      // Determine the expected output for rdata0
      if (raddr0 == 0) begin
        rdata0_exp = 32'h0; // Register 0 always reads as 0
      end 
      else if (raddr0 == waddr && wen) begin
        rdata0_exp = expected_data[raddr0]; // Read old data if waddr == raddr0 and wen is high
      end 
      else begin
        rdata0_exp = expected_data[raddr0]; // Otherwise, read the current value
      end

      // Determine the expected output for rdata1
      if (raddr1 == 0) begin
        rdata1_exp = 32'h0; // Register 0 always reads as 0
      end 
      else if (raddr1 == waddr && wen) begin
        rdata1_exp = expected_data[raddr1]; // Read old data if waddr == raddr1 and wen is high
      end 
      else begin
        rdata1_exp = expected_data[raddr1]; // Otherwise, read the current value
      end

      // Call check with the expected data
      check(wen, waddr, wdata, raddr0, rdata0_exp, raddr1, rdata1_exp);

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
    if ((t.n <= 0) || (t.n == 3)) test_case_3_read_after_write_same_address();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_read_during_write_different_address();
    if ((t.n <= 0) || (t.n == 5)) test_case_5_enable_check();
    if ((t.n <= 0) || (t.n == 6)) test_case_6_random();

    t.test_bench_end();
  end

endmodule

