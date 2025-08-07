class ahb_sequencer extends uvm_sequencer #(ahb_xtns);

	// Factory registration using `uvm_component_utils
        `uvm_component_utils(ahb_sequencer)

	// Standard UVM Methods:
        extern function new(string name = "ahb_sequencer",uvm_component parent);
endclass


//  constructor new 
function ahb_sequencer::new(string name="ahb_sequencer",uvm_component parent);
        super.new(name,parent);
endfunction
