//------------------------------------
// Basic AXI LITE Master/Slave Transaction class definition
//  This transaction will be used by Sequences, Drivers and Monitors
//------------------------------------
`ifndef AXI_LITE_SEQ_ITEM
`define AXI_LITE_SEQ_ITEM

//axi_lite sequence item derived from base uvm_sequence_item
class axi_lite_seq_item extends uvm_sequence_item;

   //define fields with or without randomization
   typedef enum bit[1:0] { OKAY=2'b00, SLVERR=2'b10, DECERR=2'b11 } resp_e;
   bit               aclk;
   bit               arst_n;
   rand bit [63:0]   AWAddr;
   bit               AWValid;
   bit      [3:0]    AWID;
   bit      [2:0]    AWProt;
   bit               WValid;
   rand bit [63:0]   WData;
   rand bit [7:0]    WStrb;
   rand bit [63:0]   ARAddr;
   bit      [3:0]    ARID;
   bit               ARValid;
   bit      [2:0]    ARProt;
   bit               RReady;
   bit               BReady;
   bit               AWReady;
   bit               Wready;
   bit               ARReady;
   rand bit [63:0]   RData;
   bit               Rvalid;
   bit      [3:0]    RID;
   rand bit [1:0]    Rresp;
   bit               Bvalid;
   bit      [3:0]    BID;
   rand bit [1:0]    BResp;

   //write constraints for signals with limitations
   constraint c_ARAddr { ARAddr inside {[64'h1fff_f000:64'h1fff_f1ff]}; }
   constraint c_AWaddr { AWAddr inside {[64'h1fff_f000:64'h1fff_f1ff]}; }
   constraint c_WData  { WData  inside {[64'h1fff_f000:64'h1fff_f1ff]}; }
   constraint c_RData  { RData  inside {[64'h1fff_f000:64'h1fff_f1ff]}; }
   constraint c_WStrb1 { WStrb  inside {8'h01,8'h02,8'h04,8'h08,8'h10,8'h20,8'h40,8'h80,8'h03,8'h0c,8'h30,8'hc0,8'h0f,8'hf0,8'hff}; }
   constraint c_WStrb2 {
      /*
         1-byte write
         0000_0001      : 8'h01
         0000_0010      : 8'h02
         0000_0100      : 8'h04
         0000_1000      : 8'h08
         0001_0000      : 8'h10
         0010_0000      : 8'h20
         0100_0000      : 8'h40
         1000_0000      : 8'h80

         2-byte write
         0000_0011      : 8'h03
         0000_1100      : 8'h0c
         0011_0000      : 8'h30
         1100_0000      : 8'hc0

         4-byte write
         0000_1111      : 8'h0f
         1111_0000      : 8'hf0

         8-byte write
         1111_1111      : 8'hff

         Notes (not sure if correct):
            * You can only do full 8 byte writes if the write strobe is 0 or 8.
            * Strobe off the unalgined bytes and pick valid WStrb values.
            Examples:

            1. Address is 0x3
            WStrb[2:0] must b 0. (I used a mask WStrb & 0xf == 0)
            Pick WStrb inside the valid 1/2/4/8 byte writes that satisfies this constraint.
               Valid values would be: 8'h08, 8'h10, 8'h20, 8'h40, 8'h80, 8'h30, 8'hc0, 8'hf0

            2. Address is 0x4
            WStrb[3:0] must be 0
               Valid values would be: 8'h10, 8'h20, 8'h40, 8'h80, 8'h30, 8'hc0, 8'hf0

            3. Address is 0x5
            Wstrb[4:0] must b 0
               Valid values would be: 8'h20, 8'h40, 8'h80, 8'hc0
      */
      if ((AWAddr[3:0]%8) > 0) {
         8'hff > WStrb;
         (WStrb & cal_mask_value(AWAddr[3:0]%8)) == 0;
      }
   }
   constraint c_Rresp { Rresp dist {OKAY:=90, SLVERR:=5, DECERR:=5}; }
   constraint c_BResp { BResp dist {OKAY:=90, SLVERR:=5, DECERR:=5}; }

   //Register with factory for dynamic creation
   `uvm_object_utils(axi_lite_seq_item)


   function new (string name = "axi_lite_seq_item");
      super.new(name);
   endfunction : new

   function bit[7:0] cal_mask_value(int size);
      bit [7:0] mask_value;

      mask_value = 8'hff << size;
      mask_value = ~mask_value;
      return mask_value;
   endfunction

   virtual function string convert2string();
      string res = "";
      res = $sformatf("aclk=0x%0h", aclk);
      res = $sformatf("%s arst_n=0x%0h", res, arst_n);
      res = $sformatf("%s {AWAddr=0x%0h; 4_lsb_mod8:%0d}", res, AWAddr, (AWAddr[3:0]%8));
      res = $sformatf("%s AWValid=0x%0h", res, AWValid);
      res = $sformatf("%s AWID=0x%0h", res, AWID);
      res = $sformatf("%s AWProt=0x%0h", res, AWProt);
      res = $sformatf("%s WValid=0x%0h", res, WValid);
      res = $sformatf("%s WData=0x%0h", res, WData);
      res = $sformatf("%s WStrb=0x%0h", res, WStrb);
      res = $sformatf("%s ARAddr=0x%0h", res, ARAddr);
      res = $sformatf("%s ARID=0x%0h", res, ARID);
      res = $sformatf("%s ARValid=0x%0h", res, ARValid);
      res = $sformatf("%s ARProt=0x%0h", res, ARProt);
      res = $sformatf("%s RReady=0x%0h", res, RReady);
      res = $sformatf("%s BReady=0x%0h", res, BReady);
      res = $sformatf("%s AWReady=0x%0h", res, AWReady);
      res = $sformatf("%s Wready=0x%0h", res, Wready);
      res = $sformatf("%s ARReady=0x%0h", res, ARReady);
      res = $sformatf("%s RData=0x%0h", res, RData);
      res = $sformatf("%s Rvalid=0x%0h", res, Rvalid);
      res = $sformatf("%s RID=0x%0h", res, RID);
      res = $sformatf("%s Rresp=0x%0h", res, Rresp);
      res = $sformatf("%s Bvalid=0x%0h", res, Bvalid);
      res = $sformatf("%s BID=0x%0h", res, BID);
      res = $sformatf("%s BResp=0x%0h", res, BResp);
      return res;
   endfunction : convert2string

   virtual function void do_print(uvm_printer printer=null);
      super.do_print(printer);
      printer.print_field_int("aclk", aclk, $bits(aclk), UVM_HEX);
      printer.print_field_int("arst_n", arst_n, $bits(arst_n), UVM_HEX);
      printer.print_field_int("AWAddr", AWAddr, $bits(AWAddr), UVM_HEX);
      printer.print_field_int("AWValid", AWValid, $bits(AWValid), UVM_HEX);
      printer.print_field_int("AWID", AWID, $bits(AWID), UVM_HEX);
      printer.print_field_int("AWProt", AWProt, $bits(AWProt), UVM_HEX);
      printer.print_field_int("WValid", WValid, $bits(WValid), UVM_HEX);
      printer.print_field_int("WData", WData, $bits(WData), UVM_HEX);
      printer.print_field_int("WStrb", WStrb, $bits(WStrb), UVM_HEX);
      printer.print_field_int("ARAddr", ARAddr, $bits(ARAddr), UVM_HEX);
      printer.print_field_int("ARID", ARID, $bits(ARID), UVM_HEX);
      printer.print_field_int("ARValid", ARValid, $bits(ARValid), UVM_HEX);
      printer.print_field_int("ARProt", ARProt, $bits(ARProt), UVM_HEX);
      printer.print_field_int("RReady", RReady, $bits(RReady), UVM_HEX);
      printer.print_field_int("BReady", BReady, $bits(BReady), UVM_HEX);
      printer.print_field_int("AWReady", AWReady, $bits(AWReady), UVM_HEX);
      printer.print_field_int("Wready", Wready, $bits(Wready), UVM_HEX);
      printer.print_field_int("ARReady", ARReady, $bits(ARReady), UVM_HEX);
      printer.print_field_int("RData", RData, $bits(RData), UVM_HEX);
      printer.print_field_int("Rvalid", Rvalid, $bits(Rvalid), UVM_HEX);
      printer.print_field_int("RID", RID, $bits(RID), UVM_HEX);
      printer.print_field_int("Rresp", Rresp, $bits(Rresp), UVM_HEX);
      printer.print_field_int("Bvalid", Bvalid, $bits(Bvalid), UVM_HEX);
      printer.print_field_int("BID", BID, $bits(BID), UVM_HEX);
      printer.print_field_int("BResp", BResp, $bits(BResp), UVM_HEX);
   endfunction : do_print

   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer=null);
      bit res;
      axi_lite_seq_item _obj;
      $cast(_obj, rhs);
      res = super.do_compare(_obj, comparer) &
            aclk == _obj.aclk &
            arst_n == _obj.arst_n &
            AWAddr == _obj.AWAddr &
            AWValid == _obj.AWValid &
            AWID == _obj.AWID &
            AWProt == _obj.AWProt &
            WValid == _obj.WValid &
            WData == _obj.WData &
            WStrb == _obj.WStrb &
            ARAddr == _obj.ARAddr &
            ARID == _obj.ARID &
            ARValid == _obj.ARValid &
            ARProt == _obj.ARProt &
            RReady == _obj.RReady &
            BReady == _obj.BReady &
            AWReady == _obj.AWReady &
            Wready == _obj.Wready &
            ARReady == _obj.ARReady &
            RData == _obj.RData &
            Rvalid == _obj.Rvalid &
            RID == _obj.RID &
            Rresp == _obj.Rresp &
            Bvalid == _obj.Bvalid &
            BID == _obj.BID &
            BResp == _obj.BResp;
      `uvm_info(get_name(), $sformatf("In Object::do_compare(), res=%0b", res), UVM_LOW)
      return res;
   endfunction : do_compare

endclass: axi_lite_seq_item

`endif//AXI_LITE_SEQ_ITEM
