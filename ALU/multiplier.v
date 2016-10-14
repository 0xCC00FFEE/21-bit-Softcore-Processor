/*
This file contains the implementation of the following digital components:
 - 1-bit Half Adder
 - 1-bit Full Adder
 - N-bit Carry Look-Ahead Adder
 - 4x4 Multiplier
*/

`ifndef __MULT_MODS
`define __MULT_MODS


//1 bit Half Adder Implementation

module myHA(input A, B, output S, Co);
assign S = A^B;
assign Co = A&B;
endmodule

//1 bit Full Adder Implementation

module myFA(input A, B, Ci, output S, Co);
assign S = A^B^Ci;
assign Co = (A&B) | ((A^B)&Ci);
endmodule

// N-bit Carry Look-Ahead Adder Implementation

module myCLA #(parameter N=4)(input [N-1:0] A,B,input Ci, output [N-1:0] S, output Co);
wire [N-2:0] Couts;
wire [N-1:0] Cg,Cp;

assign Cg = A&B;		// Carry Generate Signals
assign Cp = A|B;		// Carry Propagate Signals

assign Couts[0] = Cg[0] | (Cp[0]&Ci);
assign Co       = Cg[N-1] | (Cp[N-1]&Couts[N-2]);

assign S[0]     = A[0]^B[0]^Ci;

genvar i;
generate
	for(i=1;i<N-1;i=i+1)
	begin: CoutsLoop
		assign Couts[i] = Cg[i] | (Cp[i]&Couts[i-1]);
	end
	for(i=1;i<N;i=i+1)
	begin: SLoop
		assign S[i] = A[i]^B[i]^Couts[i-1];
	end
endgenerate

endmodule

// 4x4 Multiplier Circuit Implementation using HA's, FA's and CLA's

module mymult(input [3:0] A,B, output [7:0] out);
wire[16:0] temp;
wire[16:0] prod;

/*
genvar i,x;
generate
	for(i=0;i<4;i=i+1)
	begin: productsloop
		for(x=0;x<4;x=x+1)
		begin: prodloop
			assign prod[a]=B[i]&A[x];
		end
	end
endgenerate
*/

assign prod[0] = B[0]&A[0];
assign prod[1] = B[0]&A[1];
assign prod[2] = B[0]&A[2];
assign prod[3] = B[0]&A[3];
assign prod[4] = B[1]&A[0];
assign prod[5] = B[1]&A[1];
assign prod[6] = B[1]&A[2];
assign prod[7] = B[1]&A[3];
assign prod[8] = B[2]&A[0];
assign prod[9] = B[2]&A[1];
assign prod[10] = B[2]&A[2];
assign prod[11] = B[2]&A[3];
assign prod[12] = B[3]&A[0];
assign prod[13] = B[3]&A[1];
assign prod[14] = B[3]&A[2];
assign prod[15] = B[3]&A[3];

assign out[0] = A[0]&B[0];

myHA myHA0(.A(prod[1]),.B(prod[4]),.S(out[1]),.Co(temp[0]));
myFA myFA0(.A(prod[2]),.B(prod[5]),.Ci(prod[8]),.S(temp[1]),.Co(temp[2]));
myHA myHA1(.A(temp[0]),.B(temp[1]),.S(out[2]),.Co(temp[7]));
myFA myFA1(.A(prod[3]),.B(prod[6]),.Ci(prod[9]),.S(temp[3]),.Co(temp[4]));
myHA myHA2(.A(prod[7]),.B(prod[10]),.S(temp[5]),.Co(temp[6]));
myFA myFA2(.A(temp[3]),.B(prod[12]),.Ci(temp[2]),.S(temp[8]),.Co(temp[9]));
myFA myFA3(.A(temp[5]),.B(prod[13]),.Ci(temp[4]),.S(temp[10]),.Co(temp[11]));
myFA myFA4(.A(prod[11]),.B(prod[14]),.Ci(temp[6]),.S(temp[12]),.Co(temp[13]));

myCLA #(.N(4)) myCLA0(.A({prod[15],temp[12],temp[10],temp[8]}),.B({temp[13],temp[11],temp[9],temp[7]}),.Ci(1'b0),.S({out[6],out[5],out[4],out[3]}),.Co(out[7]));

endmodule

`endif
