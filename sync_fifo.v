module sync_fifo (
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire rd_en,
    input wire [7:0] din,
    output reg [7:0] dout,
    output reg full,
    output reg empty
);
    parameter DEPTH = 16;
    reg [7:0] fifo_mem [0:DEPTH-1];
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;
    reg [4:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (wr_en && !full) begin
                fifo_mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            if (rd_en && !empty) begin
                dout <= fifo_mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end

            full <= (count == DEPTH);
            empty <= (count == 0);
        end
    end