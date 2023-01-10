`timescale 1ns / 1ps

module RATE_GEN(input clk, output rxclk_en, txclk_en);

parameter RX_ACC_MAX = 50_000_000 / 115200;
parameter RX_ACC_WIDTH = $clog2(RX_ACC_MAX);
reg [RX_ACC_WIDTH - 1:0] rx_acc = 0;

parameter TX_ACC_MAX = 100_000_000 / 115200;
parameter TX_ACC_WIDTH = $clog2(TX_ACC_MAX);
reg [TX_ACC_WIDTH - 1:0] tx_acc = 0;

assign rxclk_en = (rx_acc == 5'd0);
assign txclk_en = (tx_acc == 9'd0);

always @(posedge clk) begin
	if (rx_acc == RX_ACC_MAX[RX_ACC_WIDTH - 1:0])
		rx_acc <= 0;
	else
		rx_acc <= rx_acc + 5'b1;
end

always @(posedge clk) begin
	if (tx_acc == TX_ACC_MAX[TX_ACC_WIDTH - 1:0])
		tx_acc <= 0;
	else
		tx_acc <= tx_acc + 9'b1;
end

endmodule