`ifndef AXI_LITE_DRIVER
`define AXI_LITE_DRIVER

class axi_lite_driver extends uvm_driver#(axi_lite_seq_item);
  `uvm_component_utils(axi_lite_driver)
 
   virtual axi_lite_if vif;
 
   function new(string name="axi_lite_driver, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_db#(virtual axi_lite_if)::get(this,"","vif",vif)
   endfunction: build_phase
 
   task run_phase(uvm_phase phase);
      axi_lite_seq_item req;
 
      forever begin
         @vif.master/slave_cb;
         seq_item_port.get_next_item(req);
         //"drive the bus"
         seq_item_port.item_done();
      end
   endtask: run_phase
endclass: axi_lite_driver

`endif//AXI_LITE_DRIVER