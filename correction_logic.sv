module correction_logic (
    input  logic [3:0] raw_sum,
    input  logic       raw_cout,
    output logic       correct_flag
);
    // Bật cờ hiệu chỉnh nếu có cờ nhớ HOẶC tổng thô lớn hơn 9
    assign correct_flag = raw_cout | (raw_sum > 4'd9);
    
endmodule