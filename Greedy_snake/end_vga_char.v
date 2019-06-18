module end_vga_char(
			input Clk_40mhz,
			input RSTn,
			output end_Hsync_sig,
			output end_Vsync_sig,
			output [4:0] end_Vga_red,
			output [5:0] end_Vga_green,
			output [4:0] end_Vga_blue

    );

// 水平扫描参数的设定800*600 VGA
parameter LinePeriod =1056;           //行周期数
parameter H_SyncPulse=128;            //行同步脉冲（Sync a）
parameter H_BackPorch=88;             //显示后沿（Back porch b）
parameter H_ActivePix=800;            //显示时序段（Display interval c）
parameter H_FrontPorch=40;            //显示前沿（Front porch d）
parameter Hde_start=216;
parameter Hde_end=1016;


// 垂直扫描参数的设定800*600 VGA
parameter FramePeriod =628;           //列周期数
parameter V_SyncPulse=4;              //列同步脉冲（Sync o）
parameter V_BackPorch=23;             //显示后沿（Back porch p）
parameter V_ActivePix=600;            //显示时序段（Display interval q）
parameter V_FrontPorch=1;             //显示前沿（Front porch r）
parameter Vde_start=27;
parameter Vde_end=627;

  reg[10 : 0] x_cnt;
  reg[9 : 0]  y_cnt;
  reg hsync_r;
  reg vsync_r; 
  reg hsync_de;
  reg vsync_de;
  
  
  wire Clk_40mhz;


  
  
 

// 水平扫描计数
always @ (posedge Clk_40mhz)
       if(~RSTn)    x_cnt <= 1;
       else if(x_cnt == LinePeriod) x_cnt <= 1;
       else x_cnt <= x_cnt+ 1;
		 

// 水平扫描信号hsync,hsync_de产生
always @ (posedge Clk_40mhz)
   begin
       if(~RSTn) hsync_r <= 1'b1;
       else if(x_cnt == 1) hsync_r <= 1'b0;            //产生hsync信号
       else if(x_cnt == H_SyncPulse) hsync_r <= 1'b1;
		 
		 		 
	    if(~RSTn) hsync_de <= 1'b0;
       else if(x_cnt == Hde_start) hsync_de <= 1'b1;    //产生hsync_de信号
       else if(x_cnt == Hde_end) hsync_de <= 1'b0;	
	end


// 垂直扫描计数
always @ (posedge Clk_40mhz)
       if(~RSTn) y_cnt <= 1;
       else if(y_cnt == FramePeriod) y_cnt <= 1;
       else if(x_cnt == LinePeriod) y_cnt <= y_cnt+1;


// 垂直扫描信号vsync, vsync_de产生
always @ (posedge Clk_40mhz)
  begin
       if(~RSTn) vsync_r <= 1'b1;
       else if(y_cnt == 1) vsync_r <= 1'b0;    //产生vsync信号
       else if(y_cnt == V_SyncPulse) vsync_r <= 1'b1;
		 
	    if(1'b0) vsync_de <= 1'b0;
       else if(y_cnt == Vde_start) vsync_de <= 1'b1;    //产生vsync_de信号
       else if(y_cnt == Vde_end) vsync_de <= 1'b0;	 
  end	 


// ROM读第一个字地址产生模块
reg[4:0] word1_is_8;
reg[10:0] word1_rom_addra;
wire y_word1;
wire x_word1;
assign x_word1=(x_cnt >= 500 && x_cnt < 556) ? 1'b1 : 1'b0;        //第一个字体的X坐标的位置，字体宽度为56
assign y_word1=(y_cnt >= 300 && y_cnt < 375) ? 1'b1 : 1'b0;        //第一个字体的Y坐标的位置，字体宽度为75

 always @(posedge Clk_40mhz)
   begin
	  if (~RSTn) begin
	     word1_is_8<=7;
		  word1_rom_addra<=0;
	  end
	  else begin
		  if (vsync_r==1'b0) begin
		     word1_rom_addra<=0;
			  word1_is_8<=0;	
        end
		  else if((y_word1==1'b1) && (x_word1==1'b1)) begin //显示第一个字体
			   if (word1_is_8==0) begin
              word1_rom_addra<=word1_rom_addra+1'b1;
				  word1_is_8<=7;
				  end
            else begin
					word1_is_8<=word1_is_8-1'b1;
					word1_rom_addra<=word1_rom_addra;				  
				end
        end
        else begin
           word1_is_8<=7;  
			  word1_rom_addra<=word1_rom_addra;	
		  end	  
		end	  
  end     


// ROM读第二个字地址产生模块
reg[4:0] word2_is_8;
reg[10:0] word2_rom_addra;
wire y_word2;
wire x_word2;
assign x_word2=(x_cnt >= 650 && x_cnt < 706) ? 1'b1 : 1'b0;             //第二个字体的X坐标的位置，字体宽度为56
assign y_word2=(y_cnt >= 300 && y_cnt < 375) ? 1'b1 : 1'b0;             //第二个字体的Y坐标的位置，字体高度为75

 always @(posedge Clk_40mhz)
   begin
	  if (~RSTn) begin
	     word2_is_8<=7;
		  word2_rom_addra<=525;                            //第二个字体在ROM中的偏移量7*75字节
	  end
	  else begin
		  if (vsync_r==1'b0) begin
		     word2_rom_addra<=525;                         //第二个字体在ROM中的偏移量7*75         
			  word2_is_8<=7;	
        end
		  else if((y_word2==1'b1) && (x_word2==1'b1)) begin    //显示第二个字体
			   if (word2_is_8==0) begin
              word2_rom_addra<=word2_rom_addra+1'b1;
				  word2_is_8<=7;
				  end
            else begin
					word2_is_8<=word2_is_8-1'b1;
					word2_rom_addra<=word2_rom_addra;				  
				end
        end
        else begin
           word2_is_8<=7;  
			  word2_rom_addra<=word2_rom_addra;	
		  end	  
		end	  
  end  

// 延迟一个节拍,因为ROM的数据输出延迟地址一个时钟周期
reg [4:0] word1_num;
reg [4:0] word2_num;

 always @(posedge Clk_40mhz)
   begin
	  if (~RSTn) begin
	     word1_num<=0;
		  word2_num<=0;
	  end
	  else begin 
	     word1_num<=word1_is_8;
	     word2_num<=word2_is_8;	
     end
   end	  
 

// VGA数据输出
wire [4:0] vga_r_reg;
wire [4:0] vga_r_word1;
wire [4:0] vga_r_word2;
assign vga_r_word1 = {5{rom_data[word1_num]}};                 //显示单色的数据1
assign vga_r_word2 = {5{rom_data[word2_num]}};                 //显示单色的数据2
assign vga_r_reg = (x_word1==1'b1) ?  vga_r_word1 : vga_r_word2;
  

// ROM实例化
wire [10:0] rom_addra;
wire [7:0] rom_data;
assign rom_addra=(x_word1==1'b1) ? word1_rom_addra : word2_rom_addra; //rom的地址选择          

	end_rom U1 (
	  .clka(Clk_40mhz), // input clka
	  .addra(rom_addra), // input [10 : 0] addra
	  .douta(rom_data) // output [7 : 0] douta
	);
	
	
	
  assign end_Hsync_sig = hsync_r;
  assign end_Vsync_sig = vsync_r;  
  assign end_Vga_red = (((y_word1==1'b1) && (x_word1==1'b1)) | ((y_word2==1'b1) && (x_word2==1'b1))) ? vga_r_reg:5'b00000;
  assign end_Vga_green = (hsync_de & vsync_de) ? 6'b00011 : 6'b000000;
  assign end_Vga_blue = (hsync_de & vsync_de) ? 5'b00011 : 5'b00000;
  
  
  

 
endmodule
