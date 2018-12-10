function LEDintensity = intensity2LEDinput(intensity, LAMP_ID)
% Convert the inputed intensity to LED lamp inputs
%
% Syntax:  LEDintensity = intensity2LEDinput(intensity, lamp_ip)
%
% Inputs:
%    intensity -    The wanted intensity
%    lamp_ID -      Defines which lamp e want to convert, RX or LX (sinus
%                   or background)
% Outputs:
%    LEDintensity - The LED lamp input
%
%
% Other m-files required: getSettings.m, mat2wwString.m
% MAT-files required: sweepingsMatrix.mat (name found in get.Settings.m)
% Other requirments: Connection to LED lamp defined in lamp_ip
%
% November 2019; Last revision: 13-December-2019
%------------- BEGIN CODE --------------

% Load settings depening on which lamp (RX or LX)
if (LAMP_ID == "RX")
    settings.conv = getSinusSettings();
    j = 3;
    
elseif (LAMP_ID == "LX")
    settings.conv = getBackgroundSettings();
    j = 0;
        
else
     disp("WRONG LAMP ID IS INPUTED TO THE FUNCTION, CHOOSE 'RX' or 'LX'");   
        
end

% Load Sweeping matrix LEDS??
load(settings.conv.sweepingsMatrix, 'LEDs', 'intIRRmatrix', 'lampINTmatrix')

% Pre-define variable
LEDintensity = zeros(1, length(LEDs));

% How much intensity we should have in each spectrum 
spectrumintensity = settings.conv.spectrum*intensity;

% Loop through all LEDS
for indexLed = j:length(LEDs)
    
    % Save in new matrix
    SweepingIRR = intIRRmatrix(indexLed, :);
    SweepingINT = lampINTmatrix(indexLed, :);
    
    if spectrumintensity(indexLed) == 0
        LEDintensity(indexLed) = 0;
    else
        % Find index of the closest value 
        [~, index] = min(abs(SweepingIRR-spectrumintensity(indexLed)));

        % Save the correponding value for the intensity in the LED lamps
        LEDintensity(indexLed) = round(SweepingINT(index));
    end

end
  
% Set the LEDS to the intensity defined in LEDintensity
LEDintensity_wwString = mat2wwString(LEDintensity,lamp_ip);
webwrite(LEDintensity_wwString{1,1},'');

end



