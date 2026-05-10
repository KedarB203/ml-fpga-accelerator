`timescale 1ns/1ps

module tb_topModule;

reg CLK;
reg rst;


initial CLK = 0;
always #5 CLK = ~CLK;

reg        in_valid;
reg [7:0]  activation_in;
reg [7:0]  weight_in;
reg        in_ready;

reg        out_valid;
reg [31:0] out_data  [0:3];
reg        out_ready;


topModule u_top (
    .clk(CLK),
    .rst(rst),

    .in_valid(in_valid),
    .activation_in(activation_in),
    .weight_in(weight_in),
    .in_ready(in_ready),

    .out_valid(out_valid),
    .out_data(out_data),
    .out_ready(out_ready)
);

initial begin
    in_valid  = 0;
    in_data   = 0;
    out_ready = 1;

    rst = 1;
    repeat (5) @(posedge clk);
    rst = 0;

end

endmodule 