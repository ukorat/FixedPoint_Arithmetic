`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:53:06 03/05/2015
// Design Name:   FixedPoint_Adder
// Module Name:   C:/Users/218/Desktop/xilinx/Fixed_Point_Library/tb_FixedPoint_Adder.v
// Project Name:  Fixed_Point_Library
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FixedPoint_Adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_FixedPoint_Adder;
parameter WI1 = 8; //INPUT-1 integer length
parameter WF1 = 8; //INPUT-1 fraction lengt
parameter WI2 = 8; //INPUT-2 integer length
parameter WF2 = 8; //INPUT-2 fraction length
parameter WIO = 11;//OUTPUT integer  length
parameter WFO = 8;
	//Inputs
	reg [WI1+WF1-1:0] in1;
	reg [WI2+WF2-1:0] in2;

	// Outputs
	wire [WIO+WFO-1:0] Out1;
	//wire [6:0] Out2;
	//wire [3:0]Out3;
	
	wire overFlow1;
//	wire overFlow2;
	//wire overFlow3;
	
	//Real Number Presentation
	real in1_real, in2_real;
	real out1_real, out2_real, out3_real;
	real Floatout1, Floatout2, Floatout3;
	
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
	//WIO>max(WI1,WI2) , WFO>max(WF1,WF2) 
	FixedPoint_Adder #(.WI1(WI1),
							 .WF1(WF1),
							 .WI2(WI2),
							 .WF2(WF2),
							 .WIO(WIO),
							 .WFO(WFO))
							  uut01 (.in1(in1), .in2(in2), .overFlow(overFlow1), .FixedPoint_Add_Out(Out1));//Output1
	
/*	//WIO=max(WI1,WI2), WFO < max(WF1,WF2)
	FixedPoint_Adder #(.WI1(3),
							 .WF1(4),
							 .WI2(4),
							 .WF2(3),
							 .WIO(4),
							 .WFO(3))
							  uut02 (.in1(in1), .in2(in2), .overFlow(overFlow2), .FixedPoint_Add_Out(Out2));
	
	//WIO<min(WI1,WI2), WFO <min(WF1,WF2)
	FixedPoint_Adder #(.WI1(3),
							 .WF1(4),
							 .WI2(4),
							 .WF2(3),
							 .WIO(2),
							 .WFO(2))
							  uut03 (.in1(in1), .in2(in2), .overFlow(overFlow3), .FixedPoint_Add_Out(Out3));	
*/
	initial begin
		// Initialize Inputs
		
//		in2 = 40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
//		in1 = 40'b1111_1111_1000_0000_0000_0000_0000_0000_0000_0000;
//		// Wait 100 ns for global reset to finish
//		#100;
//				in1 = 9'b0111_1111_0;
////        in2 = 9'b1000_0001_0;
//        in2 = 9'b0111_1111_0;
	in1 = 16'b0000_0001_1000_0000;
	in2 = 16'b0000_0001_1000_0000;
	#100;
	/*	
		in1 = 7'b111_0000;
		in2 = 7'b0110_000;
		// Wait 100 ns for global reset to finish
		#100;
		
		in1 = 7'b100_0000;
		in2 = 7'b0011_000;
		// Wait 100 ns for global 
		#100;*/
		$finish;
	
	end
      
		
	always @ in1 in1_real = FixedToFloat(in1, WI1, WF1); //convert in1 to real
	always @ in2 in2_real = FixedToFloat(in2, WI2, WF2); //convert in2 to real
	always @ Out1 out1_real = FixedToFloat(Out1, WIO, WFO);//convert Out2 to real
	always @ (in1_real or in2_real) Floatout1 = in1_real + in2_real;//Ideal Output

//	always @ Out2 out2_real = FixedToFloat(Out2, 4, 3);//convert Out2 to real
//	always @ (in1_real or in2_real) Floatout2 = in1_real + in2_real;//Ideal Output
	
//	always @ Out3 out3_real = FixedToFloat(Out3, 2, 2);//convert Out3 to real
//	always @ (in1_real or in2_real) Floatout3 = in1_real + in2_real;//Ideal Output

endmodule

