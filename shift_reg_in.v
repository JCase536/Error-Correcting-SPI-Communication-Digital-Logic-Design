
module shift_reg_in (output reg [15:0] data_out, input in, ld, clk);
	reg [15:0] data;
	always @(posedge clk) begin
		if (ld == 1'b1) data_out <= data;
		data <= {in, data[15:1]};
	end
endmodule
