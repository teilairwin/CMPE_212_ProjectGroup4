//------------------------------------
//DUT
//------------------------------------
module axi_lite_1x1 (
  input  wire        aclk,
  input  wire        arst_n,
  input  wire [63:0] m2s_aw_addr,
  input  wire        m2s_aw_valid,
  input  wire [ 3:0] m2s_aw_id,
  input  wire [ 2:0] m2s_aw_prot,
  output wire        m2s_aw_ready,
  input  wire [63:0] m2s_wdata,
  input  wire        m2s_wvalid,
  input  wire [ 8:0] m2s_wstrb,
  output wire        m2s_wready,
  input  wire [63:0] m2s_ar_addr,
  input  wire        m2s_ar_valid,
  input  wire [ 3:0] m2s_ar_id,
  input  wire [ 2:0] m2s_ar_prot,
  output wire        m2s_ar_ready,
  output wire [63:0] m2s_rdata,
  output wire        m2s_rvalid,
  output wire [ 3:0] m2s_rid,
  output wire [ 1:0] m2s_rrsesp,
  input  wire        m2s_rready,
  output wire        m2s_bvalid,
  output wire [ 3:0] m2s_bid,
  output wire [ 1:0] m2s_bresp,
  input  wire        m2s_bready,
  output wire [63:0] s2m_aw_addr,
  output wire        s2m_aw_valid,
  output wire [ 3:0] s2m_aw_id,
  output wire [ 2:0] s2m_aw_prot,
  input  wire        s2m_aw_ready,
  output wire [63:0] s2m_wdata,
  output wire        s2m_wvalid,
  output wire [ 8:0] s2m_wstrb,
  input  wire        s2m_wready,
  output wire [63:0] s2m_ar_addr,
  output wire        s2m_ar_valid,
  output wire [ 3:0] s2m_ar_id,
  output wire [ 2:0] s2m_ar_prot,
  input  wire        s2m_ar_ready,
  input  wire [63:0] s2m_rdata,
  input  wire        s2m_rvalid,
  input  wire [ 3:0] s2m_rid,
  input  wire [ 1:0] s2m_rrsesp,
  output wire        s2m_rready,
  input  wire        s2m_bvalid,
  input  wire [ 3:0] s2m_bid,
  input  wire [ 1:0] s2m_bresp,
  output wire        s2m_bready
);

wire [63:0] s2m_aw_addr;
wire        s2m_aw_valid;
wire [ 3:0] s2m_aw_id;
wire [ 2:0] s2m_aw_prot;
wire        s2m_aw_ready;
wire [63:0] s2m_wdata;
wire        s2m_wvalid;
wire [ 8:0] s2m_wstrb;
wire        s2m_wready;
wire [63:0] s2m_ar_addr;
wire        s2m_ar_valid;
wire [ 3:0] s2m_ar_id;
wire [ 2:0] s2m_ar_prot;
wire        s2m_ar_ready;
wire [63:0] s2m_rdata;
wire        s2m_rvalid;
wire [ 3:0] s2m_rid;
wire [ 1:0] s2m_rresp;
wire        s2m_rready;
wire        s2m_bvalid;
wire [ 3:0] s2m_bid;
wire [ 1:0] s2m_bresp;
wire        s2m_bready;


  assign aw_addr      = m2s_aw_addr;
  assign aw_valid     = m2s_aw_valid;
  assign aw_id        = m2s_aw_id;
  assign aw_prot      = m2s_aw_prot;
  assign wdata        = m2s_wdata;
  assign wvalid       = m2s_wvalid;
  assign wstrb        = m2s_wstrb;
  assign ar_addr      = m2s_ar_addr;
  assign ar_valid     = m2s_ar_valid;
  assign ar_id        = m2s_ar_id;
  assign ar_prot      = m2s_ar_prot;
  assign rready       = m2s_rready;
  assign bready      = m2s_bready;
  assign wready       = s2m_wready;
  assign aw_ready     = s2m_aw_ready;
  assign ar_ready     = s2m_ar_ready;
  assign rdata        = s2m_rdata;
  assign rvalid       = s2m_rvalid;
  assign rid          = s2m_rid;
  assign rresp        = s2m_rresp;
  assign bvalid       = s2m_bvalid;
  assign bid          = s2m_bid; 
  assign bresp        = s2m_bresp;
  assign m2s_wready   = wready;
  assign m2s_aw_ready = aw_ready;
  assign m2s_ar_ready = ar_ready;
  assign m2s_rdata    = rdata;
  assign m2s_rvalid   = rvalid;
  assign m2s_rid      = rid;
  assign m2s_rrsesp   = rresp;
  assign m2s_bvalid   = bvalid;
  assign m2s_bid      = bid;
  assign m2s_bresp    = bresp;
  assign s2m_aw_addr  = aw_addr;
  assign s2m_aw_valid = aw_valid;
  assign s2m_aw_id    = aw_id;
  assign s2m_aw_prot  = aw_prot;
  assign s2m_wdata    = wdata;
  assign s2m_wvalid   = wvalid;
  assign s2m_wstrb    = wstrb;
  assign s2m_ar_addr  = ar_addr;
  assign s2m_ar_valid = ar_valid;
  assign s2m_ar_id    = ar_id;
  assign s2m_ar_prot  = ar_prot;
  assign s2m_rready   = rready;
  assign s2m_brready  = bready;

endmodule