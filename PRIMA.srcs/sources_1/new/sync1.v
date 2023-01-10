`timescale 1ns / 1ps

module sync1 (input clk,
            input in,
            output final_out1,
            output final_out2);


D_trigger1 first(.clk(clk), .data(in), .q(final_out1));
D_trigger1 second(.clk(clk), .data(final_out1), .q(final_out2));

endmodule
