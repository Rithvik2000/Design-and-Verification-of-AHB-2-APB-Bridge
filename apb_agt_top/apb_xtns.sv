class apb_xtns extends uvm_sequence_item;
        `uvm_object_utils(apb_xtns)
        
        
        bit Penable;
        
        bit Pwrite; 

        bit [31:0] Prdata;

        bit [31:0] Pwdata;

        bit [31:0] Paddr;

        bit [3:0] Pselx;
        
        //methods
        
        
        extern function void do_print(uvm_printer printer);
        
endclass


function void apb_xtns::do_print(uvm_printer printer);

        super.do_print(printer);
        
        //printer.print_field( string_name,value,size,radix)
        
        printer.print_field("Paddr", this.Paddr, 32, UVM_HEX);
        printer.print_field("Pselx", this.Pselx, 4, UVM_HEX);
        printer.print_field("Pwrite", this.Pwrite, 1, UVM_HEX);
        printer.print_field("Penable", this.Penable, 1, UVM_HEX);
        printer.print_field("Prdata", this.Prdata, 32, UVM_HEX);
	      printer.print_field("Pwdata", this.Pwdata, 32, UVM_HEX);

endfunction
