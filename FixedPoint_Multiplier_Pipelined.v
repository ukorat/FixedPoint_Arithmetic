`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:46:42 11/04/2015 
// Design Name: 
// Module Name:    FixedPoint_Multiplier_Pipelined 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`define WIO1 (WIO >= 2)? (WIO+frc_len-2) : frc_len

`define Max_len ((int_len+frc_len-2)>= (WIO+frc_len-1)) ? (int_len+frc_len-2) : (WIO+frc_len-1)

`define trun_size (WIO < int_len)? ((int_len+frc_len-1)-(WIO+frc_len-1)) : 1

module  FixedPoint_Multiplier_Pipelined #(parameter WI1 = 3, //INPUT-1 integer length
												WF1 = 4, //INPUT-1 fraction length
												WI2 = 4, //INPUT-2 integer length
												WF2 = 3, //INPUT-2 fraction length
												//WIO = WI1+WI2, //OUTPUT integer  length
												//WFO = WF1+WF2) //OUTPUT fraction length
												WIO = 5, //OUTPUT integer  length
												WFO = 6) //OUTPUT fraction length

								 (input signed [WI1+WF1-1:0] input1,
								  input signed [WI2+WF2-1:0] input2,
								  input clk,reset,
								  output reg overFlow,
								  output  reg signed [WIO+WFO-1:0] FixedPoint_Mul_Out);

parameter int_len = WI1+WI2;
parameter frc_len = WF1+WF2;

reg signed [int_len+frc_len-1:0] reg_in1;
reg signed [int_len+frc_len-1:0] reg_in2;
reg signed [WIO+WFO-1:0] reg_FixedPoint_Mul_Out;


reg signed [WI1+WF1-1:0] in1;
reg signed [WI2+WF2-1:0] in2;
						  
reg [(`trun_size)-1:0] reg_trun;
reg [(`trun_size)-1:0] reg_sign;	

reg signed [int_len+frc_len-1:0] tmp;

reg [WIO-1:0] int_out;
reg [WFO-1:0] frc_out;

//integer WIO1;
//integer [63:0] Max_len;
//integer [63:0] trun_size;

//assign WIO1 = (WIO >= 2)? (WIO+frc_len-2) : frc_len;
//
//assign Max_len = ((int_len+frc_len-2)>= (WIO+frc_len-1)) ? (int_len+frc_len-2) : (WIO+frc_len-1);
//
//assign trun_size = (WIO < int_len)? ((int_len+frc_len-1)-(WIO+frc_len-1)) : 1;
//
//reg [(trun_size)-1:0] reg_trun;
//reg [(trun_size)-1:0] reg_sign;

//-----------------------------------------------------------------------------------//
 always @* begin
	(* use_dsp48 = "yes" *) tmp = in1 * in2; 
 end

//----------------------------------------------------------------------------------//

	always @* begin
	
		if (WFO >= frc_len) begin
			frc_out = {tmp[frc_len-1:0], {(WFO-frc_len){1'b0}}};
		end
		
		else begin //(WFO<frc_len)
			frc_out = tmp[frc_len-1:frc_len-WFO];
		end
	
	end

//-------------------------------------------------------------------------------//
//OUTPUT_INTEGER
	
	always @* begin 
		
		if (WIO >= int_len) begin
			int_out = {{(WIO-int_len){tmp[int_len+frc_len-1]}} , tmp[int_len+frc_len-1:frc_len] };
				overFlow = 1'b0;
				reg_sign = tmp[int_len+frc_len-1];
				reg_trun = 1'b0;
			end
		
		
		else begin // (WIO<int_len)
			
			if (WIO == 1) begin
				int_out = tmp[int_len+frc_len-1];
				
				reg_trun = tmp[`Max_len: WIO+frc_len-1] ;
//				reg_trun = tmp[Max_len: WIO+frc_len-1] ;
				reg_sign = {(`trun_size){tmp[int_len+frc_len-1]}};
//				reg_sign = {(trun_size){tmp[int_len+frc_len-1]}};

				
					if ( reg_trun == reg_sign) begin
						overFlow = 1'b0;
					end
					
					else begin
						overFlow = 1'b1;
					end					
			end
			else begin
				int_out = {tmp[int_len+frc_len-1] , tmp[`WIO1:frc_len]};
//				int_out = {tmp[int_len+frc_len-1] , tmp[WIO1:frc_len]};
				
				reg_trun = tmp[`Max_len: WIO+frc_len-1] ;
//				reg_trun = tmp[Max_len: WIO+frc_len-1] ;
				reg_sign = {(`trun_size){tmp[int_len+frc_len-1]}};
//				reg_sign = {(trun_size){tmp[int_len+frc_len-1]}};
				
					if ( reg_trun == reg_sign) begin
						overFlow = 1'b0;
					end
					
					else begin
						overFlow = 1'b1;
					end
			end
		end
	end
//------------------------------------------------------------------//

	always @(posedge clk) begin
		if (reset) begin
			in1 <= 0;
			in2 <= 0;
			reg_FixedPoint_Mul_Out <= 0;
			FixedPoint_Mul_Out <= 0;
		end
		else begin
			in1 <= input1;
			in2 <= input2;
			//reg_FixedPoint_Mul_Out <= {int_out,frc_out};
			FixedPoint_Mul_Out <= {int_out,frc_out};
		end
	end
endmodule 