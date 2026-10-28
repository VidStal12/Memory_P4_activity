`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2026 18:41:33
// Design Name: 
// Module Name: 
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

module bit_matriz #(
    parameter int ROW_BITS = 2,
    parameter int COL_BITS = 2,
    parameter int ADDR_WIDTH = ROW_BITS + COL_BITS
)(
    input  logic                  rst_n,
    input  logic [ADDR_WIDTH-1:0] address,
    input  logic                  write_enable,
    input  logic                  read_enable,
    inout  tri                    d_inout
);

    localparam int NUM_ROWS = (1 << ROW_BITS);
    localparam int NUM_COLS = (1 << COL_BITS);

    logic [NUM_ROWS-1:0] row_wires;
    logic [NUM_COLS-1:0] col_wires;

    // Separación de la dirección en bits si elige columna o fila  
    logic [COL_BITS-1:0] col_addr;
    logic [ROW_BITS-1:0] row_addr;

    assign col_addr = address[ADDR_WIDTH-1 : ROW_BITS];
    assign row_addr = address[ROW_BITS-1   : 0];

    // 1. Decodificador Binario de Filas
    decodificador #(
        .ADDR_BITS (ROW_BITS)
    ) u_row_decoder (
        .addr_in    (row_addr),
        .select_out (row_wires)
    );

    // 2. Decodificador Binario de Columnas
    decodificador #(
        .ADDR_BITS (COL_BITS)
    ) u_col_decoder (
        .addr_in    (col_addr),
        .select_out (col_wires)
    );

    // 3. Matriz 2D de Nodos (Intersecciones Fila x Columna)
    genvar r, c;
    generate
        for (r = 0; r < NUM_ROWS; r = r + 1) begin : gen_rows
            for (c = 0; c < NUM_COLS; c = c + 1) begin : gen_cols
                nodos_celdas_matriz u_cell_node (
                    .rst_n        (rst_n),
                    .row_sel      (row_wires[r]),
                    .col_sel      (col_wires[c]),
                    .write_enable (write_enable),
                    .read_enable  (read_enable),
                    .d_inout      (d_inout)
                );
            end
        end
    endgenerate

endmodule