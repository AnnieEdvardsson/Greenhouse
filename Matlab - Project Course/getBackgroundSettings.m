function settings = getBackgroundSettings()
% Settings used for generating background light
%
% Syntax:  settings = getBackgroundSettings()
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
% December 2018; Last revision: 13-December-2018
%------------- BEGIN CODE --------------
settings =                  struct();
settings.LEDs =             [450 451 660 661 5700 5701];
settings.spectrum =         [0.6 0.6 0.4 0.4 0 0]; % - 40% blue, 60% red
settings.sweepingsMatrix =  'Sweeping_LX2018-12-18-1059.mat';
settings.lamp_ip =          '192.168.100.101'; 
settings.lamp_ID =           "LX";

end