 import uvm_pkg::*;
`include "uvm_macros.svh"

 //Include all files
`include "axi_lite_if.sv"
`include "axi_lite_seq_item.sv"
`include "axi_lite_1x1.sv"

//--------------------------------------------------------
//Top level module that instantiates  just a physical axi lite interface
//No real DUT or axi lite slave as of now
//--------------------------------------------------------
module tb_top;

    logic         aclk;
    logic         arst_n; 
   
    logic         AWReady;
    logic         Wready;
    logic         ARReady;
    logic [63:0]  RData;
    logic         Rvalid;
    logic [3:0]   RID;
    logic [1:0]   Rresp;
    logic         Bvalid;
    logic [1:0]   BResp;

    logic [63:0]  AWAddr;
    logic         AWValid;
    logic [3:0]   AWID;
    logic [2:0]   AWProt;
    logic         WValid;  
    logic [63:0]  WData;
    logic [7:0]   WStrb;
    logic [63:0]  ARAddr;
    logic [3:0]   ARID;
    logic         ARValid;
    logic [2:0]   ARProt;
    logic         RReady;
    logic         BReady;
  
   //clk gen
   	initial begin
		aclk=0;
      	forever begin
      		#1 aclk = ~aclk;
      	end
   	end
	
   	//reset block
   	initial begin
   	  arst_n = 0; 
      repeat(100) @(posedge aclk);
   	  arst_n = 1;
    end
	
   	//Instantiate a physical interface for AXI LITE interface
  	axi_lite_if  m_axi_lite_if(.aclk(aclk), .arst_n(arst_n));
  	axi_lite_if  s_axi_lite_if(.aclk(aclk), .arst_n(arst_n));
  
   	/*instantiate dut*/
axi_lite_1x1 dut (
   .aclk               (aclk)
  ,.arst_n             (arst_n)
  ,.m2s_aw_addr        (m_axi_lite_if.aw_addr)
  ,.m2s_aw_valid       (m_axi_lite_if.aw_valid)
  ,.m2s_aw_id          (m_axi_lite_if.aw_id)
  ,.m2s_aw_prot        (m_axi_lite_if.aw_prot)
  ,.m2s_aw_ready       (m_axi_lite_if.aw_ready)
  ,.m2s_wdata          (m_axi_lite_if.wdata)
  ,.m2s_wvalid         (m_axi_lite_if.wvalid)
  ,.m2s_wstrb          (m_axi_lite_if.wstrb)
  ,.m2s_wready         (m_axi_lite_if.wready)
  ,.m2s_ar_addr        (m_axi_lite_if.ar_addr)
  ,.m2s_ar_valid       (m_axi_lite_if.ar_valid)
  ,.m2s_ar_id          (m_axi_lite_if.ar_id)
  ,.m2s_ar_prot        (m_axi_lite_if.ar_prot)
  ,.m2s_ar_ready       (m_axi_lite_if.ar_ready)
  ,.m2s_rdata          (m_axi_lite_if.rdata)
  ,.m2s_rvalid         (m_axi_lite_if.rvalid)
  ,.m2s_rid            (m_axi_lite_if.rid)
  ,.m2s_rrsesp         (m_axi_lite_if.rresp)
  ,.m2s_rready         (m_axi_lite_if.rready)
  ,.m2s_bvalid         (m_axi_lite_if.bvalid)
  ,.m2s_bid            (m_axi_lite_if.bid)
  ,.m2s_bresp          (m_axi_lite_if.bresp)
  ,.m2s_bready         (m_axi_lite_if.bready)
  ,.s2m_aw_addr        (s_axi_lite_if.aw_addr)
  ,.s2m_aw_valid       (s_axi_lite_if.aw_valid)
  ,.s2m_aw_id          (s_axi_lite_if.aw_id)
  ,.s2m_aw_prot        (s_axi_lite_if.aw_prot)
  ,.s2m_aw_ready       (s_axi_lite_if.aw_ready)
  ,.s2m_wdata          (s_axi_lite_if.wdata)
  ,.s2m_wvalid         (s_axi_lite_if.wvalid)
  ,.s2m_wstrb          (s_axi_lite_if.wstrb)
  ,.s2m_wready         (s_axi_lite_if.wready)
  ,.s2m_ar_addr        (s_axi_lite_if.ar_addr)
  ,.s2m_ar_valid       (s_axi_lite_if.ar_valid)
  ,.s2m_ar_id          (s_axi_lite_if.ar_id)
  ,.s2m_ar_prot        (s_axi_lite_if.ar_prot)
  ,.s2m_ar_ready       (s_axi_lite_if.ar_ready)
  ,.s2m_rdata          (s_axi_lite_if.rdata)
  ,.s2m_rvalid         (s_axi_lite_if.rvalid)
  ,.s2m_rid            (s_axi_lite_if.rid)
  ,.s2m_rrsesp         (s_axi_lite_if.rresp)
  ,.s2m_rready         (s_axi_lite_if.rready)
  ,.s2m_bvalid         (s_axi_lite_if.bvalid)
  ,.s2m_bid            (s_axi_lite_if.bid)
  ,.s2m_bresp          (s_axi_lite_if.bresp)
  ,.s2m_bready         (s_axi_lite_if.bready)
);


  	initial begin
      uvm_config_db#(virtual axi_lite_if)::set( null, "uvm_test_top.env", "vif0", m_axi_lite_if);
      uvm_config_db#(virtual axi_lite_if)::set( null, "uvm_test_top.env", "vif1", s_axi_lite_if);
      run_test("axi_lite_test");
  	end
  
   initial begin
    //$dumpfile("dump.vcd"); 
    //$dumpvars;
  end
endmodule