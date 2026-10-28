`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2026 17:32:11
// Design Name: 
// Module Name: Latch_AND_OR
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


module and_or_latch (
    input  logic rst_n,   // Estado inicial 
    input  logic set,     
    input  logic reset,   
    output logic q        // Bit de data
);

    logic or_out;
    logic reset_eff;
    logic not_reset;

    // Si rst_n == 0 al inicio
    assign reset_eff = reset | (~rst_n);

    // Inversor 
    assign not_reset = ~reset_eff;

    // Compuerta OR 
    assign or_out    = set | q;

    // Compuerta AND 
    assign q         = or_out & not_reset;

endmodule