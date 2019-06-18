module Game_ctrl_module//��Ϸ����ģ��
(
	input Clk_50mhz,//��Ƶ���50MHZʱ��
	input Rst_n,//ȫ�ָ�λ�ź�
	input Key_left,//�󰴼�
	input Key_right,//�Ұ���
	input Key_up,//�ϰ���
	input Key_down,//�°���
	input Hit_wall_sig,//ײǽ�ź�
	input Hit_body_sig,//ײ�������ź�
	output reg  [2:0] Game_status,//3����Ϸ״̬��START��001��PLAY��010��END��100��
	output reg Flash_sig//FLASH�ź�	
);

	//3����Ϸ״̬	
	parameter START = 3'b001;
	parameter  PLAY = 3'b010;
	parameter   END = 3'b100;
	
	always @ (posedge Clk_50mhz or negedge Rst_n)
	begin
		if(!Rst_n)
		begin
			Game_status <= START;;//��λ��ʱ�򣬷���START״̬
			Flash_sig <= 1'd1;
			
		end
		else
		begin
			Game_status <= START;
			case(Game_status)//ѡ����Ϸ״̬
				START://��START״̬�������һ���������£���PLAY״̬
							begin	
								if(Key_left | Key_right | Key_up | Key_down)
								begin		
									Game_status <= PLAY;
								end
								else
									Game_status <= START;//��������������
							end
					 
	
				PLAY://PLAY״̬�����ײǽ���������Լ����壬��END״̬
						begin
							if(Hit_wall_sig | Hit_body_sig)
							begin		
								Game_status <= END;								
							end
							else
								Game_status <= PLAY;
						end
	
	
				END://END״̬����Ϸ����
					begin
						if(Key_left | Key_right | Key_up | Key_down)
						begin
							Game_status <= START;
							Flash_sig <= 1'd1;
						end
						else
						begin
							Game_status <= END;
							Flash_sig <= 1'd1;
						end		
					end
			endcase
		end
	end
	
	endmodule
	

