class apb_monitor extends uvm_monitor;

	`uvm_component_utils(apb_monitor)

	virtual apb_if.APB_MON_MP vif;
	apb_agt_config m_cfg;
  uvm_analysis_port #(apb_xtns) apb_mon_d;
  apb_xtns xtn;

  //methods
 	extern function new(string name ="apb_monitor",uvm_component parent);
 	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data;
  extern function void report_phase(uvm_phase phase);
 	

endclass



//constructor new method
function apb_monitor::new(string name ="apb_monitor",uvm_component parent);
	super.new(name,parent);
 // create object for handle ap_s using new
  apb_mon_d=new("apb_mon_d",this);
endfunction



//build_phase
function void apb_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
   
        if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction


//connect_phase

function void apb_monitor::connect_phase(uvm_phase phase);

      vif=m_cfg.vif;
endfunction

// run phase

task apb_monitor::run_phase(uvm_phase phase);

        forever
                begin
                        collect_data();
                end
endtask



task apb_monitor::collect_data();
        
        xtn = apb_xtns::type_id::create("xtn");
        
         while(!(vif.apb_mon_cb.Penable && vif.apb_mon_cb.Pselx))
            @(vif.apb_mon_cb);
                xtn.Paddr = vif.apb_mon_cb.Paddr;
                xtn.Pwrite = vif.apb_mon_cb.Pwrite; 
                xtn.Pselx = vif.apb_mon_cb.Pselx;
                
                 @(vif.apb_mon_cb);
                
        if(xtn.Pwrite == 1)
		xtn.Pwdata = vif.apb_mon_cb.Pwdata; //collect data
        else
                xtn.Prdata = vif.apb_mon_cb.Prdata; 
                
	repeat(2)
        @(vif.apb_mon_cb);
        
        m_cfg.mon_data_count++;
        
        apb_mon_d.write(xtn);
        
        `uvm_info("apb_moniter",$sformatf("printing from apb moniter  \n %s",xtn.sprint()),UVM_LOW)


endtask

//report_phase

function void apb_monitor::report_phase(uvm_phase phase);

   `uvm_info("CONFIG",$sformatf("report.apb_moniter sent %0d transaction",m_cfg.mon_data_count),UVM_LOW);
   
endfunction

