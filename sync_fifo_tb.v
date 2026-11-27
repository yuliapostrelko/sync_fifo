modulr sync_fifo_tb;
    reg clk;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [7:0] din;
    wire [7:0] dout;
    wire full;
    wire empty;

    sync_fifo uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        din = 8'h00;

        #20 rst_n = 1; // Release reset

        // Write data to FIFO
        repeat (16) begin
            @(posedge clk);
            wr_en = 1;
            din = din + 1; // Increment data
            @(posedge clk);
            wr_en = 0;
        end

        // Read data from FIFO
        repeat (16) begin
            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
        end

        $finish;
    end