`timescale 1ns/1ps

module tb_VGA_patten;

    reg clk25m;
    reg rst_n;
    wire hsync;
    wire vsync;
    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;

    VGA_patten #(
        .H_SYNC_PULSE(96),
        .V_SYNC_PULSE(2),
        .H_BACK_PORCH(48),
        .V_BACK_PORCH(33),
        .H_FRONT_PORCH(16),
        .V_FRONT_PORCH(10),
        .H_ACTIVE(640),
        .V_ACTIVE(480)
    ) uut (
        .clk25m(clk25m),
        .rst_n(rst_n),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
    );

    initial begin
        clk25m = 0;
        rst_n = 0;
        
        #100; // wait for reset
        rst_n = 1;

    end

    always #20 clk25m = ~clk25m; // 25 MHz clock


endmodule