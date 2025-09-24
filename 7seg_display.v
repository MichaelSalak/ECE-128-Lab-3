`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2025 08:58:57 PM
// Design Name: 
// Module Name: segConv
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


//top level module
module top(input [3:0]A,B,
           input CI,
           output dp,a,b,c,d,e,f,g,
           output [3:0]anode);
           
    wire [3:0] SUM;
    wire CO;
    
    CLA4bit adder(.A(A), .B(B), .CI(CI), .SUM(SUM), .CO(CO));
    segConv s0(.num(SUM), .valid(1), .dp(dp),.a(a),.b(b),.c(c),
               .d(d),.e(e),.f(f),.g(g), .anode(anode));   //display sum

endmodule


//seven segment display (1 digit)
module segConv(input [3:0]num, 
               input valid, 
               output reg dp,a,b,c,d,e,f,g, 
               output [3:0]anode);
               
assign anode = {3'b111,~valid}; //enable right most digit in display when valid = 1; 
always @(*) begin
    dp = 1'b1;   //default decimal value
    case(num)   //active low (anode)
        4'b0000: {a,b,c,d,e,f,g} = 7'b0000001;
        4'b0001: {a,b,c,d,e,f,g} = 7'b1001111;
        4'b0010: {a,b,c,d,e,f,g} = 7'b0010010;
        4'b0011: {a,b,c,d,e,f,g} = 7'b0000110;
        4'b0100: {a,b,c,d,e,f,g} = 7'b1001100;
        4'b0101: {a,b,c,d,e,f,g} = 7'b0100100;
        4'b0110: {a,b,c,d,e,f,g} = 7'b0100000;
        4'b0111: {a,b,c,d,e,f,g} = 7'b0001111;
        4'b1000: {a,b,c,d,e,f,g} = 7'b0000000;
        4'b1001: {a,b,c,d,e,f,g} = 7'b0001100;
        default: {a,b,c,d,e,f,g} = 7'b1111111;
    endcase
end
endmodule


//Full Adder (1 bit)
module Adder(A,B,CI,SUM,CO);
input A,B,CI;
output SUM,CO;

wire ab = A ^ B;
assign SUM = ab ^ CI;
assign CO = (A & B) | (CI & ab);

endmodule


//Carry Look Ahead Adder (4 bit)
module CLA4bit(A,B,CI,SUM,CO);
input [3:0] A,B;
input CI;
output [3:0] SUM;
output CO;

wire [3:0] P,G;
wire [3:1] C;   //omit C0 (carry in)
assign P = A ^ B; //P[i] = A[i] ^ B[i] 
assign G = A & B; //G[i] = A[i] & B[i] 

//Ci+1 = Gi + PiCi
assign C[1] = G[0] | (P[0]&CI); //G0+P0CI
assign C[2] = G[1] | (G[0]&P[1]) | (P[1]&P[0]&CI); 
//C2 = G1+P1(G0+P0CI) = G1+G0P1+P1P0CI
assign C[3] = G[2] | (G[1]&P[2]) | (G[0]&P[2]&P[1]) | (P[2]&P[1]&P[0]&CI); 
//C3 = G2+P2(G1+G0P1+P1P0CI) = G2+G1P2+G0P2P1+P2P1P0CI
assign CO = G[3] | (G[2]&P[3]) | (G[1]&P[3]&P[2]) | (G[0]&P[3]&P[2]&P[1]) | 
(P[3]&P[2]&P[1]&P[0]&CI);
//CO = G3+P3(G2+G1P2+G0P2P1+P2P1P0CI) = G3+G2P3+G1P3P2+G0P3P2P1+P3P2P1P0CI

//omit carryouts (carries computed above)
Adder a0(.A(A[0]),.B(B[0]),.CI(CI),.SUM(SUM[0]),.CO());
Adder a1(.A(A[1]),.B(B[1]),.CI(C[1]),.SUM(SUM[1]),.CO());
Adder a2(.A(A[2]),.B(B[2]),.CI(C[2]),.SUM(SUM[2]),.CO());
Adder a3(.A(A[3]),.B(B[3]),.CI(C[3]),.SUM(SUM[3]),.CO());

endmodule
