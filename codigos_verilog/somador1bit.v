// 5° aula prática
// Matheus Dias de Souza Barros
// Somador de 1 bit


module somador1bit(A, B, Te, Ts, S);//variaveis que aparecem no circuito

//input [17:15]SW;

input A, B, Te;

output Ts, S;


assign S =A ^ B ^ Te;
assign Ts = (A&B) | (A&Te) | (B&Te);


	


endmodule
