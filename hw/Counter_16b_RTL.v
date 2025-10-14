//========================================================================
// Counter_16b_RTL
//========================================================================

`ifndef COUNTER_16B_RTL_V
`define COUNTER_16B_RTL_V

`include "Register_16b_RTL.v"

module Counter_16b_RTL
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,
  (* keep=1 *) input  logic        load,
  (* keep=1 *) input  logic [15:0] in,
  (* keep=1 *) output logic [15:0] count,
  (* keep=1 *) output logic        done
);

  logic [15:0] next;
  logic next_done;

  //Create 16-bit register with enable always high
  Register_16b_RTL register(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(next),
    .q(count)
  );

  // Combinational logic to take input and subtract by 1, output when finished where count is zero
  always_comb begin
    next = count; // Default values
    next_done = 1'b0;

    if (load) begin
      // Load input value
      next = in;
      next_done = (count == 16'b0); // Checks if equals to 0, otherwise not done
    end
    
    else if (count > 16'b0) begin
      // Decrement the counter and checks if equals to 0 otherwise not done
      next = count - 16'b0000_0000_0000_0001;
      next_done = (count == 16'b0);
    end

    else begin
      // When count is zero, done remains high
      next_done = (count == 16'b0);
    end
  end

  assign done = next_done;

endmodule

`endif /* COUNTER_16B_RTL_V */

