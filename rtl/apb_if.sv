interface apb_if (input logic clock);


        logic Penable;
        
        logic [31:0] Paddr;
        
        logic  Pwrite;
        
        logic [31:0] Prdata;
        
        logic [31:0] Pwdata;
        
         logic [3:0] Pselx;
         
         
         //ahb driver
         
        clocking apb_drv_cb @(posedge clock);
                default input #1 output #1;
                output Prdata;
                input Penable;
                input Pwrite;
                input Pselx; 
        endclocking

       
       
        //apb monitor
        
        clocking apb_mon_cb @(posedge clock);
                default input #1 output #1;
                input Prdata;
                input Penable;
                input Pwrite;
                input Pselx;
                input Paddr;
                input Pwdata;
        endclocking
property only_one_bit_high_Psel;
       
        @(posedge clock)  (Pselx == 4'b0000 || Pselx == 4'b1000 || Pselx == 4'b0100 || Pselx == 4'b0010 || Pselx == 4'b0001);
            
        

          endproperty;

       ONLY_ONE_BIT_HIGH_PSEL: assert property (only_one_bit_high_Psel);
       
       
       property penable_high_for_one_cycle;
          	@(posedge clock) Penable[->1] |=> !(Penable);
      endproperty

      PENABLE_HIGH: assert property (penable_high_for_one_cycle);


      property after_addr_change_penable_high;
	@(posedge clock) 1'b1 ##1 $changed(Paddr) |=> Penable[->1] ##1 !(Penable);
endproperty

     ADDR_CHANGE_PENABLE_HIGH: assert property (after_addr_change_penable_high);

	//modport
 
 
    modport APB_DRV_MP (clocking apb_drv_cb);
    modport APB_MON_MP (clocking apb_mon_cb);

endinterface: apb_if
