`timescale 1ns / 1ps

module tb ();
    logic reset;
    logic clk;
    logic [15:0] data;
    logic ready;
    logic valid;
    logic [15:0] data_out;
    logic valid_out;

    logic pdm_clk;
    logic audio_clk;

    logic [15:0] sample_out;

    logic [11:0] rom_addr;
    logic [15:0] rom_out;

cic_compiler_0 cic_comp (
    .aclk(pdm_clk),
    .aresetn(~reset),
    .s_axis_data_tdata(data),
    .s_axis_data_tready(ready),
    .s_axis_data_tvalid(valid),
    .m_axis_data_tdata(data_out),
    .m_axis_data_tvalid(valid_out)
);

sine_rom sine_rom_0 (
    .clk(clk),
    .addr(rom_addr),
    .q(rom_out)
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
    rom_addr = 1;
    repeat (3) @(posedge clk);
    @(posedge clk) reset <= 0;

    while (rom_addr != 0) begin
        data <= rom_out;
        valid <= 1;
        wait(valid && ready);
        @ (posedge pdm_clk);
        valid <= 0;
        rom_addr <= rom_addr + 1;
    end
    $finish();
end

endmodule

