wavelengths = [0 1 0 0 0 0 0]; % wavelengths used in excitation signal 
period_t    = 10*60; % period time in seconds, could be one value or a vector of length(wavelengths)
amplitude  = 65; %amplitude of excitation signal given in uE 
meanvalue = 0;
step_length = 0.001;
while true
    desired_intensity = meanvalue + amplitude.* (sin(2*pi*1./period_t.*t));
    desired_intensities = desired_intensity * wavelengths;
    intensity2LEDinput(desired_intensities);
    pause(step_length)
end
