`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2026 18:50:12
// Design Name: 
// Module Name: SRAM_abstraction_top
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
`timescale 1ns / 1ps

module Top_SRAM #(
    parameter int ROW_BITS   = 4,                       
    parameter int COL_BITS   = 4,                        
    parameter int ADDR_WIDTH = ROW_BITS + COL_BITS,      
    parameter int DATA_WIDTH = 8                         
)(
    input  logic                  rst_n,
    input  logic [ADDR_WIDTH-1:0] address,
    input  logic                  write_enable,
    input  logic                  read_enable,
    input  logic [DATA_WIDTH-1:0] data_in,               
    output logic [DATA_WIDTH-1:0] data_out,              
    inout  tri   [DATA_WIDTH-1:0] data_bus              
);

    genvar b;
    generate
        for (b = 0; b < DATA_WIDTH; b = b + 1) begin : gen_byte_matrices
            // Conduce data_in[b] hacia la línea D_in/out de la matriz b cuando se escribe
            transistor_switch u_write_driver (
                .d_in        (data_in[b]),
                .read_enable (write_enable & ~read_enable),
                .d_out       (data_bus[b])
            );

            // Matriz de memoria para el bit b del Byte
            bit_matriz #(
                .ROW_BITS (ROW_BITS),
                .COL_BITS (COL_BITS)
            ) u_bit_matrix (
                .rst_n        (rst_n),
                .address      (address),
                .write_enable (write_enable),
                .read_enable  (read_enable),
                .d_inout      (data_bus[b])
            );
        end
    endgenerate

    // Instancia de tu módulo registrar_nbit para retener el Byte leído desde el bus
    registrar_nbit #(
        .WIDTH (DATA_WIDTH)
    ) u_read_register (
        .rst_n        (rst_n),
        .write_enable (read_enable),
        .d_in         (data_bus),
        .d_out        (data_out)
    );

endmodule