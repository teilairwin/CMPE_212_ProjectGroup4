class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  function new(string name = "base_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  // in the build phase, create three object, randomize them
  // first object is used for testing print and conver2string
  // the second and 3rd objects are used to test comparison
  function void build_phase(uvm_phase phase);
    axi_lite_seq_item obj = axi_lite_seq_item::type_id::create("item");
    axi_lite_seq_item item1 = axi_lite_seq_item::type_id::create("item1");
    axi_lite_seq_item item2 = axi_lite_seq_item::type_id::create("item2");
    repeat(10) begin
      obj.randomize();
      obj.print();
      `uvm_info(get_type_name(), $sformatf("convert2string: %s", obj.convert2string()), UVM_LOW)
    end
    item1.randomize();
    item2.randomize();

    //expect two items not equal due to randomization
    _compare(item1, item2);
    //make two items equal to each other
    item2.AWAddr = item1.AWAddr;
    item2.ARAddr = item1.ARAddr;
    item2.WData = item1.WData;
    item2.RData = item1.RData;
    $display("compare item 2 and item 1 again");
    _compare(item1, item2);
  endfunction

  function void _compare(axi_lite_seq_item item1, item2);
    if(item2.compare(item1))
      `uvm_info("Test", "item 1 and item 2 are same",  UVM_LOW)
    else
      `uvm_info("Test", "item 1 and item 2 are different", UVM_LOW)
  endfunction
  
endclass