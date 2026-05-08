`timescale 1ns/1ns
module pe_tb();

reg CLK;
reg rst;
reg w_load;
reg [7:0] a_in [3:0];
reg [7:0] b_in [3:0];
reg signed [31:0] acc_in;

wire signed [7:0] a_out;
wire signed [7:0] b_out;
wire signed [31:0] acc_out;

pe u_pe (
    .clk(CLK),
    .rst(rst),
    .w_load(w_load),
    .a_in(a_in[0]),
    .b_in(b_in[0]),
    .acc_in(acc_in),

    .a_out(a_out),
    .b_out(b_out),
    .acc_out(acc_out)
);

initial CLK = 0;
always #0.5 CLK = ~CLK;

initial begin

    // Init
    rst     = 1;
    w_load  = 0;
    a_in    = 0;
    b_in    = 0;
    acc_in  = 0;

    repeat(2) @(posedge CLK);
    rst = 0;

    // ----------------------
    // Test 1
    // ----------------------
    a_in = 3;
    b_in = 4;
    acc_in = 0;

    w_load = 1;
    @(posedge CLK);

    w_load = 0;
    @(posedge CLK);

    assert(a_out == 3);
    assert(b_out == 4);
    assert(acc_out == 12);

    // ----------------------
    // Test 2 (accumulate)
    // ----------------------
    a_in = 3;
    b_in = 4;
    acc_in = 5;

    @(posedge CLK);

    assert(acc_out == 17);

    $display("PE Test Passed!");
    $finish;
end
endmodule