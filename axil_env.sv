//----------------------------------------------                                                        
// AXI Lite Env class                                                                                        
//----------------------------------------------

`ifndef __AXIL_ENV__
`define __AXIL_ENV__
                                                        
class axil_env  extends uvm_env;                                                                         
                                                                                                        
   `uvm_component_utils(axil_env);                                                                       
                                                                                                        
   //ENV class will have agent as its sub component                                                     
   axi_lite_agent  agt;  
   axil_scoreboard scb;                                                                                     
   //virtual interface for APB interface                                                                
   virtual axi_lite_if  vif;                                                                                 
                                                                                                        
   function new(string name, uvm_component parent = null);                                              
      super.new(name, parent);                                                                          
   endfunction                                                                                          
                                                                                                        
   //Build phase - Construct agent and get virtual interface handle from test  and pass it down to agent
   function void build_phase(uvm_phase phase);   
   	 super.build_phase(phase);   
   	    
     scb = axil_scoreboard::type_id::create("scb", this);                                                  
     agt = axi_lite_agent::type_id::create("agt", this); 
                                                         
     if (!uvm_config_db#(virtual axi_lite_if)::get(this, "", "vif", vif)) begin                              
       `uvm_fatal("AXIL/ENV/NOVIF", "No virtual interface specified for this env instance")            
     end 
     
     //pass it down to agent                                                                                               
     uvm_config_db#(virtual axi_lite_if)::set( this, "agt", "vif", vif);                                     
   endfunction: build_phase  
   
   //Connect - driver and monitor analysis port to scoreboard                                            
   virtual function void connect_phase(uvm_phase phase);                                      
      agt.al_drvr.Drvr2Sb_port.connect(scb.drv2Sb_port);                                         
      uvm_report_info("axil_agent::", "connect_phase, Connected driver to scb"); 
      
      agt.al_mon.ap.connect(scb.mon2Sb_port);                                         
      uvm_report_info("axil_agent::", "connect_phase, Connected monitor to scb");         
   endfunction                                                                             
                                                                                                        
endclass : axil_env                                                                                      
                                                                                                        
                                                                                                        
`endif  //__AXIL_ENV__                                                                                                