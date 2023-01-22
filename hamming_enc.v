
module hamming_enc (output [15:0] packet, input [10:0] data, input [3:0] state, input clk);
	wire [4:0] parity_bit;
	reg [4:0] bit_in, pb_latch;
	reg [1:0] reset;
	
	assign packet = {pb_latch[4:2], data[10], pb_latch[1], data[9:7], pb_latch[0], data[6:0]};
	genvar i;
	generate
		for (i=0; i<4; i=i+1) begin : gen_parity_rc
			even_parity parity (parity_bit[i], bit_in[i], reset[0], clk);
		end
	endgenerate
	even_parity parity_whole (parity_bit[4], bit_in[4], reset[1], clk);

	always @(negedge clk) begin
		if (state == 4'd15) pb_latch = 5'd0;
		else if (state == 4'd6) pb_latch[3:0] = parity_bit[3:0];
		else if (state == 4'd14) pb_latch[4] = parity_bit[4];
	end
	
	always @(*) begin
		case (state)
			4'd0: {bit_in, reset} = {data[1], packet[4], packet[4], packet[1], packet[1], 2'b00};
			4'd1: {bit_in, reset} = {data[2], packet[8], packet[8], packet[2], packet[2], 2'b00};
			4'd2: {bit_in, reset} = {data[3], packet[12], packet[12], packet[3], packet[3], 2'b00};
			4'd3: {bit_in, reset} = {data[4], packet[2], packet[1], packet[8], packet[4], 2'b00};
			4'd4: {bit_in, reset} = {data[5], packet[6], packet[5], packet[9], packet[5], 2'b00};
			4'd5: {bit_in, reset} = {data[6], packet[10], packet[9], packet[10], packet[6], 2'b01};
			4'd6: {bit_in, reset} = {data[7], packet[10], packet[9], packet[10], packet[6], 2'b01};
			4'd7: {bit_in, reset} = {data[8], packet[10], packet[9], packet[10], packet[6], 2'b01};
			4'd8: {bit_in, reset} = {data[9], packet[10], packet[9], packet[10], packet[6], 2'b01};
			4'd9: {bit_in, reset} = {data[10], packet[10], packet[9], packet[10], packet[6], 2'b01};
			4'd10: {bit_in, reset} = {pb_latch[0], packet[10], packet[9], packet[10], packet[6], 2'b01};
			4'd11: {bit_in, reset} = {pb_latch[1], packet[10], packet[9], packet[10], packet[6], 2'b01};
			4'd12: {bit_in, reset} = {pb_latch[2], packet[10], packet[9], packet[10], packet[6], 2'b01};
			4'd13: {bit_in, reset} = {pb_latch[3], packet[10], packet[9], packet[10], packet[6], 2'b11};
			4'd14: {bit_in, reset} = {pb_latch[3], packet[10], packet[9], packet[10], packet[6], 2'b11};
			4'd15: {bit_in, reset} = {data[0], packet[0], packet[0], packet[0], packet[0], 2'b00};
		endcase
	end
endmodule
