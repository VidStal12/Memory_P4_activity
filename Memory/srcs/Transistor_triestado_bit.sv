`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2026 17:47:34
// Design Name: 
// Module Name: Transistor_triestado_bit
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

module transistor_switch (
    input  logic d_in,
    input  logic read_enable,
    output tri   d_out
);

    // Cuando se activa conduce la data de lo contrario funciona da alta imperancia
    assign d_out = read_enable ? d_in : 1'bz;

endmodule