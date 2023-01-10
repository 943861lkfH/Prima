`timescale 1ns / 1ps

module ascii_coder(code, ascii_code);

input [3:0] code;
output reg [7:0] ascii_code;

always @(*) begin
	case (code)
		4'h0: ascii_code <= 8'h30;
		4'h1: ascii_code <= 8'h31;
		4'h2: ascii_code <= 8'h32;
		4'h3: ascii_code <= 8'h33;
		4'h4: ascii_code <= 8'h34;
		4'h5: ascii_code <= 8'h35;
		4'h6: ascii_code <= 8'h36;
		4'h7: ascii_code <= 8'h37;
		4'h8: ascii_code <= 8'h38;
		4'h9: ascii_code <= 8'h39;
		4'ha: ascii_code <= 8'h41;
		4'hb: ascii_code <= 8'h42;
		4'hc: ascii_code <= 8'h43;
		4'hd: ascii_code <= 8'h44;
		4'he: ascii_code <= 8'h45;
		4'hf: ascii_code <= 8'h46;
	endcase
end

endmodule
