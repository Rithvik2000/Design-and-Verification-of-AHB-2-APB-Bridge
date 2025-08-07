class base_ahb_seq extends uvm_sequence #(ahb_xtns);

 `uvm_object_utils(base_ahb_seq)
    
    
    bit [31:0] haddr;
    
    bit hwrite;
    
    bit [1:0] hsize;
    
    bit [2:0] hburst;
 
extern function new(string name="base_ahb_seq");


endclass

function base_ahb_seq::new(string name="base_ahb_seq");
   super.new(name);
endfunction

/************single*****************************/

class single_ahb_seq extends base_ahb_seq;

    `uvm_object_utils(single_ahb_seq)
    
    
    extern function new(string name="single_ahb_seq");
    extern task body();
    
endclass

function single_ahb_seq::new(string name="single_ahb_seq");
   super.new(name);
endfunction

task single_ahb_seq::body();

   req = ahb_xtns::type_id::create("req");
   
   begin
     start_item(req);
     
     assert(req.randomize() with {Htrans == 2'b10; Hwrite == 1'b1; Hburst == 3'b000;});
     
     finish_item(req);
     
     
   end
   
   
   //storeing xtn varuables to local variables
   
   
        haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
        
        
endtask

/*********************undefind***********************/
class undef_ahb_seq extends base_ahb_seq;


   `uvm_object_utils(undef_ahb_seq)
    
    
    extern function new(string name="undef_ahb_seq");
    extern task body();
    
endclass

function undef_ahb_seq::new(string name="undef_ahb_seq");
   super.new(name);
endfunction

task undef_ahb_seq::body();

   req = ahb_xtns::type_id::create("req");
   
   begin
     start_item(req);
     
     assert(req.randomize() with {Htrans == 2'b10; Hwrite == 1'b1; Hburst == 3'b001;});
     
     finish_item(req);
     
     
   end
  
   
   
   //storeing xtn varuables to local variables
   
   
       haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
  
   /***************unspecified length ***********/
  
        if(hburst == 3'b001)
          
            begin
            
              for(int i=0; i<req.length-1;i++)
              
                begin
                
                  start_item(req);
                  
                  if(hsize == 2'b00)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+1'b1;});
                  
                    end
                    
                    
                  if(hsize == 2'b01)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+2'b10;});
                  
                    end
                    
                    if(hsize == 2'b10)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+3'b100;});
                  
                    end
                    
                    finish_item(req);
                    
                      haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
        
                    
                  end
              end
endtask    
/************************increment*********************/

class inc_ahb_seq extends base_ahb_seq;


   `uvm_object_utils(inc_ahb_seq)
    
    
    extern function new(string name="inc_ahb_seq");
    extern task body();
    
endclass

function inc_ahb_seq::new(string name="inc_ahb_seq");
   super.new(name);
endfunction

task inc_ahb_seq::body();

   req = ahb_xtns::type_id::create("req");
   
   begin
     start_item(req);
     
     assert(req.randomize() with {Htrans == 2'b10; Hwrite == 1'b1; Hburst inside {3,5,7};});
     
     finish_item(req);
     
     
   end
   
   
   //storeing xtn varuables to local variables
   
   
        haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
        
        /***************inc-4***********/
        
        if(hburst == 3'b011)
          
            begin
            
              for(int i=0; i<3;i++)
              
                begin
                
                  start_item(req);
                  
                  if(hsize == 2'b00)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});
               
                    end
                    
                    
                  if(hsize == 2'b01)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});
                  
                    end
                    
                    if(hsize == 2'b10)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite;Haddr == haddr+(2**hsize);});
                
                    end
                    
                    finish_item(req);
                    
                    
                            haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
                    
                  end
              end
              
              
              
          /***************inc-8***********/
        
        if(hburst == 3'b101)
          
            begin
            
              for(int i=0; i<7;i++)
              
                begin
                
                  start_item(req);
                  
                  if(hsize == 2'b00)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});
                 
                    end
                    
                    
                    
                  if(hsize == 2'b01)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});
                  
                    end
                    
                    if(hsize == 2'b10)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});
                 
                    end
                    
                    finish_item(req);
                    
                            haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
                    
                  end
              end
              
          
          /***************inc-16***********/
        
        if(hburst == 3'b111)
          
            begin
            
              for(int i=0; i<15;i++)
              
                begin
                
                  start_item(req);
                  
                  if(hsize == 2'b00)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});
                 
                    end
                    
                    
                  if(hsize == 2'b01)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});
               
                    end
                    
                    if(hsize == 2'b10)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == haddr+(2**hsize);});
                
                    end
                    
                    finish_item(req);
                    
                            haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
                    
                  end
              end
        
endtask
     
/************************wrap*********************/

class wrap_ahb_seq extends base_ahb_seq;


   `uvm_object_utils(wrap_ahb_seq)
    
    
    extern function new(string name="wrap_ahb_seq");
    extern task body();
    
endclass

function wrap_ahb_seq::new(string name="wrap_ahb_seq");
   super.new(name);
endfunction

task wrap_ahb_seq::body();

   req = ahb_xtns::type_id::create("req");
   
   begin
     start_item(req);
     
     assert(req.randomize() with {Htrans == 2'b10; Hwrite == 1'b1; Hburst  inside {2,4,6}; }); // Hburst 
     
     finish_item(req);
     
     
   end
   
   
   //storeing xtn varuables to local variables
   
   
        haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;       
        
       /***************wrap-4***********/
        
        if(hburst == 3'b010)
          
            begin
            
              for(int i=0; i<3;i++)
              
                begin
                
                  start_item(req);
                  
                  if(hsize == 2'b00)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr =={haddr[31:2], {haddr[1:0] + 1'b1}};});
                  
                    end
                    
                    
                  if(hsize == 2'b01)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:3], {haddr[2:0] + 2'b10}};});
                  
                    end
                    
                    if(hsize == 2'b10)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:4], {haddr[3:0] + 3'b100}};});
                  
                    end
                    
                    finish_item(req);
                    
                      haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
        
                    
                  end
              end
        
       /***************wrap-8***********/
        
        if(hburst == 3'b100)
          
            begin
            
              for(int i=0; i<7;i++)
              
                begin
                
                  start_item(req);
                  
                  if(hsize == 2'b00)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr =={haddr[31:2], haddr[1:0] + 1'b1};});
                  
                    end
                    
                    
                  if(hsize == 2'b01)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:3], haddr[2:0] + 2'b10};});
                  
                    end
                    
                    if(hsize == 2'b10)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:4], haddr[3:0] + 3'b100};});
                  
                    end
                    
                    finish_item(req);
                    
                      haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
        
                    
                  end
              end
        
       /***************wrap-16***********/
        
        if(hburst == 3'b110)
          
            begin
            
              for(int i=0; i<15;i++)
              
                begin
                
                  start_item(req);
                  
                  if(hsize == 2'b00)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr =={haddr[31:2], haddr[1:0] + 1'b1};});
                  
                    end
                    
                    
                  if(hsize == 2'b01)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:3], haddr[2:0] + 2'b10};});
                  
                    end
                    
                    if(hsize == 2'b10)
                  
                    begin
                    
                      assert(req.randomize() with { Hsize == hsize; Hburst == hburst; Htrans == 2'b11; Hwrite == hwrite; Haddr == {haddr[31:4], haddr[3:0] + 3'b100};});
                  
                    end
                    
                    finish_item(req);
                    
                      haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
        
                    
                  end
              end
        
endtask     
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////  sequence 5////////////////////////////

class ahb_seq_5 extends base_ahb_seq;

    `uvm_object_utils(ahb_seq_5)
    
    
    extern function new(string name="ahb_seq_5");
    extern task body();
    
endclass




function ahb_seq_5::new(string name="ahb_seq_5");
   super.new(name);
endfunction




task ahb_seq_5::body();

   req = ahb_xtns::type_id::create("req");

   begin
     start_item(req);

     assert(req.randomize() with {
       Htrans == 2'b10;                 // NONSEQ transfer
       Hwrite == 1'b1;                  // Write transfer
       Hburst == 3'b010;                // WRAP4 burst
       Hsize == 3'b010;                 // WORD size (4 bytes)
       Haddr inside {32'h00000038};     // Misaligned to 16-byte boundary
     });

     finish_item(req);
   end

   // storing xtn variables to local variables

   haddr  = req.Haddr;
   hsize  = req.Hsize;
   hburst = req.Hburst;
   hwrite = req.Hwrite;




  if (hburst == 3'b010) // WRAP4
begin
  for (int i = 0; i < 3; i++)
  begin
    start_item(req);

    if (hsize == 2'b00) // BYTE
    begin
      bit [1:0] next_addr = haddr[1:0] + 1'b1;
      next_addr = next_addr % 4; // Wrap at 4 bytes
      assert(req.randomize() with {
        Hsize  == hsize;
        Hburst == hburst;
        Htrans == 2'b11; // SEQ
        Hwrite == hwrite;
        Haddr  == {haddr[31:2], next_addr};
      });
    end

    if (hsize == 2'b01) // HALFWORD
    begin
      bit [2:0] next_addr = haddr[2:0] + 3'b010;
      next_addr = next_addr % 8; // Wrap at 8 bytes
      assert(req.randomize() with {
        Hsize  == hsize;
        Hburst == hburst;
        Htrans == 2'b11;
        Hwrite == hwrite;
        Haddr  == {haddr[31:3], next_addr};
      });
    end

    if (hsize == 2'b10) // WORD
    begin
      bit [3:0] next_addr = haddr[3:0] + 4;
      next_addr = next_addr % 16; // Wrap at 16 bytes
      assert(req.randomize() with {
        Hsize  == hsize;
        Hburst == hburst;
        Htrans == 2'b11;
        Hwrite == hwrite;
        Haddr  == {haddr[31:4], next_addr};
      });
    end

    finish_item(req);

    // Update local variables
    haddr  = req.Haddr;
    hsize  = req.Hsize;
    hburst = req.Hburst;
    hwrite = req.Hwrite;
  end
end

endtask


//////////////////////////////////////////////////////////////////////////////////
        
