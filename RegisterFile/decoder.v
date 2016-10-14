/*
 This file contains the implementation of the following digital components:
 - 3x8 Decoder
 - 3x8 Decoder with Enable Bit
 - D Flip Flop
 - 21-bit Parallel Load Register
 - Tri-state Buffer
*/

`ifndef __DECODER_MODS
`define __DECODER_MODS

// Tri-state Buffer Implementation

module myTSB(input inp, En, output out);

assign out = (En)?(inp):(1'bz);

endmodule

// 3x8 Decoder Implementation

module my3x8DEC(input[2:0] inp, output[7:0] out);

assign out = (inp == 3'b000)?(8'b00000001):(
             (inp == 3'b001)?(8'b00000010):(
             (inp == 3'b010)?(8'b00000100):(
             (inp == 3'b011)?(8'b00001000):(
             (inp == 3'b100)?(8'b00010000):(
             (inp == 3'b101)?(8'b00100000):(
             (inp == 3'b110)?(8'b01000000):(8'b10000000)))))));
endmodule

// 3x8 Decoder with Enable Bit Implementation

module my3x8ENDEC(input[2:0] inp, input En, output reg[7:0] out);

always@(inp or En)
begin
out = 8'b0;
if(En)
begin
	case(inp)
	3'b000: out = 8'b00000001;
	3'b001: out = 8'b00000010;
	3'b010: out = 8'b00000100;
	3'b011: out = 8'b00001000;
	3'b100: out = 8'b00010000;
	3'b101: out = 8'b00100000;
	3'b110: out = 8'b01000000;
	3'b111: out = 8'b10000000;
	endcase
end

end

endmodule

/*

// D Flip Flop Implementation

module myDFF(input clk, D, rst, en, output reg Q);

always@(posedge clk)
begin
	if(rst)
		Q <= 1'b0;
	else if(en)
		Q <= D;
end

endmodule
*/

// 21-bit Parallel Load Register

module myPLR(input[20:0] inp, input clk, en, rst, output[20:0] out);
reg[20:0] temp;

assign out = temp;

always@(posedge clk)
begin
	if(rst)
		temp <= 21'b0;
	else if(en)
		temp <= inp;
end

/*
genvar i;
generate
	for(i=0;i<21;i=i+1)
	begin: inst_Loop
		myDFF myinst(.clk(clk),.rst(1'b0),.D(inp[i]),.en(en),.Q(out[i]));
	end
endgenerate
*/



endmodule

`endif


