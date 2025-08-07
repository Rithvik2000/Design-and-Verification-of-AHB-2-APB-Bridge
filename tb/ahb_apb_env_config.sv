class ahb_apb_env_config extends uvm_object;

	`uvm_object_utils(ahb_apb_env_config)
	
	bit has_ahb_agent = 1;//agent tops
	bit has_apb_agent = 1;//agent tops
	
	int  no_of_ahb_agent = 1;
	int no_of_apb_agent = 1;
	
	bit has_virtual_sequencer = 1;

	bit has_scoreboard = 1;
  bit no_of_duts = 1;

	ahb_agt_config ahb_agt_cfg[];
	apb_agt_config apb_agt_cfg[];

	extern function new(string name = "ahb_apb_env_config");

endclass

function ahb_apb_env_config::new(string name = "ahb_apb_env_config");
	super.new(name);
endfunction
