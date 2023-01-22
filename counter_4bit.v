
module counter_4bit (output reg [3:0] state, input reset, clk);
	always @(posedge clk or posedge reset) begin
		if (reset) state <= 4'd15;
		else begin
			state[0] <= ~state[0];
			state[1] <= state[0] ^ state[1];
			state[2] <= (state[0]&state[1]) ^ state[2];
			state[3] <= (state[0]&state[1]&state[2]) ^ state[3];
		end
	end
endmodule
