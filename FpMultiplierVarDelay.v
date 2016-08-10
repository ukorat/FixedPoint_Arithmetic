`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:01:49 06/22/2016 
// Design Name: 
// Module Name:    FpMultiplierVarDelay 
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

module FpMultiplierVarDelay
#(parameter WI1 = 3, //INPUT-1 integer length
				WF1 = 4, //INPUT-1 fraction length
				WI2 = 4, //INPUT-2 integer length
				WF2 = 3, //INPUT-2 fraction length
				WIO = WI1+WI2, //OUTPUT integer  length
				WFO = WF1+WF2,
				pipelineStage = 3) //OUTPUT fraction length

 (input clk, nRst,
  input signed [WI1+WF1-1:0] in1,
  input signed [WI2+WF2-1:0] in2,
  output overFlow,
  output signed [WIO+WFO-1:0] FpMulOut);



wire ovf;
wire delayedOvf;

wire signed [WIO+WFO-1:0] mulOut;
wire signed [WIO+WFO-1:0] varDelayedMulOut;


FixedPoint_Multiplier 
 #(.WI1(WI1),
   .WF1(WF1),
   .WI2(WI2),
   .WF2(WF2),
   .WIO(WIO),
   .WFO(WFO))
  fpMultiplier
  (.in1(in1),
   .in2(in2),
   .overFlow(ovf),
   .FixedPoint_Mul_Out(mulOut));
generate
	if (pipelineStage > 0) begin
delayRegVarStage 
 #(.bitWidth(WIO+WFO),
   .pipelineStage(pipelineStage))
  delayRegVarStageMul
  (.clk(clk), 
	 .nRst(nRst),
   .inputValue(mulOut),
   .outputValue(varDelayedMulOut));
	
delayRegVarStage 
 #(.bitWidth(1),
   .pipelineStage(pipelineStage))
  delayRegVarStageOvf
  (.clk(clk), 
	 .nRst(nRst),
   .inputValue(ovf),
   .outputValue(delayedOvf));

end
endgenerate

assign overFlow = pipelineStage == 0 ? ovf : delayedOvf;

assign FpMulOut = pipelineStage == 0 ? mulOut : varDelayedMulOut;
	
endmodule
