`timescale 1ns / 1ps

module BOUNCE(
    input clk, in_s, clock_en,
    output out_signal_en, out_signal
);

wire w0, w1, w2;
reg and2, and3, and4, rxnor, clock_en1;
wire [1:0] wcounter;

initial begin
    clock_en1 = clk && clock_en;
    and2 = 0;
    and3 = 0;
    and4 = 0;
    rxnor = 0;
end

SYNC sync(.clk(clk), .in(in_s), .out(w0));
D_TRIG d_trig1(.clk(clk), .in(w0), .en(and3), .out(w1));

COUNTER #(.mod(8), .out(3)) counter(.clk(clock_en1), .ce(1'b1), .rst(rxnor), .value(wcounter));

D_TRIG d_trig2(.clk(clk), .in(and4), .en(1'b1), .out(w2));

always @(wcounter)
    if (wcounter[1] && wcounter[0] == 1)
        and2 = 1;
    
always @(clk)
    clock_en1 = clk&&clock_en;
    
always @(posedge clk) begin
    rxnor = (w0 && w1) + (!w0 && !w1);
    and3 = and2 && clock_en;
    and4 = and3 && w0;
end

assign out_signal = w1;
assign out_signal_en = w2;

endmodule
