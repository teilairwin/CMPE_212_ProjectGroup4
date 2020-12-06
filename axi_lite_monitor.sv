`ifndef AXI_LITE_MONITOR
`define AXI_LITE_MONITOR

class axi_lite_monitor extends uvm_monitor#(axi_lite_seq_item);
  `uvm_component_utils(axi_lite_monitor)
 
   virtual axi_lite_if vif;
   uvm_analysis_port #(axi_lite_seq_item) ap;
 
   function new(string name="axi_lite_monitor, uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_db#(virtual axi_lite_if)::get(this,"","vif",vif)
   endfunction: build_phase
 
   task run_phase(uvm_phase phase);
      axi_lite_seq_item req;
 
      forever begin
         @vif.monitor_cb;
         //"monitor the bus"
         ap.write(req);
      end
   endtask: run_phase
endclass: axi_lite_monitor

`endif//AXI_LITE_MONITOR