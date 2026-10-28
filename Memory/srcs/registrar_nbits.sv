`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2026 17:37:53
// Design Name: 
// Module Name: registrar_nbits
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

module registrar_nbit #(    /// Operador ternario
    parameter int WIDTH = 8
) (
    input  logic             rst_n,
    input  logic             write_enable,
    input  logic [WIDTH-1:0] d_in,
    output logic [WIDTH-1:0] d_out
);

// Dependiendo de los bits más significativos activaremso una linea de la matriz que tiene los latches
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_reg_latches
            compuerta_latch u_latch (
                .rst_n        (rst_n),
                .data         (d_in[i]),
                .write_enable (write_enable),
                .d_out        (d_out[i])
            );
        end
    endgenerate

endmodule