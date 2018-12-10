function generateBackgroundLight(intensity)
% Set the background light (LED LX60) with the intensity inputed in the
% function and the choosen spectrum
%
% Syntax:  generateBackgroundLight(intensity)
%
% Inputs:
%    intensity - the intensity of the LED
%
% Outputs:
%    None
%
%
% Other m-files required:   getBackgroundSettings()
%                           intensity2LEDinput()
%                           mat2wwString()
%
% MAT-files required:       Connection to LX60 LED
%
% December 2018; Last revision: 14-December-2018
%------------- BEGIN CODE --------------

%% Load settings 
settings.conv =     getBackgroundSettings();
lamp_ip =           settings.lamp_ip;
lamp_ID =           settingd.lamp_ID;

%% Calculate LED intensity with mapping
LEDintensity = intensity2LEDinput(intensity, lamp_ID);

%% Set the LED value (webwrite)
LEDintensity_wwString = mat2wwString(LEDintensity,lamp_ip);
webwrite(LEDintensity_wwString{1,1},'');

