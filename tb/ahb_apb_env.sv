class ahb_apb_env extends uvm_env;

	`uvm_component_utils(ahb_apb_env)

	ahb_agt_top ahb_agt_toph;
	apb_agt_top apb_agt_toph;

	ahb_apb_env_config m_cfg;
  
  ahb_apb_scoreboard sb;
   ahb_apb_v_sequencer v_seqr;
   
  
 
	extern function new(string name = "ahb_apb_env", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
endclass


function ahb_apb_env::new(string name = "ahb_apb_env", uvm_component parent);
        super.new(name,parent);
endfunction

//build_phase

function void ahb_apb_env::build_phase(uvm_phase phase);
	super.build_phase(phase);	
	if(!uvm_config_db #(ahb_apb_env_config)::get(this,"","ahb_apb_env_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

    	if(m_cfg.has_ahb_agent)
                begin
    			ahb_agt_toph=ahb_agt_top::type_id::create("ahb_agt_toph",this);
                end
        
	if(m_cfg.has_apb_agent)
                begin
    			apb_agt_toph=apb_agt_top::type_id::create("apb_agt_toph",this);
                end
                
 if(m_cfg.has_virtual_sequencer)
              v_seqr=ahb_apb_v_sequencer::type_id::create("v_seqr",this);
     if(m_cfg.has_scoreboard)
          sb=ahb_apb_scoreboard::type_id::create("sb",this);
endfunction


function void ahb_apb_env::connect_phase(uvm_phase phase);

if(m_cfg.has_virtual_sequencer)
	begin
		if(m_cfg.has_ahb_agent)
	            	begin
		            for(int i=0;i<m_cfg.no_of_ahb_agent;i++)
                   			begin
		                  	v_seqr.ahb_seqr[i]=ahb_agt_toph.agnth[i].seqrh;
		                   	end
		end
   
 

	end
 
  if(m_cfg.has_scoreboard)
		begin
   foreach(ahb_agt_toph.agnth[i])
     begin
  
			    ahb_agt_toph.agnth[i].monh.ahb_mon_ap.connect(sb.fifo_ahb[i].analysis_export);
      end
      
    foreach(apb_agt_toph.agnth[i])
     
      begin
       
			    apb_agt_toph.agnth[i].monh.apb_mon_d.connect(sb.fifo_apb[i].analysis_export);
      end
		end
endfunction

