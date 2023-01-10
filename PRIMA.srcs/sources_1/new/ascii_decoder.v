`timescale 1ns / 1ps

module ascii_decoder(ascii_code, code);

input [7:0] ascii_code;
output reg [3:0] code;

always @(*) begin
	case (ascii_code)
		8'h30: code <= 4'h0;
		8'h31: code <= 4'h1;
		8'h32: code <= 4'h2;
		8'h33: code <= 4'h3;
		8'h34: code <= 4'h4;
		8'h35: code <= 4'h5;
		8'h36: code <= 4'h6;
		8'h37: code <= 4'h7;
		8'h38: code <= 4'h8;
		8'h39: code <= 4'h9;
		8'h41, 8'h61: code <= 4'ha;
		8'h42, 8'h62: code <= 4'hb;
		8'h43, 8'h63: code <= 4'hc;
		8'h44, 8'h64: code <= 4'hd;
		8'h45, 8'h65: code <= 4'he;
		8'h46, 8'h66: code <= 4'hf;
		default: code <= 0;
	endcase
end

endmodule