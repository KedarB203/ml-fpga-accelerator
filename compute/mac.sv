module mac (
    input  clk,
    input rst,

    input  signed [7:0] a_in,
    input  signed [7:0] b_in,
    input  signed [31:0] acc_in,
    output reg signed [31:0] acc_out
);

reg signed [15:0] mult;
reg signed [31:0] acc_reg;
always @(posedge clk) begin
    if (rst) begin
        acc_out <= 0;
    end
    else begin
        mult <= a_in * b_in;
        acc_out <= acc_reg + mult;
    end
end

endmodule