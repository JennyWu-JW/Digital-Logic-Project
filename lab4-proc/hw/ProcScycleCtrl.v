//========================================================================
// ProcScycleCtrl
//========================================================================

`ifndef PROC_SCYCLE_CTRL_V 
`define PROC_SCYCLE_CTRL_V

`include "tinyrv1.v"

module ProcScycleCtrl
(
  (* keep=1 *) input  logic        rst,

  // Control Signals (Control Unit -> Datapath)

  (* keep=1 *) output logic  [1:0] c2d_pc_sel,
  (* keep=1 *) output logic  [1:0] c2d_imm_type,
  (* keep=1 *) output logic        c2d_op2_sel,
  (* keep=1 *) output logic        c2d_alu_func,
  (* keep=1 *) output logic  [2:0] c2d_wb_sel,
  (* keep=1 *) output logic        c2d_rf_wen,
  (* keep=1 *) output logic        c2d_imemreq_val,
  (* keep=1 *) output logic        c2d_dmemreq_val,
  (* keep=1 *) output logic        c2d_dmemreq_type,
  (* keep=1 *) output logic        c2d_out0_en,
  (* keep=1 *) output logic        c2d_out1_en,
  (* keep=1 *) output logic        c2d_out2_en,

  // Status Signals (Datapath -> Control Unit)

  (* keep=1 *) input  logic [31:0] d2c_inst,
  (* keep=1 *) input  logic        d2c_eq
);

  // Localparams for different control signals

  // verilator lint_off UNUSED
  localparam imm_i = 2'd0;
  localparam imm_s = 2'd1;
  localparam imm_j = 2'd2;
  localparam imm_b = 2'd3;

  localparam add   = 1'd0;
  localparam mul   = 1'd1;
  // verilator lint_on UNUSED

  // Task for setting control signals
  task automatic cs
  (
    input logic [1:0] pc_sel,
    input logic [1:0] imm_type,
    input logic       op2_sel,
    input logic       alu_func,
    input logic [2:0] wb_sel,
    input logic       rf_wen,
    input logic       imemreq_val,
    input logic       dmemreq_val,
    input logic       dmemreq_type
  );
    c2d_pc_sel       = pc_sel;
    c2d_imm_type     = imm_type;
    c2d_op2_sel      = op2_sel;
    c2d_alu_func     = alu_func;
    c2d_wb_sel       = wb_sel;
    c2d_rf_wen       = rf_wen;
    c2d_imemreq_val  = imemreq_val;
    c2d_dmemreq_val  = dmemreq_val;
    c2d_dmemreq_type = dmemreq_type;
  endtask

  // Logic for BNE to determine if we do PC + 4 or if we jump
  logic [1:0] bne_sel;

  always_comb begin
    if ( d2c_eq ) begin
      bne_sel = 0;
    end
    else begin
      bne_sel = 1;
    end
  end

  // CSR instructions, mapping corresponding addresses to the correct output on register
  logic [2:0] csrr_sel;
  logic [11:0] csr;
  assign csr = d2c_inst[31:20];

  always_comb begin

    csrr_sel = 0;
    if ( csr == `TINYRV1_CSR_IN0 )
      csrr_sel = 4;
    if ( csr == `TINYRV1_CSR_IN1 )
      csrr_sel = 5;
    if ( csr == `TINYRV1_CSR_IN2 )
      csrr_sel = 6;

  end

  // Control signal table
  always_comb begin
    c2d_out0_en = 0;
    c2d_out1_en = 0;
    c2d_out2_en = 0;
    if ( rst )
      cs( '0, '0, '0, '0, '0, '0, '0, '0, '0 );
    else begin
      casez ( d2c_inst )
                          //    pc       imm    op2  alu     wb     rf  imem dmem dmem
                          //    sel      type   sel  func    sel   wen   val  val  type
        `TINYRV1_INST_ADDI: cs(  0,      imm_i,  1,  add,     1,    1,  1,    0,   0   );
        `TINYRV1_INST_ADD:  cs(  0,      'x,     0,  add,     1,    1,  1,    0,   0   );
        `TINYRV1_INST_MUL:  cs(  0,      'x,     0,  'x,      0,    1,  1,    0,   0   );
        `TINYRV1_INST_LW:   cs(  0,      imm_i,  1,  add,     3,    1,  1,    1,   0   );
        `TINYRV1_INST_SW:   cs(  0,      imm_s,  1,  add,    'x,    0,  1,    1,   1   ); // Not sure why imem val change passes both

        `TINYRV1_INST_JAL:  cs(  1,      imm_j, 'x,  'x,      2,    1,  1,    0,   0   );
        `TINYRV1_INST_JR:   cs(  2,      imm_j, 'x,  'x,     'x,    0,  1,    1,   0   );

        `TINYRV1_INST_BNE:  cs( bne_sel, imm_b,  0,   mul,   'x,    0,  1,    0,   0   ); //conditional pc_sel

        `TINYRV1_INST_CSRR: cs(  0,      imm_i, 'x,  'x, csrr_sel,  1,  1,    0,   0   );
        
        `TINYRV1_INST_CSRW: begin
          cs(  0,      imm_i, 'x,  'x,      7,    0,  1,    0,  'x   );
          case(csr)
            `TINYRV1_CSR_OUT0: begin
              c2d_out0_en = 1;
              c2d_out1_en = 0;
              c2d_out2_en = 0;
            end
            `TINYRV1_CSR_OUT1: begin
              c2d_out0_en = 0;
              c2d_out1_en = 1;
              c2d_out2_en = 0;
            end
            `TINYRV1_CSR_OUT2: begin
              c2d_out0_en = 0;
              c2d_out1_en = 0;
              c2d_out2_en = 1;
            end
            default: begin
              c2d_out0_en = 0;
              c2d_out1_en = 0;
              c2d_out2_en = 0;
            end
          endcase
        end
        default:            cs( 'x,        'x,  'x,  'x,     'x,   'x,  1,   'x,  'x   );
      endcase
    end
  end

endmodule

`endif /* PROC_SCYCLE_CTRL_V */
