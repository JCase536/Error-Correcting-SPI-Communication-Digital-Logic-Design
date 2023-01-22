
module spi_top (output [10:0] data_to_proc, data_to_peri0, data_to_peri1, output err_m, err_s0, err_s1,
		input [10:0] data_from_proc, data_from_peri0, data_from_peri1, input dis, reset, clk);

	wire miso, miso_dis;
	wire mosi, mosi_dis;
	wire [1:0] ss;
	wire clk_m;

	assign miso_dis = dis ^ miso;
	assign mosi_dis = dis ^ mosi;

	spi_master master (data_to_proc, err_m, mosi, clk_m, ss, data_from_proc, miso_dis, clk, reset);
	spi_slave s0 (data_to_peri0, err_s0, miso, data_from_peri0, mosi_dis, clk_m, reset, ss[0]);
	spi_slave s1 (data_to_peri1, err_s1, miso, data_from_peri1, mosi_dis, clk_m, reset, ss[1]);
endmodule
