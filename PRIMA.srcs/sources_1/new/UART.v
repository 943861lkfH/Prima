`timescale 1ns / 1ps

module UART(
    input clk, recR_O, [7:0] recData, [19:0] OutFsmData, fsmR_O, trNext, 
    output reg [19:0] fsmData, reg trStart, reg trData, reg set, reg read, reg reset);

wire [3:0] decode;
reg [3:0] state;
reg [3:0] fsmDout;
wire [7:0] code;

initial
begin
    set = 0;
    read = 0;
    reset = 0;
    fsmData = 20'b0;
    state = 4'b0;
end

always @(posedge clk)
begin
    if(recR_O)
    begin
        case(recData)
            8'h47, 8'h67: set <= 1;
            8'h48, 8'h68: read <= 1;
            8'h4a, 8'h6a: reset <= 1;
            default: 
            begin
                fsmData <= {fsmData[15:0], decode};
                {set, read, reset} <= 0;
            end
        endcase
    end
    else {set, read, reset} <= 0;
end

ascii_decoder decoder(.ascii_code(recData), .code(decode));


always @(posedge clk)
begin    
	if(reset) state <= 0;
    case(state)
        4'd0: if(fsmR_O&read)
        begin
            trStart <= 0;
            fsmDout <= OutFsmData[19:16];
            state <= 4'd1;
        end
		4'd1: if (trNext) 
		begin
			trStart <= 1;
			trData <= code;
			state <= 4'd2;
		end
		4'd2: 
		begin
			trStart <= 0;
			fsmDout <= OutFsmData[15:12];
			state <= 4'd3;
        end
        4'd3: if (trNext) 
        begin
			trStart <= 1;
			trData <= code;
			state <= 4'd4;
		end
		4'd4: 
		begin
			trStart <= 0;
			fsmDout <= OutFsmData[11:8];
			state <= 4'd5;
        end
        4'd5: if (trNext) 
        begin
			trStart <= 1;
			trData <= code;
			state <= 4'd6;
		end
		4'd6: 
		begin
			trStart <= 0;
			fsmDout <= OutFsmData[7:4];
			state <= 4'd7;
        end
        4'd7: if (trNext) 
        begin
			trStart <= 1;
			trData <= code;
			state <= 4'd8;
		end
		4'd8: 
		begin
			trStart <= 0;
			fsmDout <= OutFsmData[3:0];
			state <= 4'd9;
        end
        4'd9: if (trNext) 
        begin
			trStart <= 1;
			trData <= code;
			state <= 4'd10;
		end
		4'd10: if (trNext) 
		begin
			trStart <= 1;
			trData <= 8'h0d; // переход на другую строку
			state <= 4'd11;
		end
		4'd11: begin
			trStart <= 0;
			state <= 4'd12;
		end
		4'd12: if (trNext) begin
			trStart <= 1;
			trData <= 8'h0a; //переход к началу строки
			state <= 4'd13;
		end
		4'd13: begin
			trStart <= 0;
			state <= 4'd0;
		end
    endcase
end

ascii_coder coder(.ascii_code(code), .code(fsmDout));

endmodule
