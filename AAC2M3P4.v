module Majority (A, B, C, Y);                 	
   input  A, B, C;			
   output Y; 
   reg Y;           		
                   	          	
// student code here
always@(A,B,C)
begin
	assign Y = (A&B)|(B&C)|(C&A);
end
endmodule // Majority  




    
