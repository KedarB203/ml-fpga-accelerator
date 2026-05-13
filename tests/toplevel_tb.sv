`timescale 1ns/1ps

// ====================================================================
// tb_topModule
//
// Systolic array computes Wᵀ × v (column-major accumulation):
//
//   W0 streamed row-by-row:       W0ᵀ (what array computes):
//   [ 1  2  3  4 ]                [ 1  5  1  5 ]
//   [ 5  6  7  8 ]       →        [ 2  6  2  6 ]
//   [ 1  2  3  4 ]                [ 3  7  3  7 ]
//   [ 5  6  7  8 ]                [ 4  8  4  8 ]
//
//   W1 = 4×4 identity,  W2 = 2×identity
//
// For input v = [1,1,1,1]ᵀ:
//   L0: [12, 16, 20, 24]
//   L1: [12, 16, 20, 24]
//   L2: [24, 32, 40, 48]
// ====================================================================

module tb_topModule;

    // ----------------------------------------------------------------
    // Clock — 10 ns period
    // ----------------------------------------------------------------
    reg CLK;
    initial CLK = 0;
    always #5 CLK = ~CLK;

    // ----------------------------------------------------------------
    // DUT ports
    // ----------------------------------------------------------------
    reg        rst;
    reg        weight_valid;
    reg        activation_valid;
    reg  [7:0] activation_in;
    reg  [7:0] weight_in;
    wire       in_ready;
    wire       out_valid;
    wire signed [31:0] out_data [0:3];
    reg        out_ready;

    topModule u_top (
        .clk              (CLK),
        .rst              (rst),
        .weight_valid     (weight_valid),
        .activation_valid (activation_valid),
        .activation_in    (activation_in),
        .weight_in        (weight_in),
        .in_ready         (in_ready),
        .out_valid        (out_valid),
        .out_data         (out_data),
        .out_ready        (out_ready)
    );

    // FSM state encoding (must match fsm_controller)
    localparam [2:0] COMPUTE = 3'd3;

    // ----------------------------------------------------------------
    // Weight / input storage
    // ----------------------------------------------------------------
    reg [7:0] weights_l0 [0:15];
    reg [7:0] weights_l1 [0:15];
    reg [7:0] weights_l2 [0:15];
    reg [7:0] weights_buf [0:15];
    reg [7:0] test_inputs [0:3];

    integer timeout;
    integer pass_count;
    integer fail_count;

    // ----------------------------------------------------------------
    // Task: copy chosen layer into weights_buf
    // ----------------------------------------------------------------
    task load_layer;
        input integer layer;
        integer k;
        begin
            for (k = 0; k < 16; k = k+1) begin
                case (layer)
                    0: weights_buf[k] = weights_l0[k];
                    1: weights_buf[k] = weights_l1[k];
                    2: weights_buf[k] = weights_l2[k];
                    default: weights_buf[k] = 8'd0;
                endcase
            end
        end
    endtask

    // ----------------------------------------------------------------
    // Task: stream weights_buf to DUT one byte per cycle
    // ----------------------------------------------------------------
    task send_weights;
        input [63:0] layer_num;
        integer j;
        begin
            $display("[%0t] loading layer %0d weights", $time, layer_num);
            for (j = 0; j < 16; j = j+1) begin
                @(posedge CLK); #1;
                weight_valid = 1'b1;
                weight_in    = weights_buf[j];
            end
            @(posedge CLK); #1;
            weight_valid = 1'b0;
            weight_in    = 8'd0;
        end
    endtask

    // ----------------------------------------------------------------
    // Task: stream test_inputs to DUT
    // ----------------------------------------------------------------
    task send_inputs;
        integer j;
        begin
            $display("[%0t] sending inputs", $time);
            for (j = 0; j < 4; j = j+1) begin
                @(posedge CLK); #1;
                activation_valid = 1'b1;
                activation_in    = test_inputs[j];
            end
            @(posedge CLK); #1;
            activation_valid = 1'b0;
            activation_in    = 8'd0;
        end
    endtask

    // ----------------------------------------------------------------
    // Task: wait for out_valid then check all four outputs
    // ----------------------------------------------------------------
    task wait_and_check;
        input signed [31:0] e0, e1, e2, e3;
        input [127:0] label;
        begin
            out_ready = 1'b0;
            timeout   = 0;

            while (!out_valid && timeout < 500) begin
                @(posedge CLK);
                timeout = timeout + 1;
            end

            if (timeout >= 500) begin
                $display("  [%s] TIMEOUT waiting for out_valid", label);
                fail_count = fail_count + 1;
            end else begin
                if (out_data[0] === e0 && out_data[1] === e1 &&
                    out_data[2] === e2 && out_data[3] === e3) begin
                    $display("  [%s] PASS  got=[%0d, %0d, %0d, %0d]",
                        label,
                        out_data[0], out_data[1], out_data[2], out_data[3]);
                    pass_count = pass_count + 1;
                end else begin
                    $display("  [%s] FAIL  got=[%0d, %0d, %0d, %0d]  expected=[%0d, %0d, %0d, %0d]",
                        label,
                        out_data[0], out_data[1], out_data[2], out_data[3],
                        e0, e1, e2, e3);
                    fail_count = fail_count + 1;
                end

                @(posedge CLK); #1;
                out_ready = 1'b1;
                @(posedge CLK); #1;
                out_ready = 1'b0;
            end
        end
    endtask

    // ----------------------------------------------------------------
    // Task: apply reset
    // ----------------------------------------------------------------
    task do_reset;
        begin
            rst              = 1'b1;
            weight_valid     = 1'b0;
            activation_valid = 1'b0;
            activation_in    = 8'd0;
            weight_in        = 8'd0;
            out_ready        = 1'b0;
            repeat(5) @(posedge CLK);
            rst = 1'b0;
            @(posedge CLK);
        end
    endtask

    // ----------------------------------------------------------------
    // Weight initialisation
    // ----------------------------------------------------------------
    initial begin
        // L0: rows [1,2,3,4] [5,6,7,8] [1,2,3,4] [5,6,7,8]
        weights_l0[ 0]=8'd1; weights_l0[ 1]=8'd2;
        weights_l0[ 2]=8'd3; weights_l0[ 3]=8'd4;
        weights_l0[ 4]=8'd5; weights_l0[ 5]=8'd6;
        weights_l0[ 6]=8'd7; weights_l0[ 7]=8'd8;
        weights_l0[ 8]=8'd1; weights_l0[ 9]=8'd2;
        weights_l0[10]=8'd3; weights_l0[11]=8'd4;
        weights_l0[12]=8'd5; weights_l0[13]=8'd6;
        weights_l0[14]=8'd7; weights_l0[15]=8'd8;

        // L1: 4×4 identity
        weights_l1[ 0]=8'd1; weights_l1[ 1]=8'd0;
        weights_l1[ 2]=8'd0; weights_l1[ 3]=8'd0;
        weights_l1[ 4]=8'd0; weights_l1[ 5]=8'd1;
        weights_l1[ 6]=8'd0; weights_l1[ 7]=8'd0;
        weights_l1[ 8]=8'd0; weights_l1[ 9]=8'd0;
        weights_l1[10]=8'd1; weights_l1[11]=8'd0;
        weights_l1[12]=8'd0; weights_l1[13]=8'd0;
        weights_l1[14]=8'd0; weights_l1[15]=8'd1;

        // L2: 2×identity
        weights_l2[ 0]=8'd2; weights_l2[ 1]=8'd0;
        weights_l2[ 2]=8'd0; weights_l2[ 3]=8'd0;
        weights_l2[ 4]=8'd0; weights_l2[ 5]=8'd2;
        weights_l2[ 6]=8'd0; weights_l2[ 7]=8'd0;
        weights_l2[ 8]=8'd0; weights_l2[ 9]=8'd0;
        weights_l2[10]=8'd2; weights_l2[11]=8'd0;
        weights_l2[12]=8'd0; weights_l2[13]=8'd0;
        weights_l2[14]=8'd0; weights_l2[15]=8'd2;
    end

    // ----------------------------------------------------------------
    // Main stimulus
    // ----------------------------------------------------------------
    initial begin
        $dumpfile("tb_topModule.fst");
        $dumpvars(0, tb_topModule);

        pass_count = 0;
        fail_count = 0;

        // ============================================================
        // TEST 1 — input [1,1,1,1]
        //   L0: W0ᵀ×[1,1,1,1] = [12, 16, 20, 24]
        //   L1: I×[12,16,20,24] = [12, 16, 20, 24]
        //   L2: 2I×[12,16,20,24] = [24, 32, 40, 48]
        // ============================================================
        $display("=== TEST 1: input all-ones ===");
        do_reset;
        test_inputs[0]=8'd1; test_inputs[1]=8'd1;
        test_inputs[2]=8'd1; test_inputs[3]=8'd1;

        // L0 weights → buf1 (loadSel=0, FSM in LOAD_W)
        load_layer(0); send_weights(0);
        // Activations kick FSM: LOAD_I → COMPUTE; loadSel flips to 1
        send_inputs;
        // Wait for COMPUTE: loadSel=1, load_weight asserted → L1 goes into buf2
        wait(u_top.u_ctrl.state == COMPUTE);
        @(posedge CLK); #1;
        load_layer(1); send_weights(1);
        wait_and_check(32'd12, 32'd16, 32'd20, 32'd24, "T1-L0");

        // L1 activations kick FSM: LOAD_I → COMPUTE; loadSel flips to 0
        send_inputs;
        // Wait for COMPUTE: loadSel=0, load_weight asserted → L2 goes into buf1
        wait(u_top.u_ctrl.state == COMPUTE);
        @(posedge CLK); #1;
        load_layer(2); send_weights(2);
        wait_and_check(32'd12, 32'd16, 32'd20, 32'd24, "T1-L1");

        // L2: last layer, no background load needed
        send_inputs;
        wait_and_check(32'd24, 32'd32, 32'd40, 32'd48, "T1-L2");

        // ============================================================
        // TEST 2 — input [2,2,2,2]
        //   L0: [24, 32, 40, 48]
        //   L1: [24, 32, 40, 48]
        //   L2: [48, 64, 80, 96]
        // ============================================================
        $display("=== TEST 2: input all-twos ===");
        do_reset;
        test_inputs[0]=8'd2; test_inputs[1]=8'd2;
        test_inputs[2]=8'd2; test_inputs[3]=8'd2;

        load_layer(0); send_weights(0);
        send_inputs;
        wait(u_top.u_ctrl.state == COMPUTE);
        @(posedge CLK); #1;
        load_layer(1); send_weights(1);
        wait_and_check(32'd24, 32'd32, 32'd40, 32'd48, "T2-L0");

        send_inputs;
        wait(u_top.u_ctrl.state == COMPUTE);
        @(posedge CLK); #1;
        load_layer(2); send_weights(2);
        wait_and_check(32'd24, 32'd32, 32'd40, 32'd48, "T2-L1");

        send_inputs;
        wait_and_check(32'd48, 32'd64, 32'd80, 32'd96, "T2-L2");

        // ============================================================
        // TEST 3 — input [0,0,0,0]  (boundary: all zeros)
        //   All layers: [0, 0, 0, 0]
        // ============================================================
        $display("=== TEST 3: input all-zeros ===");
        do_reset;
        test_inputs[0]=8'd0; test_inputs[1]=8'd0;
        test_inputs[2]=8'd0; test_inputs[3]=8'd0;

        load_layer(0); send_weights(0);
        send_inputs;
        wait(u_top.u_ctrl.state == COMPUTE);
        @(posedge CLK); #1;
        load_layer(1); send_weights(1);
        wait_and_check(32'd0, 32'd0, 32'd0, 32'd0, "T3-L0");

        send_inputs;
        wait(u_top.u_ctrl.state == COMPUTE);
        @(posedge CLK); #1;
        load_layer(2); send_weights(2);
        wait_and_check(32'd0, 32'd0, 32'd0, 32'd0, "T3-L1");

        send_inputs;
        wait_and_check(32'd0, 32'd0, 32'd0, 32'd0, "T3-L2");

        // ============================================================
        // TEST 4 — input [1,2,3,4]
        //   L0: W0ᵀ×[1,2,3,4] = [34, 44, 54, 64]
        //   L1: [34, 44, 54, 64]
        //   L2: [68, 88, 108, 128]
        // ============================================================
        $display("=== TEST 4: input [1,2,3,4] ===");
        do_reset;
        test_inputs[0]=8'd1; test_inputs[1]=8'd2;
        test_inputs[2]=8'd3; test_inputs[3]=8'd4;

        load_layer(0); send_weights(0);
        send_inputs;
        wait(u_top.u_ctrl.state == COMPUTE);
        @(posedge CLK); #1;
        load_layer(1); send_weights(1);
        wait_and_check(32'd34, 32'd44, 32'd54, 32'd64, "T4-L0");

        send_inputs;
        wait(u_top.u_ctrl.state == COMPUTE);
        @(posedge CLK); #1;
        load_layer(2); send_weights(2);
        wait_and_check(32'd34, 32'd44, 32'd54, 32'd64, "T4-L1");

        send_inputs;
        wait_and_check(32'd68, 32'd88, 32'd108, 32'd128, "T4-L2");

        // ============================================================
        // TEST 5 — reset recovery mid-stream
        // ============================================================
        $display("=== TEST 5: reset recovery ===");
        @(posedge CLK); #1;
        activation_valid = 1'b1;
        activation_in    = 8'd99;
        repeat(2) @(posedge CLK);
        do_reset;

        test_inputs[0]=8'd1; test_inputs[1]=8'd1;
        test_inputs[2]=8'd1; test_inputs[3]=8'd1;

        load_layer(0); send_weights(0);
        send_inputs;
        wait(u_top.u_ctrl.state == COMPUTE);
        @(posedge CLK); #1;
        load_layer(1); send_weights(1);
        wait_and_check(32'd12, 32'd16, 32'd20, 32'd24, "T5-L0");

        send_inputs;
        wait(u_top.u_ctrl.state == COMPUTE);
        @(posedge CLK); #1;
        load_layer(2); send_weights(2);
        wait_and_check(32'd12, 32'd16, 32'd20, 32'd24, "T5-L1");

        send_inputs;
        wait_and_check(32'd24, 32'd32, 32'd40, 32'd48, "T5-L2");

        $display("");
        $display("=== RESULTS: %0d passed, %0d failed ===", pass_count, fail_count);
        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILURES DETECTED — check waveform");
        $finish;
    end

endmodule