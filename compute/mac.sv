module mac (
    input  clk,
    input rst,

    input  signed [7:0] a_in,
    input  signed [7:0] b_in,
    input  signed [31:0] acc_in,
    output reg signed [31:0] acc_out
);

always @(posedge clk) begin
    if (rst) begin
        acc_out <= 0;
    end
    else begin
        acc_out <= acc_in + a_in * b_in;
    end
end

endmodule