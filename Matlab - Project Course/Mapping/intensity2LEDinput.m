function intensity2LEDinput(intensity)

% IP for specific LED lamp
lamp_ip = '192.168.100.102'; 

% Load settings 
settings.conv = getSettings();

% Load Sweeping matrix LEDS??
load(settings.conv.sweepingsMatrix, 'LEDs', 'intIRRmatrix', 'lampINTmatrix')

% Pre-define variable
LEDintensity = zeros(1, length(LEDs));

% How much intensity we should have in each spectrum 
spectrumintensity = [settings.conv.spectrum*intensity];

% Loop through all LEDS
for indexLed = 3:length(LEDs)
    
    % Save in new matrix
    SweepingIRR = intIRRmatrix(indexLed, :);
    SweepingINT = lampINTmatrix(indexLed, :);

    % Find index of the closest value 
    [~, index] = min(abs(SweepingIRR-spectrumintensity(indexLed)));
    
    % Save the correponding value for the intensity in the LED lamps
    LEDintensity(indexLed) = SweepingINT(index);

end
  
% Set the LEDS to the intensity defined in LEDintensity
LEDintensity_wwString = mat2wwString(LEDintensity,lamp_ip);
webwrite(LEDintensity_wwString{1,1},'') 

end



