`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2026 03:04:59 PM
// Design Name: 
// Module Name: alu
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



module alu #(
    parameter int DATA_WIDTH = 32
)(
    input  logic [4:0]            alu_control,
    input  logic [DATA_WIDTH-1:0] rs1_data,
    input  logic [DATA_WIDTH-1:0] rs2_data,

    output logic [DATA_WIDTH-1:0] alu_out,
    output logic                  zero
);

    always_comb begin

        // Default outputs
        alu_out = '0;
        zero    = 1'b0;

        case (alu_control)

            // Arithmetic operations
            5'b00000: begin
                alu_out = rs1_data + rs2_data;       // ADD
            end

            5'b00001: begin
                alu_out = rs1_data - rs2_data;       // SUB
            end

            // Logical operations
            5'b00010: begin
                alu_out = rs1_data ^ rs2_data;       // XOR
            end

            5'b00011: begin
                alu_out = rs1_data | rs2_data;       // OR
            end

            5'b00100: begin
                alu_out = rs1_data & rs2_data;       // AND
            end

            // Shift operations
            5'b00101: begin
                alu_out = rs1_data << rs2_data[4:0]; // SLL
            end

            5'b00110: begin
                alu_out = rs1_data >> rs2_data[4:0]; // SRL
            end

            5'b00111: begin
                alu_out = $signed(rs1_data) >>> rs2_data[4:0]; // SRA
            end

            // Set less than operations
            5'b01000: begin
                alu_out = ($signed(rs1_data) < $signed(rs2_data))
                          ? {{(DATA_WIDTH-1){1'b0}}, 1'b1}
                          : '0;
            end

            5'b01001: begin
                alu_out = (rs1_data < rs2_data)
                          ? {{(DATA_WIDTH-1){1'b0}}, 1'b1}
                          : '0;
            end

            // Branch comparison operations
            5'b01010: begin
                zero = (rs1_data == rs2_data); // BEQ
            end

            5'b01011: begin
                zero = (rs1_data != rs2_data); // BNE
            end

            5'b01100: begin
                zero = ($signed(rs1_data) < $signed(rs2_data)); // BLT
            end

            5'b01101: begin
                zero = ($signed(rs1_data) >= $signed(rs2_data)); // BGE
            end

            5'b01110: begin
                zero = (rs1_data < rs2_data); // BLTU
            end

            5'b01111: begin
                zero = (rs1_data >= rs2_data); // BGEU
            end

            // Unused operations
            default: begin
                alu_out = '0;
                zero    = 1'b0;
            end

        endcase

    end

endmodule

