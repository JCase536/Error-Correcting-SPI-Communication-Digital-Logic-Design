
module spi_slave (output reg [10:0] data_to_peri, output double_err, msg_out_tri,
			input [10:0] data_from_peri, input msg_in, clk_in, reset, ss);

	wire [3:0] state;
	wire [15:0] packet_in, packet_out;
	wire [10:0] data_out;
	reg [10:0] data_in;
	wire ld_in, ld_out;
	wire msg_out;
	wire msg_in_tri;
	
	assign ld_in = (state == 4'd0) ? 1'b1 : 1'b0;
	assign ld_out = (state == 4'd15) ? 1'b1 : 1'b0;
	assign {msg_in_tri, msg_out_tri} = (ss == 1'b1) ? {msg_in, msg_out} : 2'bzz;

	counter_4bit counter (.state(state), .reset(reset), .clk(clk_in));

	hamming_enc enc (packet_out, data_in, state, clk_in);
	hamming_dec dec (data_out, double_err, packet_in, state, clk_in);

	shift_reg_out shift_out (msg_out, packet_out, ld_out, clk_in);
	shift_reg_in shift_in (packet_in, msg_in_tri, ld_in, clk_in);

	always @(posedge clk_in) begin
		if (state == 4'd15) begin
			data_in <= data_from_peri;
			data_to_peri <= data_out;
		end
	end

endmodule
