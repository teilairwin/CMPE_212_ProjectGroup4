//-----------------------------
// This file contains apb config, axil_agent and axil_env class components
//-----------------------------
`ifndef __AXIL_CFG__
`define __AXIL_CFG__

//---------------------------------------
// APB Config class
//   -Not really done anything as of now
//---------------------------------------
class axil_config extends uvm_object;

   `uvm_object_utils(axil_config)
   virtual axi_lite_if vif;

  function new(string name="axil_config");
     super.new(name);
  endfunction

endclass

`endif//__AXIL_CFG__
