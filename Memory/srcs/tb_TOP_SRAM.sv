`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2026 19:18:24
// Design Name: 
// Module Name: tb_TOP_SRAM
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

module tb_Top_SRAM;

    // Parámetros idénticos a SRAM_abstraction_top.sv (Matriz 16x16 = 256 Bytes)
    localparam int ROW_BITS   = 4;
    localparam int COL_BITS   = 4;
    localparam int ADDR_WIDTH = ROW_BITS + COL_BITS; // 8 bits de dirección (0 a 255)
    localparam int DATA_WIDTH = 8;                   // 8 bits de datos (1 Byte)

    // Señales conectadas al módulo Top_SRAM
    logic                  rst_n;
    logic [ADDR_WIDTH-1:0] address;
    logic                  write_enable;
    logic                  read_enable;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
    tri   [DATA_WIDTH-1:0] data_bus;

    int pass_count = 0;
    int fail_count = 0;

    // Instancia del módulo principal (DUT)
    Top_SRAM #(
        .ROW_BITS   (ROW_BITS),
        .COL_BITS   (COL_BITS),
        .DATA_WIDTH (DATA_WIDTH)
    ) uut (
        .rst_n        (rst_n),
        .address      (address),
        .write_enable (write_enable),
        .read_enable  (read_enable),
        .data_in      (data_in),
        .data_out     (data_out),
        .data_bus     (data_bus)
    );

    // 1. Generación del archivo de ondas .fsdb para Synopsys Verdi
    initial begin
        $fsdbDumpfile("dump_sram.fsdb");
        $fsdbDumpvars(0, tb_Top_SRAM, "+all");
    end

    // Tarea auxiliar para escribir un Byte en una dirección de la SRAM
    task automatic write_byte(
        input logic [ADDR_WIDTH-1:0] addr,
        input logic [DATA_WIDTH-1:0] data
    );
        begin
            read_enable  = 1'b0;
            address      = addr;
            data_in      = data;
            #5;
            write_enable = 1'b1; // Activar escritura en la intersección (Fila, Columna)
            #15;
            write_enable = 1'b0; // Desactivar escritura para retener el dato en los latches
            #5;
            data_in      = 8'h00; // Limpiar entrada para comprobar que el latch recuerda el valor
            #10;
        end
    endtask

    // Tarea auxiliar para leer un Byte y verificar que coincida con el valor esperado
    task automatic check_read_byte(
        input string                 test_name,
        input logic [ADDR_WIDTH-1:0] addr,
        input logic [DATA_WIDTH-1:0] expected_data
    );
        begin
            write_enable = 1'b0;
            address      = addr;
            #5;
            read_enable  = 1'b1; // Activar transistores de lectura hacia data_bus
            #15;
            if (data_out === expected_data) begin
                $display("[PASS] %s | Addr: 0x%02h (%b) | Leido: 0x%02h (%b) | Esperado: 0x%02h",
                         test_name, addr, addr, data_out, data_out, expected_data);
                pass_count++;
            end else begin
                $display("[FAIL] %s | Addr: 0x%02h (%b) | Leido: 0x%02h (%b) | Esperado: 0x%02h",
                         test_name, addr, addr, data_out, data_out, expected_data);
                fail_count++;
            end
            read_enable  = 1'b0;
            #10;
        end
    endtask

    // 2. Secuencia principal de pruebas
    initial begin
        $display(" INICIANDO SIMULACION DE MEMORIA SRAM (256 Direcciones x 8 Bits)");
        // Estado inicial apagado (Reset activo en bajo para limpiar los latches AND-OR)
        rst_n        = 1'b0;
        address      = 8'h00;
        write_enable = 1'b0;
        read_enable  = 1'b0;
        data_in      = 8'h00;
        #25;
        rst_n        = 1'b1;
        #15;

        // Iniciar captura de actividad SAIF para análisis de potencia
        $set_toggle_region(tb_Top_SRAM.uut);
        $toggle_start();

        // Prueba 1: Verificar que la memoria inicia limpia en 0x00 tras el reset
        check_read_byte("Reset Inicial Addr 0x00", 8'h00, 8'h00);
        check_read_byte("Reset Inicial Addr 0x0B", 8'h0B, 8'h00);

        // Prueba 2: Escribir en distintas intersecciones de Filas y Columnas
        write_byte(8'h0B, 8'b1011_1100); // Columna 0, Fila 11 -> 0xBC (Ejemplo del video)
        write_byte(8'hA5, 8'b0101_1010); // Columna 10, Fila 5 -> 0x5A
        write_byte(8'h3C, 8'b1111_0000); // Columna 3, Fila 12 -> 0xF0
        write_byte(8'hFF, 8'b1100_0011); // Última celda (Col 15, Fila 15) -> 0xC3

        // Prueba 3: Verificar que cambiar data_in con write_enable=0 NO altera la memoria
        address      = 8'h0B;
        data_in      = 8'hFF;
        write_enable = 1'b0;
        #20;
        data_in      = 8'h00;

        // Prueba 4: Leer todas las direcciones escritas y verificar retención
        check_read_byte("Lectura Celda 0x0B", 8'h0B, 8'b1011_1100);
        check_read_byte("Lectura Celda 0xA5", 8'hA5, 8'b0101_1010);
        check_read_byte("Lectura Celda 0x3C", 8'h3C, 8'b1111_0000);
        check_read_byte("Lectura Celda 0xFF", 8'hFF, 8'b1100_0011);

        // Prueba 5: Verificar que una celda vecina no escrita sigue en 0x00 (Aislamiento de AND)
        check_read_byte("Aislamiento Celda Vecina 0x0A", 8'h0A, 8'h00);

        // Prueba 6: Sobrescribir la dirección 0x0B con un nuevo valor (0x42) y verificar
        write_byte(8'h0B, 8'h42);
        check_read_byte("Sobrescritura Celda 0x0B", 8'h0B, 8'h42);

        // Detener y exportar reporte SAIF
        $toggle_stop();
        $toggle_report("sram_actividad.saif", 1.0e-9, tb_Top_SRAM.uut);

  
        $display(" RESUMEN FINAL: %0d PRUEBAS EXITOSAS [PASS] | %0d FALLIDAS [FAIL]",
                 pass_count, fail_count);
        #20;
        $finish;
    end

endmodule
