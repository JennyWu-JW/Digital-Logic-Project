//========================================================================
// proc-sim-prog1
//========================================================================

task proc_sim_prog1();

  // Read inputs
  asm( 'h000, "csrr x1, in0"      );   // Load in0 to x1
  asm( 'h004, "csrr x2, in1"      );   // Load in1 to x2
  asm( 'h008, "csrr x3, in2"      );   // Load buttons (in2) to x3

  // Check if buttons == 0 (if all buttons are 0)
  asm( 'h00c, "bne x3, x0, 0x024" );   // If buttons != 0, jump to multiplication, skip addition

  // Addition (if buttons == 0)
  asm( 'h010, "add x3, x1, x2"    );   // x3 = x1 + x2 (Addition)
  asm( 'h014, "csrw out0, x1"     );   // Store the result in out0
  asm( 'h018, "csrw out1, x2"     );
  asm( 'h01c, "csrw out2, x3"     );
  asm( 'h020, "jal x0, 0x034"     );   // Jump to end (no multiplication)

    // Multiplication (else part)
  asm( 'h024, "mul x3, x1, x2"    );   // x3 = x1 * x2 (Multiplication)
  asm( 'h028, "csrw out0, x1"     );
  asm( 'h02c, "csrw out1, x2"     );
  asm( 'h030, "csrw out2, x3"     );   // Store the result in out0
 

  // End of program
  asm( 'h034, "jal x0, 0x034"    );   // Jump to end (no-op to exit)

endtask

