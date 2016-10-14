/*

*/


`ifndef __OPS_FILE
`define __OPS_FILE

// N-Bit Carry Look-Ahead Adder/Subracter

module myCLA #(parameter N=4)(input [N-1:0] A, B, input Ci, output [N-1:0] S, output Co);
wire [N-2:0] Couts;
wire [N-1:0] Cg,Cp;
wire [N-1:0] Bout;


assign Cg = A&Bout;                // Carry Generate Signals
assign Cp = A|Bout;                // Carry Propagate Signals

assign Couts[0] = Cg[0] | (Cp[0]&Ci);
assign Co       = Cg[N-1] | (Cp[N-1]&Couts[N-2]);

assign S[0]     = A[0]^Bout[0]^Ci;

genvar i;
generate
        for(i=1;i<N-1;i=i+1)
        begin: CoutsLoop
                assign Couts[i] = Cg[i] | (Cp[i]&Couts[i-1]);
        end
        for(i=1;i<N;i=i+1)
        begin: SLoop
                assign S[i] = A[i]^Bout[i]^Couts[i-1];
        end
        for(i=0;i<N;i=i+1)
        begin: BoutLoop
                assign Bout[i] = B[i]^Ci;
        end
endgenerate

endmodule

// 21-bit logical AND implementation

module myAND(input[20:0] A, B, output[20:0] out);
assign out = A&B;
endmodule

//21-bit logical XOR implementation

module myXOR(input[20:0] A, B, output[20:0] out);
assign out = A^B;
endmodule

//21-bit logical OR implementation

module myOR(input[20:0] A, B, output[20:0] out);
assign out = A|B;
endmodule

//21-bit logical 1's Complement implementation

module myOneComp(input[20:0] inp, output[20:0] out);
assign out = ~inp;
endmodule

//21-bit Incrementation and Decrementation
// ControlBit = 0 ==> Increment

module myIncDec(input[20:0] inp, input ControlBit, output[20:0] out, output OverflowBit);
reg[21:0] temp;
assign out = temp[20:0];
assign OverflowBit = temp[21];

always@*
begin
	if(!ControlBit)
		temp <= inp+1;
	else
		temp <= inp-1;
end
endmodule

//21-bit Logical Left/Right Shifting
// ControlBit = 0 ==> Right shifting

module myLS(input[20:0] inp, input ControlBit, output[20:0] out);
assign out = (ControlBit)?(inp<<1):(inp>>1);
endmodule

//21-bit Arithmetic Right Shifting

module myARS(input[20:0] inp, output[20:0] out);
assign out = {inp[20],inp[20:1]};
endmodule

//21-bit Binary Rotation
// ControlBit = 0 ==> Right Rotation

module myLBR(input[20:0] inp, input ControlBit, output[20:0] out);
assign out = (ControlBit)?({inp[19:0],inp[20]}):({inp[0],inp[20:1]});
endmodule

`endif
