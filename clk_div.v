// 奇数分频
module odd_divide #(
    parameter N = 7
)(
    input       rst_n       ,
    input       clk         ,
    output      clk_div
);

reg     clk_p = 0;
reg     clk_n = 0;

localparam WIDTH = clog2(N) + 1;
reg [WIDTH:0]   cnt_p, cnt_n;

always @(posedge clk) begin
    if(!rst_n)
        cnt_p <= 'd0;
    else if(cnt_p==N-1)
        cnt_p <= 'd0;
    else
        cnt_p <= cnt_p + 1'b1;
end

always @(posedge clk) begin
    if(!rst_n)
        clk_p <= 1'b0;
    else if(cnt_p==(N-1)>>1 || cnt_p==N-1)
        clk_p <= ~clk_p;
    else
        clk_p <= clk_p;
end

always @(negedge clk) begin
    if(!rst_n)
        cnt_n <= 'd0;
    else if(cnt_n==N-1)
        cnt_n <= 'd0;
    else
        cnt_n <= cnt_n + 1'b1;
end

always @(negedge clk) begin
    if(!rst_n)
        clk_n <= 1'b0;
    else if(cnt_n==(N-1)>>1 || cnt_n==N-1)
        clk_n <= ~clk_n;
    else
        clk_n <= clk_n;
end

assign clk_div = clk_p|clk_n;

endmodule