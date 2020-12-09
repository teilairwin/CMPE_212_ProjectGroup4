`ifndef AXI_LITE_MONITOR
`define AXI_LITE_MONITOR

class axi_lite_monitor extends uvm_monitor#(axi_lite_seq_item);
  `uvm_component_utils(axi_lite_monitor)

   virtual axi_lite_if vif;
   uvm_analysis_port #(axi_lite_seq_item) ap;

   function new(string name="axi_lite_monitor", uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
   endfunction: new

   function void build_phase(uvm_phase phase);
     axi_lite_agent agent;
      super.build_phase(phase);
     if ($cast(agent, get_parent()) && agent != null) begin
       vif = agent.vif;
     end
     else begin
       if (!uvm_config_db#(virtual axi_lite_if)::get(this,"","vif",vif)) begin
         `uvm_fatal("APB/MON/NOVIF", "uh oh");
       end
     end
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
