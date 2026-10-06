module tb_top_bcd_adder;
    logic [3:0] a;
    logic [3:0] b;
    logic       cin;
    logic [3:0] bcd_sum;
    logic       bcd_cout;
    logic [6:0] seg;
    logic [3:0] invalid_bcd;
    logic [6:0] invalid_seg;
    integer     ai;
    integer     bi;
    integer     ci;
    integer     expected;
    integer     errors;

    top_bcd_adder dut (
        .a        (a),
        .b        (b),
        .cin      (cin),
        .bcd_sum  (bcd_sum),
        .bcd_cout (bcd_cout),
        .seg      (seg)
    );

    // Test the decoder's invalid-BCD protection independently.
    decoder_7seg invalid_input_decoder (
        .bcd (invalid_bcd),
        .seg (invalid_seg)
    );

    initial begin
        $dumpfile("bcd_adder_waveform.vcd");
        $dumpvars(0, tb_top_bcd_adder);
        errors = 0;

        // Test Case 1: 3 + 4 + 0 = 7
        a = 4'd3;
        b = 4'd4;
        cin = 1'b0;
        #1;
        if (bcd_sum !== 4'd7 || bcd_cout !== 1'b0 || seg !== 7'b1111000) begin
            $display("FAIL Test Case 1: 3 + 4 + 0");
            errors = errors + 1;
        end else
            $display("PASS Test Case 1: 3 + 4 + 0 = 7, seg = %b", seg);

        // Test Case 2: 5 + 5 + 0 = 10, requiring the +6 correction.
        a = 4'd5;
        b = 4'd5;
        cin = 1'b0;
        #1;
        if (bcd_sum !== 4'd0 || bcd_cout !== 1'b1 || seg !== 7'b1000000) begin
            $display("FAIL Test Case 2: 5 + 5 + 0");
            errors = errors + 1;
        end else
            $display("PASS Test Case 2: 5 + 5 + 0 = 10, seg = %b", seg);

        // Test Case 3: 9 + 9 + 1 = 19.
        a = 4'd9;
        b = 4'd9;
        cin = 1'b1;
        #1;
        if (bcd_sum !== 4'd9 || bcd_cout !== 1'b1 || seg !== 7'b0010000) begin
            $display("FAIL Test Case 3: 9 + 9 + 1");
            errors = errors + 1;
        end else
            $display("PASS Test Case 3: 9 + 9 + 1 = 19, seg = %b", seg);

        // Test Case 4: decoder protection for invalid BCD input 12.
        invalid_bcd = 4'd12;
        #1;
        if (invalid_seg !== 7'b1111111) begin
            $display("FAIL Test Case 4: invalid BCD 12 was not blanked");
            errors = errors + 1;
        end else
            $display("PASS Test Case 4: invalid BCD 12, seg = %b", invalid_seg);

        for (ai = 0; ai <= 9; ai = ai + 1)
            for (bi = 0; bi <= 9; bi = bi + 1)
                for (ci = 0; ci <= 1; ci = ci + 1) begin
                    a = ai;
                    b = bi;
                    cin = ci;
                    #1;

                    expected = ai + bi + ci;
                    if (bcd_sum !== (expected % 10) ||
                        bcd_cout !== (expected / 10)) begin
                        $display("FAIL: %0d + %0d + %0d", ai, bi, ci);
                        errors = errors + 1;
                    end
                end

        if (errors == 0)
            $display("PASS: 4 directed cases and 200 valid BCD input combinations.");
        else
            $fatal(1, "%0d test(s) failed.", errors);

        $finish;
    end
endmodule
