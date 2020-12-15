//------------------------------------
//
//------------------------------------
`ifndef AXI_LITE_SCOREBOARD__SV
`define AXI_LITE_SCOREBOARD__SV

`uvm_analysis_imp_decl(_master)
`uvm_analysis_imp_decl(_slave)

class axi_lite_scoreboard extends uvm_scoreboard;
   
   `uvm_component_utils(axi_lite_scoreboard)

   uvm_analysis_imp_master #(axi_lite_seq_item, axi_lite_scoreboard) m_axi_lite_export;
   

   uvm_analysis_imp_slave #(axi_lite_seq_item, axi_lite_scoreboard) s_axi_lite_export;

   axi_lite_seq_item rqueue{$];
   axi_lite_seq_item wqueue{$];

   function new(string name=axi_lite_scoreboard, uvm_component parent);
      super.new(name, parent);
      m_axi_lite_export = new("m_axi_lite_export", this);
      s_axi_lite_export = new("s_axi_lite_export", this);
   endfunction: new
 
   function void write_master(axi_lite_seq_item req);
     axi_lite_seq_item tmp_;
     if(req.wvalid && req.wready)
       wqueue.pushback(req);
     if(req.rvalid && req.rready) begin
       if(rqueue.size()!= 0)  
         tmp_ = rqueue.pop_front();
       else 
         `uvm_error("fill in")
       if(!req.compare(tmp_) begin
         `uvm_error("fill in")
       end
       else begin
         `uvm_info("fill in")
       end
     end     

   endfunction

   function void write_slave(ai_lite_seq_item req);  
      axi_lite_seq_item tmp_;
     if(req.rvalid && req.rready)
       rqueue.pushback(req);
     if(req.wvalid && req.wready) begin
       if(wqueue.size()!= 0)  
         tmp_ = wqueue.pop_front();
       else 
         `uvm_error("fill in")
       if(!req.compare(tmp_) begin
         `uvm_error("fill in")
       end
       else begin
         `uvm_info("fill in")
       end
     end     
   endfunction 

endclass: axi_lite_scoreboard

`endif//AXI_LITE_SCOREBOARD__SV