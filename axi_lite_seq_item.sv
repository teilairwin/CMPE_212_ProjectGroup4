//------------------------------------
// Basic AXI LITE  Master/Slave Transaction class definition
//  This transaction will be used by Sequences, Drivers and Monitors
//------------------------------------
// Kristopher Mach
`ifndef AXI_LITE_SEQ_ITEM
`define AXI_LITE_SEQ_ITEM

//axi_lite sequence item derived from base uvm_sequence_item
class axi_lite_seq_item extends uvm_sequence_item;

  typedef enum {READ, WRITE} rw_e;
  typedef enum {MASTER, SLAVE} ms_e;
  
   rand bit[63:0] addr;
   rand bit[63:0] data;
   rand bit [3:0] id; // for awid/arid/rid
        // I like to have error flags if the monitor detects something unusual/bad protocol
        bit       error;
   rand rw_e      rd_wr; // Read/write select
        ms_e      mst_slv; // Fixed for agent

   /* I/F signals used for protocol only : awready, wready, arready, rready, bready, awprot, arprot,
                                           rvalid, bvalid, awvalid, wvalid, arvalid, rresp, bresp, wstrb */

   //write constraints for signals with limitations
   constraint c_addr { addr   inside {[0:64'h0ff00fff]};  } // can be configured
   constraint c_data { data   inside {[0:64'hffffffff]};  } // can be configured
   constraint c_id   { id     inside {[0:4'hf]};  } // can be configured


    //Register with factory for dynamic creation
   `uvm_object_utils(axi_lite_seq_item)
 
   function new (string name = "axi_lite_seq_item");
      super.new(name);
   endfunction : new

   function string convert2string();
     return $sformatf("addr: %h, data: %h, id: %h, error: %b, rd_wr: %x, mst_slv: %x,/n",
                       addr, data, id, error, rd_wr, mst_slv);
   endfunction : convert2string

   function void  print(uvm_printer printer=null);
     super.print(printer);
     printer.print_string("mst_slv", mst_slv.name());
     printer.print_string("rd_wr",   rd_wr.name());
     printer.print_field("addr",     addr,     64, UVM_HEX);
     printer.print_field("data",     data,     64, UVM_HEX);
     printer.print_field("id",       id,        4, UVM_HEX);
     printer.print_field("error",    error,     1, UVM_BIN);
   endfunction : print
 
   function bit compare(uvm_object rhs, uvm_comparer comparer=null);
     axi_lite_seq_item other;
     
     if(!$cast(other, rhs)) return 0;
     
     return(
       super.do_compare(rhs, comparer)    &&
       this.mst_slv  == other.mst_slv     &&
       this.rd_wr    == other.rd_wr       &&
       this.error    == other.error       &&
       this.id       == other.id          &&
       this.data     == other.data        &&
       this.addr     == other.addr        
     );
   endfunction : compare

endclass: axi_lite_seq_item

`endif//AXI_LITE_SEQ_ITEM