/*
Atividade 6 - SOMADOR 4 BITS

Aluno: Matheus Dias de Souza Barros

09/06/2022

A3			A2		A1			A0
SW[17] SW[16] SW[15] SW[14]

B3		B2		 B1	 B0
SW[3] SW[2] SW[1] SW[0]

Te SW[10]

Dezena HEX1 
Unidade HEX0
*/


module somador4bits(A, B, Te,  HEX1, HEX0);

input [3:0]A;
input [3:0]B;
input Te;

output [0:6] HEX1;
output [0:6] HEX0;

wire[3:0] aux_Ts;
wire[4:0] S;



//somador1bit(A, B, Te, Ts, S);

somador1bit somaBit_0 (A[0], B[0], Te, aux_Ts[0], S[0]);
somador1bit somaBit_1 (A[1], B[1], aux_Ts[0], aux_Ts[1], S[1]);
somador1bit somaBit_2 (A[2], B[2], aux_Ts[1], aux_Ts[2], S[2]);
somador1bit somaBit_3 (A[3], B[3], aux_Ts[2], aux_Ts[3], S[3]);


assign S[4] = aux_Ts[3];


decod_4bits resultado (S, HEX1, HEX0);



endmodule
