function flourLEDSignal =  sinusSignal(meanvalue, t)
%
% Syntax:  
%
% Inputs:
%     - None
%
% Outputs:
%     - None
%
%
% Other m-files required: none
% MAT-files required: none
%
% December 2018; Last revision: 03-December-2018
%------------- BEGIN CODE --------------

%% Add path so it finds intensity2LEDinput function
addpath(genpath('..\Mapping'))
addpath(genpath('\AM_Sweeping'))

%% Load settings 
settings.conv = getSinusSettings();
period = settings.conv.period;          % period time in seconds, could be one value or a vector of length(wavelengths)
amplitude = settings.conv.amplitude;    % amplitude of excitation signal given in uE 


%%
desired_intensity = meanvalue + amplitude.* (sin(2*pi*1./period.*t));

ledIN = intensity2LEDinput(desired_intensity, settings.conv.lamp_ip);

%% Calculate fluorsence value 
flourLEDSignal = desired_intensity; % THIS IS WRONG
