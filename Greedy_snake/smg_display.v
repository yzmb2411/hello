module Smg_display_module//数码管计分显示模块
(
	input Clk_50mhz,//50M时钟
	input Rst_n,//全局复位信号
	
	input Body_add_sig,//身体增长信号
	input [2:0] Game_status,//3种游戏状态，START：001；PLAY：010；END：100；
	
	output reg [7:0] Smg_duan,//数码管段选
	output reg [1:0] Smg_we//数码管位选
);
	reg [7:0] Points;//分数，用来显示在数码管
	reg [31:0] Count1;//32位的计数器
	
	
	parameter   END = 3'b100;
	
	
	always@(posedge Clk_50mhz or negedge Rst_n)
	begin
		if(!Rst_n)
		begin
			Smg_duan <= 8'd0;
			Count1 <= 32'd0;
			Smg_we <= 2'b00;	
		end
		else
		begin
			if(Count1 == 32'd5_0000)//如果时间达到1ms
			begin
				Smg_we <= 2'b10;//选通1位数码管，用来显示个位的分数,0是选通
				Count1 <= Count1 + 32'd1;//这里再进行计数器加一，否则不能正常计数，只会停留在第一个数码管这里显示
				case(Points[3:0])//个位的数字
					4'b0000:
								Smg_duan <= 8'b1100_0000;
					4'b0001:
								Smg_duan <= 8'b1111_1001;
					4'b0010:
								Smg_duan <= 8'b1010_0100;
					
					4'b0011:
								Smg_duan <= 8'b1011_0000;
					4'b0100:
								Smg_duan <= 8'b1001_1001;
					4'b0101:
								Smg_duan <= 8'b1001_0010;
					
					4'b0110:
								Smg_duan <= 8'b1000_0010;
					4'b0111:
								Smg_duan <= 8'b1111_1000;
					4'b1000:
								Smg_duan <= 8'b1000_0000;
					4'b1001:
								Smg_duan <= 8'b1001_0000;
				endcase
			end
			else if(Count1 == 32'd10_0000)//如果时间达到2ms
					begin
						Smg_we <= 2'b01;//注意0是选通
						Count1 <= 32'd0;//这里再进行计数器加一，否则不能正常计数
						case(Points[7:4])//十位的数字
							4'b0000:
											Smg_duan <= 8'b1100_0000;
							4'b0001:
											Smg_duan <= 8'b1111_1001;
							4'b0010:
											Smg_duan <= 8'b1010_0100;
							
							4'b0011:
											Smg_duan <= 8'b1011_0000;
							4'b0100:
											Smg_duan <= 8'b1001_1001;
							4'b0101:
											Smg_duan <= 8'b1001_0010;
							
							4'b0110:
											Smg_duan <= 8'b1000_0010;
							4'b0111:
											Smg_duan <= 8'b1111_1000;
							4'b1000:
											Smg_duan <= 8'b1000_0000;
							4'b1001:
											Smg_duan <= 8'b1001_0000;							
						endcase
					end
							
			else
				Count1 <= Count1 + 32'd1;
		end	
	end
	
	
	reg Eaten_sig;//吃苹果信号
	
	always @ (posedge Clk_50mhz or negedge Rst_n)
	begin
		if(!Rst_n)
		begin
			Points <= 8'd0;
			Eaten_sig <= 1'd0;
		end
		else if(Game_status == END)
				Points <= 8'd0;
		else 
		begin
			case(Eaten_sig)
				1'd0		:
				begin
					if(Body_add_sig)//下面是BCD码的转换
					begin
						if(Points[3:0] < 4'd9)
							Points[3:0] <= Points[3:0] + 4'd1;
						else
						begin
							Points[3:0] <= 4'd0;//把个位清零
							if(Points[7:4] < 4'd9)
								Points[7:4] <= Points[7:4] + 4'd1;
							else
				            Points[7:4] <= 4'd0;
						end								
						Eaten_sig <= 1'd1;//这里使代码进行下一步的执行
					end
				end
				1'd1		:
					if(!Body_add_sig)//等待身体增长信号恢复0
						Eaten_sig <= 1'd0;	
			endcase
		end							
	end	
		
endmodule
