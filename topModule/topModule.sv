module topModule(
    input  clk,
    input  rst,

    // input stream (activations)
    input         weight_valid,
    input   activation_valid,
    input  [7:0]  activation_in,
    input  [7:0]  weight_in,
    output        in_ready,

    // output stream (results)
    output        out_valid,
    output signed [31:0] out_data [0:3],
    input         out_ready
);

    // ---------------- INTERNAL SIGNALS ----------------
    wire load_input, load_weight;
    wire start_compute;
    wire input_read_en, weight_read_en;
    wire load_doneA, load_doneB;
    wire load_done;
    wire signed [7:0] activation_data [0:3];
    wire signed [7:0] weight_data [0:3][0:3];
    wire signed [7:0] weight_dataA [0:3][0:3];
    wire signed [7:0] weight_dataB [0:3][0:3];
    wire done_compute;
    wire bufSel; // buffer selector for double buffering
    wire signed [31:0] pre_bias_data [0:3];
    wire input_load_done;
    wire loadSel; // selector for weight loading (which buffer to load)
    //reg counter [2:0]; // layer counter

    
    // ---------------- INPUT BUFFER ----------------
    reg signed [7:0] feedback_data [0:3];
    reg use_feedback;
    reg feedback_valid;
    wire [7:0] mux_res;
    wire act_valid_mux;
    reg [1:0] fb_idx;
    reg       fb_active;

    always @(posedge clk) begin
    if (rst) begin
        use_feedback     <= 1'b0;
        feedback_valid   <= 1'b0;
        fb_active        <= 1'b0;
        fb_idx           <= 2'b00;
        feedback_data[0] <= 8'd0;
        feedback_data[1] <= 8'd0;
        feedback_data[2] <= 8'd0;
        feedback_data[3] <= 8'd0;
    end else begin

        // Latch outputs and start streaming.
        // !fb_active prevents re-triggering while out_valid stays high.
        if (out_valid && !fb_active && u_ctrl.counter != 2'd2) begin
            feedback_data[0] <= out_data[0][7:0];
            feedback_data[1] <= out_data[1][7:0];
            feedback_data[2] <= out_data[2][7:0];
            feedback_data[3] <= out_data[3][7:0];
            use_feedback     <= 1'b1;
            feedback_valid   <= 1'b0;
            fb_active        <= 1'b0;
            fb_idx           <= 2'b00;

        // Advance index each cycle while streaming
        end else if (use_feedback && !fb_active && load_input) begin
            feedback_valid   <= 1'b1;
            fb_active        <= 1'b1;
            fb_idx           <= 2'b00;
        end else if (fb_active) begin
            fb_idx <= fb_idx + 2'b01;
            if (fb_idx == 2'b11) begin
                fb_active      <= 1'b0;
                fb_idx         <= 2'b00;
                feedback_valid <= 1'b0;
            end
        end

        // Return to external input after last layer
        if (out_valid && u_ctrl.counter == 2'd2 && out_ready)
            use_feedback <= 1'b0;

    end
end

    assign mux_res    = use_feedback ? feedback_data[fb_idx]  : activation_in;
    assign act_valid_mux = use_feedback ? feedback_valid : activation_valid;

    input_buffer u_input (
        .clk(clk),
        .rst(rst),

        .load(load_input),
        .read_en(input_read_en),

        .in_data(mux_res),
        .in_valid(act_valid_mux),
        .in_ready(in_ready),
        .out_data(activation_data),
        .input_load_done(input_load_done)
    );

    // ---------------- WEIGHT BUFFER ----------------
    weight_buffer u_weight (
        .clk(clk),
        .rst(rst),

        .load(~loadSel & load_weight),
        .read_en(~bufSel & weight_read_en),

        .in_data(weight_in),   
        .in_valid(weight_valid),
        .out_data(weight_dataA),
        .load_done(load_doneA)
    );


    weight_buffer u_weight2 (
        .clk(clk),
        .rst(rst),

        .load(loadSel & load_weight),
        .read_en(bufSel & weight_read_en),

        .in_data(weight_in),   
        .in_valid(weight_valid),
        .out_data(weight_dataB),
        .load_done(load_doneB)
    );

    genvar r, c;
    generate
        for (r = 0; r < 4; r = r+1) begin
            for (c = 0; c < 4; c = c+1) begin
                assign weight_data[r][c] = bufSel
                                         ? weight_dataB[r][c]
                                         : weight_dataA[r][c];
            end
        end
    endgenerate

    assign load_done = load_doneA | load_doneB;
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
        .out_ready(out_ready),

        .data_out(out_data), 
        .valid(out_valid)
    );

    // ---------------- FSM CONTROLLER ----------------
    fsm_controller u_ctrl (
        .clk(clk),
        .rst(rst),

        .done(done_compute),
        .load_done       (load_done),       // from active weight buffer
        .input_load_done (input_load_done), // from input buffer
        .load_input(load_input),
        .load_weight(load_weight),

        .start_compute(start_compute),

        .input_read_en(input_read_en),
        .weight_read_en(weight_read_en),
        .bufSel(bufSel),
        .loadSel(loadSel)
    );

endmodule