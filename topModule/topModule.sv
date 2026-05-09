module topModule(
    input  clk,
    input  rst,

    // input stream (activations)
    input         in_valid,
    input  [7:0]  activation_in,
    input  [7:0]  weight_in,
    output        in_ready,

    // output stream (results)
    output        out_valid,
    output  [31:0] out_data [0:3],
    input         out_ready
);

    // ---------------- INTERNAL SIGNALS ----------------
    wire load_input, load_weight;
    wire start_compute;
    wire input_read_en, weight_read_en;

    wire [7:0] activation_data [0:3];
    wire [7:0] weight_data [0:3];

    wire done_compute;

    // ---------------- INPUT BUFFER ----------------
    input_buffer u_input (
        .clk(clk),
        .rst(rst),

        .load(load_input),
        .read_en(input_read_en),

        .in_data(activation_in),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .out_data(activation_data)
    );

    // ---------------- WEIGHT BUFFER ----------------
    weight_buffer u_weight (
        .clk(clk),
        .rst(rst),

        .load(load_weight),
        .read_en(weight_read_en),

        .in_data(weight_in),   // assume same stream 

        .out_data(weight_data)
    );

    // ---------------- SYSTOLIC ARRAY ----------------
    systolic_array u_array (
        .clk(clk),
        .rst(rst),

        .w_load(load_weight),
        .start_compute(start_compute),
        .a_in(activation_data),
        .b_in(weight_data),

        .result_out(out_data),
        .done(done_compute)
    );

    // ---------------- OUTPUT INTERFACE ----------------
    // (simple pass-through version; replace with FIFO later)
    reg out_valid_r;

    always @(posedge clk) begin
        if (rst)
            out_valid_r <= 0;
        else
            out_valid_r <= done_compute;
    end

    assign out_valid = out_valid_r;

    // ---------------- FSM CONTROLLER ----------------
    fsm_controller u_ctrl (
        .clk(clk),
        .rst(rst),

        .done(done_compute),

        .load_input(load_input),
        .load_weight(load_weight),

        .start_compute(start_compute),

        .input_read_en(input_read_en),
        .weight_read_en(weight_read_en)
    );

endmodule