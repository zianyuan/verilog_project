`timescale 1ns/1ps
// 交换两个寄存器的值
module swap();
//方法1：XOR交换
    reg [7:0]  a1;
    reg [7:0]  b1;

    initial begin
        a1 = 8'h55;
        b1 = 8'haa;
        $display("Before swap: a1 = %b, b1 = %b", a1, b1);
        // 使用异或交换
        #10
        a1 = a1^b1;
        b1 = a1^b1;
        a1 = a1^b1;
        $display("After swap: a1 = %b, b1 = %b", a1, b1);
    end
//方法2：时钟中间变量
    reg [7:0] a2, b2;
    reg [7:0] temp;
    initial begin
        a2 = 8'h55;
        b2 = 8'haa;
        $display("Before swap: a2 = %b, b2 = %b", a2, b2);
        #10
        temp = a2;
        a2 = b2;
        b2 = temp;
        $display("After swap: a2 = %b, b2 = %b", a2, b2);
    end
// 方法3：加减法
    reg [7:0] a3, b3;
    initial begin
        a3 = 8'd10;
        b3 = 8'd20;
        $display("Before swap: a3 = %b, b3 = %b", a3, b3);
        #10
        a3 = a3 + b3;
        b3 = a3 - b3;
        a3 = a3 - b3;
        $display("After swap: a3 = %b, b3 = %b", a3, b3);
    end
endmodule