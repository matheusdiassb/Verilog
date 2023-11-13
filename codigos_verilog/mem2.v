module mem2 (writeback, data_in, index, tag, read, write, clk, hit, miss, state, valido_exit, dirty_exit, lru_exit, tag_exit, dado_exit, dado_retornadocpu);
	input [1:0]index;
	input clk, read, write;
	input [2:0] tag;
	input [2:0] data_in;
		
	reg lru_mem [3:0][1:0];
	reg dirty_mem [3:0][1:0];
	reg valid_mem [3:0][1:0];
	reg [2:0] tag_mem [3:0][1:0];
	reg [2:0] data_mem [3:0][1:0];
	
	output reg valido_exit;
	output reg lru_exit;
	output reg dirty_exit;
	output reg [2:0]tag_exit;
	output reg [2:0]dado_exit;
	output reg [2:0]dado_retornadocpu;
	output reg writeback;
	
	reg [2:0]cont;
	
	output reg miss;
	output reg hit;
	
	
	output reg [1:0]state;
	
initial begin //bit mais a esquerda = via0, bit mais a direita via1, inicialização da memória
			state = 2'b00;
			miss = 0;
			hit = 0;
			cont = 3'b000;
			writeback = 0;
			
			//via 0
			valid_mem [0][0] = 0; dirty_mem [0][0] = 0; lru_mem[0][0] = 0; tag_mem[0][0] = 3'b100; data_mem [0][0] = 3'b001; // indice 0
			valid_mem [1][0] = 1; dirty_mem [1][0] = 0; lru_mem[1][0] = 1; tag_mem[1][0] = 3'b000; data_mem [1][0] = 3'b011; // indice 1
			valid_mem [2][0] = 1; dirty_mem [2][0] = 1; lru_mem[2][0] = 0; tag_mem[2][0] = 3'b101; data_mem [2][0] = 3'b101; // indice 2
			valid_mem [3][0] = 0; dirty_mem [3][0] = 0; lru_mem[3][0] = 0; tag_mem[3][0] = 3'b000; data_mem [3][0] = 3'b000; // indice 3
			
			//via 1
			valid_mem [0][1] = 0; dirty_mem [0][1] = 0; lru_mem[0][1] = 0; tag_mem[0][1] = 3'b000; data_mem [0][1] = 3'b010; // indice 0
			valid_mem [1][1] = 0; dirty_mem [1][1] = 0; lru_mem[1][1] = 0; tag_mem[1][1] = 3'b000; data_mem [1][1] = 3'b100; // indice 1
			valid_mem [2][1] = 1; dirty_mem [2][1] = 0; lru_mem[2][1] = 1; tag_mem[2][1] = 3'b111; data_mem [2][1] = 3'b110; // indice 2
			valid_mem [3][1] = 0; dirty_mem [3][1] = 0; lru_mem[3][1] = 0; tag_mem[3][1] = 3'b000; data_mem [3][1] = 3'b000; // indice 3
end



always @ (posedge clk) begin

		case(state)
		2'b00:	begin // comparar tag e bit valido e direcionar se é escrita ou leitura
			if((valid_mem [index][0] == 1 && tag_mem[index][0] == tag) || (valid_mem [index][1] == 1 && tag_mem[index][1] == tag)) begin
				
					hit = 1; miss = 0; // marca hit
				
					if(read) begin
						state = 2'b10;
						writeback = 0;
					end
					else if(write) begin
									state = 2'b01;
									writeback = 0;
						  end
			
			end
			
			else begin
				state = 2'b11;
				writeback = 0;
			end
			
		end
		
		2'b01:	begin	// se for escrita vai fazer alguma coisa aqui
		
				if(hit && write) begin
					if(tag == tag_mem[index][0]) begin
								lru_mem [index][0] = 1; 
						end
					else begin
								lru_mem [index][0] = 0; 
					end
				end
				
				if(lru_mem [index][0] == 1)begin
					
					//atualizar o dado antes
					data_mem[index][0] = data_in;
					dirty_mem [index][0] = 1;
					
					valido_exit = valid_mem[index][0];
					lru_exit = lru_mem[index][0];
					dirty_exit = dirty_mem [index][0];
					tag_exit = tag_mem[index][0];
					dado_retornadocpu = data_mem[index][0];
					dado_exit = data_mem[index][0];
					//writeback = 0; //mexer nisso
				end 
				else begin
					//atualizar o dado antes
					data_mem[index][1] = data_in;
					dirty_mem [index][1] = 1;
					
					valido_exit = valid_mem[index][1];
					lru_exit = lru_mem[index][1];
					dirty_exit = dirty_mem [index][1];
					tag_exit = tag_mem[index][1];
					dado_retornadocpu = data_mem[index][1];
					dado_exit = data_mem[index][1];
					//writeback = 0; //mexer nisso
				end
				
				state = 2'b00;
		end
		
		2'b10:	begin // se for leitura vai fazer alguma coisa aqui
		
				if(hit && read)begin
					if(tag == tag_mem[index][0]) begin
							lru_mem [index][0] = 1;
					end
					else begin
							lru_mem [index][0] = 0;
					end
				end
					
				if(lru_mem [index][0] == 1)begin
					valido_exit = valid_mem[index][0];
					lru_exit = lru_mem[index][0];
					dirty_exit = dirty_mem [index][0];
					tag_exit = tag_mem[index][0];
					dado_retornadocpu = data_mem[index][0];
					dado_exit = data_mem[index][0];
					//writeback = 0; //mexer nisso
					
				end
				else begin
					valido_exit = valid_mem[index][1];
					lru_exit = lru_mem[index][1];
					dirty_exit = dirty_mem [index][1];
					tag_exit = tag_mem[index][1];
					dado_retornadocpu = data_mem[index][1];
					dado_exit = data_mem[index][1];
					
				end
				
					state = 2'b00;
		end
		
		2'b11:	begin // caso for miss sera tratado aqui.
			
			miss = 1; hit = 0;
			cont = cont + 1'b1;
			
			if (read) begin
			
					if (lru_mem [index][0] == 0)begin
								
								if(dirty_mem [index][0] == 1)begin
									writeback = 1;
								end
								
								valid_mem[index][0] = 1; dirty_mem [index][0] = 0; lru_mem[index][0] = 1; tag_mem[index][0] = tag; data_mem[index][0] = cont;
								lru_mem[index][1] = 0;
								 
					end
					
					else begin
					
								if(dirty_mem [index][1] == 1)begin
									writeback = 1;
								end
								
								valid_mem[index][1] = 1; dirty_mem [index][1] = 0; lru_mem[index][1] = 1; tag_mem[index][1] = tag; data_mem[index][1] = cont;
								lru_mem[index][0] = 0;
								dado_exit = data_mem[index][1]; // talvez chamar o display nesse momento
					end
				
					state = 2'b10;
			end
			
			//tratar quando der miss na leitura
			else begin
					if (lru_mem [index][0] == 0)begin
					
								if(dirty_mem [index][0] == 1)begin
									writeback = 1;
								end
					
								tag_mem[index][0] = tag; 
								lru_mem[index][0] = 1; 
								lru_mem[index][1] = 0;
								
					end
					
					else begin
					
								if(dirty_mem [index][1] == 1)begin
									writeback = 1;
								end
								
								tag_mem[index][1] = tag; 
								lru_mem[index][1] = 1; 
								lru_mem[index][0] = 0;
							
					end
			
			
					//manda para a escrita
					state = 2'b01;
			
			end
			
		
		end
		
	endcase


end


endmodule

/////////////////////////////////////////////// modulo display/////////////////////////////////////////////////

module BCDpara7Seg(IN, S);

	input [3:0] IN;
	output [6:0] S;
	
	wire A, B, C, D;
	
	assign A = IN[3];
	assign B = IN[2];
	assign C = IN[1];
	assign D = IN[0];

	assign S[0] = B&(~C)&(~D) | (~A)&(~B)&(~C)&D;
	assign S[1] = B&(C&(~D) | (~C)&D);
	assign S[2] = (~B)&C&(~D);
	assign S[3] = B&C&D | B&(~C)&(~D) | (~A)&(~B)&(~C)&D;
	assign S[4] = B&(~C) | D;
	assign S[5] = (~A)&(~B)&D | C&D | (~B)&C;
	assign S[6] = B&C&D | (~A)&(~B)&(~C);

endmodule

/////////////////////////////////////////////// modulo simulação///////////////////////////////////////////////

module teste_mem2();

	reg [1:0]index;
	reg clk, read, write;
	reg [2:0] tag;
	reg [2:0] data_in;
	
	wire miss;
	wire hit;
	wire writeback;
	wire [1:0]state;
	wire valido_exit;
	wire lru_exit;
	wire dirty_exit;
	wire [2:0]tag_exit;
	wire [2:0]dado_exit;
	wire [2:0]dado_retornadocpu;

	mem2 dut (writeback, data_in, index, tag, read, write, clk, hit, miss, state, valido_exit, dirty_exit, lru_exit, tag_exit, dado_exit, dado_retornadocpu);
	
	initial begin
		//read miss via 0 - caso 1
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 0; #1;
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 1; #1;
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 0; #1;
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 1; #1;
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 0; #1;
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 1; #1;
		
		//read miss via 1 - caso 2
		index = 2'b00; tag = 3'b101; read = 1; write = 0; clk = 0; #1;
		index = 2'b00; tag = 3'b101; read = 1; write = 0; clk = 1; #1;
		index = 2'b00; tag = 3'b101; read = 1; write = 0; clk = 0; #1;
		index = 2'b00; tag = 3'b101; read = 1; write = 0; clk = 1; #1;
		index = 2'b00; tag = 3'b101; read = 1; write = 0; clk = 0; #1;
		index = 2'b00; tag = 3'b101; read = 1; write = 0; clk = 1; #1;
		
		//read hit via 0 - caso 3
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 0; #1;
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 1; #1;
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 0; #1;
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 1; #1;
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 0; #1;
		index = 2'b00; tag = 3'b100; read = 1; write = 0; clk = 1; #1;
		
		//write hit via 0 - caso 4
		data_in = 3'b111; index = 2'b01; tag = 3'b000; read = 0; write = 1; clk = 0; #1;
		data_in = 3'b111; index = 2'b01; tag = 3'b000; read = 0; write = 1; clk = 1; #1;
		data_in = 3'b111; index = 2'b01; tag = 3'b000; read = 0; write = 1; clk = 0; #1;
		data_in = 3'b111; index = 2'b01; tag = 3'b000; read = 0; write = 1; clk = 1; #1;
		data_in = 3'b111; index = 2'b01; tag = 3'b000; read = 0; write = 1; clk = 0; #1;
		data_in = 3'b111; index = 2'b01; tag = 3'b000; read = 0; write = 1; clk = 1; #1;
		
		//write hit via 1 - caso 5
		data_in = 3'b010; index = 2'b10; tag = 3'b111; read = 0; write = 1; clk = 0; #1;
		data_in = 3'b010; index = 2'b10; tag = 3'b111; read = 0; write = 1; clk = 1; #1;
		data_in = 3'b010; index = 2'b10; tag = 3'b111; read = 0; write = 1; clk = 0; #1;
		data_in = 3'b010; index = 2'b10; tag = 3'b111; read = 0; write = 1; clk = 1; #1;
		data_in = 3'b010; index = 2'b10; tag = 3'b111; read = 0; write = 1; clk = 0; #1;
		data_in = 3'b010; index = 2'b10; tag = 3'b111; read = 0; write = 1; clk = 1; #1;
		
		//write miss com writeback - caso 6
		data_in = 3'b011; index = 2'b10; tag = 3'b110; read = 0; write = 1; clk = 0; #1;
		data_in = 3'b011; index = 2'b10; tag = 3'b110; read = 0; write = 1; clk = 1; #1;
		data_in = 3'b011; index = 2'b10; tag = 3'b110; read = 0; write = 1; clk = 0; #1;
		data_in = 3'b011; index = 2'b10; tag = 3'b110; read = 0; write = 1; clk = 1; #1;
		data_in = 3'b011; index = 2'b10; tag = 3'b110; read = 0; write = 1; clk = 0; #1;
		data_in = 3'b011; index = 2'b10; tag = 3'b110; read = 0; write = 1; clk = 1; #1;
		data_in = 3'b011; index = 2'b10; tag = 3'b110; read = 0; write = 1; clk = 0; #1;
		data_in = 3'b011; index = 2'b10; tag = 3'b110; read = 0; write = 1; clk = 1; #1;
		
		//read miss com writeback - caso 7
		index = 2'b10; tag = 3'b001; read = 1; write = 0; clk = 0; #1;
		index = 2'b10; tag = 3'b001; read = 1; write = 0; clk = 1; #1;
		index = 2'b10; tag = 3'b001; read = 1; write = 0; clk = 0; #1;
		index = 2'b10; tag = 3'b001; read = 1; write = 0; clk = 1; #1;
		index = 2'b10; tag = 3'b001; read = 1; write = 0; clk = 0; #1;
		index = 2'b10; tag = 3'b001; read = 1; write = 0; clk = 1; #1;
		
	end
	
	initial begin
		$monitor("Tempo : %0d, Writeback: %b Miss: %b, Hit: %b, State: %b, valido_exit: %b, dirty_exit: %b, lru_exit: %b, tag_exit: %b, dado_exit: %b, dado_retornadocpu: %b", 
		$time, writeback, miss, hit, state, valido_exit, dirty_exit, lru_exit, tag_exit, dado_exit, dado_retornadocpu); //monitor: sempre que alguma das "variaveis" de formatacao se alterar, imprime na tela
	end
	
	
endmodule
