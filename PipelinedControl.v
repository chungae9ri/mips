`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:03:58 10/20/2015 
// Design Name: 
// Module Name:    SingleCycleControl 
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
`define RTYPEOPCODE 		6'b000000
`define LWOPCODE 			6'b100011
`define SWOPCODE 			6'b101011
`define BEQOPCODE 		6'b000100
`define JOPCODE 			6'b000010
`define JALOPCODE			6'b000011
`define ORIOPCODE 		6'b001101
`define ADDIOPCODE 		6'b001000
`define ADDIUOPCODE 		6'b001001
`define ANDIOPCODE 		6'b001100
`define LUIOPCODE 		6'b001111
`define SLTIOPCODE 		6'b001010
`define SLTIUOPCODE 		6'b001011
`define XORIOPCODE 		6'b001110

//
`define AND     4'b0000
`define OR      4'b0001
`define ADD     4'b0010
`define SLL     4'b0011
`define SRL     4'b0100
`define SUB     4'b0110
`define SLT     4'b0111
`define ADDU    4'b1000
`define SUBU    4'b1001
`define XOR     4'b1010
`define SLTU    4'b1011
`define NOR     4'b1100
`define SRA     4'b1101
`define LUI     4'b1110
`define RTYP	 4'b1111
//
`define SLLFunc  	6'b000000
`define SRLFunc  	6'b000010
`define SRAFunc  	6'b000011
`define JRFunc		6'b001000

// SingleCycleControl module
module PipelinedControl(RegDst, MemToReg, RegWrite, MemRead, MemWrite, Branch, 
								Jump, Jal, Jr, SignExtend, ALUOp, Opcode, FuncCode);
// declaration of input, output signals								
	input [5:0] Opcode, FuncCode;
	output reg [1:0] RegDst;
	output reg MemToReg;
	output reg RegWrite;
	output reg MemRead;
	output reg MemWrite;
	output reg Branch ;
	output reg Jump, Jal, Jr;
	output reg SignExtend;
	output reg [3:0] ALUOp;
	
	always @(*) begin
		if(Opcode == `RTYPEOPCODE) begin
// RegDst : 1, ALUSrc1(rs) : 0,ALUSrc2(rt) : 0, MemToReg(RegSrc) : 0, RegWrite : 1,
//	MemRead : 1'bx, MemWrite : 1'b0, Branch : 0, Jump : 0, SignExtend : 1'bx, ALUOp :4'b1111
				RegDst = 2'b01;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				if(FuncCode == `JRFunc) Jr = 1'b1;
				else Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `RTYP;
		end else if(Opcode == `LWOPCODE) begin
// Load Word
// RegDst : 0, ALUSrc1 :0, ALUSrc2 : 1, MemToReg(RegSrc) : 1, RegWrite : 1,
//	MemRead : 1, MemWrite :1'b0, Branch : 0, Jump : 0, SignExtend : 1, ALUOp:ADD,4'b0010
				RegDst = 2'b00;
				MemToReg = 1'b1;
				RegWrite = 1'b1;
				MemRead = 1'b1;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `ADD;
		end else if(Opcode == `SWOPCODE) begin
// RegDst : 0, 1'bx, ALUSrc1 : 0,ALUSrc2 : 1, MemToReg(RegSrc) :1'bx, RegWrite : 0,
//	MemRead : 0, MemWrite :1, Branch : 0, Jump : 0, SignExtend : 1, ALUOp:ADD,4'b0010
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b1;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `ADD;
		end else if(Opcode == `BEQOPCODE) begin
// branch(beq)
// RegDst : 0 1'bx, ALUSrc1 : 0,ALUSrc2 : 0, MemToReg(RegSrc) : 1'bx, RegWrite :1'b0 ,
//	MemRead :1'bx, MemWrite : 1'b0, Branch : 1, Jump : 0, SignExtend : 1, ALUOp :SUB ,4'b0110
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b1;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `SUB;			
		end else if(Opcode == `JOPCODE) begin
//jump
// RegDst :0 1'bx, ALUSrc1 :1'bx ,ALUSrc2 :1'bx, MemToReg(RegSrc) :1'bx, RegWrite :1'b0,
//	MemRead :1'bx, MemWrite :1'b0, Branch :0, Jump :1, SignExtend :1'bx, ALUOp :4'bx
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b1;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = 4'b0;	
		end else if(Opcode == `JALOPCODE) begin
				RegDst = 2'b10;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b1;
				Jal = 1'b1;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = 4'b0;	
		end else if(Opcode == `ORIOPCODE) begin
// RegDst : 0 , ALUSrc1 : 0,ALUSrc2 : 1, MemToReg(RegSrc) : 1'b0, RegWrite :1'b1 ,
//	MemRead :1'bx, MemWrite : 1'b0, Branch : 0, Jump : 0, SignExtend : 0, ALUOp :OR,
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `OR;				
		end else if(Opcode == `ADDIOPCODE) begin
// RegDst : 0 , ALUSrc1 : 0,ALUSrc2 : 1, MemToReg(RegSrc) : 1'b0, RegWrite :1'b1 ,
//	MemRead :1'bx, MemWrite : 1'b0, Branch : 0, Jump : 0, SignExtend : 1, ALUOp :ADD,
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `ADD;				
		end else if(Opcode == `ADDIUOPCODE) begin
// RegDst : 0 , ALUSrc1 : 0,ALUSrc2 : 1, MemToReg(RegSrc) : 1'b0, RegWrite :1'b1 ,
//	MemRead :1'bx, MemWrite : 1'b0, Branch : 0, Jump : 0, SignExtend : 1, ALUOp :ADDU,	
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `ADDU;		
		end else if(Opcode == `ANDIOPCODE) begin
// RegDst : 0 , ALUSrc1 : 0,ALUSrc2 : 1, MemToReg(RegSrc) : 1'b0, RegWrite :1'b1 ,
//	MemRead :1'bx, MemWrite : 1'b0, Branch : 0, Jump : 0, SignExtend : 0, ALUOp :AND,	
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `AND;		
		end else if(Opcode == `LUIOPCODE) begin
// RegDst : 0 , ALUSrc1 : 0,ALUSrc2 : 1, MemToReg(RegSrc) : 1'b0, RegWrite :1'b1 ,
//	MemRead :1'bx, MemWrite : 1'b0, Branch : 0, Jump : 0, SignExtend : 1'bx, ALUOp :LUI,
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `LUI;			
		end else if(Opcode == `SLTIOPCODE) begin
// RegDst : 0 , ALUSrc1 : 0,ALUSrc2 : 1, MemToReg(RegSrc) : 1'b0, RegWrite :1'b1 ,
//	MemRead :1'bx, MemWrite : 1'b0, Branch : 0, Jump : 0, SignExtend : 1'b1, ALUOp :SLT,
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `SLT;			
		end else if(Opcode == `SLTIUOPCODE) begin 
// RegDst : 0, ALUSrc1 : 0,ALUSrc2 : 1, MemToReg(RegSrc) : 1'b0, RegWrite :1'b1 ,
//	MemRead :1'bx, MemWrite : 1'b0, Branch : 0, Jump : 0, SignExtend : 1'b1, ALUOp :SLTU,		
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `SLTU;	
		end else if(Opcode == `XORIOPCODE) begin
// RegDst : 0, ALUSrc1 : 0,ALUSrc2 : 1, MemToReg(RegSrc) : 1'b0, RegWrite :1'b1 ,
//	MemRead :1'bx, MemWrite : 1'b0, Branch : 0, Jump : 0, SignExtend : 1'b0, ALUOp :XOR		
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `XOR;	
		end else begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 1'b0;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `ADD;
		end
	end

endmodule

