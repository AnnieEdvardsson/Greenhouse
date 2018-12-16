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
backgroundIntensity = settings.s.meanvalue;     % Start with the same intensity as the mean of the sinus

% Get settings for the sinus signal (period, amplitude etc)
settingsback.s = getBackgroundSettings();

% Setup for the measurment of spectrometer
settings_spec.m2 = getSpecSettings("plants");
Spectrometers    = jsetUpSpectrometers(settings_spec); %The java-object(s) communicating with the spectrometer(s) is (are) created and contained in Spectrometer.Wrapper

%% Pre-define and initiate
NrPeriods = 5;
maxLengthVec = period *3;

flourLEDsignal = [];
flourPlantsignal = [];
phase_error2 = 0;

% Start values
phase_error = 0; 
cum_error = 0;


%% Other 
% Turn on fans on maximum speed, RX/LX
FanConfiguration("Max", settings.s.lamp_ip);
FanConfiguration("Max", settingsback.s.lamp_ip);

%% PRE LOOP (to generate flourLEDsignal and flourPlantsignal)
    
% Change background light with the new wanted intensity
generateBackgroundLight(backgroundIntensity);

% plot during loop
% figure(1);
% % subplot(2,1,1)
% PREfig_plant = plot(flourPlantsignal);
% title(sprintf('Subplot 1:  Plant signal'));

% subplot(2,1,2)
% PREfig_LED = plot(flourLEDsignal);
% title(sprintf('Subplot 2: LED signal'));
% PREfig_plant = figure(1);
% title(sprintf('Subplot 1:  Plant signal'));
 
% Start clock
tStart = tic; 
for i = 0:maxLengthVec-1
    
    [flourLEDsignal, flourPlantsignal]= PRELOOP(i, flourLEDsignal, flourPlantsignal, tStart, sampleTime, pauseAfterLEDchange, maxLengthVec, Spectrometers);
%     if i >= 10
%         LoopPlot(PREfig_plant, flourPlantsignal, flourLEDsignal, i)
%     end

end
%% Plot flourPlantsignal and flourLEDsignal

plotSub(flourPlantsignal, flourLEDsignal);
%% Load
% load('flourPlantsignal4.mat');
% load('flourLEDsignal4.mat');

%% MAIN LOOP
tStart = tic; % Restart clock
for i = 0:(period * NrPeriods)-1
    
    [flourLEDsignal, flourPlantsignal, backgroundIntensity, phase_error, phase_error2]= MAINLOOP(i, flourLEDsignal, flourPlantsignal, backgroundIntensity, tStart, sampleTime, pauseAfterLEDchange, period, Spectrometers, phase_error, maxLengthVec, NrPeriods, phase_error2);

end
%% Other 
% Turn off fan RX
FanConfiguration("Off", settings.s.lamp_ip);

% Turn off fan LX
FanConfiguration("Off", settingsback.s.lamp_ip);

% Turn off lamp RX
TurnOffLamp(settings.s.LEDs, settings.s.lamp_ip);

% Turn off lamp LX
TurnOffLamp(settingsback.s.LEDs, settingsback.s.lamp_ip);



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
    fprintf("PRE Loop: %i/%i \n", i+1, maxLengthVec);
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

function  [flourLEDsignal, flourPlantsignal, backgroundIntensity, phase_error, phase_error2]= MAINLOOP(i, flourLEDsignal, flourPlantsignal, backgroundIntensity, tStart, sampleTime, pauseAfterLEDchange, period, Spectrometers, phase_error, maxLengthVec, NrPeriods, phase_error2)
	fprintf("MAIN Loop: %i/%i : ", i+1, period * NrPeriods);
    t = period * NrPeriods * sampleTime -toc(tStart);
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
    
    generateBackgroundLight(backgroundIntensity(end));
    
    %% Pause until it can be ensured that the LEDs are set
    while toc(tStart) < sampleTime*i + pauseAfterLEDchange
    end
    
    %% Measure fluroescent from plants and store and process
    % Measure emitted fluoresence from plants
    flourPlantValue = measure_fluorescence(Spectrometers);
    
    % Add measured value to fluoresence signal vector
    flourPlantsignal = updateVector(flourPlantsignal, flourPlantValue, maxLengthVec);
    
    % Filter the measured fluoresence signal
    %filtredPlantFlourSignal = filter_fluorescent(flourPlantsignal);
    
    % PLOT
    % plotOnTop(flourPlantsignal, filtredPlantFlourSignal)
    
    %% Estimate the phase shift
     phase_shift = estimate_phase(flourLEDsignal, flourPlantsignal);
     phase_shift2 = estimate_phase_hilbert(flourLEDsignal, flourPlantsignal);
     
     phase_error2 = [phase_error, phase_shift2];
    
    %% Controller
    % PID controller
    [backgroundIntensity, phase_error] = pid_control(phase_shift, phase_error, sampleTime, backgroundIntensity);
    
    
    fprintf("LED signal= %2.1f, Plant signal = %2.3f, Intensity = %i, Phase error = %i \n\n",flourLEDsignal(end), flourPlantsignal(end), backgroundIntensity(end), phase_error(end)); 
   
    %% Pause intil the sample time of the loop is finished
    while toc(tStart) < sampleTime*(i+1)
    end
end

function TurnOffLamp(LEDs, lamp_ip)
    LEDintensity = zeros(1,length(LEDs));
    LEDintensity_wwString = mat2wwString(LEDintensity,lamp_ip);
    webwrite(LEDintensity_wwString{1,1},'');
end

function plotSub(var1, var2)
subplot(2,1,1)
plot(var1);
title(sprintf('Subplot 1:  Plant signal'));
subplot(2,1,2)
plot(var2);
title(sprintf('Subplot 2: LED signal'));
end

function plotOnTop(var1, var2)
var1 = detrend(var1);
var2 =detrend(var2);
figure
hold on
plot(var1);
plot(var2);
line([0,length(var1)+20],[0,0])
legend("non_filt","filt")
%title(sprintf('Subplot 2:  %s', var2));
end

function PREfig_plant = LoopPlot(PREfig_plant, PlantSIgnal, LEDsignal, i)

if i == 10
    
    % subplot(2,1,1)
    PREfig_plant = plot(PlantSIgnal, 1:length(PlantSIgnal));

end
     set(PREfig_plant,'XData', PlantSIgnal, 'YData', 1:length(PlantSIgnal));
     drawnow;
     pause(0.5);

end
