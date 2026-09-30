module decoder_7seg (
    input  logic [3:0] bcd,
    output logic [6:0] seg // Thứ tự: a, b, c, d, e, f, g
);
    always_comb begin
        case (bcd)
            4'b0000: seg = 7'b1000000; // Số 0
            4'b0001: seg = 7'b1111001; // Số 1
            4'b0010: seg = 7'b0100100; // Số 2
            4'b0011: seg = 7'b0110000; // Số 3
            4'b0100: seg = 7'b0011001; // Số 4
            4'b0101: seg = 7'b0010010; // Số 5
            4'b0110: seg = 7'b0000010; // Số 6
            4'b0111: seg = 7'b1111000; // Số 7
            4'b1000: seg = 7'b0000000; // Số 8
            4'b1001: seg = 7'b0010000; // Số 9
            default: seg = 7'b1111111; // Tắt toàn bộ nếu dữ liệu lỗi
        endcase
    end
endmodule