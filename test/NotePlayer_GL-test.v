//========================================================================
// NotePlayer_GL-test
//========================================================================

`include "ece2300-test.v"
`include "NotePlayer_GL.v"

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
  logic [7:0] dut_period;
  logic [3:0] dut_state;
  logic       dut_note;

  NotePlayer_GL note_player
  (
    .clk    (clk),
    .rst    (reset || dut_rst),
    .period (dut_period),
    .state  (dut_state),
    .note   (dut_note)
  );

  //----------------------------------------------------------------------
  // check
  //----------------------------------------------------------------------
  // All tasks start at #1 after the rising edge of the clock. So we
  // write the inputs #1 after the rising edge, and check the outputs #1
  // before the next rising edge.

  string state_str;
  localparam STATE_RESET     = 4'b0000;
  localparam STATE_LOAD_HIGH = 4'b1000;
  localparam STATE_WAIT_HIGH = 4'b0100;
  localparam STATE_LOAD_LOW  = 4'b0010;
  localparam STATE_WAIT_LOW  = 4'b0001;

  task check
  (
    input logic       rst,
    input logic [7:0] period,
    input logic [3:0] state,
    input logic       note
  );
    if ( !t.failed ) begin

      dut_rst    = rst;
      dut_period = period;

      #8;

      if ( t.n != 0 ) begin

        case ( dut_state )
          STATE_RESET:     state_str = "RESET    ";
          STATE_LOAD_HIGH: state_str = "LOAD_HIGH";
          STATE_WAIT_HIGH: state_str = "WAIT_HIGH";
          STATE_LOAD_LOW:  state_str = "LOAD_LOW ";
          STATE_WAIT_LOW:  state_str = "WAIT_LOW ";
          default:         state_str = "?        ";
        endcase

        $display( "%3d: %b %b > %b (%s) %b", t.cycles,
                  dut_rst, dut_period, dut_state, state_str, dut_note );

      end

      `ECE2300_CHECK_EQ( dut_state, state );
      `ECE2300_CHECK_EQ( dut_note,  note  );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // Include test cases
  //----------------------------------------------------------------------

  `include "NotePlayer-test-cases.v"

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin( `__FILE__ );

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_reset_behavior();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_random();

    t.test_bench_end();
  end

endmodule

