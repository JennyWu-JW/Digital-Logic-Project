//========================================================================
// ImmGen_RTL
//========================================================================
// Generate immediate from a TinyRV1 instruction.
//
//  imm_type == 0 : I-type (ADDI)
//  imm_type == 1 : S-type (SW)
//  imm_type == 2 : J-type (JAL)
//  imm_type == 3 : B-type (BNE)
//

`ifndef IMM_GEN_RTL_V
`define IMM_GEN_RTL_V

module ImmGen_RTL
(
  (* keep=1 *) input  logic [31:0] inst,
  (* keep=1 *) input  logic  [1:0] imm_type,
  (* keep=1 *) output logic [31:0] imm
);

  logic [6:0]unused;
  assign unused = inst[6:0];

  logic [31:0] imm_i_type, imm_s_type, imm_j_type, imm_b_type;

  assign imm_i_type = {{20{inst[31]}}, inst[31:20]};
  assign imm_s_type = {{20{inst[31]}}, inst[31:25], inst[11:7]};
  assign imm_j_type = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
  assign imm_b_type = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};

  always_comb begin
    case (imm_type)
      2'b00: imm = imm_i_type;
      2'b01: imm = imm_s_type;
      2'b10: imm = imm_j_type;
      2'b11: imm = imm_b_type;
      default: imm = 32'd0;
    endcase
  end

endmodule

`endif /* IMM_GEN_RTL_V */

