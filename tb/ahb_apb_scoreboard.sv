class ahb_apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(ahb_apb_scoreboard)
  
  
  uvm_tlm_analysis_fifo #(ahb_xtns) fifo_ahb[];
	uvm_tlm_analysis_fifo #(apb_xtns) fifo_apb[];
 
  ahb_xtns ahb_data;
	apb_xtns apb_data;
 
  ahb_xtns ahb_cov;
	apb_xtns apb_cov;
  
  
  ahb_apb_env_config e_cfg;
  
  ahb_xtns q[$]; //queue is used to push data ahb to apb to compare it with apb
  
  covergroup cg_ahb_cov;
      option.per_instance = 1;
      
        SIZE  : coverpoint ahb_cov.Hsize {bins H1[] = {[0:2]};}  //1,2,4  byts of data
        
        TRANS:  coverpoint ahb_cov.Htrans {bins trans[] = {[2:3]} ;}//NS and S
        
        BURST: coverpoint ahb_cov.Hburst {bins burst[] = {[0:7]} ;}
        
        ADDR: coverpoint ahb_cov.Haddr {bins addr_1 = {[32'h8000_0000:32'h8000_03ff]} ;
                                        bins addr_2 = {[32'h8400_0000:32'h8400_03ff]};
                                        bins addr_3 = {[32'h8800_0000:32'h8800_03ff]};
                                        bins  addr_4 = {[32'h8C00_0000:32'h8C00_03ff]};}
                                                     
  endgroup : cg_ahb_cov
  
   covergroup cg_apb_cov;
      option.per_instance = 1;
      
            ADDR: coverpoint apb_cov.Paddr  {  bins addr_1 = {[32'h8000_0000:32'h8000_03ff]};
                                               bins addr_2 = {[32'h8400_0000:32'h8400_03ff]};
                                               bins addr_3 = {[32'h8800_0000:32'h8800_03ff]};
                                               bins  addr_4 = {[32'h8C00_0000:32'h8C00_03ff]};}
                                               
           SEL : coverpoint apb_cov.Pselx {bins sel_1 = {4'b0001};
                                           bins sel_2 = {4'b0010};
                                           bins sel_3 = {4'b0100};
                                           bins sel_4 = {4'b1000};}
                                           
   endgroup : cg_apb_cov
                                 
    
  
  
  extern function new(string name="ahb_apb_scoreboard",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
      extern task run_phase(uvm_phase phase);
      extern task user_compare (apb_xtns h2);
      
      
endclass

function ahb_apb_scoreboard::new(string name="ahb_apb_scoreboard",uvm_component parent);
   super.new(name,parent);
   ahb_data = new();
   apb_data = new();

   cg_ahb_cov = new();
   cg_apb_cov = new();
   
endfunction
 
 
 function void ahb_apb_scoreboard::build_phase(uvm_phase phase);
 
   super.build_phase(phase);
        
        
        if(!uvm_config_db #(ahb_apb_env_config)::get(this, "", "ahb_apb_env_config", e_cfg))
	          	`uvm_fatal("CONFIG", "Cannot get() e_cfg, have you set() it?")

          fifo_ahb = new[e_cfg.no_of_ahb_agent];
        	fifo_apb = new[e_cfg.no_of_apb_agent];
         
         
         foreach(fifo_ahb[i])
            		fifo_ahb[i] = new($sformatf("fifo_ahb[%0d]",i), this);
            
        	foreach(fifo_apb[i])
                 	fifo_apb[i] = new($sformatf("fifo_apb[%0d]",i), this);
                  
             
            	
	
endfunction



task ahb_apb_scoreboard::run_phase(uvm_phase phase);

	fork
		
		begin
		forever
			begin
				fifo_ahb[0].get(ahb_data);
				q.push_back(ahb_data);
        `uvm_info("ahb_apb_scoreboard",$sformatf("ahb_data printing from scoreboard \n %s",ahb_data.sprint),UVM_LOW);
 
			
				ahb_cov = ahb_data;
				cg_ahb_cov.sample();
			end
		end

		begin
		forever
			begin		
				fifo_apb[0].get(apb_data);
        `uvm_info("ahb_apb_scoreboard",$sformatf("apb_data printing from scoreboard \n %s",apb_data.sprint),UVM_LOW);

				user_compare(apb_data);
				
				apb_cov = apb_data;
				cg_apb_cov.sample();
			end
		end


	join
 
 	
endtask



task ahb_apb_scoreboard::user_compare(apb_xtns h2);

     ahb_data = q.pop_front();
     //$display("a1");
     
     if(ahb_data.Hwrite)
         begin
             if(ahb_data.Hsize==2'b00)
                     begin
                       if(ahb_data.Haddr[1:0] == 2'b00)
                          begin
                         if(ahb_data.Hwdata[7:0] == h2.Pwdata[7:0])
                            begin
                              `uvm_info("ahb_apb_scoreboard",$sformatf("Data  compare Successful HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          else
                                begin
                              `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                          end
                         end
                          
                          if(ahb_data.Haddr[1:0] == 2'b01)
                         begin
                          if(ahb_data.Hwdata[15:8] == h2.Pwdata[7:0])
                                begin
                               `uvm_info("ahb_apb_scoreboard",$sformatf("Data  compare Successful HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          else
                                begin
                             `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          end
                          
                          if(ahb_data.Haddr[1:0] == 2'b10)
                         begin
                          if(ahb_data.Hwdata[23:16] == h2.Pwdata[7:0])
                                begin
                               `uvm_info("ahb_apb_scoreboard",$sformatf("Data  compare Successful HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          else
                                begin
                             `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          end
                          
                          if(ahb_data.Haddr[1:0] == 2'b11)
                         begin
                          if(ahb_data.Hwdata[31:24] == h2.Pwdata[7:0])
                                begin
                             `uvm_info("ahb_apb_scoreboard",$sformatf("Data  compare Successful HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          else
                                begin
                               `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          end
                          
                      end
                      
                      
                else if(ahb_data.Hsize==2'b01)
                     begin
                       if(ahb_data.Haddr[1:0] == 2'b00)
                         begin
                          if(ahb_data.Hwdata[15:0] == h2.Pwdata[15:0])
                                begin
                               `uvm_info("ahb_apb_scoreboard",$sformatf("Data  compare Successful HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          else
                                begin
                              `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          end
                          
                          if(ahb_data.Haddr[1:0] == 2'b10)
                         begin
                          if(ahb_data.Hwdata[31:16] == h2.Pwdata[15:0])
                                begin
                              `uvm_info("ahb_apb_scoreboard",$sformatf("Data  compare Successful HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                              end
                          else
                                begin
                             `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          end            
                       end
                       
                else if(ahb_data.Hsize==2'b10)
                     begin
                       if(ahb_data.Haddr[1:0] == 2'b00)
                         begin
                          if(ahb_data.Hwdata[31:0] == h2.Pwdata[31:0])
                                begin
                                `uvm_info("ahb_apb_scoreboard",$sformatf("Data  compare Successful HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          else
                                begin
                            `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HDATA=%0h and PDATA=%0h  \n",ahb_data.Hwdata,h2.Pwdata),UVM_LOW)
                                end
                          end
                          
                     end
                end

     else
         //read data compar
          begin
            if(ahb_data.Hsize==2'b00)
                    begin
                      if(ahb_data.Haddr[1:0] == 2'b00)
                        begin
                         if(ahb_data.Hrdata[7:0] == h2.Prdata[7:0])
                           begin
                               `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare  Successful HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
                               end
                         else
                               begin
                            `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
	 
                               end
                         end
                      
                         
                         if(ahb_data.Haddr[1:0] == 2'b01)
                        begin
                         if(ahb_data.Hrdata[7:0] == h2.Prdata[15:8])
                               begin
                                `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare  Successful HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
                               end
                         else
                               begin
                             `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
	 
                               end
                         end
                      
                         
                         if(ahb_data.Haddr[1:0] == 2'b10)
                        begin
                         if(ahb_data.Hrdata[7:0] == h2.Prdata[23:16])
                               begin
                               `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare  Successful HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
                               end
                         else
                               begin
                            `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
	 
                               end
                         end
                      
                         
                         if(ahb_data.Haddr[1:0] == 2'b11)
                        begin
                         if(ahb_data.Hrdata[7:0] == h2.Prdata[31:24])
                               begin
                                `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare  Successful HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
                               end
                         else
                               begin
                             `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
	 
                               end
                         end
                         
                     end
                     
                     
               else if(ahb_data.Hsize==2'b01)
                    begin
                      if(ahb_data.Haddr[1:0] == 2'b00)
                        begin
                         if(ahb_data.Hrdata[15:0] == h2.Prdata[15:0])
                               begin
                                `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare  Successful HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
                               end
                         else
                               begin
                             `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
	 
                               end
                         end
                      
                         
                         if(ahb_data.Haddr[1:0] == 2'b10)
                        begin
                         if(ahb_data.Hrdata[15:0] == h2.Prdata[31:16])
                               begin
                               `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare  Successful HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
                               end
                         else
                               begin
                             `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
	 
                               end
                         end            
                      end
                      
               else if(ahb_data.Hsize==2'b10)
                    begin
                      if(ahb_data.Haddr[1:0] == 2'b00)
                        begin
                         if(ahb_data.Hrdata[31:0] == h2.Prdata[31:0])
                               begin
                                `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare  Successful HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
                               end
                         else
                               begin
                             `uvm_info("ahb_apb_scoreboard",$sformatf("Data compare Failure HRDATA=%0h and PRDATA=%0h  \n",ahb_data.Hrdata,h2.Prdata),UVM_LOW)
	 
                               end
                         end
                         
                    end 
                    
                end     
endtask
