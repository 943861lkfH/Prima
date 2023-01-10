`timescale 1ns / 1ps

module ps2_top(
	clk, PS2_DATA, AN, SEG, LED, PS2_CLK
);

input clk, PS2_DATA, PS2_CLK;
output [7:0] AN;
output [6:0] SEG;
output [15:0] LED;

wire ps2_ro;
wire [7:0] data; // идет из reciever в дешифратор

RECIEVER_pc2 ps2_r(
	.r(PS2_DATA), .clk(clk), .PS2_CLK(PS2_CLK),
	.R_O(ps2_ro), .received_data(data)
);

wire [11:0] fsm_data; // идет из dc в автомат
wire R_I, BTNL, BTNR, reset; // идут из dc в автомат
reg ro_dc = 0;
reg flag = 0;
// сигнал R_O, идущий из reciever длится один такт сихросигнала с клавиатуры (ps2_ro)
// надо, чтобы он длился один такт сихросигнала с платы (ro_dc)
// этот блок и нужен для решения этой задачи
always @(posedge clk) begin
	if (ps2_ro&~flag&~PS2_CLK) begin
		ro_dc <= 1;
		flag <= 1;
	end
	else ro_dc <= 0;// идет из dc в автомат
	if (PS2_CLK) flag <= 0;
end

DC_pc2 dc(
	.clk(clk), .ps2_data(data), .ps2_ro(ro_dc),
	.fsm_data(fsm_data), .R_I(R_I), .BTNL(BTNL),
	.BTNR(BTNR), .reset(reset)
);

TOPTOP FSM(
	.clk(clk), .cpu_reset(reset),
	.btn_u(R_I), .BTNL(BTNL), .BTNR(BTNR),
	.SW(fsm_data), .AN(AN), .SEG(SEG),
	.LED(LED)
);

endmodule
