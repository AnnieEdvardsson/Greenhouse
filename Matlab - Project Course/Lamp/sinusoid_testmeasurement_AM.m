clear all 
close all 
clc

addpath(genpath('..\Mapping'))
addpath(genpath('\AM_Sweeping'))
addpath('..\')


% Load settings 
settings.conv = getSettings();


%% Define variables
% wavelengths = [0 1 0 0 0 0 0];  % wavelengths used in excitation signal 
period_t    = 60;               % period time in seconds, could be one value or a vector of length(wavelengths)
amplitude  = 10;                % amplitude of excitation signal given in uE 
meanvalue = 20;
step_length = 1;
i = 0;

%%
[Lamp.exc_mat, Lamp.exc_str] = sinusSignal_AM();
Lamp.delta_t = 1;
Lamp.sampleTime = 1; %Time between spec samples
Lamp.exc_period = 1;
Lamp.anyLamp = true;

%% Setup for the measurment of spectrometer
settings_spec.m2     = getSweepingSettings();
Spectrometers   = jsetUpSpectrometers(settings_spec); %The java-object(s) communicating with the spectrometer(s) is (are) created and contained in Spectrometer.Wrapper


%% Turn on fan on maximum speed
webwrite(strcat('http://',settings.conv.lamp_ip,'/config.cgi?action=fan&mode=manual&value=255'),'');

[~,~,Spectrometers] = collectDataAM(Spectrometers,[],Lamp,0);


int_index(:,:,1) = [725 750; 410 430; 400 700];

specProc = amprepareData_All(Spectrometers, 1, int_index);
specProc.t=unixtime(cell2mat(Spectrometers.Spectra(:,1)),3600);
specProc.t=specProc.t-specProc.t(1);
