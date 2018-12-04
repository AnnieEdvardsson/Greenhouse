%% This is the main-file for the Greenhouse project'
%% Clear and close
clear; close all; clc

%% Pre-define and initiate
format long;

% Setup for the measurment of spectrometer
settings_spec.m2     = getSweepingSettings();
Spectrometers   = jsetUpSpectrometers(settings_spec); %The java-object(s) communicating with the spectrometer(s) is (are) created and contained in Spectrometer.Wrapper


%% Other 
% Turn on fan on maximum speed
webwrite(strcat('http://',settings.conv.lamp_ip,'/config.cgi?action=fan&mode=manual&value=255'),'');

%% Timekeeper

tStart = tic;
pauseAfterLEDchange = 0.5;
sampleTime = 2;

tElapsed = toc(tStart)

%% LOOP
for i = 0:59 * 10
    fprintf("Loop #%i -- ", i+1);
    
    %% Generate sinus + store flour signal from LED
    % Create calculate sinus signal and set LED value 
    % Return the LED value in flour spectrum
    flourLEDValue =  sinusSignal(meanvalue, toc(tStart));
    
    % Add returned flourLEDValue value to vector flourLEDsignal
    % flourLEDsignal = add(flourLEDValue)
    
    %% Pause until it can be ensured that the LEDs are set
    while toc(tStart) < sampleTime*i + pauseAfterLEDchange
    end
    
    %% Measure flour from plants and store and process
    % Measure emitted flour from plants
    % flourPlantValue = measureflour();
    
    % Add returned flourPlantValue value to vector flourPlantsignal
    % flourPlantsignal = add(flourPlantValue)
    
    % Process the LED signal in flour spectrum
    filtredFlourSignal = filter_fluorescent(flourPlantsignal);
    
    %% Estimate the phase shift
    % estimate(flourPlantsignal, flourLEDsignal)
    
    %% Controller
    % PID controller
    
    
    %% Pause intil the sample time of the loop is finished
    while toc(tStart) < sampleTime*(i+1)
    end


end
%% Other 
% Turn off fan
webwrite(strcat('http://',settings.conv.lamp_ip,'/config.cgi?action=fan&mode=default'),'');

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