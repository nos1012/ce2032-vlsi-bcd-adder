module tb_top_bcd_adder;
    logic [3:0] a;
    logic [3:0] b;
    logic       cin;
    logic [3:0] bcd_sum;
    logic       bcd_cout;
    logic [6:0] seg;
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

    initial begin
        errors = 0;

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
            $display("PASS: 200 valid BCD input combinations.");
        else
            $fatal(1, "%0d test(s) failed.", errors);

        $finish;
    end
endmodule
