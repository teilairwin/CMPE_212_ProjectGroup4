`ifndef __AXIL_BASE_TEST_SV__
`define __AXIL_BASE_TEST_SV__

//--------------------------------------------------------
//Top level Test class that instantiates env, configures and starts stimulus
//--------------------------------------------------------
class axil_base_test extends uvm_test;

  //Register with factory
  `uvm_component_utils(axil_base_test);
  
  axil_env      env;
  axil_config   cfg;
  uvm_event     reset_done; 
  virtual axi_lite_if vif;
  
  function new(string name = "axil_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //Build phase - Construct the cfg and env class using factory
  //Get the virtual interface handle from Test and then set it config db for the env component
  function void build_phase(uvm_phase phase);
    cfg = axil_config::type_id::create("cfg", this);
    env = axil_env::type_id::create("env", this);
    //
    if (!uvm_config_db#(virtual axi_lite_if)::get(this, "", "vif", vif)) begin
       `uvm_fatal(this.get_name(), "No virtual interface specified for this test instance")
    end 
    uvm_config_db#(virtual axi_lite_if)::set( this, "env", "vif", vif);
    
    //pass down to any component starting from 'this' level
    uvm_config_db#(axil_config)::set( this, "*", "cfg", cfg);
    
    if(!uvm_config_db#(uvm_event)::get( null, "*", "reset_done", reset_done))begin
	    `uvm_fatal(this.get_name(), "No reset_done specified for this test instance")
    end
    
  endfunction

  //Run phase - Create an abp_sequence and start it on the apb_sequencer
  task run_phase( uvm_phase phase );
    axil_base_seq axil_seq;
    axil_seq = axil_base_seq::type_id::create("axil_seq");
    
    phase.raise_objection( this, "Starting apb_base_seqin main phase" );
    reset_done.wait_trigger();
    $display("%t Starting sequence axil_seq run_phase",$time);
    axil_seq.start(env.agt.al_seqr);
    #100ns;
    phase.drop_objection( this , "Finished axil_seq in main phase" );
  endtask: run_phase
  
  
endclass


`endif