
module shift_reg_out (output out, input [15:0] data_in, input ld, clk);
	reg [15:0] data;
	assign out = data[0];
	always @(posedge clk) begin
		data <= (ld == 1'b1) ? data_in : {data[15], data[15:1]};
	end
endmodule
