function intensity2LEDinput(intensity)


lamp_ip = '192.168.100.102'; % IP for specific LED lamp

% Load Sweeping matrix
load('Sweeping_RX2018-11-20-1110.mat', 'LEDs', 'intIRRmatrix', 'lampINTmatrix')

% Pre-define variable
LEDintensity = zeros(1, length(LEDs));


% Loop through all LEDS
for indexLed = 3:length(LEDs)
    
    SweepingIRR = intIRRmatrix(indexLed, :);
    SweepingINT = lampINTmatrix(indexLed, :);

    % Find closest value 
    [~, index] = min(abs(SweepingIRR-intensity(indexLed)));
    
    LEDintensity(indexLed) = SweepingINT(index);

end
  
% Set the LEDS to the intensity defined in LEDintensity
LEDintensity_wwString = mat2wwString(LEDintensity,lamp_ip);
webwrite(LEDintensity_wwString{1,1},'') 

end



