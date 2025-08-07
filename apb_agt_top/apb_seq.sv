class apb_seq extends uvm_sequence;

 `uvm_object_utils(apb_seq)
 
extern function new(string name="apb_seq");

endclass

function apb_seq::new(string name="apb_seq");
   super.new(name);
endfunction
