// Delta-sigma modulator
// Takes upsampled samples as input (high frequency)
// Outputs high frequency single bit output, should go directly to output jack on Urbana board
module dsmod (
    input logic reset,
    input logic clk,
    input logic pdm_clk, // should be 48k * 64 = 3.072 MHz
    input logic [15:0] sample_in,

    output logic out
);

logic [15:0] first;
logic [15:0] out_large;
logic [15:0] second;
logic [15:0] integrate_reg;
logic quantized;
logic [15:0] sample_in_unsigned;

logic pdm_clk_posedge;

posedge_detect pdm_clk_ped (
    .signal(pdm_clk),
    .clk(clk),
    .out(pdm_clk_posedge)
);

always_comb begin
    sample_in_unsigned = sample_in + 32768;
    // out_large = {~quantized, {(15){quantized}}}; // sets to 2's comp. min or max for quantized = 0 or 1, respectively
    out_large = {(16){quantized}};
    first = sample_in_unsigned - out_large;
    second = first + integrate_reg;
    out = quantized;
end

always_ff @ (posedge clk) begin
    if (reset) begin
        integrate_reg <= 0;
        quantized <= 0;
    end
    else begin
        if (pdm_clk_posedge) begin
            integrate_reg <= second;
            quantized <= second[15];
        end
    end
end

endmodule

// Since the original did not work, created this version
// Adapted from https://www.koheron.com/blog/2016/09/27/pulse-density-modulation/
module dsmod2 #(
    parameter BIT_DEPTH = 16
)
(
    input logic pdm_clk,
    input logic reset,
    input logic [BIT_DEPTH - 1 : 0] sample_in, // Signed (2's complement) PCM sample

    output logic out // 1-bit PDM output
);
    localparam MAX = 2 ** BIT_DEPTH - 1;

    // Combinational logic outputs
    logic [BIT_DEPTH - 1 : 0] sample_unsigned;
    logic [BIT_DEPTH - 1 : 0] error_0;
    logic [BIT_DEPTH - 1 : 0] error_1;

    // Register
    logic [BIT_DEPTH - 1 : 0] error = 0;

    always_comb begin
        sample_unsigned = sample_in + (2 ** 15); // Convert to unsigned numbers
        error_1 = error + MAX - sample_unsigned;
        error_0 = error - sample_unsigned;
    end

    always_ff @ (posedge pdm_clk) begin
        if (reset == 1'b1) begin
            out <= 0;
            error <= 0;
        end
        else if (sample_unsigned >= error) begin
            out <= 1;
            error <= error_1;
        end
        else begin
            out <= 0;
            error <= error_0;
        end
    end

endmodule
