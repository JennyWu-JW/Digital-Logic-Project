
//========================================================================
// ProcScycleDpath
//========================================================================

`ifndef PROC_SCYCLE_DPATH_V
`define PROC_SCYCLE_DPATH_V

`include "tinyrv1.v"
`include "Register_RTL.v"
`include "Adder_32b_GL.v"
`include "RegfileZ2r1w_32x32b_RTL.v"
`include "ALU_32b.v"
`include "ImmGen_RTL.v"

`include "Mux2_RTL.v"
`include "Mux4_RTL.v"
`include "Mux8_RTL.v"
`include "Multiplier_32x32b_RTL.v"

module ProcScycleDpath
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  // Memory Interface

  (* keep=1 *) output logic        imemreq_val,
  (* keep=1 *) output logic [31:0] imemreq_addr,
  (* keep=1 *) input  logic [31:0] imemresp_data,

  (* keep=1 *) output logic        dmemreq_val,
  (* keep=1 *) output logic        dmemreq_type,
  (* keep=1 *) output logic [31:0] dmemreq_addr,
  (* keep=1 *) output logic [31:0] dmemreq_wdata,
  (* keep=1 *) input  logic [31:0] dmemresp_rdata,

  // I/O Interface

  (* keep=1 *) input  logic [31:0] in0,
  (* keep=1 *) input  logic [31:0] in1,
  (* keep=1 *) input  logic [31:0] in2,

  (* keep=1 *) output logic [31:0] out0,
  (* keep=1 *) output logic [31:0] out1,
  (* keep=1 *) output logic [31:0] out2,

  // Trace Interface

  (* keep=1 *) output logic        trace_val,
  (* keep=1 *) output logic [31:0] trace_addr,
  (* keep=1 *) output logic [31:0] trace_data,

  // Control Signals (Control Unit -> Datapath)

  (* keep=1 *) input  logic  [1:0] c2d_pc_sel,
  (* keep=1 *) input  logic  [1:0] c2d_imm_type,
  (* keep=1 *) input  logic        c2d_op2_sel,
  (* keep=1 *) input  logic        c2d_alu_func,
  (* keep=1 *) input  logic  [2:0] c2d_wb_sel,
  (* keep=1 *) input  logic        c2d_rf_wen,
  (* keep=1 *) input  logic        c2d_imemreq_val,
  (* keep=1 *) input  logic        c2d_dmemreq_val,
  (* keep=1 *) input  logic        c2d_dmemreq_type,
  (* keep=1 *) input  logic        c2d_out0_en,
  (* keep=1 *) input  logic        c2d_out1_en,
  (* keep=1 *) input  logic        c2d_out2_en,

  // Status Signals (Datapath -> Control Unit)

  (* keep=1 *) output logic [31:0] d2c_inst,
  (* keep=1 *) output logic        d2c_eq
);

  logic [`TINYRV1_INST_RS1_NBITS-1:0] rs1;
  logic [`TINYRV1_INST_RS2_NBITS-1:0] rs2;  
  logic [`TINYRV1_INST_RD_NBITS-1:0]  rd;

  assign rs1 = inst[`TINYRV1_INST_RS1];
  assign rs2 = inst[`TINYRV1_INST_RS2];
  assign rd  = inst[`TINYRV1_INST_RD];

  // Register File
  logic [31:0] rf_wdata;
  logic [31:0] rf_rdata0;
  logic [31:0] rf_rdata1;

  RegfileZ2r1w_32x32b_RTL rf
  (
    .clk    (clk),

    .wen    (c2d_rf_wen),
    .waddr  (rd),
    .wdata  (rf_wdata),

    .raddr0 (rs1),
    .rdata0 (rf_rdata0),

    .raddr1 (rs2),
    .rdata1 (rf_rdata1) 
  );

  logic [31:0] inst;
  assign inst = imemresp_data;
  assign d2c_inst = inst;

  // Immediate Generation
  logic [31:0] immgen_imm;

  ImmGen_RTL immgen(
    .inst     (inst),
    .imm_type (c2d_imm_type),
    .imm      (immgen_imm)
   );

  // 2-to-1 Mux from imm and regfile
  logic [31:0] mux2_out;

  Mux2_RTL #(32) imm_rdata1_mux(
    .in0(rf_rdata1),
    .in1(immgen_imm),
    .sel(c2d_op2_sel),
    .out(mux2_out) 
  );

  // Adder for JAL
  logic [31:0] pc;
  logic [31:0] jal_add_out;

  Adder_32b_GL jal_add(
    .in0(immgen_imm),
    .in1(pc), 
    .sum(jal_add_out)
  );

  // 4-to-1 Mux for pc
  logic [31:0] pc_next;
  logic [31:0] pc_mux_out;

  Mux4_RTL #(32) pc_mux(
    .in0(pc_next), 
    .in1(jal_add_out),
    .in2(rf_rdata0),
    .in3('0),// unused
    .sel(c2d_pc_sel),
    .out(pc_mux_out)
  );

  // Fetch Logic
  Register_RTL#(32) pc_reg
  (
    .clk (clk),
    .rst (rst),
    .en  (1'b1),
    .d   (pc_mux_out), // pc mux out
    .q   (pc)
  );

  assign imemreq_addr = pc;
  assign imemreq_val  = c2d_imemreq_val;

  // Adder for pc going to next instruction
  Adder_32b_GL pc_adder
  (
    .in0 (pc),
    .in1 (32'd4),
    .sum (pc_next)
  );

  // Instantiated Multiplier 
  logic [31:0] multi_out;

  Multiplier_32x32b_RTL multi(
    .in0(rf_rdata0),
    .in1(rf_rdata1),
    .prod(multi_out)
  );

  // ALU
  logic [31:0] alu_out;

  ALU_32b alu
  (
    .in0 (rf_rdata0),
    .in1 (mux2_out), 
    .op  (c2d_alu_func),
    .out (alu_out)
  );
  
  // 8-to-1 Mux to regfile(write)
  logic [31:0] mux8_out;

  Mux8_RTL #(32) WB_mux(
    .in0(multi_out),
    .in1(alu_out),
    .in2(pc_next), 
    .in3(dmemresp_rdata),
    .in4(in0),
    .in5(in1),
    .in6(in2),
    .in7(rf_rdata0), 
    .sel(c2d_wb_sel),
    .out(mux8_out)
  ); 

  // wires to dmemreq outputs (used for lw and sw)
  assign dmemreq_addr = alu_out; // output should be memory address 
  assign dmemreq_val = c2d_dmemreq_val; // make dmem if val to use lw

  assign dmemreq_wdata = rf_rdata1; // rs2 value stored
  assign dmemreq_type = c2d_dmemreq_type; 

  assign d2c_eq = alu_out[0]; 

  // Instantiated Register out0
  Register_RTL #(32) out_0_reg(
    .clk(clk),
    .rst(rst),
    .en(c2d_out0_en),
    .d(mux8_out),
    .q(out0)
  );

  // Instantiated Register out1
  Register_RTL #(32) out_1_reg(
    .clk(clk),
    .rst(rst),
    .en(c2d_out1_en),
    .d(mux8_out),
    .q(out1)
  );

  // Instantiated Register out2
  Register_RTL #(32) out_2_reg(
    .clk(clk),
    .rst(rst),
    .en(c2d_out2_en),
    .d(mux8_out),
    .q(out2)
  );

  assign rf_wdata = mux8_out;

  // Trace Output
  assign trace_val  = imemreq_val;
  assign trace_addr = pc;
  assign trace_data = rf_wdata;


endmodule

`endif /* PROC_SCYCLE_DPATH_V */

