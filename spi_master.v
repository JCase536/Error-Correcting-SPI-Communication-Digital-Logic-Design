
module spi_master (output reg [10:0] data_to_proc, output double_err, msg_out, clk_out, output reg [1:0] ss,
			input [10:0] data_from_proc, input msg_in, clk_in, reset);

	wire [3:0] state;
	wire [15:0] packet_in, packet_out;
	wire [10:0] data_out;
	reg [10:0] data_in;
	wire ld_in, ld_out;

	assign ld_in = (state == 4'd0) ? 1'b1 : 1'b0;
	assign ld_out = (state == 4'd15) ? 1'b1 : 1'b0;
	assign clk_out = clk_in;

	counter_4bit counter (.state(state), .reset(reset), .clk(clk_in));

	hamming_enc enc (packet_out, data_in, state, clk_in);
	hamming_dec dec (data_out, double_err, packet_in, state, clk_in);

	shift_reg_out shift_out (msg_out, packet_out, ld_out, clk_in);
	shift_reg_in shift_in (packet_in, msg_in, ld_in, clk_in);

	always @(posedge clk_in) begin
		if (reset == 1'b1)
			ss <= 2'b01;
		else if (state == 4'd15) begin
			ss <= {ss[0], ss[1]};
			data_in <= data_from_proc;
			data_to_proc <= data_out;
		end
	end

endmodule
