module start_and_end
(
	input Clk_40mhz,
	input RSTn,

	input [2:0] Game_status,//3÷÷”Œœ∑◊¥Ã¨£¨START£∫001£ªPLAY£∫010£ªEND£∫100£ª
		
	input play_VGA_red,
	input play_VGA_green,
	input play_VGA_blue,
	input play_HSYNC_sig,
	input play_VSYNC_sig,	
		
	output VSYNC_Sig_out,
	output HSYNC_Sig_out,
	output VGA_red_out,
	output VGA_green_out,
	output VGA_blue_out
);
	wire start_Vga_red;
	wire start_Hsync_sig;
	wire start_Vsync_sig;
	wire start_Vga_green;
	wire start_Vga_blue;
	
	wire end_Vsync_sig;
	wire end_Hsync_sig;
	wire end_Vga_red;
	wire end_Vga_blue;
	wire end_Vga_green;
	

	
	start_vga_char	start_top		
(								
	.Clk_40mhz(Clk_40mhz),				
	.RSTn(RSTn),					
	.start_Vga_green(start_Vga_green),			
	.start_Vga_blue(start_Vga_blue),			
	.start_Vga_red(start_Vga_red),
	.start_Hsync_sig(start_Hsync_sig),
	.start_Vsync_sig(start_Vsync_sig)
);

	end_vga_char		end_top	
(								
	.Clk_40mhz(Clk_40mhz),					
	.RSTn(RSTn),					
	.end_Vga_green(end_Vga_green),			
	.end_Vga_blue(end_Vga_blue),			
	.end_Vga_red(end_Vga_red),
	.end_Hsync_sig(end_Hsync_sig),
	.end_Vsync_sig(end_Vsync_sig)
);
	

	
	vga_select_module 	vga_select_module
(
	.play_VSYNC_Sig(play_VSYNC_sig),
	.play_HSYNC_Sig(play_HSYNC_sig),
	.play_VGA_red(play_VGA_red),
	.play_VGA_green(play_VGA_green),
	.play_VGA_blue(play_VGA_blue),
	.end_VSYNC_Sig(end_Vsync_sig),
	.end_HSYNC_Sig(end_Hsync_sig),
	.end_VGA_red(end_Vga_red),
	.end_VGA_green(end_Vga_green),
	.end_VGA_blue(end_Vga_blue),
	.start_VGA_green(start_Vga_green),		
	.start_VGA_blue(start_Vga_blue),			
	.start_VGA_red(start_Vga_red),
	.start_HSYNC_Sig(start_Hsync_sig),
	.start_VSYNC_Sig(start_Vsync_sig),
	.Game_status(Game_status),
	.VSYNC_Sig_out(VSYNC_Sig_out),
	.HSYNC_Sig_out(HSYNC_Sig_out),
	.VGA_red_out(VGA_red_out),
	.VGA_green_out(VGA_green_out),
	.VGA_blue_out(VGA_blue_out)
);
	
	
		
	
	
	
endmodule
