`timescale 1ns / 1ps

module DEVICE(
    input clk_old, 
    
    input set_button,
    input reset_button,
    input read_button, 
    
    input [3:0] switch,

    output reg [7:0] an, // parts of led panel
    output reg [7:0] seg, // parts of number
    output ok_led, red_led
);

reg [31:0] memory;

reg [7:0] mask;
wire [7:0] catod;
wire clk;

wire [19:0] dataOut;

wire set_signal;
wire set_signal_enable;

wire reset_signal;
wire reset_signal_enable;

wire read_signal;
wire read_signal_enable;

reg CLOCK_ENABLE = 0;
wire [2:0] count;

wire readIn;
wire [19:0] inForPrima;
wire get;
wire [2:0] cnt; 

//assign clk = clk_old; //------------commite for bitstream
CLK_DIV div26(
    .clk(clk_old), 
    .new_clk(clk));  //-----------uncommite for bitstream

COUNTER #(.mod(8), .out(3)) counter ( //counter for output leds
    .clk(clk),
    .rst(reset_signal),
    .ce(1'b1),
    .value(count));

LED led(
    .clk(clk),
    .switcher(memory[((count+1)*4-1)-:4]),
    .SEG(catod));

initial begin
    memory = 0;
    mask = 8'b00011111;
    an = ~1'b1;
    seg = ~8'b0;
end

assign red_led = readIn;

always@ (posedge clk)
begin
    an <= ~((1'd1 << count) & mask);
    seg <= catod;
    if(reset_signal)
        memory <= 36'b0;
    else
        begin
            CLOCK_ENABLE <= ~CLOCK_ENABLE;
            if(set_signal_enable) // CHANGE set_signal_enable for bitstream
                memory <= {12'b0, memory[15:0], switch[3:0]};
            if(ok_led || read_signal_enable) // CHANGE read_signal_enable for bitstream
                memory <= {12'b0, dataOut[19:0]}; //--------PRIMA---------//
        end
end

BUTTON set(    
    .clock_enable(CLOCK_ENABLE), 
    .clk(clk), 
    .in_signal(set_button), 
    .output_signal(set_signal), 
    .output_signal_enable(set_signal_enable));

BUTTON reset(
    .clock_enable(CLOCK_ENABLE), 
    .clk(clk), 
    .in_signal(reset_button), 
    .output_signal(reset_signal), 
    .output_signal_enable(reset_signal_enable));
                   
BUTTON read(
    .clock_enable(CLOCK_ENABLE), 
    .clk(clk), 
    .in_signal(read_button), 
    .output_signal(read_signal), 
    .output_signal_enable(read_signal_enable));

prima prima1(
    .clk(clk),
    .dataIn(inForPrima),
    .rst(reset_signal_enable),
    .R_I(set_signal_enable),
    .get_out(read_signal_enable), // CHANGE "_button" on "_signal" for bitstream
    .readIn(readIn),
    .get_in(get),
    .dataOut(dataOut),
    .R_O(ok_led),
    .cnt(cnt));

input_block in (        // CHANGE "_button" on "_signal" for bitstream
    .clk(clk), 
    .dataIn(switch), 
    .set(set_signal_enable), 
    .rst(reset_signal_enable), 
    .R_O(readIn), 
    .dataOut(inForPrima), 
    .get(get), 
    .cnt(cnt));
    
endmodule
