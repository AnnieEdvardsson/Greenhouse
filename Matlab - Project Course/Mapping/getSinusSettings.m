function [settings] = getSinusSettings()
% Settings used for generating sinus signal and in intensity2LEDinput
%
% Syntax:  [settings] = getSinusSettings()
%
% Inputs:
%    None
%
% Outputs:
%    settings - A scruct of settings
%
%
% Other m-files required: None
% MAT-files required: None
% Other requirments:None
%
% December 2019; Last revision: 03-December-2019
%------------- BEGIN CODE --------------
settings = struct();
settings.LEDs = [380 400 420  450 530 620 660 735 5700];
%settings.spectrum = [0 0 0.2 0.2 0.3 0.3 0.3 0.5 0];
settings.spectrum = [0 0 0 0 0 0.3 0.3 0.4 0];
settings.sweepingsMatrix = 'Sweeping_RX2018-11-27-1414.mat';
settings.lamp_ip = '192.168.100.102'; 

s_settings.period_t    = 60;               % period time in seconds, could be one value or a vector of length(wavelengths)
s_settings.amplitude  = 10;                % amplitude of excitation signal given in uE 
s_settings.step_length = 1;


end