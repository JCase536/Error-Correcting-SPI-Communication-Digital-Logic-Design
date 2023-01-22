
module even_parity (output parity_bit, input bit_in, reset, clk);
	wire d;
	reg state;
	
	assign parity_bit = reset & (bit_in ^ state);
	assign d = ~reset & (bit_in ^ state);
	
	always @(posedge clk) begin
		state <= d;
	end
endmodule
