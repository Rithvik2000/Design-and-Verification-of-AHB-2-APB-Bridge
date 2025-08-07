class apb_driver extends uvm_driver #(apb_xtns);

	`uvm_component_utils(apb_driver)

	virtual apb_if.APB_DRV_MP vif;
	apb_agt_config m_cfg;
  apb_xtns xtn;
  
  
 	extern function new(string name ="apb_driver",uvm_component parent);
 	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
 	extern task run_phase(uvm_phase phase);
  extern task send_to_dut(apb_xtns xtn);
 	extern function void report_phase(uvm_phase phase);


endclass



// constructor new method

function apb_driver::new(string name ="apb_driver",uvm_component parent);
	super.new(name,parent);
endfunction



//build phase 

function void apb_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
        // get the config object using uvm_config_db
        if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

//connect phase

function void apb_driver::connect_phase(uvm_phase phase);

  vif=m_cfg.vif;
  
endfunction

//run phase

task apb_driver::run_phase(uvm_phase phase);

    
    forever
         begin
          
          //user define task calling
          send_to_dut(req);

        end
endtask



task apb_driver::send_to_dut(apb_xtns xtn);

xtn = apb_xtns::type_id::create("xtn", this);
		

      while(!vif.apb_drv_cb.Pselx)
        @(vif.apb_drv_cb);
       

      if(!vif.apb_drv_cb.Pwrite) 
          vif.apb_drv_cb.Prdata <= {$random};
          
        repeat(2)
           @(vif.apb_drv_cb);
           
        while(!vif.apb_drv_cb.Penable)
          @(vif.apb_drv_cb);
        
        
        m_cfg.drv_data_count++;
        
   // `uvm_info("apb_driver",$sformatf("printing from apb driver  \n %s",xtn.sprint()),UVM_LOW)
        
endtask
        

//report_phase

function void apb_driver::report_phase(uvm_phase phase);

   `uvm_info("CONFIG",$sformatf("report.apb_driver sent %0d transaction",m_cfg.drv_data_count),UVM_LOW);
   
endfunction

