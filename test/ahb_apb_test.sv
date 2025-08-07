class ahb_apb_test extends uvm_test;

	`uvm_component_utils(ahb_apb_test)
 
 
 
 
   ahb_apb_env env;
	ahb_apb_env_config e_cfg;
   
  base_ahb_seq seq_ahb;
  apb_seq seq_apb;
  ahb_sequencer seqrh_ahb;
  apb_sequencer seqrh_apb;
  
  ahb_apb_v_sequencer  v_seqr;
  
	ahb_agt_config ahb_cfg[];
	apb_agt_config apb_cfg[];

	bit has_ahb_agent=1;
	bit has_apb_agent=1;
	
	int no_of_apb_agent=1;
	int no_of_ahb_agent=1;

	bit has_scoreboard = 1;
  bit has_virtual_sequencer = 1;
  
  extern function new (string name="ahb_apb_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_ahb_apb();
	extern function void end_of_elaboration_phase(uvm_phase phase);
  //extern task run_phase(uvm_phase phase);
endclass

function ahb_apb_test::new(string name="ahb_apb_test",uvm_component parent);
	super.new(name,parent);
endfunction


function void ahb_apb_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	e_cfg = ahb_apb_env_config::type_id::create("e_cfg");

	//create env_config object
	if(has_ahb_agent)
		e_cfg.ahb_agt_cfg=new[no_of_ahb_agent];
	if(has_apb_agent)
		e_cfg.apb_agt_cfg=new[no_of_apb_agent];
	config_ahb_apb();

	uvm_config_db #(ahb_apb_env_config)::set(this,"*","ahb_apb_env_config",e_cfg);
	//creating obj of env
	env=ahb_apb_env::type_id::create("env",this);
  
  

endfunction




function void ahb_apb_test::config_ahb_apb();
	//creating src & rd agent 
	if(has_ahb_agent)
		begin
			ahb_cfg=new[no_of_ahb_agent];
			foreach(ahb_cfg[i])
				begin
					ahb_cfg[i]=ahb_agt_config::type_id::create($sformatf("ahb_cfg[%0d]",i));
		
					if(!uvm_config_db #(virtual ahb_if)::get(this,"","ahb_vif",ahb_cfg[i].vif))
					  `uvm_fatal("VIF CONFIG- src","cannot get() interface from uvm_config_db.have you set() it?")
	
					ahb_cfg[i].is_active=UVM_ACTIVE;
					e_cfg.ahb_agt_cfg[i]=ahb_cfg[i];
				end
		end


 	if(has_apb_agent)
          	begin
          		apb_cfg=new[no_of_apb_agent];
          		foreach(apb_cfg[i])
                		begin
                          		apb_cfg[i]=apb_agt_config::type_id::create($sformatf("apb_cfg[%0d]",i));
 	
        		                if(!uvm_config_db #(virtual apb_if)::get(this,"","apb_vif",apb_cfg[i].vif))
                          			`uvm_fatal("VIF CONFIG- dst","cannot get() interface from uvm_config_db.have you set() it?")
                           		
					apb_cfg[i].is_active=UVM_ACTIVE;
                          		e_cfg.apb_agt_cfg[i]=apb_cfg[i];
 				end
 		end

	e_cfg.has_apb_agent=has_apb_agent;
	e_cfg.has_ahb_agent=has_ahb_agent;
	e_cfg.no_of_apb_agent=no_of_apb_agent;
	e_cfg.no_of_ahb_agent=no_of_ahb_agent;
	e_cfg.has_scoreboard = has_scoreboard;
  e_cfg.has_virtual_sequencer = has_virtual_sequencer;
endfunction


function void ahb_apb_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
  
endfunction

/*task ahb_apb_test::run_phase(uvm_phase phase);

  seq_ahb=base_ahb_seq::type_id::create("seq_ahb");
	phase.raise_objection(this);
  fork
  
    begin
      foreach(env.ahb_agt_toph.agnth[i])
      seq_ahb.start(env.ahb_agt_toph.agnth[i].seqrh);
    end

  join
 	phase.drop_objection(this);
endtask*/


class single_test extends ahb_apb_test;

  `uvm_component_utils(single_test)
  
  single_v_seq s_seq;
  
  extern function new (string name="single_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
 
endclass


function single_test::new(string name="single_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void single_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task single_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
   repeat(10)
     begin
        
         s_seq=single_v_seq::type_id::create("s_seq");
         s_seq.start(env.v_seqr);
         #100;
     end
  

          
    	phase.drop_objection(this);
endtask


class undef_test extends ahb_apb_test;

  `uvm_component_utils(undef_test)
  
  undef_v_seq un_seq;
  
  extern function new (string name="undef_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
 
endclass


function undef_test::new(string name="undef_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void undef_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task undef_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
 
    repeat(10)
       begin
           
            un_seq=undef_v_seq::type_id::create("un_seq");
            un_seq.start(env.v_seqr);
            #120;
       end

          
    	phase.drop_objection(this);
endtask
 
class inc_test extends ahb_apb_test;
 
 `uvm_component_utils(inc_test)
  
  inc_v_seq i_seq;
  
  extern function new (string name="inc_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
 
endclass


function inc_test::new(string name="inc_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void inc_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task inc_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
 
    repeat(10)
     begin
         
           i_seq=inc_v_seq::type_id::create("i_seq");
           i_seq.start(env.v_seqr);
            #120;
          end

    	phase.drop_objection(this);
endtask            


class wrap_test extends ahb_apb_test;

 `uvm_component_utils(wrap_test)
  
  wrap_v_seq w_seq;
  
  extern function new (string name="wrap_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
 
endclass


function wrap_test::new(string name="wrap_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void wrap_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task wrap_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
         
  repeat(10)
    begin

           w_seq=wrap_v_seq::type_id::create("w_seq");
           w_seq.start(env.v_seqr);
            #120;
     end

         
    	phase.drop_objection(this);
endtask


//////////////////////////////////////////////////////////////////////////////////////////////////////////




class seq_5_test extends ahb_apb_test;

 `uvm_component_utils(seq_5_test)
  
  seq5_v_seq v_seq_5;
  
  extern function new (string name="seq_5_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
 
endclass


function seq_5_test::new(string name="seq_5_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void seq_5_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction




task seq_5_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
         
  repeat(10)
    begin

           v_seq_5 = seq5_v_seq::type_id::create("v_seq_5");
           v_seq_5.start(env.v_seqr);
            #120;
     end

         
    	phase.drop_objection(this);
endtask


///////////////////////////////////////////////////////////////////////////////////////////////////
