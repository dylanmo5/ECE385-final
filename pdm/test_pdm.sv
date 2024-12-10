module test_pdm (
    input logic Clk,
    input logic reset_rtl_0,

    output logic SPKL,
    output logic SPKR
);

    logic reset;
    logic clk;

    logic pdm_clk;
    logic audio_clk;

    logic [15:0] sample_out;
    logic pdm_out;


always_comb begin // I/O pin assignment
    clk = Clk;
    reset = reset_rtl_0;
    SPKL = pdm_out;
    SPKR = pdm_out;
end

pcm2pdm pcm2pdm_0 (
    .reset(reset),
    .clk(clk),
    .audio_clk(audio_clk),
    .pdm_clk(pdm_clk),
    .sample(sample_out),
    .pdm(pdm_out)
);

clock_gen clk_gen_0 (
    .reset(reset),
    .clk(clk),
    .pdm_clk(pdm_clk),
    .audio_clk(audio_clk)
);

nn_phaseosc nn_phaseosc_0(
    .clk(clk),
    .audio_clk(audio_clk),
    .reset(reset),
    .enable(~reset),
    .nn_offset(21),
    .sample(sample_out)
);

endmodule

