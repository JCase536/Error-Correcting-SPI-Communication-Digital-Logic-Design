
module hamming_dec (output [10:0] data, output reg double_err, input [15:0] packet, input [3:0] state, input clk);
	wire [4:0] parity_bit;
	wire [1:0] row, col;
	reg [15:0] packet_fixed;
	reg [4:0] bit_in, pb_latch;
	reg [1:0] reset;

	assign row = {pb_latch[0], pb_latch[1]};
	assign col = {pb_latch[2], pb_latch[3]};
	assign data = {packet_fixed[12], packet_fixed[10:8], packet_fixed[6:0]};
	
	genvar i;
	generate
		for (i=0; i<4; i=i+1) begin : gen_parity_rc
			even_parity parity (parity_bit[i], bit_in[i], reset[0], clk);
		end
	endgenerate
	even_parity parity_whole (parity_bit[4], bit_in[4], reset[1], clk);

	always @(negedge clk) begin
		if (state == 4'd1) pb_latch = 5'd0;
		else if (state == 4'd8) pb_latch[3:0] = parity_bit[3:0];
		else if (state == 4'd0) begin
			pb_latch[4] = parity_bit[4];
			packet_fixed = packet;
			case ({row, col})
				4'd1: packet_fixed[14] = ~packet[14];
				4'd2: packet_fixed[13] = ~packet[13];
				4'd3: packet_fixed[12] = ~packet[12];
				4'd4: packet_fixed[11] = ~packet[11];
				4'd5: packet_fixed[10] = ~packet[10];
				4'd6: packet_fixed[9] = ~packet[9];
				4'd7: packet_fixed[8] = ~packet[8];
				4'd8: packet_fixed[7] = ~packet[7];
				4'd9: packet_fixed[6] = ~packet[6];
				4'd10: packet_fixed[5] = ~packet[5];
				4'd11: packet_fixed[4] = ~packet[4];
				4'd12: packet_fixed[3] = ~packet[3];
				4'd13: packet_fixed[2] = ~packet[2];
				4'd14: packet_fixed[1] = ~packet[1];
				4'd15: packet_fixed[0] = ~packet[0];
				default: packet_fixed = packet;
			endcase
		end
	end

	always @(*) begin
		case (state)
			4'd0: {bit_in, reset} = {packet[0], packet[0], packet[0], packet[0], packet[0], 2'b00};
			4'd1: {bit_in, reset} = {packet[1], packet[4], packet[4], packet[1], packet[1], 2'b00};
			4'd2: {bit_in, reset} = {packet[2], packet[8], packet[8], packet[2], packet[2], 2'b00};
			4'd3: {bit_in, reset} = {packet[3], packet[12], packet[12], packet[3], packet[3], 2'b00};
			4'd4: {bit_in, reset} = {packet[4], packet[2], packet[1], packet[8], packet[4], 2'b00};
			4'd5: {bit_in, reset} = {packet[5], packet[6], packet[5], packet[9], packet[5], 2'b00};
			4'd6: {bit_in, reset} = {packet[6], packet[10], packet[9], packet[10], packet[6], 2'b00};
			4'd7: {bit_in, reset} = {packet[7], packet[14], packet[13], packet[11], packet[7], 2'b01};
			4'd8: {bit_in, reset} = {packet[8], packet[14], packet[13], packet[11], packet[7], 2'b01};
			4'd9: {bit_in, reset} = {packet[9], packet[14], packet[13], packet[11], packet[7], 2'b01};
			4'd10: {bit_in, reset} = {packet[10], packet[14], packet[13], packet[11], packet[7], 2'b01};
			4'd11: {bit_in, reset} = {packet[11], packet[14], packet[13], packet[11], packet[7], 2'b01};
			4'd12: {bit_in, reset} = {packet[12], packet[14], packet[13], packet[11], packet[7], 2'b01};
			4'd13: {bit_in, reset} = {packet[13], packet[14], packet[13], packet[11], packet[7], 2'b01};
			4'd14: {bit_in, reset} = {packet[14], packet[14], packet[13], packet[11], packet[7], 2'b01};
			4'd15: {bit_in, reset} = {packet[15], packet[0], packet[0], packet[0], packet[0], 2'b11};
		endcase
		double_err = ~pb_latch[4] & (pb_latch[3:0] != 4'd0);
	end
endmodule
