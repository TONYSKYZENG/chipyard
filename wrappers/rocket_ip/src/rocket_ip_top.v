module rocket_ip_top (
    // ============================================================
    // Clock / Reset (Vivado style)
    // ============================================================
    input  wire        aclk,
    input  wire        aresetn,

    // ============================================================
    // AXI4 Memory Master (DRAM @ 0x8000_0000)
    // ============================================================
    // AW
    input  wire        m_axi_mem_awready,
    output wire        m_axi_mem_awvalid,
    output wire [3:0]  m_axi_mem_awid,
    output wire [31:0] m_axi_mem_awaddr,
    output wire [7:0]  m_axi_mem_awlen,
    output wire [2:0]  m_axi_mem_awsize,
    output wire [1:0]  m_axi_mem_awburst,
    output wire        m_axi_mem_awlock,
    output wire [3:0]  m_axi_mem_awcache,
    output wire [2:0]  m_axi_mem_awprot,
    output wire [3:0]  m_axi_mem_awqos,

    // W
    input  wire        m_axi_mem_wready,
    output wire        m_axi_mem_wvalid,
    output wire [63:0] m_axi_mem_wdata,
    output wire [7:0]  m_axi_mem_wstrb,
    output wire        m_axi_mem_wlast,

    // B
    output wire        m_axi_mem_bready,
    input  wire        m_axi_mem_bvalid,
    input  wire [3:0]  m_axi_mem_bid,
    input  wire [1:0]  m_axi_mem_bresp,

    // AR
    input  wire        m_axi_mem_arready,
    output wire        m_axi_mem_arvalid,
    output wire [3:0]  m_axi_mem_arid,
    output wire [31:0] m_axi_mem_araddr,
    output wire [7:0]  m_axi_mem_arlen,
    output wire [2:0]  m_axi_mem_arsize,
    output wire [1:0]  m_axi_mem_arburst,
    output wire        m_axi_mem_arlock,
    output wire [3:0]  m_axi_mem_arcache,
    output wire [2:0]  m_axi_mem_arprot,
    output wire [3:0]  m_axi_mem_arqos,

    // R
    output wire        m_axi_mem_rready,
    input  wire        m_axi_mem_rvalid,
    input  wire [3:0]  m_axi_mem_rid,
    input  wire [63:0] m_axi_mem_rdata,
    input  wire [1:0]  m_axi_mem_rresp,
    input  wire        m_axi_mem_rlast,

    // ============================================================
    // AXI4 MMIO Master (0x6000_0000)
    // ============================================================
    // AW
    input  wire        m_axi_mmio_awready,
    output wire        m_axi_mmio_awvalid,
    output wire [3:0]  m_axi_mmio_awid,
    output wire [37:0] m_axi_mmio_awaddr,
    output wire [7:0]  m_axi_mmio_awlen,
    output wire [2:0]  m_axi_mmio_awsize,
    output wire [1:0]  m_axi_mmio_awburst,
    output wire        m_axi_mmio_awlock,
    output wire [3:0]  m_axi_mmio_awcache,
    output wire [2:0]  m_axi_mmio_awprot,
    output wire [3:0]  m_axi_mmio_awqos,

    // W
    input  wire        m_axi_mmio_wready,
    output wire        m_axi_mmio_wvalid,
    output wire [63:0] m_axi_mmio_wdata,
    output wire [7:0]  m_axi_mmio_wstrb,
    output wire        m_axi_mmio_wlast,

    // B
    output wire        m_axi_mmio_bready,
    input  wire        m_axi_mmio_bvalid,
    input  wire [3:0]  m_axi_mmio_bid,
    input  wire [1:0]  m_axi_mmio_bresp,

    // AR
    input  wire        m_axi_mmio_arready,
    output wire        m_axi_mmio_arvalid,
    output wire [3:0]  m_axi_mmio_arid,
    output wire [37:0] m_axi_mmio_araddr,
    output wire [7:0]  m_axi_mmio_arlen,
    output wire [2:0]  m_axi_mmio_arsize,
    output wire [1:0]  m_axi_mmio_arburst,
    output wire        m_axi_mmio_arlock,
    output wire [3:0]  m_axi_mmio_arcache,
    output wire [2:0]  m_axi_mmio_arprot,
    output wire [3:0]  m_axi_mmio_arqos,

    // R
    output wire        m_axi_mmio_rready,
    input  wire        m_axi_mmio_rvalid,
    input  wire [3:0]  m_axi_mmio_rid,
    input  wire [63:0] m_axi_mmio_rdata,
    input  wire [1:0]  m_axi_mmio_rresp,
    input  wire        m_axi_mmio_rlast,

    // ============================================================
    // UART
    // ============================================================
    output wire        uart_txd,
    input  wire        uart_rxd
);

    // ------------------------------------------------------------
    // Reset conversion
    // ------------------------------------------------------------
    wire reset = ~aresetn;

    // ------------------------------------------------------------
    // DigitalTop instance
    // ------------------------------------------------------------
    DigitalTop u_digitaltop (
        .auto_chipyard_prcictrl_domain_reset_setter_clock_in_member_allClocks_uncore_clock(aclk),
        .auto_chipyard_prcictrl_domain_reset_setter_clock_in_member_allClocks_uncore_reset(reset),

        .auto_mbus_fixedClockNode_anon_out_clock(),
        .auto_cbus_fixedClockNode_anon_out_clock(),
        .auto_cbus_fixedClockNode_anon_out_reset(),
        .auto_sbus_fixedClockNode_anon_out_clock(),

        // Debug (tied off)
        .resetctrl_hartIsInReset_0(1'b0),
        .debug_clock(aclk),
        .debug_reset(reset),
        .debug_clockeddmi_dmi_req_ready(),
        .debug_clockeddmi_dmi_req_valid(1'b0),
        .debug_clockeddmi_dmi_req_bits_addr(7'b0),
        .debug_clockeddmi_dmi_req_bits_data(32'b0),
        .debug_clockeddmi_dmi_req_bits_op(2'b0),
        .debug_clockeddmi_dmi_resp_ready(1'b1),
        .debug_clockeddmi_dmi_resp_valid(),
        .debug_clockeddmi_dmi_resp_bits_data(),
        .debug_clockeddmi_dmi_resp_bits_resp(),
        .debug_clockeddmi_dmiClock(aclk),
        .debug_clockeddmi_dmiReset(reset),
        .debug_dmactive(),
        .debug_dmactiveAck(1'b1),

        // Memory AXI
        .mem_axi4_0_aw_ready(m_axi_mem_awready),
        .mem_axi4_0_aw_valid(m_axi_mem_awvalid),
        .mem_axi4_0_aw_bits_id(m_axi_mem_awid),
        .mem_axi4_0_aw_bits_addr(m_axi_mem_awaddr),
        .mem_axi4_0_aw_bits_len(m_axi_mem_awlen),
        .mem_axi4_0_aw_bits_size(m_axi_mem_awsize),
        .mem_axi4_0_aw_bits_burst(m_axi_mem_awburst),
        .mem_axi4_0_aw_bits_lock(m_axi_mem_awlock),
        .mem_axi4_0_aw_bits_cache(m_axi_mem_awcache),
        .mem_axi4_0_aw_bits_prot(m_axi_mem_awprot),
        .mem_axi4_0_aw_bits_qos(m_axi_mem_awqos),

        .mem_axi4_0_w_ready(m_axi_mem_wready),
        .mem_axi4_0_w_valid(m_axi_mem_wvalid),
        .mem_axi4_0_w_bits_data(m_axi_mem_wdata),
        .mem_axi4_0_w_bits_strb(m_axi_mem_wstrb),
        .mem_axi4_0_w_bits_last(m_axi_mem_wlast),

        .mem_axi4_0_b_ready(m_axi_mem_bready),
        .mem_axi4_0_b_valid(m_axi_mem_bvalid),
        .mem_axi4_0_b_bits_id(m_axi_mem_bid),
        .mem_axi4_0_b_bits_resp(m_axi_mem_bresp),

        .mem_axi4_0_ar_ready(m_axi_mem_arready),
        .mem_axi4_0_ar_valid(m_axi_mem_arvalid),
        .mem_axi4_0_ar_bits_id(m_axi_mem_arid),
        .mem_axi4_0_ar_bits_addr(m_axi_mem_araddr),
        .mem_axi4_0_ar_bits_len(m_axi_mem_arlen),
        .mem_axi4_0_ar_bits_size(m_axi_mem_arsize),
        .mem_axi4_0_ar_bits_burst(m_axi_mem_arburst),
        .mem_axi4_0_ar_bits_lock(m_axi_mem_arlock),
        .mem_axi4_0_ar_bits_cache(m_axi_mem_arcache),
        .mem_axi4_0_ar_bits_prot(m_axi_mem_arprot),
        .mem_axi4_0_ar_bits_qos(m_axi_mem_arqos),

        .mem_axi4_0_r_ready(m_axi_mem_rready),
        .mem_axi4_0_r_valid(m_axi_mem_rvalid),
        .mem_axi4_0_r_bits_id(m_axi_mem_rid),
        .mem_axi4_0_r_bits_data(m_axi_mem_rdata),
        .mem_axi4_0_r_bits_resp(m_axi_mem_rresp),
        .mem_axi4_0_r_bits_last(m_axi_mem_rlast),

        // MMIO AXI
        .mmio_axi4_0_aw_ready(m_axi_mmio_awready),
        .mmio_axi4_0_aw_valid(m_axi_mmio_awvalid),
        .mmio_axi4_0_aw_bits_id(m_axi_mmio_awid),
        .mmio_axi4_0_aw_bits_addr(m_axi_mmio_awaddr),
        .mmio_axi4_0_aw_bits_len(m_axi_mmio_awlen),
        .mmio_axi4_0_aw_bits_size(m_axi_mmio_awsize),
        .mmio_axi4_0_aw_bits_burst(m_axi_mmio_awburst),
        .mmio_axi4_0_aw_bits_lock(m_axi_mmio_awlock),
        .mmio_axi4_0_aw_bits_cache(m_axi_mmio_awcache),
        .mmio_axi4_0_aw_bits_prot(m_axi_mmio_awprot),
        .mmio_axi4_0_aw_bits_qos(m_axi_mmio_awqos),

        .mmio_axi4_0_w_ready(m_axi_mmio_wready),
        .mmio_axi4_0_w_valid(m_axi_mmio_wvalid),
        .mmio_axi4_0_w_bits_data(m_axi_mmio_wdata),
        .mmio_axi4_0_w_bits_strb(m_axi_mmio_wstrb),
        .mmio_axi4_0_w_bits_last(m_axi_mmio_wlast),

        .mmio_axi4_0_b_ready(m_axi_mmio_bready),
        .mmio_axi4_0_b_valid(m_axi_mmio_bvalid),
        .mmio_axi4_0_b_bits_id(m_axi_mmio_bid),
        .mmio_axi4_0_b_bits_resp(m_axi_mmio_bresp),

        .mmio_axi4_0_ar_ready(m_axi_mmio_arready),
        .mmio_axi4_0_ar_valid(m_axi_mmio_arvalid),
        .mmio_axi4_0_ar_bits_id(m_axi_mmio_arid),
        .mmio_axi4_0_ar_bits_addr(m_axi_mmio_araddr),
        .mmio_axi4_0_ar_bits_len(m_axi_mmio_arlen),
        .mmio_axi4_0_ar_bits_size(m_axi_mmio_arsize),
        .mmio_axi4_0_ar_bits_burst(m_axi_mmio_arburst),
        .mmio_axi4_0_ar_bits_lock(m_axi_mmio_arlock),
        .mmio_axi4_0_ar_bits_cache(m_axi_mmio_arcache),
        .mmio_axi4_0_ar_bits_prot(m_axi_mmio_arprot),
        .mmio_axi4_0_ar_bits_qos(m_axi_mmio_arqos),

        .mmio_axi4_0_r_ready(m_axi_mmio_rready),
        .mmio_axi4_0_r_valid(m_axi_mmio_rvalid),
        .mmio_axi4_0_r_bits_id(m_axi_mmio_rid),
        .mmio_axi4_0_r_bits_data(m_axi_mmio_rdata),
        .mmio_axi4_0_r_bits_resp(m_axi_mmio_rresp),
        .mmio_axi4_0_r_bits_last(m_axi_mmio_rlast),

        // Boot / UART
        .custom_boot(1'b1),
        .uart_0_txd(uart_txd),
        .uart_0_rxd(uart_rxd),

        .clock_tap()
    );

endmodule
