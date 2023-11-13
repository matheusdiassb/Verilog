
module decod_4bits(S, saida_display_dezena, saida_display_unidade);

input [4:0]S;
output reg [0:6]saida_display_dezena;
output reg [0:6]saida_display_unidade;

always @ (S)

	begin
		case( {S} )   //a, b, c, d, e, f, g
		
			// 0 a 9
			5'b00000: begin saida_display_dezena=7'b0000001; saida_display_unidade = 7'b0000001; end
			5'b00001: begin saida_display_dezena=7'b0000001; saida_display_unidade = 7'b1001111; end
			5'b00010: begin saida_display_dezena=7'b0000001; saida_display_unidade = 7'b0010010; end
			5'b00011: begin saida_display_dezena=7'b0000001; saida_display_unidade = 7'b0000110; end
			5'b00100: begin saida_display_dezena=7'b0000001; saida_display_unidade = 7'b1001100; end
			5'b00101: begin saida_display_dezena=7'b0000001; saida_display_unidade = 7'b0100100; end
			5'b00110: begin saida_display_dezena=7'b0000001; saida_display_unidade = 7'b0100000; end
			5'b00111: begin saida_display_dezena=7'b0000001; saida_display_unidade = 7'b0001111; end
			5'b01000: begin saida_display_dezena=7'b0000001; saida_display_unidade = 7'b0000000; end
			5'b01001: begin saida_display_dezena=7'b0000001; saida_display_unidade = 7'b0000100; end
			
			//virou a dezena 10 a 19
			5'b01010: begin saida_display_dezena=7'b1001111; saida_display_unidade = 7'b0000001; end
			5'b01011: begin saida_display_dezena=7'b1001111; saida_display_unidade = 7'b1001111; end
			5'b01100: begin saida_display_dezena=7'b1001111; saida_display_unidade = 7'b0010010; end
			5'b01101: begin saida_display_dezena=7'b1001111; saida_display_unidade = 7'b0000110; end
			5'b01110: begin saida_display_dezena=7'b1001111; saida_display_unidade = 7'b1001100; end
			5'b01111: begin saida_display_dezena=7'b1001111; saida_display_unidade = 7'b0100100; end
			5'b10000: begin saida_display_dezena=7'b1001111; saida_display_unidade = 7'b0100000; end
			5'b10001: begin saida_display_dezena=7'b1001111; saida_display_unidade = 7'b0001111; end
			5'b10010: begin saida_display_dezena=7'b1001111; saida_display_unidade = 7'b0000000; end
			5'b10011: begin saida_display_dezena=7'b1001111; saida_display_unidade = 7'b0000100; end
			
			//virou a dezena 20 a 29
			5'b10100: begin saida_display_dezena=7'b0010010; saida_display_unidade = 7'b0000001; end
			5'b10101: begin saida_display_dezena=7'b0010010; saida_display_unidade = 7'b1001111; end
			5'b10110: begin saida_display_dezena=7'b0010010; saida_display_unidade = 7'b0010010; end
			5'b10111: begin saida_display_dezena=7'b0010010; saida_display_unidade = 7'b0000110; end
			5'b11000: begin saida_display_dezena=7'b0010010; saida_display_unidade = 7'b1001100; end
			5'b11001: begin saida_display_dezena=7'b0010010; saida_display_unidade = 7'b0100100; end
			5'b11010: begin saida_display_dezena=7'b0010010; saida_display_unidade = 7'b0100000; end
			5'b11011: begin saida_display_dezena=7'b0010010; saida_display_unidade = 7'b0001111; end
			5'b11100: begin saida_display_dezena=7'b0010010; saida_display_unidade = 7'b0000000; end
			5'b11101: begin saida_display_dezena=7'b0010010; saida_display_unidade = 7'b0000100; end
			
			// virou a dezena = 30 a 31
			5'b11110: begin saida_display_dezena=7'b0000110; saida_display_unidade = 7'b0000001; end
			5'b11111: begin saida_display_dezena=7'b0000110; saida_display_unidade = 7'b1001111; end
			
			
		endcase
	end
	
	
endmodule
