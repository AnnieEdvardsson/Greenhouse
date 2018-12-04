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
% December 2019; Last revision: 03-December-2019
%------------- BEGIN CODE --------------

%% Clear and load variables
clc
clear 
close all

% Add path so it finds intensity2LEDinput function
addpath(genpath('..\Mapping'))
addpath(genpath('\AM_Sweeping'))

%% Load settings 
settings.conv = getSinusSettings();
period_t = s_settings.period_t;          % period time in seconds, could be one value or a vector of length(wavelengths)
amplitude = s_settings.amplitude;        % amplitude of excitation signal given in uE 
step_length = s_settings.step_length;


%% Setup for the measurment of spectrometer
settings_spec.m2     = getSweepingSettings();
Spectrometers   = jsetUpSpectrometers(settings_spec); %The java-object(s) communicating with the spectrometer(s) is (are) created and contained in Spectrometer.Wrapper

%%
t = i*step_length;
desired_intensity = meanvalue + amplitude.* (sin(2*pi*1./period_t.*t));

ledIN(i,:) = intensity2LEDinput(desired_intensity, settings.conv.lamp_ip);
pause(1)
meas_int(i) = spectrometer_measurement(Spectrometers);
fprintf(" -- measured intensity %2.2f, wanted it to be %2.2f  \n", meas_int(i),desired_intensity);
