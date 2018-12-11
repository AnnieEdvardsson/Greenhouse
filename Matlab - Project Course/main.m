%% This is the main-file for the Greenhouse project'
%% Clear and close
clear; close all; clc; format long;

%% Pre-define and initiate
NrPeriods = 1;

flourLEDsignal = [];
flourPlantsignal = [];

% Start values
backgroundIntensity = 40;  
prev_error = 0; 
cum_error = 0;

%% Define paths

addpath(genpath('Lamp'))
addpath(genpath('Mapping'))

%% Load settings
% Load settings from signal_settings.m
s_settings.conv = signal_settings();

% Get settings for the sinus signal (period, amplitude etc)
settings.s = getSinusSettings();
period = settings.s.period;

% Setup for the measurment of spectrometer
settings_spec.m2 = getSweepingSettings();
Spectrometers    = jsetUpSpectrometers(settings_spec); %The java-object(s) communicating with the spectrometer(s) is (are) created and contained in Spectrometer.Wrapper


%% Other 
% Turn on fan on maximum speed
FanConfiguration("Max");

%% Timekeeper
tStart = tic;               % Start clock
pauseAfterLEDchange = 0.5;  % Time LED lamps have to changed to defined value
sampleTime = 2;             % Time for one loop 

%% PRE LOOP (to generate flourLEDsignal and flourPlantsignal)
for i = 0:(period-1)
    [flourLEDsignal, flourPlantsignal]= PRELOOP(i, flourLEDsignal, flourPlantsignal, backgroundIntensity, tStart, sampleTime, pauseAfterLEDchange, period, Spectrometers);
    fprintf("TIME after loop: %2.1f \n", toc(tStart));
end

%% MAIN LOOP
tStart = tic; % Restart clock
for i = 0:(period-1) * NrPeriods
    [flourLEDsignal, flourPlantsignal, backgroundIntensity, error, cum_error]= MAINLOOP(i, flourLEDsignal, flourPlantsignal, backgroundIntensity, tStart, sampleTime, pauseAfterLEDchange, period, Spectrometers, error, cum_error);
    fprintf("flourLEDsignal= %2.1f, flourPlantsignal = %2.1f, backgroundIntensity= %i \n",flourLEDsignal(end), flourPlantsignal(end), backgroundIntensity); 
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
function  [flourLEDsignal, flourPlantsignal]= PRELOOP(i, flourLEDsignal, flourPlantsignal, meanvalue, tStart, sampleTime, pauseAfterLEDchange, period, Spectrometers)
	fprintf("PRE Loop #%i \n", i+1);
    
    %% Generate sinus + store flour signal from LED
    % Create calculate sinus signal and set LED value 
    % Return the LED value in flour spectrum
    flourLEDValue =  sinusSignal(meanvalue, toc(tStart));
    
    % Add returned flourLEDValue value to vector flourLEDsignal
    flourLEDsignal = updateVector(flourLEDsignal, flourLEDValue, period);
    
    %% Pause until it can be ensured that the LEDs are set
    while toc(tStart) < sampleTime*i + pauseAfterLEDchange
    end
    
    %% Measure fluroescent from plants and store and process
    % Measure emitted flour from plants
    flourPlantValue = measure_fluorescence(Spectrometers);
    
    % Add returned flourPlantValue value to vector flourPlantsignal
    flourPlantsignal = updateVector(flourPlantsignal, flourPlantValue, period);
    
    %% Pause intil the sample time of the loop is finished
    while toc(tStart) < sampleTime*(i+1)
    end
end

function  [flourLEDsignal, flourPlantsignal, backgroundIntensity, error, cum_error]= MAINLOOP(i, flourLEDsignal, flourPlantsignal, backgroundIntensity, tStart, sampleTime, pauseAfterLEDchange, period, Spectrometers, prev_error, cum_error)
	fprintf("MAIN Loop #%i : ", i+1);
    
    %% Generate sinus + store flour signal from LED
    % Create calculate sinus signal and set LED value 
    % Return the LED value in flour spectrum
    flourLEDValue =  sinusSignal(toc(tStart));
    
    % Add returned flourLEDValue value to vector flourLEDsignal
    flourLEDsignal = updateVector(flourLEDsignal, flourLEDValue, period);
    
    %% Change background light with the new wanted intensity
    
    generateBackgroundLight(backgroundIntensity);
    
    %% Pause until it can be ensured that the LEDs are set
    while toc(tStart) < sampleTime*i + pauseAfterLEDchange
    end
    
    %% Measure fluroescent from plants and store and process
    % Measure emitted fluoresence from plants
    flourPlantValue = measure_fluorescence(Spectrometers);
    
    % Add measured value to fluoresence signal vector
    flourPlantsignal = updateVector(flourPlantsignal, flourPlantValue, period);
    
    % Filter the measured fluoresence signal
    filtredPlantFlourSignal = filter_fluorescent(flourPlantsignal);
    
    %% Estimate the phase shift
    phase_shift = estimate_phase(flourLEDsignal, filtredPlantFlourSignal);
    
    %% Controller
    % PID controller
    [backgroundIntensity, error, cum_error] = pid_control(phase_shift, prev_error, cum_error, sampleTime);
    
    %% Pause intil the sample time of the loop is finished
    while toc(tStart) < sampleTime*(i+1)
    end
end

function TurnOffLamp(LEDs, lamp_ip)
    LEDintensity = zeros(1,length(LEDs));
    LEDintensity_wwString = mat2wwString(LEDintensity,lamp_ip);
    webwrite(LEDintensity_wwString{1,1},'');
end
