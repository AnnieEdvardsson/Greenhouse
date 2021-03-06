function intensity =  GenerateSinusSignal(t)
%
% Syntax:  intensity =  GenerateSinusSignal(t)
%
% Inputs:
%    t - The current time is secounds (toc(tStart))
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
settings.conv =     getSinusSettings();
period =            settings.conv.period;       % period time in seconds, could be one value or a vector of length(wavelengths)
amplitude =         settings.conv.amplitude;    % amplitude of excitation signal given in uE 
meanvalue =         settings.conv.meanvalue;    % The meanvalue of the sinus
lamp_ip =           settings.conv.lamp_ip;
lamp_ID =           settings.conv.lamp_ID;

%% Calcutate the desired intensity
intensity = meanvalue + amplitude.* (sin(2*pi*1./period.*t));

%% Convert the intensity to LED input
LEDintensity = intensity2LEDinput(intensity, lamp_ID);

%% Set the LED value (webwrite)
LEDintensity_wwString = mat2wwString(LEDintensity, lamp_ip);
webwrite(LEDintensity_wwString{1,1},'');

