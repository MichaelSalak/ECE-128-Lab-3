`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2025 09:34:08 PM
// Design Name: 
// Module Name: display_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module display_tb();
    reg [3:0] A,B;
    reg CI;
    wire a,b,c,d,e,f,g,dp;
    wire [3:0] anode;

    top display(.A(A),.B(B),.CI(CI),.a(a),.b(b),.c(c),.d(d),.e(e),
                .f(f),.g(g),.dp(dp),.anode(anode));
    
    initial begin
        A = 4'b0101;
        B = 4'b0011;
        CI = 0;
        #50;
        A = 4'b0001;
        B = 4'b0100;
        CI = 1;
        #50;
        $finish;
    end

endmodule
