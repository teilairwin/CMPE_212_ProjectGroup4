`ifndef __AXI_LITE_SEQUENCE_SV__
`define __AXI_LITE_SEQUENCE_SV__

//------------------------
//Base AXI lite sequence derived from uvm_sequence and parameterized with sequence item of type axi_lite_seq_item
//------------------------
class axi_lite_sequence extends uvm_sequence#(axi_lite_seq_item);

  `uvm_object_utils(axi_lite_sequence)

  function new(string name ="axi_lite_sequence");
    super.new(name);
  endfunction


  //Main Body method that gets executed once sequence is started
  task body();
     `uvm_info("BASE_SEQ", $sformatf("Starting body of %s", this.get_name()), UVM_MEDIUM)
     axi_lite_seq_item rw_trans;
     rw_trans = axi_lite_seq_item::type_id::create(.name("rw_trans"),.contxt(get_full_name()));
     //Create 10 random axi_lite read/write transaction and send to driver
     repeat(10) begin
       start_item(rw_trans);
       assert (rw_trans.randomize());
       finish_item(rw_trans);
     end
     `uvm_info(get_type_name(), $sformatf("Sequence %s is over", this.get_name()), UVM_MEDIUM)
  endtask
  
endclass

`endif