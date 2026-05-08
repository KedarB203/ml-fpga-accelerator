`timescale 1ns/1ns
module mac_tb();
	reg CLK;
	reg rst;
    reg signed [7:0] a, b;
    reg signed [31:0] acc;
    wire signed [31:0] acc_out;

initial CLK = 0;
always #0.5 CLK = ~CLK;

    mac u_mac (
        .clk(CLK),
        .rst(rst),
        .a_in(a),
        .b_in(b),
        .acc_in(acc),
        .acc_out(acc_out)
    );
initial begin
    a = 3; b = 4; acc = 0;
    #2;
    assert(acc_out == 12);

    a = 3; b = 4; acc = 5;
    #2;
    assert(acc_out == 17);
    #2;
    $display("MAC Test Passed!");
    $finish;
end

endmodule