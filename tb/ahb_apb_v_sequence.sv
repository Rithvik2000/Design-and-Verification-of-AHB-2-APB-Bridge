class ahb_apb_v_sequence extends uvm_sequence;

  `uvm_object_utils(ahb_apb_v_sequence)
  
  ahb_sequencer  ahb_seqr[];
  //apb_sequencer apb_seqr[];
  
  ahb_apb_v_sequencer v_seqr;
  ahb_apb_env_config m_cfg;
  
  
  extern function new(string name="ahb_apb_v_sequence");
  
  extern task body();
  
  
endclass

function ahb_apb_v_sequence::new(string name="ahb_apb_v_sequence");
   super.new(name);
endfunction

task ahb_apb_v_sequence::body();

       if(!uvm_config_db #(ahb_apb_env_config)::get(null,get_full_name(),"ahb_apb_env_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
    		 
		
		    ahb_seqr = new[m_cfg.no_of_ahb_agent];
		   // apb_seqr = new[m_cfg.no_of_apb_agent];
            
            
            assert($cast(v_seqr,m_sequencer))
              else
              	begin
              	`uvm_error("body","error in $cast of virtual sequencer")
              	end
             
             
              foreach(ahb_seqr[i])
                     begin
              	        ahb_seqr[i]=v_seqr.ahb_seqr[i];
                     end
             /* foreach(apb_seqr[i])
                     begin
                        apb_seqr[i]=v_seqr.apb_seqr[i];
                      end*/
              
endtask


    
class single_v_seq extends ahb_apb_v_sequence;
	
  `uvm_object_utils(single_v_seq)
  
  single_ahb_seq  single_seq;
  
  extern function new(string name="single_v_seq");
	extern task body();
endclass

function single_v_seq::new(string name="single_v_seq");
	super.new(name);
endfunction


task single_v_seq::body();
      
      super.body();

        if(m_cfg.has_ahb_agent)
        begin
               single_seq =single_ahb_seq::type_id::create("single_seq");
                single_seq.start(ahb_seqr[0]);
        end

endtask


class undef_v_seq extends ahb_apb_v_sequence;
	
  `uvm_object_utils(undef_v_seq)
  
  undef_ahb_seq  undef_seq;
  
  extern function new(string name="undef_v_seq");
	extern task body();
endclass

function undef_v_seq::new(string name="undef_v_seq");
	super.new(name);
endfunction


task undef_v_seq::body();
      
      super.body();

        if(m_cfg.has_ahb_agent)
        begin
               undef_seq =undef_ahb_seq::type_id::create("undef_seq");
                undef_seq.start(ahb_seqr[0]);
        end

endtask

class inc_v_seq extends ahb_apb_v_sequence;
	
  `uvm_object_utils(inc_v_seq)
  
  inc_ahb_seq  inc_seq;
  
  extern function new(string name="inc_v_seq");
	extern task body();
endclass

function inc_v_seq::new(string name="inc_v_seq");
	super.new(name);
endfunction


task inc_v_seq::body();
      
      super.body();

        if(m_cfg.has_ahb_agent)
        begin
               inc_seq =inc_ahb_seq::type_id::create("inc_seq");
                inc_seq.start(ahb_seqr[0]);
        end

endtask


class wrap_v_seq extends ahb_apb_v_sequence;
	
  `uvm_object_utils(wrap_v_seq)
  
  wrap_ahb_seq  wrap_seq;
  
  extern function new(string name="wrap_v_seq");
	extern task body();
endclass

function wrap_v_seq::new(string name="wrap_v_seq");
	super.new(name);
endfunction


task wrap_v_seq::body();
      
      super.body();

        if(m_cfg.has_ahb_agent)
        begin
               wrap_seq =wrap_ahb_seq::type_id::create("wrap_seq");
                wrap_seq.start(ahb_seqr[0]);
        end

endtask

////////////////////////////////////////////////////


class seq5_v_seq extends ahb_apb_v_sequence;
	
  `uvm_object_utils(seq5_v_seq)
  
  ahb_seq_5 seq_5;
  
  extern function new(string name="seq5_v_seq");
	extern task body();
endclass

function seq5_v_seq::new(string name="seq5_v_seq");
	super.new(name);
endfunction


task seq5_v_seq::body();
      
      super.body();

        if(m_cfg.has_ahb_agent)
        begin
               seq_5 = ahb_seq_5::type_id::create("seq_5");
                seq_5.start(ahb_seqr[0]);
        end

endtask

//////////////////////////////////////////