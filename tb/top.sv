module top;
	
	//Import Packages
	import ahb_apb_pkg::*;
	import uvm_pkg::*;
	
	//Generate Clock
	bit clock;
	
	initial
	begin	
		forever
			#10 clock = ~clock;
	end
 
 //interface instantiation
        ahb_if in0(clock);
        apb_if in1(clock);
        
        
        rtl_top duv(  .Hclk(clock),
                     .Hresetn(in0.Hresetn),
                     .Htrans(in0.Htrans),
		    	.Hsize(in0.Hsize), 
		    	.Hreadyin(in0.Hreadyin),
		    	.Hwdata(in0.Hwdata), 
		    	.Haddr(in0.Haddr),
		    		.Hwrite(in0.Hwrite),
       	.Prdata( in1.Prdata),
		   	.Hrdata(in0.Hrdata),
		   	.Hresp(in0.Hresp),
		   	.Hreadyout(in0.Hreadyout),
		   	.Pselx(in1.Pselx),
	    	.Pwrite(in1.Pwrite),
	    	.Penable(in1.Penable), 
		     .Paddr(in1.Paddr),
		   .Pwdata(in1.Pwdata)
		    ) ;
  
  
  initial
	begin
 
 
 
         `ifdef VCS
         		$dumpfile("wave.vcd");
                        $dumpvars(0, top);
        		`endif
           
           
           
          uvm_config_db #(virtual ahb_if)::set(null, "*", "ahb_vif", in0);
          uvm_config_db #(virtual apb_if)::set(null, "*", "apb_vif", in1);

       // Call run_test
	
  
          	run_test();
	end
 
 

      
 endmodule
