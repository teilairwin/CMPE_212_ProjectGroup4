`ifndef AXI_LITE_DRIVER
`define AXI_LITE_DRIVER

//forward declaration
typedef axi_lite_agent;

class axi_lite_driver extends uvm_driver#(axi_lite_seq_item);
  `uvm_component_utils(axi_lite_driver)
 
  virtual axi_lite_if vif;
  uvm_event  reset_done; 
  uvm_analysis_port #(axi_lite_seq_item) Drvr2Sb_port;
  
   function new(string name="axi_lite_driver", uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
     axi_lite_agent agent;
      super.build_phase(phase);
     Drvr2Sb_port = new("Drvr2Sb",this);
     if ($cast(agent, get_parent()) && agent != null) begin
       vif = agent.vif;
     end
     else begin
       if (!uvm_config_db#(virtual axi_lite_if)::get(this,"","vif",vif)) begin
         `uvm_fatal("AXIL/DRV/NOVIF", "uh oh");
       end
     end

    if(!uvm_config_db#(uvm_event)::get( null, "*", "reset_done", reset_done))begin
	    `uvm_fatal(this.get_name(), "No reset_done specified for this test instance")
    end
   endfunction: build_phase
 
   task run_phase(uvm_phase phase);
      axi_lite_seq_item req;
      //axi_lite_seq_item reqDup;
      // Do we need to call some reset logic ?
      super.run_phase(phase); 

      reset_done.wait_trigger();

      forever begin
         @vif.master_cb;
         seq_item_port.get_next_item(req);
         `uvm_info("feeding item from driver to scoreboard","huh",UVM_NONE);
         req.print();
         Drvr2Sb_port.write(req);
         @vif.master_cb;
         //"drive the bus"
         //Decode the AXI_LITE Command and call either the read/write function
        case (req.rd_wr)
         axi_lite_seq_item::READ:  begin
          uvm_report_info("AXI_LITE_DRIVER ", $psprintf("Got read Transaction %s",req.convert2string()));
          drive_read(req.addr, req.data);
         end
         axi_lite_seq_item::WRITE: begin
          uvm_report_info("AXI_LITE_DRIVER ", $psprintf("Got write Transaction %s",req.convert2string()));
          drive_write(req.addr, req.data);
         end
       endcase
       
         seq_item_port.item_done();
      end
   endtask: run_phase

  task drive_read(input  bit   [63:0] addr, output logic [63:0] data);
    this.vif.master_cb.araddr <= addr;
    this.vif.master_cb.arvalid <= 1'b1;
     fork
      whileloop :
      begin
        while (this.vif.master_cb.arready != 1) @vif.master_cb;
      end
      watchDone :
      begin
        `uvm_info("repeat fork","argh",UVM_NONE);
        repeat(5) @vif.master_cb;
      end
    join_any
    disable fork;
      if(this.vif.master_cb.arready != 1) begin
        `uvm_warning("time out waiting for arready signal","argh");
        return;
      end
      else `uvm_info("normal procedure","argh",UVM_NONE);
    // one clock cycle delay before the RREADY
    @vif.master_cb;
    this.vif.master_cb.arvalid <= 1'b0;

    this.vif.master_cb.rready <= 1'b1;
    @vif.master_cb;
    this.vif.master_cb.rready <= 1'b0;
    data = this.vif.master_cb.rdata ; 

  endtask: drive_read


  task drive_write(input bit [63:0] addr, input bit [63:0] data);
    this.vif.master_cb.awaddr <= addr;
    this.vif.master_cb.awvalid <= 1'b1;
    `uvm_info("before fork","argh",UVM_NONE);
    fork
      whileloop :
      begin
         while (this.vif.master_cb.wready != 1) @vif.master_cb;
      end
      watchDone :
      begin
        `uvm_info("repeat fork","argh",UVM_NONE);
        repeat(5) @vif.master_cb;
      end
    join_any
    disable fork;
      if(this.vif.master_cb.wready != 1) begin
        `uvm_warning("time out waiting for wready signal","argh");
        return;
      end
      else `uvm_info("normal procedure","argh",UVM_NONE);
         

    this.vif.master_cb.wdata <= data;
    this.vif.master_cb.wvalid <= 1'b1;
    @vif.master_cb;
    this.vif.master_cb.awvalid <= 1'b0;
    this.vif.master_cb.wvalid <= 1'b0;

    this.vif.master_cb.bready <= 1'b1;
    @vif.master_cb;
    this.vif.master_cb.bready <= 1'b0;


  endtask: drive_write
endclass: axi_lite_driver

`endif//AXI_LITE_DRIVER