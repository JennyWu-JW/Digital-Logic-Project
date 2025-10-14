//========================================================================
// proc-sim-prog2
//========================================================================

task proc_sim_prog2();

 // Read inputs (assuming the inputs are pre-loaded or read from I/O)
  asm( 'h000, "csrr x1, in0"      );   // Load in0 to x1
  asm( 'h004, "csrr x2, in1"      );   // Load in1 to x2
  asm( 'h008, "csrr x3, in2"      );   // Load buttons state (in2) to x3
  asm( 'h00c, "csrw out0, x1"     );   // Write the inputs to out0 & out1
  asm( 'h010, "csrw out1, x2"     );

  // Check if buttons == 0000
  asm( 'h014, "bne x3, x0, 0x024" );   // If buttons != 0, jump to multiplication

  // Addition (if buttons == 0000)
  asm( 'h018, "add x3, x1, x2"    );   // x3 = x1 + x2 (Addition)
  asm( 'h01c, "csrw out2, x3"     );   // Write sum to out2
  asm( 'h020, "jal x0, 0x048"     );   // Jump to end (no other operations)

  // Multiplication (if buttons == 0001)
  asm( 'h024, "addi x4, x0, 1"    );
  asm( 'h028, "bne x3, x4, 0x038" );   // If button != 1, jump to subtraction
  asm( 'h02c, "mul x3, x1, x2"    );   // x3 = x1 * x2 (Multiplication)
  asm( 'h030, "csrw out2, x3"     );   // Write result to out2
  asm( 'h034, "jal x0, 0x048"     );   // Jump to end (no other operations)
  
  // Subtraction (if buttons == 0010) 
  asm( 'h038, "addi x5, x0, -1"   );   // Put -1 into x5
  asm( 'h03c, "mul x6, x2, x5"    );   // Multiply x2 by -1 to get -x2
  asm( 'h040, "add x3, x1, x6"    );   // Subtraction x3 = x1 + -x2
  asm( 'h044, "csrw out2, x3"     );   // Write the result in out2

  // End of program
  asm( 'h048, "jal x0, 0x000"     );   // Jump to beginning, new operation

endtask

