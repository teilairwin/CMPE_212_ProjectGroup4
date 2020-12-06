//------------------------------------
//DUT
//------------------------------------
module axi_lite_1x1 (
  input  logic        aclk,
  input  logic        arst_n,
  input  logic [63:0] m2s_aw_addr,
  input  logic        m2s_aw_valid,
  input  logic [ 3:0] m2s_aw_id,
  input  logic [ 2:0] m2s_aw_prot,
  output logic        m2s_aw_ready,
  input  logic [63:0] m2s_wdata,
  input  logic        m2s_wvalid,
  input  logic [ 8:0] m2s_wstrb,
  output logic        m2s_wready,
  input  logic [63:0] m2s_ar_addr,
  input  logic        m2s_ar_valid,
  input  logic [ 3:0] m2s_ar_id,
  input  logic [ 2:0] m2s_ar_prot,
  output logic        m2s_ar_ready,
  output logic [63:0] m2s_rdata,
  output logic        m2s_rvalid,
  output logic [ 3:0] m2s_rid,
  output logic [ 1:0] m2s_rrsesp,
  input  logic        m2s_rready,
  output logic        m2s_bvalid,
  output logic [ 3:0] m2s_bid,
  output logic [ 1:0] m2s_bresp,
  input  logic        m2s_bready,
  output logic [63:0] s2m_aw_addr,
  output logic        s2m_aw_valid,
  output logic [ 3:0] s2m_aw_id,
  output logic [ 2:0] s2m_aw_prot,
  input  logic        s2m_aw_ready,
  output logic [63:0] s2m_wdata,
  output logic        s2m_wvalid,
  output logic [ 8:0] s2m_wstrb,
  input  logic        s2m_wready,
  output logic [63:0] s2m_ar_addr,
  output logic        s2m_ar_valid,
  output logic [ 3:0] s2m_ar_id,
  output logic [ 2:0] s2m_ar_prot,
  input  logic        s2m_ar_ready,
  input  logic [63:0] s2m_rdata,
  input  logic        s2m_rvalid,
  input  logic [ 3:0] s2m_rid,
  input  logic [ 1:0] s2m_rrsesp,
  output logic        s2m_rready,
  input  logic        s2m_bvalid,
  input  logic [ 3:0] s2m_bid,
  input  logic [ 1:0] s2m_bresp,
  output logic        s2m_bready
);

logic [63:0] s2m_aw_addr;
logic        s2m_aw_valid;
logic [ 3:0] s2m_aw_id;
logic [ 2:0] s2m_aw_prot;
logic        s2m_aw_ready;
logic [63:0] s2m_wdata;
logic        s2m_wvalid;
logic [ 8:0] s2m_wstrb;
logic        s2m_wready;
logic [63:0] s2m_ar_addr;
logic        s2m_ar_valid;
logic [ 3:0] s2m_ar_id;
logic [ 2:0] s2m_ar_prot;
logic        s2m_ar_ready;
logic [63:0] s2m_rdata;
logic        s2m_rvalid;
logic [ 3:0] s2m_rid;
logic [ 1:0] s2m_rrsesp;
logic        s2m_rready;
logic        s2m_bvalid;
logic [ 3:0] s2m_bid;
logic [ 1:0] s2m_bresp;
logic        s2m_bready;


  assign aw_addr      = m2s_aw_addr;
  assign aw_valid     = m2s_aw_valid;
  assign aw_id        = m2s_aw_id;
  assign aw_prot      = m2s_aw_prot;
  assign wdata        = m2s_wdata;
 
  assign wstrb        = m2s_wstrb;
  assign ar_addr      = m2s_ar_addr;
  assign ar_valid     = m2s_ar_valid;
  assign ar_id        = m2s_ar_id;
  assign ar_prot      = m2s_ar_prot;
  assign rready       = m2s_rready;
  assign brready      = m2s_bready;
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