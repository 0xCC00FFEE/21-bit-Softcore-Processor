`timescale 1ns / 1ps

`include "RegisterFile.v"

module tb;

reg[20:0] data_input;
reg we,clk;
reg[2:0] dest_address,data_bus0_address,data_bus1_address;
wire[20:0] data_out_bus0,data_out_bus1;
//reg flag;

myRegFile myinst(.data_in0(data_input),.we(we),.clk(clk),.dst_add(dest_address),.data_out0_add(data_bus0_address),.data_out1_add(data_bus1_address),.data_out0(data_out_bus0),.data_out1(data_out_bus1));

initial
begin
	we = 1'b0;
	clk = 1'b0;
	data_bus0_address = 3'b0;
	data_bus1_address = 3'b0;
	forever #1 clk = ~clk;
end

initial
	$monitor("Data Bus0 : %d \t Data Bus1 : %d\n",data_out_bus0,data_out_bus1);

initial
begin
	#10
	data_input = 21'b0;
	we = 1'b1;
	#2 dest_address = 3'b001;
	#2 dest_address = 3'b010;
	#2 dest_address = 3'b011;
	#2 dest_address = 3'b100;
	#2 dest_address = 3'b101;
	#2 dest_address = 3'b110;
	#2 dest_address = 3'b111;
	#2 dest_address = 3'b000;
   	#2 we = 1'b0;
end

initial
begin
	//while(flag == 0);
	#100
	data_input = 21'b101;
	#5 dest_address = 3'b011;		// D3 Register
	we = 1'b1;
	#5			// D3 = 5
	we = 1'b0;
	#5 data_input = 21'b1010;
	#5 dest_address = 3'b110;		// D6
	we = 1'b1;
	#5				// D6 = 10;
	we = 1'b0;
	#5
	data_bus0_address = 3'b011;	//Output bus0 = D3
	#5 data_bus1_address = 3'b110;	//Output bus1 = D6
	#5
	data_input = 21'd11;
	#5 dest_address = 3'b000;
	we = 1'b1;
	#5				//D0 = 11
	we = 1'b0;
	#5
	data_bus1_address = 3'b000;	//Output bus1 = D0
	#5
	data_input = 21'd15;
	#5 dest_address = 3'b111;
	we = 1'b1;
	#5				//D7 = 15
	we = 1'b0;
	#5
	data_bus1_address = 3'b111;	//Output bus1 = D7
	#5 data_input = 21'd200;
	#5 dest_address = 3'b110;
	#5 we = 1'b1;
	#5				//D6 = 200
	we = 1'b0;
	#5
	data_bus0_address = 3'b110;	//Output bus0 = D6
	#10
	$finish;
end

endmodule
