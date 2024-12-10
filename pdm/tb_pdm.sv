`timescale 1ns / 1ps

module tb_pdm ();
    logic reset;
    logic clk;

    logic pdm_clk;
    logic audio_clk;

    logic [15:0] sample_out;
    logic pdm_out;


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

initial begin: CLOCK_INITIALIZATION
    clk = 1;
end 
  
always begin : CLOCK_GENERATION
    #1 clk = ~clk;
end

initial begin: TEST
    reset = 1;
    repeat (3) @(posedge clk);
    @(posedge clk) reset <= 0;

    // $finish();
end

endmodule

