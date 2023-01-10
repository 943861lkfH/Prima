`timescale 1ns / 1ps

module D_TRIG(
    input clk,
    input in,
    input en,
    output out
);

reg value;

assign out = value;

always @(posedge clk) begin
    if (en == 1) begin
        value <= in;
    end
end

initial begin
    value = 0;
end

endmodule
