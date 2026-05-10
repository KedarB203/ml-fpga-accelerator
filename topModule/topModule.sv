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
    wire [7:0] weight_dataA [0:3];
    wire [7:0] weight_dataB [0:3];

    wire done_compute;
    wire bufSel; // buffer selector for double buffering
    wire  [31:0] pre_bias_data [0:3];
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

        .load(bufSel & load_weight),
        .read_en(weight_read_en),

        .in_data(weight_in),   

        .out_data(weight_dataA)
    );


    weight_buffer u_weight2 (
        .clk(clk),
        .rst(rst),

        .load(~bufSel & load_weight),
        .read_en(weight_read_en),

        .in_data(weight_in),   

        .out_data(weight_dataB)
    );

    genvar i;

    for (i = 0; i < 4; i=i+1) begin
        assign weight_data[i] = bufSel ? weight_dataA[i] : weight_dataB[i];
    end
    
    // ---------------- SYSTOLIC ARRAY ----------------
    systolic_array u_array (
        .clk(clk),
        .rst(rst),

        .w_load(load_weight),
        .start_compute(start_compute),
        .a_in(activation_data),
        .b_in(weight_data),

        .result_out(pre_bias_data),
        .done(done_compute)
    );


    // ---------------- OUTPUT INTERFACE ----------------
    
    output_buffer u_output (
        .clk(clk),
        .rst(rst),
        .done(done_compute),
        .data_in(pre_bias_data),

        .data_out(out_data), 
        .valid(out_valid)
    );

    // ---------------- FSM CONTROLLER ----------------
    fsm_controller u_ctrl (
        .clk(clk),
        .rst(rst),

        .done(done_compute),

        .load_input(load_input),
        .load_weight(load_weight),

        .start_compute(start_compute),

        .input_read_en(input_read_en),
        .weight_read_en(weight_read_en),
        .bufSel(bufSel)
    );

endmodule