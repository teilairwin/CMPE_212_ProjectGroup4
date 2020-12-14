`ifndef BASE_TEST__SV
`define BASE_TEST__SV
class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  axi_lite_env   env;
  
  function new(string name="base_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    env = axi_lite_env::type_id::crate("env",this);
  endfunction : build_phase
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase
 
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    uvm_top.print_topology();
  endfunction : start_of_simulation_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this, "sending transactions");
    seq = axi_lite_seq::type_id::create("seq
);
    assert(seq.randomize());
    seq.start(env.m_agent.sequencer);
    #1000;
    phase.drop_objection(this,"done sending transactions");
  endtask : run_phase


endclass
`endif //BASE_TEST__SV