module pcm2pdm (
    input logic reset,
    input logic clk,
    input logic audio_clk,
    input logic pdm_clk,
    input logic [15:0] sample, // PCM sample, 16-bit

    output logic pdm // to audio port
);

logic [15:0] upsampled;
logic upsampled_valid;

cic_compiler_0 cic_comp (
    .aclk(pdm_clk),
    .aresetn(~reset),
    .s_axis_data_tdata(sample),
    .s_axis_data_tready(),
    .s_axis_data_tvalid(1),
    .m_axis_data_tdata(upsampled),
    .m_axis_data_tvalid(upsampled_valid)
);

dsmod2 dsmod_0 (
    .reset(reset),
    // .clk(clk),
    .pdm_clk(pdm_clk),
    .sample_in(upsampled),
    .out(pdm)
);

endmodule
