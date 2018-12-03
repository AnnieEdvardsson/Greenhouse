function [settings] = getSettings()
settings = struct();
settings.LEDs = [380 400 420  450 530 620 660 735 5700];
%settings.spectrum = [0 0 0.2 0.2 0.3 0.3 0.3 0.5 0];
settings.spectrum = [0 0 0 0 0 0.3 0.3 0.4 0];
settings.sweepingsMatrix = 'Sweeping_RX2018-11-27-1414.mat';
settings.lamp_ip = '192.168.100.102'; 


end