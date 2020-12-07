import uvm_pkg::*;
`include "uvm_macros.svh"

 //Include all files
 // Agent Files
`include "axi_lite_if.sv"
`include "axi_lite_seq_item.sv"
`include "axi_lite_sequencer.sv"
`include "axi_lite_driver.sv"
`include "axi_lite_monitor.sv"
`include "axi_lite_agent.sv"
// Env Files
`include "axil_config.sv"
`include "axil_sequence.sv"
`include "axil_env.sv"
`include "axil_test.sv"
`include "axi_lite_1x1.sv"

//--------------------------------------------------------
//Top level module that instantiates  just a physical apb interface
//No real DUT or APB slave as of now
//--------------------------------------------------------
module tb_top;

   	logic aclk;
   	logic arst; 
   
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

   //clk gen
   	initial begin
		aclk=0;
      	forever begin
      		#10 aclk = ~aclk;
      	end
   	end
	
   	//reset block
   	initial begin
   		uvm_event reset_done = new("reset_done"); 
   		uvm_config_db#(uvm_event)::set( null, "*", "reset_done", reset_done);
   		arst = 0; 
   		repeat(20) @(posedge aclk);
   		arst = 1;
   		repeat(20) @(posedge aclk);
   		arst = 0;
   		reset_done.trigger();
   	end
	
   	//Instantiate a physical interface for APB interface
  	axi_lite_if  axi_lite_if_inst(.aclk(aclk), .arst(arst));
 
   	//instantiate dut
   	axi_lite_1x1 axil_dut_inst(	
      .aclk	        (aclk   ), 
   	  .arst_n	    (arst   ),
      // Master Agent here
      .m2s_aw_addr  (),// DUT In  [63:0]
      .m2s_aw_valid (),// DUT In        
      .m2s_aw_id,   (),// DUT In  [ 3:0]
      .m2s_aw_prot  (),// DUT In  [ 2:0]
      .m2s_aw_ready (),// Out           
      .m2s_wdata    (),// DUT In  [63:0]
      .m2s_wvalid   (),// DUT In        
      .m2s_wstrb    (),// DUT In  [ 8:0]
      .m2s_wready   (),// Out           
      .m2s_ar_addr  (),// DUT In  [63:0]
      .m2s_ar_valid (),// DUT In        
      .m2s_ar_id    (),// DUT In  [ 3:0]
      .m2s_ar_prot  (),// DUT In  [ 2:0]
      .m2s_ar_ready (),// Out           
      .m2s_rdata    (),// Out     [63:0]
      .m2s_rvalid   (),// Out           
      .m2s_rid      (),// Out     [ 3:0]
      .m2s_rrsesp   (),// Out     [ 1:0]
      .m2s_rready   (),// DUT In        
      .m2s_bvalid   (),// Out           
      .m2s_bid      (),// Out     [ 3:0] // Not provided in AXI_Lite I/F template ? 
      .m2s_bresp    (),// Out     [ 1:0]
      .m2s_bready   (),// DUT In      

      // Slave agent here
      .s2m_aw_addr  (),// Out     [63:0]
      .s2m_aw_valid (),// Out           
      .s2m_aw_id,   (),// Out     [ 3:0]
      .s2m_aw_prot  (),// Out     [ 2:0]
      .s2m_aw_ready (),// DUT In        
      .s2m_wdata    (),// Out     [63:0]
      .s2m_wvalid   (),// Out           
      .s2m_wstrb    (),// Out     [ 8:0]
      .s2m_wready   (),// DUT In        
      .s2m_ar_addr  (),// Out     [63:0]
      .s2m_ar_valid (),// Out           
      .s2m_ar_id    (),// Out     [ 3:0]
      .s2m_ar_prot  (),// Out     [ 2:0]
      .s2m_ar_ready (),// DUT In        
      .s2m_rdata    (),// DUT In  [63:0]
      .s2m_rvalid   (),// DUT In        
      .s2m_rid      (),// DUT In  [ 3:0]
      .s2m_rrsesp   (),// DUT In  [ 1:0]
      .s2m_rready   (),// Out           
      .s2m_bvalid   (),// DUT In        
      .s2m_bid      (),// DUT In  [ 3:0]
      .s2m_bresp    (),// DUT In  [ 1:0]
      .s2m_bready   ()// Out           
    );      
   	
   	//connect interface 
   	assign axi_lite_if_inst.awready  = m2s_aw_ready;
   	assign axi_lite_if_inst.wready   = m2s_wready  ;
   	assign axi_lite_if_inst.arready  = m2s_ar_ready;
   	assign axi_lite_if_inst.rdata    = m2s_rdata   ;
   	assign axi_lite_if_inst.rvalid   = m2s_rvalid  ;
   	assign axi_lite_if_inst.rid      = m2s_rid     ;
   	assign axi_lite_if_inst.rresp    = m2s_rrsesp  ;// Dut spelling bug
   	assign axi_lite_if_inst.bvalid   = m2s_bvalid  ;
   	assign axi_lite_if_inst.bresp    = m2s_bresp   ;
     
   	assign m2s_aw_addr	   = axi_lite_if_inst.awaddr;
   	assign m2s_aw_valid	   = axi_lite_if_inst.awvalid;
   	assign m2s_aw_id	   = axi_lite_if_inst.awid;
   	assign m2s_aw_prot	   = axi_lite_if_inst.awprot;
   	assign m2s_wvalid	   = axi_lite_if_inst.wvalid;
   	assign m2s_wdata	   = axi_lite_if_inst.wdata;
   	assign m2s_wstrb	   = axi_lite_if_inst.wstrb;
   	assign m2s_ar_addr	   = axi_lite_if_inst.araddr;
   	assign m2s_ar_id	   = axi_lite_if_inst.arid;
   	assign m2s_ar_valid	   = axi_lite_if_inst.arvalid;
   	assign m2s_ar_prot	   = axi_lite_if_inst.arprot;
   	assign m2s_rready	   = axi_lite_if_inst.rready;
   	assign m2s_bready	   = axi_lite_if_inst.bready;

  	initial begin
    	//Pass this physical interface to test top (which will further pass it down to env->agent->drv/sqr/mon
    	uvm_config_db#(virtual axi_lite_if)::set( null, "uvm_test_top", "vif", axi_lite_if_inst);
    
    	//Call the test - but passing run_test argument as test class name
    	//Another option is to not pass any test argument and use +UVM_TEST on command line to sepecify which test to run
    	run_test("axil_base_test");
  	end
  
   initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule