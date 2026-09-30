# ce2032-vlsi-bcd-adder
RTL design and physical implementation of a 4-bit BCD Adder with 7-Segment Decoder

## Block diagram

```mermaid
graph LR
    A("Input A [3:0]") --> ADDER1
    B("Input B [3:0]") --> ADDER1
    CIN("Carry In") --> ADDER1

    ADDER1["Block 1: Raw Adder<br/>(adder_4bit)"]
    CORRECT_LOGIC{"Block 2: Correction Logic<br/>(raw_sum > 9 or raw_cout = 1)"}
    ADDER2["Block 3: Correction Adder<br/>(adder_4bit)"]
    DECODER["Block 4: 7-Segment Decoder<br/>(decoder_7seg)"]

    ADDER1 -- "raw_sum[3:0]" --> CORRECT_LOGIC
    ADDER1 -- "raw_cout" --> CORRECT_LOGIC
    ADDER1 -- "raw_sum[3:0]" --> ADDER2
    CORRECT_LOGIC -- "correct_flag (add 6 or 0)" --> ADDER2
    ADDER2 -- "bcd_sum[3:0]" --> DECODER
    ADDER1 -- "raw_cout" --> CARRY_OR["Decimal Carry Logic"]
    ADDER2 -- "correction_cout" --> CARRY_OR
    CARRY_OR -- "bcd_cout" --> BCD_COUT("Decimal Carry Out")
    DECODER -- "seg[6:0]" --> LED("7-segment display")
```

`correct_flag` selects the correction operand for the second adder: `4'd6` when
the raw binary sum is not a valid BCD digit, otherwise `4'd0`. `bcd_cout` is
`raw_cout | correction_cout`, the carry into the decimal tens digit.
