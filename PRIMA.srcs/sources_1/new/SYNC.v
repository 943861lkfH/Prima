`timescale 1ns / 1ps

module SYNC(
    input clk,
    input in,
    output out
);

wire w0, w1;

D_TRIG first(.clk(clk), .in(in), .en(1'b1), .out(w0));
D_TRIG second(.clk(clk), .in(w0), .en(1'b1), .out(w1));

assign out = in;

endmodule
