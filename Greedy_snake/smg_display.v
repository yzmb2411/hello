module Smg_display_module//����ܼƷ���ʾģ��
(
	input Clk_50mhz,//50Mʱ��
	input Rst_n,//ȫ�ָ�λ�ź�
	
	input Body_add_sig,//���������ź�
	input [2:0] Game_status,//3����Ϸ״̬��START��001��PLAY��010��END��100��
	
	output reg [7:0] Smg_duan,//����ܶ�ѡ
	output reg [1:0] Smg_we//�����λѡ
);
	reg [7:0] Points;//������������ʾ�������
	reg [31:0] Count1;//32λ�ļ�����
	
	
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
			if(Count1 == 32'd5_0000)//���ʱ��ﵽ1ms
			begin
				Smg_we <= 2'b10;//ѡͨ1λ����ܣ�������ʾ��λ�ķ���,0��ѡͨ
				Count1 <= Count1 + 32'd1;//�����ٽ��м�������һ������������������ֻ��ͣ���ڵ�һ�������������ʾ
				case(Points[3:0])//��λ������
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
			else if(Count1 == 32'd10_0000)//���ʱ��ﵽ2ms
					begin
						Smg_we <= 2'b01;//ע��0��ѡͨ
						Count1 <= 32'd0;//�����ٽ��м�������һ����������������
						case(Points[7:4])//ʮλ������
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
	
	
	reg Eaten_sig;//��ƻ���ź�
	
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
					if(Body_add_sig)//������BCD���ת��
					begin
						if(Points[3:0] < 4'd9)
							Points[3:0] <= Points[3:0] + 4'd1;
						else
						begin
							Points[3:0] <= 4'd0;//�Ѹ�λ����
							if(Points[7:4] < 4'd9)
								Points[7:4] <= Points[7:4] + 4'd1;
							else
				            Points[7:4] <= 4'd0;
						end								
						Eaten_sig <= 1'd1;//����ʹ���������һ����ִ��
					end
				end
				1'd1		:
					if(!Body_add_sig)//�ȴ����������źŻָ�0
						Eaten_sig <= 1'd0;	
			endcase
		end							
	end	
		
endmodule
