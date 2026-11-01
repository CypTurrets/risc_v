`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2026 03:19:36 PM
// Design Name: 
// Module Name: ex_stage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module ex_stage (
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [31:0] imm_out,
    input  logic [31:0] address,

    input  logic        branch,
    input  logic        alu_src,
    input  logic        fn7_5,
    input  logic        mux_inp,
    input  logic [2:0]  fn3,
    input  logic [6:0]  imm11_5,
    input  logic [2:0]  aluop,
    input  logic [6:0]  opcode,

    output logic        and_out_ex,
    output logic [31:0] alu_out,
    output logic [31:0] pc_ex_out
);

    // Internal signals
    logic [31:0] alu_operand_b;
    logic [4:0]  alu_control_signal;
    logic        zero;

    logic [31:0] pc_signed_offset;

    // ---------------------------------------------
    // 1. ALU Operand B Selection
    // ---------------------------------------------
    assign alu_operand_b = alu_src ? imm_out : rs2_data;

    // ---------------------------------------------
    // 2. ALU Control Unit
    // ---------------------------------------------
    alu_control ALU_CTRL (
        .alu_op     (aluop),
        .fn3        (fn3),
        .imm11_5    (imm11_5),
        .fn7_5      (fn7_5),
        .control_out(alu_control_signal)
    );

    // ---------------------------------------------
    // 3. Arithmetic Logic Unit
    // ---------------------------------------------
    alu #(
        .DATA_WIDTH(32)
    ) ALU (
        .alu_control (alu_control_signal),
        .rs1_data    (rs1_data),
        .rs2_data    (alu_operand_b),
        .alu_out     (alu_out),
        .zero        (zero)
    );

    // ---------------------------------------------
    // 4. Branch / Jump Target Calculation
    // ---------------------------------------------
    assign pc_signed_offset = address + imm_out;

    // ---------------------------------------------
    // 5. JALR / Branch Target Selection
    // ---------------------------------------------
    assign pc_ex_out = mux_inp
                     ? {alu_out[31:1], 1'b0}
                     : pc_signed_offset;

    // ---------------------------------------------
    // 6. Branch / Jump Taken Logic
    // ---------------------------------------------
    assign and_out_ex = (branch && zero) ||
                        (opcode == 7'h6F) ||
                        (opcode == 7'h67);

endmodule

