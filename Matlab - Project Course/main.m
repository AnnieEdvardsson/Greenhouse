%% This is the main-file for the Greenhouse project'
%% Clear and close
clear; close all; clc; format long; dbstop if error;

%% Define paths

addpath(genpath('Lamp'))
addpath(genpath('Mapping'))

%% Load settings
% Load settings from signal_settings.m
s_settings.conv = signal_settings();
pauseAfterLEDchange = s_settings.conv.pauseAfterLEDchange;  % Time LED lamps have to changed to defined value 
sampleTime = s_settings.conv.sampleTime;                    % Time for one loop 

% Get settings for the sinus signal (period, amplitude etc)
settings.s = getSinusSettings();
period = settings.s.period;

% Setup for the measurment of spectrometer
settings_spec.m2 = getSpecSettings("plants");
Spectrometers    = jsetUpSpectrometers(settings_spec); %The java-object(s) communicating with the spectrometer(s) is (are) created and contained in Spectrometer.Wrapper

%% Pre-define and initiate
NrPeriods = 4;
maxLengthVec = period * 4;

flourLEDsignal = [];
flourPlantsignal = [];

% Start values
backgroundIntensity = 40;  
phase_error = 0; 
cum_error = 0;


%% Other 
% Turn on fan on maximum speed
FanConfiguration("Max");

% Start clock
tStart = tic;               

%% PRE LOOP (to generate flourLEDsignal and flourPlantsignal)
    
% Change background light with the new wanted intensity
generateBackgroundLight(backgroundIntensity);

for i = 0:maxLengthVec
    
    [flourLEDsignal, flourPlantsignal]= PRELOOP(i, flourLEDsignal, flourPlantsignal, tStart, sampleTime, pauseAfterLEDchange, maxLengthVec, Spectrometers);
 
end
%% Plot flourPlantsignal and flourLEDsignal

plotPREloop(flourPlantsignal, flourLEDsignal);

%% MAIN LOOP
tStart = tic; % Restart clock
for i = 0:(period-1) * NrPeriods
    
    [flourLEDsignal, flourPlantsignal, backgroundIntensity, phase_error, cum_error]= MAINLOOP(i, flourLEDsignal, flourPlantsignal, backgroundIntensity, tStart, sampleTime, pauseAfterLEDchange, period, Spectrometers, phase_error, cum_error, maxLengthVec);

end
%% Other 
% Turn off fan
FanConfiguration("Off");

% Turn off lamp
TurnOffLamp(settings.s.LEDs, settings.s.lamp_ip);


%% Plot figure
% figure
% hold on 
% 
% for ii = 1:length(settings.conv.LEDs)
%     [rgb,name]= getColororder(settings.conv.LEDs(ii));
%     h = plot(1:length(ledIN(:,ii)), ledIN(:,ii),'DisplayName',name{1});
%     h.Color = rgb;
% end
% legend('show')
% 
% %figure
% plot(meas_int);

%%%%%%%%% FUNCTIONS %%%%%%%%%%%
function  [flourLEDsignal, flourPlantsignal]= PRELOOP(i, flourLEDsignal, flourPlantsignal, tStart, sampleTime, pauseAfterLEDchange, maxLengthVec, Spectrometers)
    fprintf("PRE Loop #%i \n", i+1);
    t = maxLengthVec * sampleTime -toc(tStart);
    mins = floor(t / 60);
    secs = t - mins * 60;
    fprintf("Time remaining: %2.0f min and %2.0f seconds \n\n", mins, secs);
    
    %% Generate sinus + store flour signal from LED
    % Create calculate sinus signal and set LED value 
    % Return the LED value in flour spectrum
    flourLEDValue =  GenerateSinusSignal(toc(tStart));
    
    % Add returned flourLEDValue value to vector flourLEDsignal
    flourLEDsignal = updateVector(flourLEDsignal, flourLEDValue, maxLengthVec);
    
    %% Pause until it can be ensured that the LEDs are set
    while toc(tStart) < sampleTime*i + pauseAfterLEDchange
    end
    
    %% Measure fluroescent from plants and store and process
    % Measure emitted flour from plants
    flourPlantValue = measure_fluorescence(Spectrometers);
    
    % Add returned flourPlantValue value to vector flourPlantsignal
    flourPlantsignal = updateVector(flourPlantsignal, flourPlantValue, maxLengthVec);
   
    
    %% Pause intil the sample time of the loop is finished
    while toc(tStart) < sampleTime*(i+1)
    end
end

function  [flourLEDsignal, flourPlantsignal, backgroundIntensity, phase_error, cum_error]= MAINLOOP(i, flourLEDsignal, flourPlantsignal, backgroundIntensity, tStart, sampleTime, pauseAfterLEDchange, period, Spectrometers, prev_phase_error, cum_error, maxLengthVec)
	fprintf("MAIN Loop #%i : ", i+1);
    t = (period-1) * NrPeriods * sampleTime -toc(tStart);
    mins = floor(t / 60);
    secs = t - mins * 60;
    fprintf("Time remaining: %2.0f min and %2.0f seconds \n", mins, secs);
    
    %% Generate sinus + store flour signal from LED
    % Create calculate sinus signal and set LED value 
    % Return the LED value in flour spectrum
    flourLEDValue =  GenerateSinusSignal(toc(tStart));
    
    % Add returned flourLEDValue value to vector flourLEDsignal
    flourLEDsignal = updateVector(flourLEDsignal, flourLEDValue, maxLengthVec);
    
    %% Change background light with the new wanted intensity
    
    generateBackgroundLight(backgroundIntensity);
    
    %% Pause until it can be ensured that the LEDs are set
    while toc(tStart) < sampleTime*i + pauseAfterLEDchange
    end
    
    %% Measure fluroescent from plants and store and process
    % Measure emitted fluoresence from plants
    flourPlantValue = measure_fluorescence(Spectrometers);
    
    % Add measured value to fluoresence signal vector
    flourPlantsignal = updateVector(flourPlantsignal, flourPlantValue, maxLengthVec);
    
    % Filter the measured fluoresence signal
    filtredPlantFlourSignal = filter_fluorescent(flourPlantsignal);
    
    %% Estimate the phase shift
    phase_shift = estimate_phase(flourLEDsignal, filtredPlantFlourSignal);
    
    %% Controller
    % PID controller
    [backgroundIntensity, phase_error, cum_error] = pid_control(phase_shift, prev_phase_error, cum_error, sampleTime);
    
    fprintf("flourLEDsignal= %2.1f, flourPlantsignal = %2.1f, backgroundIntensity= %i \n\n",flourLEDsignal(end), flourPlantsignal(end), backgroundIntensity); 
   
    %% Pause intil the sample time of the loop is finished
    while toc(tStart) < sampleTime*(i+1)
    end
end

function TurnOffLamp(LEDs, lamp_ip)
    LEDintensity = zeros(1,length(LEDs));
    LEDintensity_wwString = mat2wwString(LEDintensity,lamp_ip);
    webwrite(LEDintensity_wwString{1,1},'');
end

function plotPREloop(flourPlantsignal, flourLEDsignal)

subplot(2,1,1)
plot(flourPlantsignal);
title('Subplot 1: flourPlantsignal')
subplot(2,1,2)
plot(flourLEDsignal);
title('Subplot 2: flourLEDsignal')
end
