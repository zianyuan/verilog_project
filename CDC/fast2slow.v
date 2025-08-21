// 单bit 快到慢
// 方法1 展宽 + 打拍同步
// 方法2 握手协议

// 握手代码：
module fast2slow(
    input   clka,
    input   clkb,
    input   rstn,
    input   pulse_in,
    output  pulse_out
);

reg req, req_b_d, req_b_d1, req_b_d2;
reg ack_a, ack_a_d;

always @(posedge clka, negedge rstn) begin
    if(!rstn)
        req <= 1'b0;
    else if(pulse_in)
        req <= 1'b1;
    else if(ack_a_d)
        req <= 1'b0;
    else
        req <= req;
end

always @(posedge clkb, negedge rstn) begin
    if(!rstn) begin
        req_b_d <= 1'b0;
        req_b_d1 <= 1'b0;
        req_b_d2 <= 1'b0;
    end else begin
        req_b_d <= req;
        req_b_d1 <= req_b_d;
        req_b_d2 <= req_b_d1;
    end
end

always @(posedge clka, negedge rstn) begin
    if(!rstn)
        {ack_a_d, ack_a} <= 2'b00;
    else
        {ack_a_d, ack_a} <= {ack_a, req_b_d1};
end

assign pulse_out = req_b_d1 & !req_b_d2;

endmodule
