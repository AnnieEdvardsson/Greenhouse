% This runs a period of a sinusoidal LED signal
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
% December 2019; Last revision: 03-December-2019
%------------- BEGIN CODE --------------

%% Clear and load variables
clc
clear 
close all

% Add path so it finds intensity2LEDinput function
addpath(genpath('..\Mapping'))
addpath(genpath('\AM_Sweeping'))

% Load settings 
settings.conv = getSinusSettings();


%% Define variables
wavelengths = [0 1 0 0 0 0 0];  % wavelengths used in excitation signal 
period_t    = 60;               % period time in seconds, could be one value or a vector of length(wavelengths)
amplitude  = 10;                % amplitude of excitation signal given in uE 
meanvalue = 20;
step_length = 1;
i = 0;

%% Setup for the measurment of spectrometer
settings_spec.m2     = getSweepingSettings();
Spectrometers   = jsetUpSpectrometers(settings_spec); %The java-object(s) communicating with the spectrometer(s) is (are) created and contained in Spectrometer.Wrapper


%% Turn on fan on maximum speed
webwrite(strcat('http://',settings.conv.lamp_ip,'/config.cgi?action=fan&mode=manual&value=255'),'');

%% Loop through a sinus signal
%while true
for j = 0:59 
    fprintf("Loop #%i -- ", j);
    i = i+1;
    t = i*step_length;
    desired_intensity = meanvalue + amplitude.* (sin(2*pi*1./period_t.*t));
    %desired_intensities = desired_intensity * wavelengths;
    ledIN(i,:) = intensity2LEDinput(desired_intensity, settings.conv.lamp_ip);
    pause(1)
    meas_int(i) = spectrometer_measurement(Spectrometers);
    fprintf(" -- measured intensity %2.2f, wanted it to be %2.2f  \n", meas_int(i),desired_intensity);
    %pause(step_length)
end

%% Turn off fan and lamp
% Turn off fan
webwrite(strcat('http://',settings.conv.lamp_ip,'/config.cgi?action=fan&mode=default'),'');

% Turn off lamp
LEDintensity = zeros(1,length(settings.conv.LEDs));
LEDintensity_wwString = mat2wwString(LEDintensity,settings.conv.lamp_ip);
webwrite(LEDintensity_wwString{1,1},'');

%% Plot figure
figure
hold on 

for ii = 1:length(settings.conv.LEDs)
    [rgb,name]= getColororder(settings.conv.LEDs(ii));
    h = plot(1:length(ledIN(:,ii)), ledIN(:,ii),'DisplayName',name{1});
    h.Color = rgb;
end
legend('show')

%figure
plot(meas_int);