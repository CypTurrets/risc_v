`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2026 02:38:26 PM
// Design Name: 
// Module Name: imm_generator
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



module imm_generator (
    input  logic [11:0] imm_input,
    input  logic [2:0]  fn3,
    input  logic [6:0]  opcode,
    input  logic [19:0] imm_input_uj,

    output logic [31:0] imm_output
);

    always_comb begin

        // Default: sign-extend 12-bit immediate
        imm_output = {{20{imm_input[11]}}, imm_input};

        case (opcode)

            // Branch: sign extend and shift left by 1
            7'b1100011: begin
                imm_output = $signed({{20{imm_input[11]}}, imm_input}) <<< 1;
            end

            // JAL: sign extend 20-bit immediate and shift left by 1
            7'b1101111: begin
                imm_output = $signed({{12{imm_input_uj[19]}}, imm_input_uj}) <<< 1;
            end

            // LUI and AUIPC: upper immediate
            7'b0110111,
            7'b0010111: begin
                imm_output = {imm_input_uj, 12'b0};
            end

            // JALR: sign extend 12-bit immediate
            7'b1100111: begin
                imm_output = {{20{imm_input[11]}}, imm_input};
            end

            // I-type ALU
            7'b0010011: begin

                // Shift instructions: zero-extend 5-bit shamt
                if (fn3 == 3'b001 || fn3 == 3'b101)
                    imm_output = {27'b0, imm_input[4:0]};

                // Other I-type ALU instructions: sign extend
                else
                    imm_output = {{20{imm_input[11]}}, imm_input};

            end

            // All other opcodes: sign extend 12-bit immediate
            default: begin
                imm_output = {{20{imm_input[11]}}, imm_input};
            end

        endcase

    end

endmodule

