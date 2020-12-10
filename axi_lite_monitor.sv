`ifndef AXI_LITE_MONITOR
`define AXI_LITE_MONITOR

class axi_lite_monitor extends uvm_monitor#(axi_lite_seq_item);
  `uvm_component_utils(axi_lite_monitor)

   virtual axi_lite_if vif;
   uvm_analysis_port #(axi_lite_seq_item) ap;

   function new(string name="axi_lite_monitor", uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
   endfunction: new

   function void build_phase(uvm_phase phase);
     axi_lite_agent agent;
      super.build_phase(phase);
     if ($cast(agent, get_parent()) && agent != null) begin
       vif = agent.vif;
     end
     else begin
       if (!uvm_config_db#(virtual axi_lite_if)::get(this,"","vif",vif)) begin
         `uvm_fatal("APB/MON/NOVIF", "uh oh");
       end
     end
   endfunction: build_phase

   task run_phase(uvm_phase phase);
      axi_lite_seq_item req;

      forever begin
         @vif.monitor_cb;
         //"monitor the bus"
         
        if(this.vif.monitor_cb.awvalid == 1)begin
          req = new;
          req.rd_wr = axi_lite_seq_item::WRITE;
 		  req.mst_slv = axi_lite_seq_item::MASTER;
          fork
            construct_write_seq_item:
            begin
              
              req.addr = this.vif.monitor_cb.awaddr;
              while (this.vif.monitor_cb.wvalid != 1 ) @vif.monitor_cb;
              req.data = this.vif.monitor_cb.wdata;
              while (this.vif.monitor_cb.bvalid != 1 ) @vif.monitor_cb;
              
            end
          	write_time_out:
            begin
              repeat(10) @vif.monitor_cb;
              req.error = 1;
            end
          join_any
          disable fork;
            `uvm_info("printing out write req item ", "uh oh", UVM_NONE);
         	ap.write(req);
        end
            
        else if(this.vif.monitor_cb.arvalid == 1)begin
          req = new;
          req.rd_wr = axi_lite_seq_item::READ;
          req.mst_slv = axi_lite_seq_item::MASTER;
          fork
            construct_seq_item:
            begin
              
              req.addr = this.vif.monitor_cb.araddr;
              while (this.vif.monitor_cb.arvalid != 1 ) @vif.monitor_cb;
              req.data = this.vif.monitor_cb.rdata;
              while (this.vif.monitor_cb.rvalid != 1 ) @vif.monitor_cb;
              
            end
          	time_out:
            begin
              repeat(10) @vif.monitor_cb;
              req.error = 1;
            end
          join_any
          disable fork;
            `uvm_info("printing out read req item ", "uh oh", UVM_NONE);
         	ap.write(req);
        end    

      end
   endtask: run_phase
endclass: axi_lite_monitor

`endif//AXI_LITE_MONITOR
