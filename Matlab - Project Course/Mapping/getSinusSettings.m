function settings = getSinusSettings()
% Settings used for generating sinus signal and in intensity2LEDinput
%
% Syntax:  settings = getSinusSettings()
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
% December 2018; Last revision: 11-December-2018
%------------- BEGIN CODE --------------
settings =                  struct();
settings.LEDs =             [380 400 420  450 530 620 660 735 5700];

% We only want in the fluoresence spectrum i.e. 420 or 450 nm
settings.spectrum =         [0 0 1 0 0 0 0 0 0];   

settings.sweepingsMatrix =  'Sweeping_RX2018-11-27-1414.mat';
settings.lamp_ip =          '192.168.100.102'; 
settings.lamp_ID =           "RX";

settings.period =         60;           % period time in seconds
settings.amplitude =      10;           % amplitude of excitation signal given in uE 
settings.meanvalue =      40;           % The meanvalue of the sinus

end