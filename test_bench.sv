import uvm_pkg::*;
`include "axi_lite_seq_item.sv"
`include "base_test.sv"

module tb;
   initial begin
       run_test("base_test");
   end
endmodule
