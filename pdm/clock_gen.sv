module clock_gen (
    input logic reset,
    input logic clk, // 100 MHz clock from on-board oscillator
    output logic pdm_clk, // 3.072 (exact) MHz clock (48 kHz * 64)
    output logic audio_clk // 48 kHz clock
);

logic pdm_clk4; // 12.288 MHz clock (3.072 Mhz * 4)
logic [7:0] counter;

clk_wiz_0 pdm_clk_gen (
    .reset(reset),
    .clk_in1(clk),
    .clk_out1(pdm_clk4)
);

always_ff @ (posedge pdm_clk4) begin
    if (reset) begin
        counter <= 0;
        pdm_clk <= 0;
        audio_clk <= 0;
    end
    else begin
        if (counter % 4 == 0) begin
            pdm_clk <= ~pdm_clk;
        end
        if (counter % 256 == 0) begin
            audio_clk <= ~audio_clk;
        end
        counter <= (counter + 1) % 256; // Not sure if we need mod
    end
end     

endmodule
