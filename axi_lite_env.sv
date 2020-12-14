//------------------------------------
//
//------------------------------------
`ifndef AXI_LITE_ENV
`define AXI_LITE_ENV

class axi_lite_env extends uvm_env;
   

   virtual axi_lite_if   m_vif;
   virtual axi_lite_if   s_vif;
 
   axi_lite_master_agent m_agent; 
   axi_lite_slave_agent  s_agent;
   axi_lite_scoreboard   sb;

   `uvm_component_utils(axi_lite_env)

   function new(string name=axi_lite_env, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      uvm_config_db#(virtual axi_lite_if)::get( this, "", "vif0", m_vif);
      uvm_config_db#(virtual axi_lite_if)::get( this, "", "vif1", s_vif);

      m_agent = axi_lite_master_agent::type_id::create(.name("m_agent"), .parent(this));
      s_agent  = axi_lite_slave_agent::type_id::create(.name("s_agent"), .parent(this));
      sb  = axi_lite_scoreboard::type_id::create(.name("sb"), .parent(this));

      uvm_config_db#(virtual axi_lite_if)::set( this, "m_agent", "vif", m_vif);
      uvm_config_db#(virtual axi_lite_if)::get( this, "s_agent", "vif", s_vif);

   endfunction: build_phase
 
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      m_agent.axi_lite_ap.connect(sb.m_axi_lite_export);
      s_agent.axi_lite_ap.connect(sb.s_axi_lite_export);
   endfunction: connect_phase

endclass: axi_lite_env

`endif//AXI_LITE_ENV