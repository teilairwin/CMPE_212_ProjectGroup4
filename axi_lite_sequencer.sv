`ifndef AXI_LITE_SEQUENCER
`define AXI_LITE_SEQUENCER

class axi_lite_sequencer extends uvm_sequencer#(axi_lite_seq_item);
 
   
   `uvm_component_utils(axi_lite_sequencer)
  	
   
   function new (string name = "axi_lite_sequencer", uvm_component parent);
      super.new(name);
   endfunction : new

endclass: axi_lite_sequencer

`endif//AXI_LITE_SEQUENCER