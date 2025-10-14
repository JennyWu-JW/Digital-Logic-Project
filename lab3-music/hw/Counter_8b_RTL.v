//========================================================================
// Counter_8b_RTL
//========================================================================
//Used ChatGPT to create body of combinational logic, had to change the 
//values as it was set wrong

`ifndef COUNTER_8B_RTL_V
`define COUNTER_8B_RTL_V

`include "Register_8b_RTL.v"

module Counter_8b_RTL
(
  (* keep=1 *) input  logic       clk,
  (* keep=1 *) input  logic       rst,
  (* keep=1 *) input  logic       load,
  (* keep=1 *) input  logic [7:0] in,
  (* keep=1 *) output logic [7:0] count,
  (* keep=1 *) output logic       done
);

  logic [7:0] next;
  logic next_done;

  //Create 8-bit register with enable always high
  Register_8b_RTL register(
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(next),
    .q(count)
  );
  
  // Combinational logic to take input and subtract by 1, output when finished where count is zero
  always_comb begin
    next = count;
    next_done = 1'b0;

    if (load) begin
      // Load input value
      next = in;
      next_done = (count == 8'b0); // Checks if equals to 0, otherwise not done
    end
    
    else if (count > 8'b0) begin
      // Decrement the counter and checks if equals to 0 otherwise not done
      next = count - 8'b1;
      next_done = (count == 8'b0);
    end
    
    else begin
      // When count is zero, done remains high
      next_done = (count == 8'b0);
    end
  end

  assign done = next_done;

endmodule

`endif /* COUNTER_8B_RTL_V */
