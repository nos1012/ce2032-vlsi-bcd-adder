module top_bcd_adder (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       cin,
    output logic [3:0] bcd_sum,
    output logic       bcd_cout,
    output logic [6:0] seg
);
    logic [3:0] raw_sum;
    logic       raw_cout;
    logic       correct_flag;
    logic [3:0] correction_value;
    logic       correction_cout;

    // First addition: generate the uncorrected binary sum.
    adder_4bit raw_adder (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (raw_sum),
        .cout (raw_cout)
    );

    // A BCD correction is required for sums greater than 9 or with carry.
    correction_logic correction_detector (
        .raw_sum      (raw_sum),
        .raw_cout     (raw_cout),
        .correct_flag (correct_flag)
    );

    // Add 6 only when the raw result is not a valid BCD digit.
    assign correction_value = correct_flag ? 4'd6 : 4'd0;

    // Second addition: produce the corrected BCD ones digit.
    adder_4bit correction_adder (
        .a    (raw_sum),
        .b    (correction_value),
        .cin  (1'b0),
        .sum  (bcd_sum),
        .cout (correction_cout)
    );

    // Either adder can generate the carry into the decimal tens digit.
    assign bcd_cout = raw_cout | correction_cout;

    decoder_7seg seven_segment_decoder (
        .bcd (bcd_sum),
        .seg (seg)
    );
endmodule
