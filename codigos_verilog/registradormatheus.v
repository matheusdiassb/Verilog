/*
Registrador - Matheus Dias de Souza Barros

	Deslocador com não-bloqueante de 4bits
*/

module registradormatheus(Q3, Q2, Q1, Q0, clock, reset, entrada);

input clock, reset, entrada;

output reg Q3, Q2, Q1, Q0;

initial begin
	Q3 = 1'b0;
	Q2 = 1'b0;
	Q1 = 1'b0;
	Q0 = 1'b0;
end

always @ (posedge clock or posedge reset)
begin

		if (reset == 1'b1)
			begin
				Q3 = 1'b0;

				Q2 = 1'b0;

				Q1 = 1'b0;

				Q0 = 1'b0;
			end
			
		else
			begin
				Q3 <= entrada;

				Q2 <= Q3;

				Q1 <= Q2;

				Q0 <= Q1;
			end

end
	
endmodule
