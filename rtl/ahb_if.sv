//ahb_interface

interface ahb_if(input bit clock);

  
     logic Hresetn;
     logic [31:0] Haddr;
     logic [1:0] Htrans;
     logic Hwrite;
     logic [2:0] Hsize;
     logic [2:0] Hburst;
     logic [31:0] Hwdata;
     logic [31:0] Hrdata;
     logic [1:0] Hresp;
     logic Hreadyin;
     logic Hreadyout;
     
     
    
     //AHB driver clocking block:
        clocking ahb_drv_cb@(posedge clock);
                default input #1 output #1;
                                output Hwrite;
                                output Hreadyin;
								output Hwdata;
                                output Haddr;
                                output Htrans;
                                output Hburst;
                                output Hresetn;
                                output Hsize;
								input Hrdata;
                                input Hreadyout;
                                input  Hresp;
        endclocking
     
     
     //AHB moniter clocking block:
                clocking ahb_mon_cb@(posedge clock);
                default input #1 output #1;
                                input Hwrite;
                                input Hreadyin;
                                input Hwdata;
                                input Haddr;
                                input Htrans;
                                input Hburst;
                                input Hresetn;
                                input Hsize;
                                input Hreadyout;
				                input Hrdata;
                                input  Hresp;
        endclocking


	
      parameter SINGLE   =    3'b000, 
	            INCR4    =    3'b011, 
	            WRAP4    =    3'b010, 
	            INCR8    =    3'b101,
	            WRAP8    =    3'b100,
	            INCR16   =    3'b111,
	            WRAP16   =    3'b110;
	
      parameter IDLE    =  2'b00,
	            BUSY    =  2'b01,
	            NON_SEQ =  2'b10,
	            SEQ     =  2'b11;
      

   /////////////////// assertions	//////////////////////////////////////////////////////////////////
	
     property master_nowait_single;
      	@(posedge clock) disable iff(( !Hresetn ))
      	
      	( Hburst == SINGLE ) |-> ( Htrans == NON_SEQ || Htrans == IDLE);
      endproperty
      
      SINGLE_XTN: assert property (master_nowait_single)
                       $display("Assertions Success", $time);
	                 else
	                   $display("Assertions Failed", $time);


		  
      
      ///////////////////////////////////////////////////////////////////////////////////////////////////
      property master_nowait_incr4_wrap4; //if 
      	@(posedge clock) disable iff(( !Hresetn ) ||  
	                            ( ( Htrans == IDLE ) ||
	                              ( Htrans == BUSY ) )	)
	
	        ( Hburst == INCR4 || Hburst == WRAP4)   &&  ( Htrans == NON_SEQ )  |=>  ( ( Htrans == SEQ ) ) [*3]; 
        endproperty

      INCR4_WRAP4: assert property (master_nowait_incr4_wrap4)
		                    $display("Assertions Success", $time);
	                 else
	                    	$display("Assertions Failed", $time);
                                             
       ///////////////////////////////////////////////////////////////////////////////////////////////////                                      
      property master_nowait_incr8_wrap8; //if
        @(posedge clock) disable iff(( !Hresetn ) ||
                                    ( ( Htrans == IDLE ) ||
                                      ( Htrans == BUSY ) )
                                                )

          ( Hburst == INCR8 || Hburst == WRAP8)   && ( Htrans == NON_SEQ )  ##1 ( ( Htrans == SEQ ) ) [*7] |-> 1;
      endproperty

      INCR8_WRAP8: assert property (master_nowait_incr8_wrap8) 
      
                       $display("Assertions Success", $time);
	                 else
	                    	$display("Assertions Failed", $time);


		  
      ///////////////////////////////////////////////////////////////////////////////////////////////////
      property master_nowait_incr16_wrap16; //if
        @(posedge clock) disable iff(( !Hresetn ) ||
                                    ( ( Htrans == IDLE ) ||
                                      ( Htrans == BUSY ) )
                                                )

          ( Hburst == INCR16 || Hburst == WRAP16)   && ( Htrans == NON_SEQ )  ##1  ( ( Htrans == SEQ ) ) [*15] |-> 1;
      endproperty

		  

     INCR16_WRAP16: assert property (master_nowait_incr16_wrap16)
     
                          $display("Assertions Success", $time);
	                 else
	                    	$display("Assertions Failed", $time);


	///////////////////////////////////////////////////////////////////////////////////////////////////	 
     
     sequence count_four1;
        	( ( Hreadyout ) && ( Htrans == SEQ ) && ( ( Hburst == WRAP4 ) ||( Hburst == INCR4 ) ) ) [->3] ;
    
    endsequence

    sequence count_four2;
        	( ( ( Htrans != IDLE ) && ( Htrans != NON_SEQ ) ) &&
	                  ( ( Hburst == WRAP4 ) || ( Hburst == INCR4 ) ) ) throughout
	                                                                           (count_four1);
    endsequence

    property count_four;                                //BURST LENGTH
      	@(posedge clock) disable iff(( !Hresetn ) )
	 
	
	      ( ( Htrans == NON_SEQ ) && ( Hreadyout ) && 
	               ( ( Hburst == WRAP4 ) || ( Hburst == INCR4 ) ) ) |=> ( count_four2 );

    endproperty

    COUNT_FOUR:assert property (count_four)
                     $display("Assertions Success", $time);
	                 else
	                    	$display("Assertions Failed", $time);
    ///////////////////////////////////////////////////////////////////////////////////////////////////

		
        
        modport AHB_DRV_MP (clocking ahb_drv_cb);
        modport AHB_MON_MP (clocking ahb_mon_cb);


endinterface : ahb_if  
        
        
      
