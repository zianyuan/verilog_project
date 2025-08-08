module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DATA_DEPTH = 8,
    parameter PTR_WIDTH  = 3
)(
    input  [DATA_WIDTH - 1 : 0]     wr_data, 	//写数据
    input                   	    wr_clk,	 	//写时钟
    input                   	    wr_rst_n,	//写时钟复位
    input                   	    wr_en,		//写使能
    input                   	    rd_clk,		//读数据
    input                   	    rd_rst_n,	//读时钟复位
    input                   	    rd_en,		//读使能
    output reg                 	    fifo_full,	//“满”标志位
    output reg                 	    fifo_empty,	//“空”标志位
    output reg [DATA_WIDTH - 1 : 0] rd_data //写时钟
);

// ==== 伪双口RAM ====
reg [DATA_WIDTH-1:0] ram_fifo [DATA_DEPTH-1:0];
// 信息位+地址位
reg [PTR_WIDTH:0] wr_ptr, rd_ptr;
wire [PTR_WIDTH:0]  wr_ptr_gray, rd_ptr_gray;

wire [PTR_WIDTH-1:0] wr_addr, rd_addr;

// 写指针计数
always @(posedge wr_clk, negedge wr_rst_n) begin
    if(!wr_rst_n)
        wr_ptr <= 'd0;
    else if(wr_en==1'b1 && fifo_full==1'b0)
        wr_ptr <= wr_ptr + 1'b1;
    else
        wr_ptr <= wr_ptr;
end

assign wr_addr = wr_ptr[PTR_WIDTH-1:0];
always @(posedge wr_clk, negedge wr_rst_n) begin
    if(!wr_rst_n)
        ram_fifo[wr_addr] <= 0;
    else if(wr_en==1'b1 && fifo_full==1'b0)
        ram_fifo[wr_addr] <= wr_data;
    else
        ram_fifo[wr_addr] <= ram_fifo[wr_addr];
end

// 读指针计数
always @(posedge rd_clk, negedge rd_rst_n) begin
    if(!rd_rst_n)
        rd_ptr <= 'd0;
    else if(rd_en==1'b1 && fifo_empty==1'b0)
        rd_ptr <= rd_ptr + 1'b1;
    else
        rd_ptr <= rd_ptr;
end

assign rd_addr = rd_ptr[PTR_WIDTH-1:0];
always @(posedge rd_clk, negedge rd_rst_n) begin
    if(!rd_rst_n)
        ram_fifo[rd_addr] <= 0;
    else if(rd_en==1'b1 && fifo_empty==1'b0)
        ram_fifo[rd_addr] <= rd_data;
    else
        ram_fifo[rd_addr] <= ram_fifo[rd_addr];
end

// 读写指针格雷码转换
assign wr_ptr_gray = wr_ptr^(wr_ptr>>1'b1);
assign rd_ptr_gray = rd_ptr^(rd_ptr>>1'b1);

// 写指针同步到读时钟域
reg [PTR_WIDTH:0]   wr_ptr_gray_r1, wr_ptr_gray_r2;
always @(posedge rd_clk, negedge rd_rst_n) begin
    if(!rd_rst_n)begin
        wr_ptr_gray_r1 <= 'd0;
        wr_ptr_gray_r2 <= 'd0;
    end else begin
        wr_ptr_gray_r1 <= wr_ptr_gray;
        wr_ptr_gray_r2 <= wr_ptr_gray_r1;
    end
end

// 读指针同步到写时钟域
reg [PTR_WIDTH:0]   rd_ptr_gray_r1, rd_ptr_gray_r2;
always @(posedge wr_clk, negedge wr_rst_n) begin
    if(!wr_rst_n)begin
        rd_ptr_gray_r1 <= 'd0;
        rd_ptr_gray_r2 <= 'd0;
    end else begin
        rd_ptr_gray_r1 <= rd_ptr_gray;
        rd_ptr_gray_r2 <= rd_ptr_gray_r1;
    end
end

// 空信号判断
always @(*) begin
    if(!rd_rst_n)
        fifo_empty = 1'b0;
    else if(rd_ptr_gray == wr_ptr_gray_r2)
        fifo_empty = 1'b1;
    else
        fifo_empty = 1'b0;
end

// 满信号判断
always @(*) begin
    if(!wr_rst_n)
        fifo_full <= 1'b0;
    else if(wr_ptr_gray == {~rd_ptr_gray_r2[PTR_WIDTH:PTR_WIDTH-1],
                            rd_ptr_gray_r2[PTR_WIDTH-2:0]})
        fifo_full <= 1'b1;
    else
        fifo_full <= 1'b0;
end

endmodule