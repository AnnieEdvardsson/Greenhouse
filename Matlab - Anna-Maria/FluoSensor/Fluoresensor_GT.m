clear all; close all;
%clear java; clear import;

%% Connect to FluoSensor

sensor_path = 'C:/Users/Daniel/Google Drive/DanielSharedFolder/sensor development/fluoSensor/Lukas sensor/Fluoresensor/';
javaaddpath([sensor_path,'ReadFluoresensor.jar']);
addpath(genpath('../'));
%addpath(genpath(sensor_path))

%% Automatic (does not work from wifi)
% Sensors = discoverFluoresensors();
% logMessage(['Found ' num2str(length(Sensors)) ' sensors.']);

%% Manual
%IPs = {'10.11.11.203','10.11.11.197'};
IPs = {'10.11.11.203','10.11.11.197','10.11.11.198','10.11.11.202'};
%NAMES = {'sensor4_740','sensor1_685'};
NAMES = {'sensor4_740','sensor1_685','sensor2_740','sensor3_740'};
nrSensors = length(IPs);
for ii = 1:nrSensors
	Sensors(ii).NAME = NAMES{ii};
	Sensors(ii).IP = IPs{ii};
	Sensors(ii).SENSOR = Fluoresensor();
	Sensors(ii).SENSOR.connect(IPs{ii});
end

%% Inputs for experiment

%lampIP = {'10.11.11.200'};
time_dark = 60;
time_light = 120;

sMsg = 'test_allSensors_plus_spectrometer_plus_canopy'; % 100 500 1000 & 1 2 
%savepath = 'C:\Users\Daniel\Google Drive\DanielSharedFolder\sensor development\fluoSensor\Lukas sensor\Fluoresensor\';
savepath = 'C:\Users\Daniel\Google Drive\ChalmersAtHeliospectra\myMatlab\myCollectors\Fluoresensor\GT\';
filename = sprintf('GT_%s_%s.mat',sMsg,datestr(now, 'mmmdd_HH_MM'));


%% Set up lamps

lamp_int = [1000 1000 0 0 0 0];
lamp_growth = [120 0 50 0 50 0]; %PAR 170
[lamp,~] = setUpLamps();

%% Collect spectrometers

[MATLAB_SpectList,n_spect] = collectSpectrometers_JavaPath();

m2settings.IT = 100000; 
m2settings.ScansToAverage = 1;
m2settings.CorrectForElectricalDark = 0;
m2settings.BoxcarWidth = 0;
m2settings.cosineCorrector = 0;
m2settings.fiberWidth = 600;
m2settings.calibDate = '2014-12-17';     

settings.m2 = m2settings;
Spectrometers = jsetUpSpectrometers(MATLAB_SpectList,n_spect,settings);

%clearvars -except Spectrometers n_spect lampSchedule nSamples savepath startTime sMsg MATLAB_SpectList
clearvars m2settings

%% Set up Apogee sensor (SI-431 IR radiometer, 28 degree angle)

% s = serial('COM5','BaudRate',9600);
% fopen(s);

%% Sample both sensors simultaneously for some time

%%% Dark adaption

timeStartDark = clock();
disp('Dark Adaption')
updateVectorIntensities(lamp, 0); pause(.5);

%pause(time_dark)

collecting = 1;
i = 1;
while collecting == true
    time_now = clock; elapsed_time = etime(time_now,timeStartDark);
    if elapsed_time >= time_dark
        collecting = 0;
    else
        disp(fprintf('Dark adaptation: %d min %d sec',floor(elapsed_time/60), floor(mod(elapsed_time,60))));
        for j = 1:n_spect
            current_spect = MATLAB_SpectList(j);
            idx = current_spect.INDEX;
            spectrum = MATLAB_SpectList(j).Spectrometer.getSpectrum(idx);
            Spectrometers(j).Spectra{i,1} = spectrum;
        end
%%        
%         fprintf(s,'0M1!'); pause(1); % 0M1! 0M!
%         temp = fscanf(s); pause(1); temp = fscanf(s); pause(1)
%         fprintf(s,'0D0!'); pause(1);
%         temp = fscanf(s); pause(1)
%         idxs = strfind(temp,'+');
%         temp_target(i,1) = str2num(temp(idxs(1)+1:idxs(2)-1));
%         temp_detector(i,1) = str2num(temp(idxs(2)+1:end));
        
        i = i + 1;
        pause(5);
    end
end

%%% Light excitation

%timeStartLight = clock();

for ii = 1:nrSensors
    Sensors(ii).SENSOR.beginRead
end

pause(1);

disp('Light treatment')
timeStartLight = clock();
tic;
updateVectorIntensities(lamp, lamp_int); %pause(.5);
timer(1,1) = toc;

%pause(time_light)

collecting = 1;
i = 1;
while collecting == true
    time_now = clock; elapsed_time = etime(time_now,timeStartLight);
    if elapsed_time >= time_light
        collecting = 0;
    else
        %disp(fprintf('Dark adaptation: %d min %d sec',floor(elapsed_time/60), floor(mod(elapsed_time,60))));
        for j = 1:n_spect
            current_spect = MATLAB_SpectList(j);
            idx = current_spect.INDEX;
            spectrum = MATLAB_SpectList(j).Spectrometer.getSpectrum(idx);
            Spectrometers(j).Spectra{i,2} = spectrum;
        end
        
%         fprintf(s,'0M1!')
%         fprintf(s,'0D2!')
%         temp = fscanf(s);
%         temps(i,2) = temp;
        
        i = i + 1;
        pause(1);
    end
end

updateVectorIntensities(lamp, 0); pause(.5);
timer(1,end+1) = toc;

for ii = 1:nrSensors
    Sensors(ii).SENSOR.stopRead
end

% fclose(s)
% delete(s)
% clear s

timer(1,end+1) = toc;
updateVectorIntensities(lamp, lamp_growth); pause(.5);

for ii = 1:nrSensors
    Data(ii) = Sensors(ii).SENSOR.result;
end

Sensors = rmfield(Sensors, 'SENSOR');

save([savepath,filename],'Data','Sensors','time_dark','time_light','nrSensors','Spectrometers','timer');
%%

colors = {'b','r','g','k'};
figure();
for ii = 1:nrSensors
    x = Data(1,ii).time;
    y = Data(1,ii).measurement;
    h(1,ii) = plot(x,y);
    hold on
    set(h(1,ii),'color',colors{1,ii});
    legNames{1,ii} = Sensors(ii).NAME;
end
legend(h,legNames);

figure()
for ii = 1:nrSensors
    x = Data(1,ii).raw_time;
    y = Data(1,ii).raw_measurement;
    h(1,ii) = plot(x,y);
    hold on
    set(h(1,ii),'color',colors{1,ii});
    legNames{1,ii} = Sensors(ii).NAME;
end
legend(h,legNames);

%%

return

for ii = 1:nrSensors
    Sensors(ii).SENSOR.delete;
end


% Data
data_file = 'FluoresensorGT_1_Aug17_11_43.mat';
data_file = 'GT_1_100__Aug17_17_24.mat';
data_file = 'GT_1_500__Aug17_17_40.mat';
data_file = 'GT_1_1000__Aug17_17_50.mat';

load(data_file);