//------------------------------------
//AXI Lite Interface 
//
//------------------------------------
`ifndef AXI_LITE_IF_SV
`define AXI_LITE_IF_SV

interface axi_lite_if(input logic aclk, input logic arst_n);

//Define axi lite fields 
logic AWReady;
logic WReady;
logic ARReady;
logic [63:0] RData;
logic RValid;
logic [3:0] RID;
logic [1:0] RResp;
logic Bvalid;
logic [3:0] BID;
logic [1:0] BResp;

logic [63:0] AWAddr;
logic AWValid;
logic [3:0] AWID;
logic [2:0] AWProt;
logic WValid;
logic [63:0] WData;
logic [7:0] WStrb;
logic [63:0] ARAddr;
logic [3:0] ARID;
logic ARValid;
logic [2:0] ARProt;
logic RReady;
logic BReady;



logic master_active;
logic slave_active;

   //Master Clocking block - used for Drivers
   clocking master_cb @(posedge aclk);
     //define all the master inputs
     input AWReady, WReady, ARReady, RData, RValid, RID, RResp, BValid, BID, BResp;
     //define all the master outputs
     output AWAddr, AWValid, AWID, AWProt, WValid, WData, WStrb, ARAddr, ARID, ARValid, ARProt, RReady, BReady;
   endclocking: master_cb

   //Slave Clocking Block - used for any Slave BFMs
   clocking slave_cb @(posedge aclk);
     //define slave inputs
     input AWAddr, AWValid, AWID, AWProt, WValid, WData, WStrb, ARAddr, ARID, ARValid, ARProt, RReady, BReady;
     //define slave outputs
     output AWReady, WReady, ARReady, RData, RValid, RID, RResp, BValid, BID, BResp;
   endclocking: slave_cb

   //Monitor Clocking block - For sampling by monitor components
   clocking monitor_cb @(posedge aclk);
     //define all the signal name as inputs
     input AWReady, WReady, ARReady, RData, RValid, RID, RResp, BValid, BID, BResp, AWAddr, AWValid, AWID, AWProt, WValid, WData, WStrb, ARAddr, ARID, ARValid, ARProt, RReady, BReady;
   endclocking: monitor_cb

endinterface: axi_lite_if

`endif  // AXI_LITE_IF_SV