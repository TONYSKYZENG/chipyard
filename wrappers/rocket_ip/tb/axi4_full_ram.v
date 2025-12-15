module axi4_full_ram #(
    parameter MEM_BYTES = 128*1024,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 64,
    parameter ID_WIDTH   = 4
)(
    input  wire                    clk,
    input  wire                    rst_n,

    // ========================
    // AXI4 Write Address
    // ========================
    input  wire                    aw_valid,
    output reg                     aw_ready,
    input  wire [ID_WIDTH-1:0]     aw_id,
    input  wire [ADDR_WIDTH-1:0]   aw_addr,
    input  wire [7:0]              aw_len,
    input  wire [2:0]              aw_size,
    input  wire [1:0]              aw_burst,

    // ========================
    // AXI4 Write Data
    // ========================
    input  wire                    w_valid,
    output reg                     w_ready,
    input  wire [DATA_WIDTH-1:0]   w_data,
    input  wire [DATA_WIDTH/8-1:0] w_strb,
    input  wire                    w_last,

    // ========================
    // AXI4 Write Response
    // ========================
    output reg                     b_valid,
    input  wire                    b_ready,
    output reg [ID_WIDTH-1:0]      b_id,
    output reg [1:0]               b_resp,

    // ========================
    // AXI4 Read Address
    // ========================
    input  wire                    ar_valid,
    output reg                     ar_ready,
    input  wire [ID_WIDTH-1:0]     ar_id,
    input  wire [ADDR_WIDTH-1:0]   ar_addr,
    input  wire [7:0]              ar_len,
    input  wire [2:0]              ar_size,
    input  wire [1:0]              ar_burst,

    // ========================
    // AXI4 Read Data
    // ========================
    output reg                     r_valid,
    input  wire                    r_ready,
    output reg [ID_WIDTH-1:0]      r_id,
    output reg [DATA_WIDTH-1:0]    r_data,
    output reg [1:0]               r_resp,
    output reg                     r_last
);

    // ============================================================
    // Memory
    // ============================================================
    localparam WORDS = MEM_BYTES / (DATA_WIDTH/8);
    reg [DATA_WIDTH-1:0] mem [0:WORDS-1];

    // ============================================================
    // WRITE CHANNEL STATE
    // ============================================================
    reg                  wr_active;
    reg [ADDR_WIDTH-1:0] wr_addr;
    reg [7:0]            wr_len;
    reg [ID_WIDTH-1:0]   wr_id;

    // ------------------------
    // AW
    // ------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            aw_ready  <= 1'b1;
            wr_active <= 1'b0;
        end else begin
            if (aw_ready && aw_valid) begin
                wr_active <= 1'b1;
                aw_ready  <= 1'b0;
                wr_addr   <= aw_addr;
                wr_len    <= aw_len;
                wr_id     <= aw_id;
            end else if (b_valid && b_ready) begin
                aw_ready  <= 1'b1;
                wr_active <= 1'b0;
            end
        end
    end

    // ------------------------
    // W
    // ------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            w_ready <= 1'b0;
        end else begin
            w_ready <= wr_active;
            if (wr_active && w_valid && w_ready) begin
                mem[wr_addr[ADDR_WIDTH-1:3]] <= w_data;
                wr_addr <= wr_addr + (1 << aw_size);
                if (wr_len != 0)
                    wr_len <= wr_len - 1;
            end
        end
    end

    // ------------------------
    // B
    // ------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            b_valid <= 1'b0;
        end else begin
            if (wr_active && w_valid && w_ready && w_last) begin
                b_valid <= 1'b1;
                b_id    <= wr_id;
                b_resp  <= 2'b00;
            end else if (b_valid && b_ready) begin
                b_valid <= 1'b0;
            end
        end
    end

    // ============================================================
    // READ CHANNEL STATE
    // ============================================================
    reg                  rd_active;
    reg [ADDR_WIDTH-1:0] rd_addr;
    reg [7:0]            rd_len;
    reg [ID_WIDTH-1:0]   rd_id;

    // ------------------------
    // AR
    // ------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ar_ready  <= 1'b1;
            rd_active <= 1'b0;
        end else begin
            if (ar_ready && ar_valid) begin
                ar_ready  <= 1'b0;
                rd_active <= 1'b1;
                rd_addr   <= ar_addr;
                rd_len    <= ar_len;
                rd_id     <= ar_id;
            end else if (r_valid && r_ready && r_last) begin
                ar_ready  <= 1'b1;
                rd_active <= 1'b0;
            end
        end
    end

    // ------------------------
    // R
    // ------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_valid <= 1'b0;
            r_last  <= 1'b0;
        end else begin
            if (rd_active && (!r_valid || r_ready)) begin
                r_valid <= 1'b1;
                r_data  <= mem[rd_addr[ADDR_WIDTH-1:3]];
                r_id    <= rd_id;
                r_resp  <= 2'b00;
                r_last  <= (rd_len == 0);

                rd_addr <= rd_addr + (1 << ar_size);
                if (rd_len != 0)
                    rd_len <= rd_len - 1;
            end

            if (r_valid && r_ready && r_last) begin
                r_valid <= 1'b0;
            end
        end
    end

endmodule
