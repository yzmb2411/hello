

 
 
 




window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"

      waveform add -signals /start_rom_tb/status
      waveform add -signals /start_rom_tb/start_rom_synth_inst/bmg_port/CLKA
      waveform add -signals /start_rom_tb/start_rom_synth_inst/bmg_port/ADDRA
      waveform add -signals /start_rom_tb/start_rom_synth_inst/bmg_port/DOUTA

console submit -using simulator -wait no "run"
