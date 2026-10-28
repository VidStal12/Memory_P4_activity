`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2026 17:50:10
// Design Name: 
// Module Name: decodificador
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
module decodificador #(
// bits de suma para columna y fila de la matriz 
    parameter int ADDR_BITS = 2,
    parameter int NUM_OUTS  = (1 << ADDR_BITS)
)(
    input  logic [ADDR_BITS-1:0] addr_in,
    output logic [NUM_OUTS-1:0]  select_out
);

    always_comb begin
        select_out = '0;
        select_out[addr_in] = 1'b1;
    end

endmodule