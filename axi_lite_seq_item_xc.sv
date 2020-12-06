//------------------------------------
// Basic AXI LITE  Master/Slave Transaction class definition
// This transaction will be used by Sequences, Drivers and Monitors
// XC: The axi_lite_seq_item is tested together with base_test.sv and test_bench.sv on eda playground
// with UVM 1.2 and synopsys selected for simulation
//------------------------------------
`ifndef AXI_LITE_SEQ_ITEM
`define AXI_LITE_SEQ_ITEM

//axi_lite sequence item derived from base uvm_sequence_item
class axi_lite_seq_item extends uvm_sequence_item;
 
   //define fields with or without randomization
   rand bit [63:0] AWAddr;     
   rand bit [63:0] ARAddr; 
        bit AWValid;   //master indicates that channel is signaling valid write addr
        bit ARValid;   //master indicates that channel is siginal valid read addr
        bit [3:0] AWID;
        bit [3:0] ARID;
        bit [2:0] AWProt;  //fixed value
        bit [2:0] ARProt;  
        bit WValid;    //master indicates that valid data and strobes are ready
        bit RValid;    //slave indicates that the channel is signaling the required read data
   rand bit [63:0] WData;
   rand bit [63:0] RData;
   rand bit [7:0] WStrb;
        bit AWReady;    //slave indicates that it is ready to accept a write addr
        bit ARReady;    //slave indicates that it is ready to accept a read addr
        bit WReady;     //slave indicates it can accept the write data
        bit RReady;     //master indicates it can accept the read data and resp info 
        bit BReady;     //master indicates it can accept write resp
        bit [3:0] RID;  
        bit [3:0] BID;
        bit [1:0] RResp; //slave indicates the status of read transfer 00 okay, 
        bit [2:0] BResp; //slave indicates the status of write transfer
        bit BValid;     //slave indicates that channel is signaling a valid write resp 

        string m_name;

   //write constraints for signals with limitations 
   constraint c_write_addr_limit { AWAddr inside {[0:64'hfff00fff]}; }
   constraint c_read_addr_limit { ARAddr inside {[0:64'hfff00fff]}; }
   //constraint c_wstrb { WStrb inside {1, 3, 15, 255}; } //correspond to 0xb1, 0xb11, 0xb1111, 0xb11111111
   constraint c_wstrb { WStrb inside {8'h1, 8'h2, 8'h4, 8'h8, 8'h10, 8'h20, 8'h40, 8'h80, 8'h3, 8'hc, 8'h30, 8'hc0, 8'hf, 8'hf0, 8'hff }; }
   constraint c_fixed { AWProt == 3'b0; ARProt == 3'b0; }
  //  constraint c_addr_dictated_by_wstrb {( WStrb == 3) -> (AWAddr%2 == 0);
  //                                       ( WStrb == 15) -> (AWAddr%4 == 0);
  //                                       ( WStrb == 255) -> (AWAddr%8 == 0);
  //                                       solve WStrb before AWAddr;
  //  }

   constraint c_addr_dictated_by_wstrb {( WStrb inside {8'h3, 8'hc, 8'h30, 8'hc0}) -> (AWAddr%2 == 0);
                                        ( WStrb inside {8'hf, 8'hf0}) -> (AWAddr%4 == 0);
                                        ( WStrb == 8'hff) -> (AWAddr%8 == 0);
                                        solve WStrb before AWAddr;
   }
   constraint c_write_data { WValid -> WData inside {[0:64'hffffffff]}; } //WData is only set when WValid is set
   constraint c_read_data { RValid -> RData inside {[0:64'hffffffff]}; }
    //Register with factory for dynamic creation
   `uvm_object_utils(axi_lite_seq_item)
  
   
   function new (string name = "axi_lite_seq_item");
      super.new(name);
      m_name = name;
   endfunction : new

   function string convert2string();
     string contents = "";
     $sformat(contents, "%s m_name=%s", contents, m_name);
     $sformat(contents, "%s AWAddr='h%0h", contents, AWAddr);
     $sformat(contents, "%s ARAddr='h%0h", contents, ARAddr);
     $sformat(contents, "%s WData='h%0h", contents, WData);
     $sformat(contents, "%s RData='h%0h", contents, RData);
     $sformat(contents, "%s WStrb='h%0h", contents, WStrb);
     return contents;
   endfunction : convert2string
  
   function void do_print(uvm_printer printer=null);
     super.do_print(printer);
     printer.print_string("m_name", m_name);
     printer.print_field_int("AWAddr ",AWAddr, $bits(AWAddr), UVM_HEX);
     printer.print_field_int("ARAddr ",ARAddr, $bits(ARAddr), UVM_HEX);
     printer.print_field_int("AWProt ", AWProt, $bits(AWProt), UVM_HEX);
     printer.print_field_int("ARProt ", ARProt, $bits(ARProt), UVM_HEX);
     printer.print_field_int("WData ", WData, $bits(WData), UVM_HEX);
     printer.print_field_int("RData ", RData, $bits(RData), UVM_HEX);
     printer.print_field_int("WStrb ", WStrb, $bits(WStrb), UVM_HEX);
   endfunction : do_print
  
   function bit do_compare(uvm_object rhs, uvm_comparer comparer=null);
    bit res;
    axi_lite_seq_item _item;
    //"rhs" does not contain the fields we have defined in the derived class since
    // it is a parent handle. So cast into child type and access using child handle
    // copy each field from the casted handle into local variable
    $cast(_item, rhs);
    super.do_compare(_item, comparer);

    res = super.do_compare(_item, comparer) &
          AWAddr == _item.AWAddr &
          ARAddr == _item.ARAddr &
          WData == _item.WData &
          RData == _item.RData;
          `uvm_info(get_name(), $sformatf("In axi_lite_seq_item::do_compare(), res=%0b", res), UVM_LOW)
    return res;
   endfunction : do_compare

endclass: axi_lite_seq_item

`endif//AXI_LITE_SEQ_ITEM