`timescale 1ns/1ps

module tb();

reg clka, clkb, rstn, pulse_in;
wire pulse_out;

initial begin
    clka = 0;
    clkb = 0;
end

always #5 clka = ~clka;
always #15 clkb = ~clkb;

initial begin
    rstn = 0;
    pulse_in = 0;
    #34;
    rstn = 1;
    repeat(2)@(posedge clka);
    pulse_in = 1;
    @(posedge clka);
    pulse_in = 0;

end

fast2slow uut(
    .clka(clka),
    .clkb(clkb),
    .rstn(rstn),
    .pulse_in(pulse_in),
    .pulse_out(pulse_out)
);

endmodule