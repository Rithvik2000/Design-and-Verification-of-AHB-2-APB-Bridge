class apb_sequencer extends uvm_sequencer #(apb_xtns);

	// Factory registration using `uvm_component_utils
        `uvm_component_utils(apb_sequencer)

	// Standard UVM Methods:
        extern function new(string name = "apb_sequencer",uvm_component parent);
endclass


//  constructor new 
function apb_sequencer::new(string name="apb_sequencer",uvm_component parent);
        super.new(name,parent);
endfunction
