`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:52:33 03/16/2015
// Design Name:   FixedPoint_Multiplier
// Module Name:   C:/Users/218/Desktop/xilinx/Fixed_Point_Library/tb_FixedPoint_Multiplier.v
// Project Name:  Fixed_Point_Library
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FixedPoint_Multiplier
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_FixedPoint_Multiplier;

	// Inputs
	reg [22:0] in1;
	reg [22:0] in2;

	// Outputs
	wire overFlow;
	wire [24:0] FixedPoint_Mul_Out;
	
	//=====  Function Definition
	function real FixedToFloat;
					input [63:0] in;
					input integer WI;
					input integer WF;
					integer i;
					real retVal;
					
					begin
					retVal = 0;
					
					for (i = 0; i < WI+WF-1; i = i+1) begin
								if (in[i] == 1'b1) begin
										retVal = retVal + (2.0**(i-WF));
								end
					end
					FixedToFloat = retVal - (in[WI+WF-1] * (2.0**(WI-1)));
					end
		endfunction

	// Instantiate the Unit Under Test (UUT)
	FixedPoint_Multiplier
	#(.WI1(3),
	.WF1(20),
	.WI2(3),
	.WF2(20),
	.WIO(5),
	.WFO(20)) 
	FixedPoint_Multiplier_uut 
	(	.in1(in1), 
		.in2(in2), 
		.overFlow(overFlow), 
		.FixedPoint_Mul_Out(FixedPoint_Mul_Out)	);

	initial begin
		// Initialize Inputs
		in1 = 23'b111_1101_0001_0010_1101_0000;
		in2 = 23'b00000000000000000000001;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

