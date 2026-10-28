`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2026 17:56:53
// Design Name: 
// Module Name: Detectar_celda_Matriz
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
module nodos_celdas_matriz (
    input  logic rst_n,
    input  logic row_sel,
    input  logic col_sel,
    input  logic write_enable,
    input  logic read_enable,
    inout  tri   d_inout
);

    logic cell_selected;
    logic local_we;
    logic local_re;
    logic latch_q;

    // 1. Compuerta AND de intersección (Fila & Columna)
    assign cell_selected = row_sel & col_sel;

    // 2. Compuertas AND que bloquean/habilitan Write Enable y Read Enable en esta celda
    assign local_we      = cell_selected & write_enable;
    assign local_re      = cell_selected & read_enable;

    // 3. Gated Latch que toma su entrada directamente de la línea compartida d_inout
    compuerta_latch u_gated_latch (
        .rst_n        (rst_n),
        .data         (d_inout),
        .write_enable (local_we),
        .d_out        (latch_q)
    );

    // 4. Transistor de salida que vuelca latch_q hacia d_inout solo cuando local_re == 1
    transistor_switch u_read_transistor (
        .d_in        (latch_q),
        .read_enable (local_re),
        .d_out       (d_inout)
    );

endmodule