%% This is the main-file for the Greenhouse project'
%% Clear and close
clear; close all; clc; format long;

%% Pre-define and initiate
NrPeriods = 10;

flourLEDsignal = [];
filtredPlantFlourSignal = [];

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
FanConfiguration("Max")

%% Timekeeper
tStart = tic;               % Start clock
pauseAfterLEDchange = 0.5;  % Time LED lamps have to changed to defined value
sampleTime = 2;             % Time for one loop 

%% PRE LOOP (to generate flourLEDsignal and flourPlantsignal)
for i = 0:(period-1)
    [flourLEDsignal, flourPlantsignal]= PRELOOP(i, flourLEDsignal, flourPlantsignal, meanvalue, tStart, sampleTime, pauseAfterLEDchange);
end

%% MAIN LOOP
tStart = tic; % Restart clock
for i = 0:(period-1) * NrPeriods
    [flourLEDsignal, flourPlantsignal, meanvalue]= MAINLOOP(i, flourLEDsignal, flourPlantsignal, meanvalue, tStart, sampleTime, pauseAfterLEDchange);
end
%% Other 
% Turn off fan
FanConfiguration("Off");

% Turn off lamp
TurnOffLamp(s_settings.conv.LEDs, s_settings.conv.lamp_ip);


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
function  [flourLEDsignal, flourPlantsignal]= PRELOOP(i, flourLEDsignal, flourPlantsignal, meanvalue, tStart, sampleTime, pauseAfterLEDchange)
	fprintf("PRE Loop #%i -- ", i+1);
    
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
    flourPlantValue = measure_fluorescence();
    
    % Add returned flourPlantValue value to vector flourPlantsignal
    flourPlantsignal = updateVector(flourPlantsignal, flourPlantValue, period);
    
    %% Pause intil the sample time of the loop is finished
    while toc(tStart) < sampleTime*(i+1)
    end
end

function  [flourLEDsignal, flourPlantsignal, meanvalue]= MAINLOOP(i, flourLEDsignal, flourPlantsignal, meanvalue, tStart, sampleTime, pauseAfterLEDchange)
	fprintf("MAIN Loop #%i -- ", i+1);
    
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
    flourPlantValue = measure_fluorescence();
    
    % Add returned flourPlantValue value to vector flourPlantsignal
    flourPlantsignal = updateVector(flourPlantsignal, flourPlantValue, period);
    
    % Process the LED signal in flour spectrum
    filtredPlantFlourSignal = filter_fluorescent(flourPlantsignal);
    
    %% Estimate the phase shift
    phase_shift = estimate_phase(flourLEDsignal, filtredPlantFlourSignal);
    
    %% Controller
    % PID controller
    
    
    %% Pause intil the sample time of the loop is finished
    while toc(tStart) < sampleTime*(i+1)
    end
end

function TurnOffLamp(LEDs, lamp_ip)
    LEDintensity = zeros(1,length(LEDs));
    LEDintensity_wwString = mat2wwString(LEDintensity,lamp_ip);
    webwrite(LEDintensity_wwString{1,1},'');
end
