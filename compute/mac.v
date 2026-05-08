module mac (
    input  logic clk,
    input  logic rst,

    input  logic signed [7:0] a_in,
    input  logic signed [7:0] b_in,
    input  logic signed [31:0] acc_in,
    output logic signed [31:0] acc_out
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