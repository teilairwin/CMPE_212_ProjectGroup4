//------------------------------------
//
//------------------------------------
`ifndef AXI_LITE_AGENT
`define AXI_LITE_AGENT

class axi_lite_agent extends uvm_agent;
   `uvm_component_utils(axi_lite_agent)
 
  virtual axi_lite_if vif;
   uvm_analysis_port #(axi_lite_seq_item) axi_lite_ap;
 
   axi_lite_sequencer al_seqr;
   axi_lite_driver    al_drvr;
   axi_lite_monitor   al_mon;
 
  function new(string name="axi_lite_agent", uvm_component parent);
      super.new(name, parent);
      axi_lite_ap = new("axi_lite_ap", this);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   
      al_seqr = axi_lite_sequencer::type_id::create(.name("al_seqr"), .parent(this));
      al_drvr = axi_lite_driver::type_id::create(.name("al_drvr"), .parent(this));
      al_mon  = axi_lite_monitor::type_id::create(.name("al_mon"), .parent(this));
     
     if (!uvm_config_db#(virtual axi_lite_if)::get(this, "", "vif", vif)) begin
       `uvm_fatal("AXIL/AGT/NOVIF", "uh oh");
     end
     //pass vif down to driver and monitor
     uvm_config_db#(virtual axi_lite_if)::set( this, "drv", "vif", vif);
     uvm_config_db#(virtual axi_lite_if)::set( this, "mon", "vif", vif);   
   endfunction: build_phase
 
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      al_drvr.seq_item_port.connect(al_seqr.seq_item_export);
      al_mon.ap.connect(axi_lite_ap);
   endfunction: connect_phase

endclass: axi_lite_agent

`endif//AXI_LITE_AGENT