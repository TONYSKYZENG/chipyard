`timescale 1ns/1ps

module tb_rocket_axi;

    // ============================================================
    // Clock / Reset
    // ============================================================
    reg clk;
    reg rst_n;

    initial begin
        clk = 1;
        forever #5 clk = ~clk; // 100MHz
        clk = 0;
        forever #5 clk = ~clk; // 100MHz
    end

    initial begin
        rst_n = 0;
        #200;                  // RAM / system stable
        rst_n = 1;              // release CPU
    end

    // ============================================================
    // AXI wires (CPU side)
    // ============================================================
    wire        aw_valid;
    wire        aw_ready;
    wire [3:0]  aw_id;
    wire [31:0] aw_addr;
    wire [7:0]  aw_len;
    wire [2:0]  aw_size;
    wire [1:0]  aw_burst;

    wire        w_valid;
    wire        w_ready;
    wire [63:0] w_data;
    wire [7:0]  w_strb;
    wire        w_last;

    wire        b_valid;
    wire        b_ready;
    wire [3:0]  b_id;
    wire [1:0]  b_resp;

    wire        ar_valid;
    wire        ar_ready;
    wire [3:0]  ar_id;
    wire [31:0] ar_addr;
    wire [7:0]  ar_len;
    wire [2:0]  ar_size;
    wire [1:0]  ar_burst;

    wire        r_valid;
    wire        r_ready;
    wire [3:0]  r_id;
    wire [63:0] r_data;
    wire [1:0]  r_resp;
    wire        r_last;

    // ============================================================
    // Instantiate Rocket wrapper
    // ============================================================
    rocket_ip_top u_rocket (
        .aclk       (clk),
        .aresetn    (rst_n),

        // AXI
        .m_axi_mem_awready (aw_ready),
        .m_axi_mem_awvalid (aw_valid),
        .m_axi_mem_awid    (aw_id),
        .m_axi_mem_awaddr  (aw_addr),
        .m_axi_mem_awlen   (aw_len),
        .m_axi_mem_awsize  (aw_size),
        .m_axi_mem_awburst (aw_burst),
        .m_axi_mem_awlock  (),
        .m_axi_mem_awcache (),
        .m_axi_mem_awprot  (),
        .m_axi_mem_awqos   (),

        .m_axi_mem_wready  (w_ready),
        .m_axi_mem_wvalid  (w_valid),
        .m_axi_mem_wdata   (w_data),
        .m_axi_mem_wstrb   (w_strb),
        .m_axi_mem_wlast   (w_last),

        .m_axi_mem_bready  (b_ready),
        .m_axi_mem_bvalid  (b_valid),
        .m_axi_mem_bid     (b_id),
        .m_axi_mem_bresp   (b_resp),

        .m_axi_mem_arready (ar_ready),
        .m_axi_mem_arvalid (ar_valid),
        .m_axi_mem_arid    (ar_id),
        .m_axi_mem_araddr  (ar_addr),
        .m_axi_mem_arlen   (ar_len),
        .m_axi_mem_arsize  (ar_size),
        .m_axi_mem_arburst (ar_burst),
        .m_axi_mem_arlock  (),
        .m_axi_mem_arcache (),
        .m_axi_mem_arprot  (),
        .m_axi_mem_arqos   (),

        .m_axi_mem_rready  (r_ready),
        .m_axi_mem_rvalid  (r_valid),
        .m_axi_mem_rid     (r_id),
        .m_axi_mem_rdata   (r_data),
        .m_axi_mem_rresp   (r_resp),
        .m_axi_mem_rlast   (r_last),

        // UART loopback
        .uart_txd (),
        .uart_rxd (1'b1)
    );

    // ============================================================
    // AXI Address Translation
    // ============================================================
    localparam AXI_BASE = 32'h8000_0000;

    wire [31:0] ram_aw_addr = aw_addr - AXI_BASE;
    wire [31:0] ram_ar_addr = ar_addr - AXI_BASE;

    // ============================================================
    // Instantiate AXI RAM
    // ============================================================
    axi4_full_ram #(
        .MEM_BYTES (128*1024)
    ) u_ram (
        .clk      (clk),
        .rst_n    (rst_n),

        // AW
        .aw_valid (aw_valid),
        .aw_ready (aw_ready),
        .aw_id    (aw_id),
        .aw_addr  (ram_aw_addr),
        .aw_len   (aw_len),
        .aw_size  (aw_size),
        .aw_burst (aw_burst),

        // W
        .w_valid  (w_valid),
        .w_ready  (w_ready),
        .w_data   (w_data),
        .w_strb   (w_strb),
        .w_last   (w_last),

        // B
        .b_valid  (b_valid),
        .b_ready  (b_ready),
        .b_id     (b_id),
        .b_resp   (b_resp),

        // AR
        .ar_valid (ar_valid),
        .ar_ready (ar_ready),
        .ar_id    (ar_id),
        .ar_addr  (ram_ar_addr),
        .ar_len   (ar_len),
        .ar_size  (ar_size),
        .ar_burst (ar_burst),

        // R
        .r_valid  (r_valid),
        .r_ready  (r_ready),
        .r_id     (r_id),
        .r_data   (r_data),
        .r_resp   (r_resp),
        .r_last   (r_last)
    );

    // ============================================================
    // RAM initialization
    // ============================================================
    initial begin
        $display("[TB] Loading RAM from prog.hex");
        $readmemh("<path>/prog.hex", u_ram.mem);
    end

    // ============================================================
    // Timeout / monitor
    // ============================================================
    initial begin
        #5_00000_000;
        $fatal(1, "[TB] Timeout!");
    end

endmodule
