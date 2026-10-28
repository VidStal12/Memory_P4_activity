`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2026 17:35:03
// Design Name: 
// Module Name: compuerta_latch
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
module compuerta_latch (
    input  logic rst_n,
    input  logic data,
    input  logic write_enable,
    output logic d_out
);

    logic not_data;
    logic set_wire;
    logic reset_wire;

    // Inversor en DATA
    assign not_data   = ~data;

    // Escritura por compuerta AND 
    assign set_wire   = data     & write_enable;
    assign reset_wire = not_data & write_enable;

    // Instancia del Latch AND_OR 
    and_or_latch u_and_or_latch (
        .rst_n (rst_n),
        .set   (set_wire),
        .reset (reset_wire),
        .q     (d_out)
    );

endmodule