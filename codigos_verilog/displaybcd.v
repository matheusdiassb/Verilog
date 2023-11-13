/*
Aula - Decodificador BCD usando display de 7 segmentos.

Nome: Matheus Dias de Souza Barros
O display irá ligar com nível lógico 0.

	Sejam as entradas
	SW17 = A
	SW16 = B
	SW15 = C
	SW14 = D
	
	E a saída o display a HEX7
	HEX7[0] = a, HEX7[1] = b, HEX7[2] = c, HEX7[3] = d, HEX7[4] = e, HEX7[5] = f, HEX7[6] = g.
*/

module displaybcd(SW, HEX7);

input [17:0]SW;
output [6:0]HEX7;

//saída g = ~A~B~C | ~ABCD
assign HEX7[6] = (~SW[17] & ~SW[16] & ~SW[15]) | (~SW[17] & SW[16] & SW[15] & SW[14]);

//saída f = ~A~BD | ~A~BC | ~ACD
assign HEX7[5] = (~SW[17] & ~SW[16] & SW[14]) | (~SW[17] & ~SW[16] & SW[15]) | ((~SW[17] & SW[15] & SW[14]));

//saida e = ~AD | ~AB~C | ~B~CD
assign HEX7[4] = (~SW[17] & SW[14]) | (~SW[17] & SW[16] & ~SW[15]) | (~SW[16] & ~SW[15] & SW[14]);

//saida d = ~B~CD | ~AB~C~D | ~ABCD
assign HEX7[3] = (~SW[16] & ~SW[15] & SW[14]) | (~SW[17] & SW[16] & ~SW[15] & ~SW[14]) | (~SW[17] & SW[16] & SW[15] & SW[14]);

//saida c = ~A~BC~D
assign HEX7[2] = ~SW[17] & ~SW[16] & SW[15] & ~SW[14];

//saida b = ~A&B&~C&D | ~ABC~D
assign HEX7[1] = (~SW[17] & SW[16] & ~SW[15] & SW[14]) | (~SW[17] & SW[16] & SW[15] & ~SW[14]);

//saida a = ~A & ~B & ~C & D | ~A & B & ~C & ~D;
assign HEX7[0] = (~SW[17] & ~SW[16] & ~SW[15] & SW[14]) | (~SW[17] & SW[16] & ~SW[15] & ~SW[14]);

endmodule




/*
///////////BACKUP///////////////////
module displaybcd(A, B, C, D, a, b, c, d, e, f, g);

input A, B, C, D;
output a, b, c, d, e, f, g;

//saída g = ~A~B~C | ~ABCD
assign g = (~A & ~B & ~C) | (~A & B & C & D);

//saída f = ~A~BD | ~A~BC | ~ACD
assign f = (~A & ~B & D) | (~A & ~B & C) | ((~A & C & D));

//saida e = ~AD | ~AB~C | ~B~CD
assign e = (~A & D) | (~A & B & ~C) | (~B & ~C & D);

//saida d = ~B~CD | ~AB~C~D | ~ABCD
assign d = (~B & ~C & D) | (~A & B & ~C & ~D) | (~A & B & C & D);

//saida c = ~A~BC~D
assign c = ~A & ~B & C & ~D;

//saida b = ~A&B&~C&D | ~ABC~D
assign b = (~A & B & ~C & D) | (~A & B & C & ~D);

//saida a = ~A & ~B & ~C & D | ~A & B & ~C & ~D;
assign a = (~A & ~B & ~C & D) | (~A & B & ~C & ~D);

endmodule





*/
