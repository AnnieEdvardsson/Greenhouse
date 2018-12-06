%% This is the main-file for the Greenhouse project'
%% Clear and close
clear; close all; clc; format long;

%% Pre-define and initiate
flourLEDsignal = [];
filtredPlantFlourSignal = [];

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

tStart = tic;
pauseAfterLEDchange = 0.5;
sampleTime = 2;

%tElapsed = toc(tStart)

%% PRE LOOP (to generate flourLEDsignal and flourPlantsignal)
for i = 0:(period-1)
    [flourLEDsignal, flourPlantsignal]= PRELOOP(i, flourLEDsignal, flourPlantsignal, meanvalue, tStart, sampleTime, pauseAfterLEDchange);
end


%% MAIN LOOP
tStart = tic; % Restart clock
for i = 0:(period-1) * 10
    [flourLEDsignal, flourPlantsignal, meanvalue]= MAINLOOP(i, flourLEDsignal, flourPlantsignal, meanvalue, tStart, sampleTime, pauseAfterLEDchange);
end
%% Other 
% Turn off fan
FanConfiguration("Off")

% Turn off lamp
LEDintensity = zeros(1,length(settings.conv.LEDs));
LEDintensity_wwString = mat2wwString(LEDintensity,settings.conv.lamp_ip);
webwrite(LEDintensity_wwString{1,1},'');


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

