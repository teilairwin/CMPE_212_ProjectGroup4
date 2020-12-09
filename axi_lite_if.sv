//------------------------------------
//AXI Lite Interface 
//
//------------------------------------
// Kristopher Mach
`ifndef AXI_LITE_IF_SV
`define AXI_LITE_IF_SV

interface axi_lite_if(input logic aclk, input logic arst);

//Define axi lite fields 
// Master In/ Slave out
logic       awready;
logic       wready;
logic       arready;
logic [63:0]rdata;
logic       rvalid;
logic [3:0] rid;
logic       rresp;
logic       bvalid;
logic       bresp;
//Master out/ Slave in
logic[63:0] awaddr;
logic       awvalid;
logic [3:0] awid;
logic [2:0] awprot;
logic       wvalid;
logic [63:0]wdata;
logic [7:0] wstrb;
logic [63:0]araddr;
logic [3:0] arid;
logic       arvalid;
logic [2:0] arprot;
logic       rready;
logic       bready;

logic master_active;
logic slave_active;

   //Master Clocking block - used for Drivers
   clocking master_cb @(posedge aclk);
     //define all the master inputs
     input  awready;
     input  wready;
     input  arready;
     input  rdata;
     input  rvalid;
     input  rid;
     input  rresp;
     input  bvalid;
     input  bresp;
     //define all the master outputs
     output awaddr;
     output awvalid;
     output awid;
     output awprot;
     output wvalid;
     output wdata;
     output wstrb;
     output araddr;
     output arid;
     output arvalid;
     output arprot;
     output rready;
     output bready; 
   endclocking: master_cb

   //Slave Clocking Block - used for any Slave BFMs
   clocking slave_cb @(posedge aclk);
     //define slave inputs
     input awaddr;
     input awvalid;
     input awid;
     input awprot;
     input wvalid;
     input wdata;
     input wstrb;
     input araddr;
     input arid;
     input arvalid;
     input arprot;
     input rready;
     input bready; 
     //define slave outputs
     output awready;
     output wready;
     output arready;
     output rdata;
     output rvalid;
     output rid;
     output rresp;
     output bvalid;
     output bresp;
   endclocking: slave_cb

   //Monitor Clocking block - For sampling by monitor components
   clocking monitor_cb @(posedge aclk);
     //define all the signal name as inputs
     input awaddr;
     input awvalid;
     input awid;
     input awprot;
     input wvalid;
     input wdata;
     input wstrb;
     input araddr;
     input arid;
     input arvalid;
     input arprot;
     input rready;
     input bready; 
     input awready;
     input wready;
     input arready;
     input rdata;
     input rvalid;
     input rid;
     input rresp;
     input bvalid;
     input bresp;
   endclocking: monitor_cb

endinterface: axi_lite_if

`endif  // AXI_LITE_IF_SV