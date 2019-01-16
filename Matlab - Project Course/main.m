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
%backgroundIntensity = 120; %settings.s.meanvalue;     % Start with the same intensity as the mean of the sinus

% Get settings for the sinus signal (period, amplitude etc)
settingsback.s = getBackgroundSettings();

% Setup for the measurment of spectrometer
settings_spec.m2 = getSpecSettings("plants");
Spectrometers    = jsetUpSpectrometers(settings_spec); %The java-object(s) communicating with the spectrometer(s) is (are) created and contained in Spectrometer.Wrapper

%% Pre-define and initiate
NrPeriodsPRE = 4;
NrPeriodsMAIN = 60-NrPeriodsPRE;
% NrPeriodsMAIN = 60;

maxLengthVec = 1000000;

flourLEDsignal = [];
flourPlantsignal = [];
phase_error2 = [];
measured_420Signal = [];
measured_450Signal = [];
measured_660Signal = [];

% Start values
phase_error = 0;
cum_error = 0;
phase_error_meas = [];
phase_error2_meas = [];
phase_error3= [];
phase_error3_meas= [];


%% Other
% Turn on fans on maximum speed, RX/LX
FanConfiguration("Max", settings.s.lamp_ip);
FanConfiguration("Max", settingsback.s.lamp_ip);

%% PRE LOOP (to generate flourLEDsignal and flourPlantsignal)


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
% backgroundIntensityVEC = [0, 20, 40, 60, 80, 90, 100, 110, 120, 140, 150, 160, 170, 180, 200];
%backgroundIntensityVEC = [50, 100, 150];

backgroundIntensityVEC = 180;

for j = 1:length(backgroundIntensityVEC)
    flourLEDsignal = [];
    flourPlantsignal = [];

    measured_420Signal = [];
    measured_450Signal = [];
    measured_660Signal = [];
    
    factor = 0;
    
    % Start values
    phase_error = [];
    cum_error = 0;
    phase_errorFILTER = [];
    phase_errorFILTERFILTER = [];
    phase_error2FILTERFILTER = [];

 
    %%
    backgroundIntensity  = backgroundIntensityVEC(j);
    % Change background light with the new wanted intensity
    generateBackgroundLight(backgroundIntensity);
    
    % Start clock
    tStart = tic;
    for i = 0:period*NrPeriodsPRE-1
        
        [flourLEDsignal, flourPlantsignal, measured_420Signal]= PRELOOP(i, flourLEDsignal, flourPlantsignal, tStart, sampleTime, pauseAfterLEDchange, maxLengthVec, Spectrometers, measured_420Signal, NrPeriodsPRE, period);
        
    end
    %% Plot flourPlantsignal and flourLEDsignal
    
    % plotSub(flourPlantsignal, flourLEDsignal);
%     % % Load
%     load('flourPlantsignal5.mat');
%     load('flourLEDsignal5.mat');
%     
    %% MAIN LOOP
    tStart = tic; % Restart clock
    for i = 0:(period * NrPeriodsMAIN)-1
        
        [flourLEDsignal, flourPlantsignal, backgroundIntensity, phase_error, phase_errorFILTERFILTER, phase_error2, phase_error2FILTERFILTER, measured_420Signal, factor]= MAINLOOP(i, flourLEDsignal, flourPlantsignal, backgroundIntensity, tStart, sampleTime, pauseAfterLEDchange, period, Spectrometers, phase_error, phase_errorFILTERFILTER, phase_error2, phase_error2FILTERFILTER, maxLengthVec, NrPeriodsMAIN, measured_420Signal, factor);
    end
    try
        %save(sprintf("WorkspaceForBackground_18dec_%i", backgroundIntensityVEC(j)));
        save(sprintf("WorkspaceForBackground_TEST_PID5"));
    catch
    end
    try
        autoPush()
    catch
    end
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
function  [flourLEDsignal, flourPlantsignal, measured_420Signal]= PRELOOP(i, flourLEDsignal, flourPlantsignal, tStart, sampleTime, pauseAfterLEDchange, maxLengthVec, Spectrometers, measured_420Signal, NrPeriodsPRE, period)
fprintf("PRE Loop: %i/%i \n", i+1, period*NrPeriodsPRE);
t = period*NrPeriodsPRE * sampleTime -toc(tStart);
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
[measured_420, flourPlantValue] = measure_fluorescence(Spectrometers);

measured_420Signal = updateVector(measured_420Signal, measured_420, maxLengthVec);

% Add returned flourPlantValue value to vector flourPlantsignal
flourPlantsignal = updateVector(flourPlantsignal, flourPlantValue, maxLengthVec);


%% Pause intil the sample time of the loop is finished
while toc(tStart) < sampleTime*(i+1)
end
end

function  [flourLEDsignal, flourPlantsignal, backgroundIntensity, phase_error, phase_errorFILTERFILTER, phase_error2, phase_error2FILTERFILTER, measured_420Signal, factor]= MAINLOOP(i, flourLEDsignal, flourPlantsignal, backgroundIntensity, tStart, sampleTime, pauseAfterLEDchange, period, Spectrometers, phase_error, phase_errorFILTERFILTER, phase_error2, phase_error2FILTERFILTER, maxLengthVec, NrPeriods, measured_420Signal, factor)
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
[measured_420, flourPlantValue] = measure_fluorescence(Spectrometers);

measured_420Signal = updateVector(measured_420Signal, measured_420, maxLengthVec);


% Add measured value to fluoresence signal vector
flourPlantsignal = updateVector(flourPlantsignal, flourPlantValue, maxLengthVec);

% Filter the measured fluoresence signal
filtredPlantFlourSignal = filter_fluorescent(flourPlantsignal);
filtredFlourLEDSignal = filter_fluorescent(flourLEDsignal);
% PLOT
% plotOnTop(flourPlantsignal, filtredPlantFlourSignal)

%% Estimate the phase shift
inputLED = flourLEDsignal(length(flourLEDsignal)-4*period:end);
inputLEDFILTERED = filtredFlourLEDSignal(length(filtredFlourLEDSignal)-4*period:end);

inputfluor       = flourPlantsignal(length(flourPlantsignal)-4*period:end);
inputfluorFILTER = filtredPlantFlourSignal(length(filtredPlantFlourSignal)-4*period:end);

phase_shift = estimate_phase(inputLED, inputfluor);
phase_shiftfilt = estimate_phase(inputLEDFILTERED, inputfluorFILTER);

% phase_error = [phase_error, phase_shift-4];
phase_errorFILTERFILTER = [phase_errorFILTERFILTER, phase_shiftfilt-4];


%% Controller
% PID controller
if mod(i+1, 15) == 0
[factor, phase_error] = pid_control(phase_shift, phase_error, sampleTime, factor);

else 
    factor = 0;
    phase_error = [phase_error, 4-phase_shift];
end
    
newIntensity = backgroundIntensity(end) + factor;
if newIntensity < 0
    backgroundIntensity = [backgroundIntensity, 0];
else
     backgroundIntensity = [backgroundIntensity, newIntensity];
end

fprintf("LED signal= %2.1f, Plant signal = %2.3f, Intensity = %4.3f, Phase error = %4.3f, factor = %2.3f \n\n",flourLEDsignal(end), flourPlantsignal(end), backgroundIntensity(end), phase_error(end), factor(end));

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
