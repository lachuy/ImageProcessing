`timescale 100ns/10ns
module Median_Filter_tb;

  parameter row = 554, col = 430;
  integer   f;
  
  reg             clk, write, start;
  reg       [7:0] mem_in[row*col-1:0];
  reg signed[31:0]pixel;
  
  wire[7:0]data_filtered;
  wire done;
  
  initial
  begin
    $readmemh("pic_input.txt",mem_in);
    f = $fopen("pic_output.txt","w");
  end
  
  initial
  begin
    pixel = 0;
    clk   = 0;
    start = 0;
    write = 0;
    #0.4 start = ~start;
    #0.2 write = ~write;
  end
  
  Median_Filter mf(.data_in_0(mem_in[pixel-row-1]), .data_in_1(mem_in[pixel-1]), .data_in_2(mem_in[pixel+row-1]),
                   .data_in_3(mem_in[pixel-row]), .data_in_4(mem_in[pixel]), .data_in_5(mem_in[pixel+row]),
                   .data_in_6(mem_in[pixel-row+1]), .data_in_7(mem_in[pixel+1]), .data_in_8(mem_in[pixel+row+1]),
                   .data_filtered, .done,
                   .pixel, .clk);
  
  always 
  begin 
    #0.2 clk = ~clk; 
  end  
  
  always@(posedge clk)
  begin
    if(start)
      begin
        pixel = pixel+1;
      end
      
    if(write)
      begin
        $fwrite(f,"%x\n",data_filtered);
      end
      
    if(done)
      begin
        $fclose(f);
        write = 0;
      end
  end          
endmodule