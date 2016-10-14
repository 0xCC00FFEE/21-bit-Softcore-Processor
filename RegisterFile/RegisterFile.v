/*
 This file contains the implementation of the following digital components:
 - 21-bit tristate buffer
 - Register File with 8 Registers D0 -> D7

*/

`include "decoder.v"

`ifndef __REGISTER_FILE
`define __REGISTER_FILE

// 21-bit tristate buffer implementation

module my21TSB(input[20:0] inp, input En, output[20:0] out);

assign out = (En)?(inp):(21'bz);
/*
genvar i;
generate
	for(i=0;i<21;i=i+1)
	begin: inst_loop
		myTSB myinst(.inp(inp[i]),.En(En),.out(out[i]));
	end
endgenerate
*/
endmodule

// Register File with 8 21-bit Registers implementation

module myRegFile(input[20:0] data_in0, input we, clk, input[2:0] dst_add, data_out0_add, data_out1_add, output[20:0] data_out0, data_out1);
wire[7:0] temp_out_inp_dec;
wire[20:0] temp_out_of_regs[7:0];
wire[20:0] temp_tri_out[7:0];
wire[7:0] temp_out_out_dec[1:0];
wire[20:0] temp_tri_out2[7:0];

//assign temp_tri_out2 = temp_tri_out;

my3x8ENDEC myinst0(.inp(dst_add),.En(we),.out(temp_out_inp_dec));
my3x8ENDEC myinst3(.inp(data_out0_add),.En(1'b1),.out(temp_out_out_dec[0]));
my3x8ENDEC myinst4(.inp(data_out1_add),.En(1'b1),.out(temp_out_out_dec[1]));


genvar i;
generate
	for(i=0;i<8;i=i+1)
	begin: inst1_loop
		myPLR myinst1(.clk(clk),.rst(1'b0),.en(temp_out_inp_dec[i]),.inp(data_in0),.out(temp_out_of_regs[i]));
	end
	for(i=0;i<8;i=i+1)
	begin: inst2_loop
		my21TSB myinst2(.inp(temp_out_of_regs[i]),.En(temp_out_out_dec[0][i]),.out(temp_tri_out[i]));
		my21TSB myinst5(.inp(temp_out_of_regs[i]),.En(temp_out_out_dec[1][i]),.out(temp_tri_out2[i]));
	end
	for(i=0;i<8;i=i+1)
	begin: inst3_loop
		assign data_out0 = temp_tri_out[i];
		assign data_out1 = temp_tri_out2[i];
	end
endgenerate

endmodule

`endif

