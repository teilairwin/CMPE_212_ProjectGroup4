`ifndef __AXIL_SCOREBOARD__
`define __AXIL_SCOREBOARD__


class axil_scoreboard extends uvm_scoreboard;

	axi_lite_seq_item exp_que[$];
	
	//Register with factory for dynamic creation
    `uvm_component_utils(axil_scoreboard)

    
    //macro for define implementation port
	`uvm_analysis_imp_decl(_from_driver)
	`uvm_analysis_imp_decl(_from_monitor)

	//declaration of implementaion ports
    uvm_analysis_imp_from_driver  #(axi_lite_seq_item,axil_scoreboard) drv2Sb_port;
    uvm_analysis_imp_from_monitor #(axi_lite_seq_item,axil_scoreboard) mon2Sb_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        
        //instantiation
        drv2Sb_port = new("drv2Sb_port", this);
        mon2Sb_port = new("mon2Sb_port", this);
    endfunction : new

    virtual function void write_from_driver(axi_lite_seq_item tr);
        exp_que.push_back(tr);
   endfunction : write_from_driver

   virtual function void write_from_monitor(axi_lite_seq_item pkt);
        if(exp_que.size()) begin
           axi_lite_seq_item exp_pkt = exp_que.pop_front();
           if( pkt.compare(exp_pkt))
             uvm_report_info(get_type_name(), $psprintf("Sent packet and received packet matched"), UVM_LOW);
           else
             uvm_report_error(get_type_name(), $psprintf("Sent packet and received packet mismatched"), UVM_LOW);
        end else begin
             //uvm_report_error(get_type_name(), $psprintf("No more packets to in the expected queue to compare"), UVM_LOW);
   		end
   endfunction : write_from_monitor


   virtual function void report();
        uvm_report_info(get_type_name(),
        $psprintf("Scoreboard Report \n", this.sprint()), UVM_LOW);
   endfunction : report


endclass : axil_scoreboard

`endif//__AXIL_SCOREBOARD__