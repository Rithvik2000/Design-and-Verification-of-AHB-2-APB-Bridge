class ahb_driver extends uvm_driver #(ahb_xtns);

	`uvm_component_utils(ahb_driver)

	virtual ahb_if.AHB_DRV_MP vif;
	ahb_agt_config m_cfg;
  ahb_xtns xtn;
  //methods
  
 	extern function new(string name ="ahb_driver",uvm_component parent);
 	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
 	extern task run_phase(uvm_phase phase);
  extern task send_to_dut(ahb_xtns xtn);
  extern function void report_phase(uvm_phase phase);
endclass



// constructor new method

function ahb_driver::new(string name ="ahb_driver",uvm_component parent);
	super.new(name,parent);
endfunction



//build phase 

function void ahb_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
 
 xtn=ahb_xtns::type_id::create("xtn");
        // get the config object using uvm_config_db
        if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

//connect phase

function void ahb_driver::connect_phase(uvm_phase phase);

  vif=m_cfg.vif;
  
endfunction

task ahb_driver::run_phase(uvm_phase phase);

      //reset logic
      
      @(vif.ahb_drv_cb);
      vif.ahb_drv_cb.Hresetn<=1'b0;
      @(vif.ahb_drv_cb);
      vif.ahb_drv_cb.Hresetn<=1'b1;
      
      forever
        
        begin
        
          seq_item_port.get_next_item(req);
          //user define task calling
          send_to_dut(req);
          seq_item_port.item_done();
          
        end
         
endtask


task ahb_driver::send_to_dut(ahb_xtns xtn);

//	@(vif.ahb_drv_cb);     
     vif.ahb_drv_cb.Htrans<=xtn.Htrans;
     vif.ahb_drv_cb.Haddr<=xtn.Haddr;
     vif.ahb_drv_cb.Hsize<=xtn.Hsize;
     vif.ahb_drv_cb.Hwrite<=xtn.Hwrite;
      vif.ahb_drv_cb.Hburst<=xtn.Hburst;
     vif.ahb_drv_cb.Hreadyin<=1'b1;
     

     @(vif.ahb_drv_cb);
   
     @(vif.ahb_drv_cb);
       
     while(!vif.ahb_drv_cb.Hreadyout)
       @(vif.ahb_drv_cb);
       
  
     if(xtn.Hwrite)
       vif.ahb_drv_cb.Hwdata<=xtn.Hwdata;
     else
       vif.ahb_drv_cb.Hwdata<=32'd0;
      
      @(vif.ahb_drv_cb); 
       m_cfg.drv_data_count++;
       
    
     
      `uvm_info("ahb_driver",$sformatf("printing from ahb_driver  \n %s",xtn.sprint()),UVM_LOW)
      
endtask

//report_phase

function void ahb_driver::report_phase(uvm_phase phase);

   `uvm_info("CONFIG",$sformatf("report.ahb_driver sent %0d transaction",m_cfg.drv_data_count),UVM_LOW);
   
endfunction

