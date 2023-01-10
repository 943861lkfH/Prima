`timescale 1ns / 1ps

module input_block( input  clk, rst, set, get, [3:0] dataIn,
                    output reg R_O, reg [19:0] dataOut, reg [2:0] cnt);

integer i;
reg [2:0] x, y;
reg reset;

reg [19:0] RES [4:0];

initial
begin
    R_O = 0;
    x = 0;
    cnt = 0;
    y = 0;
    for(i = 0; i < 5; i =  i + 1)
        RES[i][19:0] = 20'b0;
end

always@(posedge clk)
begin
    if(reset || rst)
    begin
        for (i = 0; i < 5; i = i + 1)
            RES [i][19:0] = 20'b0;
        R_O = 1'b0;
        x <= 0;
        y <= 0;
        cnt = 0;
        reset <= 1'b0;
    end
    else
    begin
        if(set)
        begin
            RES [y][16 - 4*x +:4] <= dataIn;
            x = x + 1;
            if(x == 5)
            begin
                x = 0;
                y = y + 1;
            end
            if (y == 5)
            begin
                R_O = 1'b1;
                y = 1'b0;
            end
        end
        if(get)
        begin
        if (R_O)
            begin
                dataOut = RES[y][19:0];
                cnt = y;
                y <= y + 1;
                if (y == 4)
                    reset <= 1'b1;
            end
        end
    end
end

endmodule
