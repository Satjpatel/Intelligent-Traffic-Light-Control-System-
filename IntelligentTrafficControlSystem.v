//Intelligent Traffic Control System using Verilog HDL 
// Road configuration showed in the diagram 
// State Machine Diagram also attached with the project file 

module Intelligent_Traffic_Control_System ( 

//Input ports 
	input clock,	 //Clock input 
	input reset, 	//Reset the stat machine to a known state 
	input M1S, M2S, M3S, M4S, //Sensors to sense the cars queuing at raods S1, S2, S3 and S4 respectively 
	input M1T, M2T, M3T , M4T , //Sensors to sense the cars queing at roads S1T, S2T, S3T and S4T respectively 
	input tGreen , // Informs (after a stipulated time) to change from Green to Yellow 
	input tYellow, // Informs (after a stipulated time) to change from Yellow to Red
	input tRed, // Informs (after a stipulated time) to change from Red to Green
	
//Output ports 
	output reg [1:0] S1_S3, //2 bit bus that controls traffic lights for roads S1 and S3 
	output reg [1:0] S2_S4, //2 bit bus that controls traffic lights for roads S2 and S4 
	output reg [1:0] S1T_S3T, //2 bit bus that controls traffic lights for roads S1T and S3T 
	output reg [1:0] S2T_S4T  //2 bit bus that controls traffic lights for roads S2T and S4T 
	//For these ports, "01" -> Green, "10" -> Yellow , "11" -> Red 
	) ; 
	
	
parameter [1:0] Green = 1, Yellow = 2, Red = 3 ; 

parameter [3:0] STATE1 = 1, 
				STATE2 = 2, 
				STATE3 = 3, 
				STATE4 = 4, 
				STATE5 = 5, 
				STATE6 = 6, 
				STATE7 = 7, 
				STATE8 = 8, 
				STATE9 = 9, 
				STATE10 = 10, 
				STATE11 = 11, 
				STATE12 = 12 ; 
				
	
reg [3:0] PS, NS ; //PS is the abbriviation for Present State and NS is for Next State 
//As any state machine, this also an be divided into 3 blocks 
//1. State Register 
//2. Next State Combinational logic 
//3. Output Combinational Logic 


//1. State Register Block 
	always @(posedge clock or posedge reset) 
		begin 
			if ( reset == 1 ) 
				NS <= STATE1 ; 
			else 
				NS <= PS ; 
		end 		
//2. Next State Combinational Logic 
					always @ ( tGreen or tRed or tYellow or M1S or M1T or M2S or M2T or M3S or M3T or M4S or M4T ) //We can't use clock here because it will ruin the combinational logic 
						
							begin 
							
							NS = PS ; //Default condition 
							
							case (PS) 
							
							STATE1: begin 
									if ( tRed == 1 & (M3S == 1 | M1S == 1) ) 
										NS = STATE2 ; 
									else if ( tRed == 1 & (M1S == 1) & (M3S == 1) & ( M1T == 1 | M3T == 1) )
										NS = STATE5 ; 
									else if ( tRed == 1 & ( M1S == 0 ) & ( M3S == 0) & (M1T == 0) & (M3T == 0) & ( M2S == 1 | M4S == 1 ) )
										NS = STATE8 ; 
									else if ( tRed == 1 & (M1S == 0 ) & ( M3S == 0) & ( M1T == 0 ) & (M3T == 0) & (M2S == 0 ) & (M4S == 0 ) & (M2T == 1 | M4T == 1) )
										NS = STATE11 ;
									else 
										NS = STATE1 ; 
								end 
							
							STATE2: begin 
										if ( tGreen) 
											NS = STATE3 ; 
										else 
											NS = STATE2 ; 
									end 
									 
							STATE3: begin 
										if (tYellow) 
											NS = STATE4 ; 
										else 
											NS = STATE3 ; 
									end 
							
							STATE4: begin 
										if ( tRed == 1 & ( M1T == 0 ) & ( M3T == 0 ) & ( M2S == 0 ) & ( M4S == 0 ) & ( M2T == 1 | M4T == 1) ) 
											NS = STATE11 ; //E 
										else if( tRed == 1 & ( M1T == 0 ) & ( M3T == 0) & (M2T == 0 ) & (M4T == 0 ) & (M2T == 0 ) & (M4T == 0) & (M1S == 1 | M3S == 1) ) 
											NS = STATE2 ; 
										else if( tRed == 1 & ( M1T == 0) & (M3T == 0) & ( M2S == 1| M4S == 1) ) 
											NS = STATE8 ; 
										else if( tRed == 1 & ( M1S == 1 | M3S == 1) ) 
											NS = STATE5 ; 
										else 
											NS = STATE4 ; 
									end 
										
							STATE5: begin 
										if(tGreen) 
											NS = STATE6 ; 
										else 
											NS = STATE5 ; 
									end 
							
							STATE6: begin 
										if(tYellow) 
											NS = STATE7 ; 
										else 
											NS = STATE6 ; 
									end 
									
							STATE7: begin 
							
										if( (tRed == 1) & ( M2S == 0 ) & ( M4S == 0 ) & ( M2T == 0 ) & ( M4T == 0 ) & ( M1S == 0 ) & ( M3S == 0 ) & ( M1T == 1 | M3T == 1 ) ) 
											NS = STATE5 ; 
										else if ( ( tRed == 1 ) & ( M2S == 0 ) & ( M4S == 0 ) & ( M2T == 0 ) & ( M4T == 0 ) & ( M1S == 1 | M3S == 1 ) ) 
											NS = STATE2 ; 
										else if ( ( tRed == 1 ) & ( M2S == 1 | M4S == 1 ) ) 
											NS = STATE8 ; 
										else if ( ( tRed == 1 ) & ( M2S == 0 ) & ( M4S == 0 ) & ( M2T == 1 | M4T == 1 ) ) 
											NS = STATE11 ; 
										else 
											NS = STATE7 ; 
									end 
									
							STATE8: begin
								
										if ( tGreen ) 
											NS = STATE9 ; 
										else 
											NS = STATE9 ; 
										
									end 
							
							STATE9: begin 
										
										if ( tYellow ) 
											NS = STATE10 ; 
										else 
											NS = STATE9 ; 
									
									end
											
							STATE10: begin 
										
										if( ( tRed == 1 ) & ( M2T == 1 | M4T == 1 ) ) 
											NS = STATE11 ; 
										else if ( ( tRed == 1 ) & ( M2T == 0 ) & ( M4T == 0 ) & ( M1S == 1 | M3S == 1 ) ) 
											NS = STATE2 ; 
										else if ( ( tRed == 1 ) & ( M2T == 0 ) & ( M4T == 0 ) & ( M1S == 0 ) & ( M3S == 0 ) & ( M1T == 1 | M3T == 1 ) ) 
											NS = STATE5 ; 
										else if ( ( tRed == 1 ) & ( M1S == 0 ) & ( M3S == 0 ) & ( M1T == 0 ) & ( M3T== 0 ) & ( M2S == 1 | M4S == 1 ) ) 
											NS = STATE8 ; 
										else 
											NS = STATE10 ; 
									
									end 
							
							STATE11: begin 
									
										if( tGreen ) 
											NS = STATE12 ; 
										else 
											NS = STATE11 ; 
										
								     end 
								
							STATE12: begin 
									
										if( tYellow ) 
											NS = STATE1 ; 
										else 
											NS = STATE12 ; 
									
									end  
							
							default : 	begin 
											NS = STATE1 ; 
										end	
										
										
							endcase 
										
							end 			
										


// 3. Output Logic - Combinational Circuit 
										
//"01" -> Green  , "10" -> Yellow , "11" -> Red 
										
	always @(PS) 
		
		begin 
		
			case(PS) 
			
				STATE1: begin //All Red 
							S1_S3 = 2'b11 ; 
							S2_S4 = 2'b11 ; 
							S1T_S3T = 2'b11 ; 
							S2T_S4T = 2'b11; 
						end 
			
				STATE2: begin 
							S1_S3 = 2'b01 ; 
						end 
						
				STATE3: begin 
							S1_S3 = 2'b10 ; 
						end 
					
				STATE4: begin //All Red 
							S1_S3 = 2'b11 ; 
							S2_S4 = 2'b11 ; 
							S1T_S3T = 2'b11 ; 
							S2T_S4T = 2'b11;  
						end 
						
				STATE5: begin 
							S1T_S3T = 2'b01 ; 
						end 
						
				STATE6: begin 
							S1T_S3T = 2'b10 ; 
						end 
						
				STATE7: begin 
							S1_S3 = 2'b11 ; 
							S2_S4 = 2'b11 ; 
							S1T_S3T = 2'b11 ; 
							S2T_S4T = 2'b11;  
						end 
						
				STATE8: begin 
							S2_S4 = 2'b01 ; 
						end 
						
				STATE9: begin 
							S2_S4 = 2'b10 ; 
						end 
						
				STATE10: begin 
							S1_S3 = 2'b11 ; 
							S2_S4 = 2'b11 ; 
							S1T_S3T = 2'b11 ; 
							S2T_S4T = 2'b11;  
						end 
						
				STATE11: begin 
							S2T_S4T = 2'b01 ; 
						end 
						
				STATE12 : begin 
							S2T_S4T = 2'b10 ; 
						end 
				
				default: begin 
							S1_S3 = 2'b11 ; 
							S2_S4 = 2'b11 ; 
							S1T_S3T = 2'b11 ; 
							S2T_S4T = 2'b11;  
						end 
						
			endcase 
										
										
		end 								
										
										
										
										
										
										
										
										
										
endmodule 									
										
										
										
										
									
					
					
					
