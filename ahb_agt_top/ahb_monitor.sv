class ahb_monitor extends uvm_monitor;

	`uvm_component_utils(ahb_monitor)

	virtual ahb_if.AHB_MON_MP vif;
	ahb_agt_config m_cfg;
  uvm_analysis_port #(ahb_xtns) ahb_mon_ap;
  ahb_xtns xtn;

  //methods
 	extern function new(string name ="ahb_monitor",uvm_component parent);
 	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();
  extern function void report_phase(uvm_phase phase);
  
 	

endclass



//constructor new method
function ahb_monitor::new(string name ="ahb_monitor",uvm_component parent);
	super.new(name,parent);
 // create object for handle ap_s using new
  ahb_mon_ap=new("ahb_mon_ap",this);
endfunction



//build_phase
function void ahb_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
   
        if(!uvm_config_db #(ahb_agt_config)::get(this,"","ahb_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction


//connect_phase

function void ahb_monitor::connect_phase(uvm_phase phase);

      vif=m_cfg.vif;

endfunction

task ahb_monitor::run_phase(uvm_phase phase);

    forever
      begin
        collect_data(); 
      end

endtask

task ahb_monitor::collect_data();

  xtn=ahb_xtns::type_id::create("xtn");
  
  while(!(vif.ahb_mon_cb.Hreadyout && (vif.ahb_mon_cb.Htrans == 2'b10 | vif.ahb_mon_cb.Htrans == 2'b11 | vif.ahb_mon_cb.Htrans == 2'b00)))
    @(vif.ahb_mon_cb);
    
   xtn.Htrans = vif.ahb_mon_cb.Htrans;
   xtn.Hwrite = vif.ahb_mon_cb.Hwrite;
   xtn.Hsize  = vif.ahb_mon_cb.Hsize;
   xtn.Haddr  = vif.ahb_mon_cb.Haddr;
   xtn.Hburst = vif.ahb_mon_cb.Hburst;
   
    @(vif.ahb_mon_cb)
     @(vif.ahb_mon_cb); 
    
  while(!vif.ahb_mon_cb.Hreadyout)
    @(vif.ahb_mon_cb);
    
   
    
   @(vif.ahb_mon_cb)
   if(vif.ahb_mon_cb.Hwrite == 1'b1)        
        	xtn.Hwdata = vif.ahb_mon_cb.Hwdata;
  	else
	      	xtn.Hrdata = vif.ahb_mon_cb.Hrdata;
        
		        
   
   `uvm_info("ahb_moniter",$sformatf("printing from ahb monitor  \n %s",xtn.sprint()),UVM_LOW)
     
       ahb_mon_ap.write(xtn);
        
       m_cfg.mon_data_count++;
endtask

//report_phase

function void ahb_monitor::report_phase(uvm_phase phase);

   `uvm_info("CONFIG",$sformatf("report.ahb_moniter sent %0d transaction",m_cfg.mon_data_count),UVM_LOW);
   
endfunction
