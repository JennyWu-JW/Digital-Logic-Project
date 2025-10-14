//========================================================================
// AccumXcelCtrl
//========================================================================

`ifndef ACCUM_XCEL_CTRL_V
`define ACCUM_XCEL_CTRL_V

module AccumXcelCtrl
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  // I/O Interface

  (* keep=1 *) input  logic        go,
  (* keep=1 *) output logic        result_val,

  // Memory Interface

  (* keep=1 *) output logic        memreq_val,

  // Reset Status (when high finished with accumulation)

  (* keep=1 *) output logic        load_done,

  // Size Status (keep count of # of elements)

  (* keep=1 *) input  logic [13:0] size
);

  // State encoding for the FSM

  // verilator lint_off UNUSEDPARAM
  localparam STATE_IDLE     = 2'b00;
  localparam STATE_LOAD     = 2'b01;
  localparam STATE_DONE     = 2'b10;
  // verilator lint_on UNUSEDPARAM

  // Counter for # of accumulations
  logic [13:0] counter, counter_next;

  Register_RTL #(14) elements_counter (
    .clk(clk),   
    .rst(rst),
    .en(1'b1),
    .d(counter_next),
    .q(counter)
  );

  // State register
  logic [1:0] state;
  logic s1, s1_next;
  logic s0, s0_next;

  // Register for state's most significant bit 
  Register_RTL #(1) s1_register
  (
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(s1_next),
    .q(s1)
  );

  // Register for state's least significant bit 
  Register_RTL #(1) s0_register
  (
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(s0_next),
    .q(s0)
  );

  // State transition
  always_comb begin
    state = {s0, s1};
    s1_next = 1'b0;
    s0_next = 1'b0;

    if (state == STATE_IDLE) begin
      // Start accumulating if go is high
      if (go == 1'b1) begin
        s0_next = 1'b0;
        s1_next = 1'b1;
      end
      // Remain in idle otherwise
      else begin
        s0_next = 1'b0;
        s1_next = 1'b0;
      end
    end

    // If done accumulating go to load, otherwise stay in load
    else if(state == STATE_LOAD) begin
      if(counter == 0) begin
        s0_next = 1'b1;
        s1_next = 1'b0;
      end
      else begin
        s0_next = 1'b0;
        s1_next = 1'b1;
      end
    end

    // Remain in this state, need reset to perform another accumulation
    else if (state == STATE_DONE) begin
        s0_next = 1'b1;
        s1_next = 1'b0;
    end

  end

  always_comb begin
    // Default values, load counter with number of elements wanted. Not done, not fetching values, and not done so all = 0
    counter_next = size;
    result_val = 1'b0;
    memreq_val = 1'b0;
    load_done = 1'b0;

    if (state == STATE_LOAD) begin
      counter_next = counter - 1; // Counting down elements for the accumulation based on size

      if (counter == 0) begin
        memreq_val = 1'b0; // Done getting values from memory address
        load_done = 1'b1; // High when finished with accumulation
      end
      else
        memreq_val = 1'b1; // Need to get value from memory address when loading
    end

    else if (state == STATE_DONE) begin
      result_val = 1'b1; // Accelerator finished
      memreq_val = 1'b0; // No longer need to fetch more values
      load_done = 1'b1; // Done with accumulation
    end

  end

endmodule

`endif /* ACCUM_XCEL_CTRL_V */

