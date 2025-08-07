class ahb_apb_v_sequencer extends uvm_sequencer;

  `uvm_component_utils(ahb_apb_v_sequencer)
  
  
   ahb_sequencer  ahb_seqr[];
  apb_sequencer apb_seqr[];
  
  ahb_apb_env_config m_cfg;
  
  
  extern function new(string name="ahb_apb_v_sequencer",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  
endclass

function ahb_apb_v_sequencer::new(string name="ahb_apb_v_sequencer",uvm_component parent);
   super.new(name,parent);
endfunction

function void ahb_apb_v_sequencer::build_phase(uvm_phase phase);

        if(!uvm_config_db #(ahb_apb_env_config)::get(this,"","ahb_apb_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
    		 super.build_phase(phase);
		
		    ahb_seqr = new[m_cfg.no_of_ahb_agent];
		    apb_seqr = new[m_cfg.no_of_apb_agent];

    		
	endfunction
