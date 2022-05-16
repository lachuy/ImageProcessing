module Median_Filter#
  (parameter row = 554, col = 430)
  (input            clk,
  input signed[31:0]pixel,
  input       [7:0] data_in_0, data_in_1, data_in_2,
  input       [7:0] data_in_3, data_in_4, data_in_5,
  input       [7:0] data_in_6, data_in_7, data_in_8,
  output            done,
  output reg  [7:0]data_filtered);
  
  parameter angle0=0, angle1=1, angle2=2, angle3=3, 
            top_edge=4, bot_edge=5, left_edge=6, right_edge=7, 
            full_area=8;
            
  reg         [3:0]area;
  
  function [7:0] filter_3;
    input  [7:0]e_0;
    input  [7:0]e_1;
    input  [7:0]e_2;
    begin
      if(e_0 >= e_2 && e_0 <= e_1)
		    filter_3 = e_0;
		  else if(e_0 >= e_1 && e_0 <= e_2)
		    filter_3 = e_0;
	    else if(e_1 >= e_0 && e_1 <= e_2)
		    filter_3 = e_1;
	    else if(e_1 >= e_2 && e_1 <= e_0)
		    filter_3 = e_1;
	    else if(e_2 >= e_0 && e_2 <= e_1)
		    filter_3 = e_2;
	    else if(e_2 >= e_1 && e_2 <= e_0)
		    filter_3 = e_2;
    end
  endfunction
    
  function  [7:0] filter_9;
    input	  [7:0] e0_0;
    input	  [7:0] e0_1;
    input	  [7:0] e0_2;
    input	  [7:0] e1_0;
    input	  [7:0] e1_1;
    input	  [7:0] e1_2;
    input	  [7:0] e2_0;
    input	  [7:0] e2_1;
    input	  [7:0] e2_2;
    
    reg   	 [7:0] median_1;
    reg     [7:0] median_2;
    reg     [7:0] median_3;
    begin
      median_1 = filter_3(e0_0, e0_1, e0_2);
      median_2 = filter_3(e1_0, e1_1, e1_2);
      median_3 = filter_3(e2_0, e2_1, e2_2);
      filter_9 = filter_3(median_1, median_2, median_3);
    end
  endfunction 
  
  always@(posedge clk)
  begin
    if( pixel==0 ) 
      begin
        area = angle0;
      end
    else begin
      if( pixel==(row-1) )
        begin
          area = angle1;
        end
      else begin
        if( pixel==(row*(col-1)) )
          begin
            area = angle2;
          end
        else begin
          if( pixel==(row*col-1) )
            begin
              area = angle3;
            end
          else begin
            if( (pixel%row)==0 && pixel>0 && pixel<(row*(col-1)) )
              begin
                area = top_edge;
              end
            else begin
              if( ((pixel+1)%row)==0 && pixel>(row-1) && pixel<(row*col-1) )
                begin
                  area = bot_edge;
                end
              else begin
                if( pixel>=1 && pixel<=(row-2) )
                  begin
                   	area = left_edge;
                 	end
                else begin
                  if( pixel>=(row*(col-1)+1) && pixel<=(row*col-2) )
                    begin
                      area = right_edge;
                    end
                  else begin
                      area = full_area;
                    end
                end
              end
            end
          end
        end
      end
    end

    case (area)
      angle0:
      begin
        data_filtered = filter_9(data_in_4, data_in_4, data_in_5,
                                 data_in_4, data_in_4, data_in_5,
                                 data_in_7, data_in_7, data_in_8);
      end
        
      angle1:
      begin
        data_filtered = filter_9(data_in_1, data_in_1, data_in_2,
                                 data_in_4, data_in_4, data_in_5,
                                 data_in_4, data_in_4, data_in_5);
      end
        
      angle2:
      begin
        data_filtered = filter_9(data_in_3, data_in_4, data_in_4,
                                 data_in_3, data_in_4, data_in_4,
                                 data_in_6, data_in_7, data_in_7);
      end
        
      angle3:
      begin
        data_filtered = filter_9(data_in_0, data_in_1, data_in_1,
                                 data_in_3, data_in_4, data_in_4,
                                 data_in_3, data_in_4, data_in_4);
      end
      
      top_edge:
      begin
        data_filtered = filter_9(data_in_3, data_in_4, data_in_5,
                                 data_in_3, data_in_4, data_in_5,
                                 data_in_6, data_in_7, data_in_8);
      end
        
      bot_edge:
      begin
        data_filtered = filter_9(data_in_0, data_in_1, data_in_2,
                                 data_in_3, data_in_4, data_in_5,
                                 data_in_3, data_in_4, data_in_5);
      end
        
      left_edge:
      begin
        data_filtered = filter_9(data_in_1, data_in_1, data_in_2,
                                 data_in_4, data_in_4, data_in_5,
                                 data_in_7, data_in_7, data_in_8);
      end
        
      right_edge:
      begin
        data_filtered = filter_9(data_in_0, data_in_1, data_in_1,
                                 data_in_3, data_in_4, data_in_4,
                                 data_in_6, data_in_7, data_in_7);
      end
      
      full_area:
      begin
        data_filtered = filter_9(data_in_0, data_in_1, data_in_2,
                                 data_in_3, data_in_4, data_in_5,
                                 data_in_6, data_in_7, data_in_8);
      end
    endcase 
  end
  
    assign done = (pixel>=row*col) ? 1 : 0;           
endmodule
