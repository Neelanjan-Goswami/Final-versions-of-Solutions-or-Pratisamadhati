module FIFO8x9(
  input clk, rst,
  input RdPtrClr, WrPtrClr, 
  input RdInc, WrInc,
  input [8:0] DataIn,
  output reg [8:0] DataOut,
  input rden, wren
	);
//signal declarations

	reg [8:0] fifo_array[7:0];
	reg [7:0] wrptr, rdptr;
	wire [7:0] wr_cnt, rd_cnt;
always@(posedge clk,rst)
begin
	if(rst)   //reset condition
	begin
		DataOut=9'b00000000;   //default value
		if(wren) begin			
			fifo_array[wrptr]=DataIn;	//When the write signal is asserted, write to one of the 9 bit registers which is fifio array reg
			wrptr <=wrptr +WrInc; end	//Use RdInc and WrInc as input signals to increment the pointers that indicate which register to read or write.
		if(rden) begin
			DataOut=fifo_array[rdptr];	//When the read signal is asserted, read to of the 9 bit registers which is fifio array reg 
			rdptr =rdptr +RdInc; end	//Use RdInc and WrInc as input signals to increment the pointers that indicate which register to read or write.
		if(RdPtrClr)	//Use RdPtrClr and WrPtrClr as input signals which reset the pointers to point to the first register in the array.
			rdptr <=0;
		if(WrPtrClr)	//Use RdPtrClr and WrPtrClr as input signals which reset the pointers to point to the first register in the array.
			wrptr<=0;
	
	end
	else
	begin
		DataOut=9'bzzzzzzzzz;	//reset condition2
	end	
end
endmodule	
