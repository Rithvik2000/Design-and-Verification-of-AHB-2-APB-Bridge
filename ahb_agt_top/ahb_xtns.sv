class ahb_xtns extends uvm_sequence_item;
        `uvm_object_utils(ahb_xtns)
        
        bit Hresetn;
        
        rand bit Hwrite;
        
        rand bit [1:0] Htrans;
        
        rand bit [2:0] Hburst;
        
        rand bit [2:0] Hsize;
        
        rand bit [31:0] Haddr;
        
        rand bit [31:0] Hwdata;
        
        bit [31:0] Hrdata;
        
        bit [1:0] Hresp;
        
        bit Hreadyin;
        
        bit Hreadyout;
        
        rand bit [9:0] length;
        
        
        constraint valid_Hsize {Hsize inside {[0:2]};} //0,1,2
        
        constraint valid_Haddr {Hsize == 1 -> Haddr%2 == 0;
                                Hsize == 2 -> Haddr%4 == 0;}
                                
        constraint valid_length { (2^Hsize)*length <= 1024;}
        
        constraint Haddr_range { Haddr inside {[32'h8000_0000 : 32'h8000_03ff],
                                               [32'h8400_0000 : 32'h8400_03ff],
                                               [32'h8800_0000 : 32'h8800_03ff],
                                               [32'h8c00_0000 : 32'h8c00_03ff]};}
                                               
        constraint hwrite_valid { Hwrite inside {0,1};}
        
        
       //methods
        
        extern function void do_print(uvm_printer printer);
        
endclass

function void ahb_xtns::do_print(uvm_printer printer);

      super.do_print(printer);
      
      //printer.print_field( string_name,value,size,radix)
      
      printer.print_field("Hwrite", this.Hwrite, 1, UVM_HEX);
      printer.print_field("Htrans", this.Htrans, 2, UVM_HEX);
	    printer.print_field("Hburst", this.Hburst, 3, UVM_HEX);
      printer.print_field("Hsize",  this.Hsize,  2, UVM_HEX);
      printer.print_field("Haddr",  this.Haddr,  32, UVM_HEX);
      printer.print_field("Hwdata", this.Hwdata, 32, UVM_HEX);
      printer.print_field("Hrdata", this.Hrdata, 32, UVM_HEX);
     // printer.print_field("length", this.length, 32, UVM_HEX);
      
endfunction
