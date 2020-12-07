

`ifndef __AXIL_SEQUENCE_SV__
`define __AXIL_SEQUENCE_SV__

//------------------------
//Base AXI VIP sequence derived from uvm_sequence and parameterized with sequence item of type axi_lite_seq_item
//------------------------
class axil_base_seq extends uvm_sequence#(axi_lite_seq_item);

  `uvm_object_utils(axil_base_seq)

  function new(string name ="");
    super.new(name);
  endfunction


  //Main Body method that gets executed once sequence is started
  task body();
     axi_lite_seq_item rw_trans;
     //Create 10 random AXI Lite read/write transactions and send to driver
     repeat(10) begin
       rw_trans = axi_lite_seq_item::type_id::create(.name("rw_trans"),.contxt(get_full_name()));
       start_item(rw_trans);
       assert (rw_trans.randomize());
       finish_item(rw_trans);
     end
  endtask
  
endclass

`endif//__AXIL_SEQUENCE_SV__
