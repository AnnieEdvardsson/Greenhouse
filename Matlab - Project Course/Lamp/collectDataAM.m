function [FluoFilt,FluoRaw,Spectrometers] = collectDataAM(Spectrometers,Sensors,Lamp,Delay)
%set lamp intensity
% webwrite
% sampling
% Input: Delay, is a 'positive' delay and will make the first lamp change
% to come 'delay' seconds earlier.

fluoSensor = length(Sensors);
if fluoSensor
    nrSensors = length(Sensors);
    for ii = 1:nrSensors
        try
            Sensors(ii).SENSOR.beginRead
        catch ME
            nrOfError = nrOfError +1;
            ErrorLog.(strcat('ErrorNr',num2str(nrOfError))) = {ME,clock};
            save(ErrorMsg,'ErrorLog')
        end
            
    end
else
    disp('No Fluorescence sensor is running')
end

[Spectrometers] = runSpecAndLamp(Spectrometers,Lamp,Delay);

if fluoSensor
    for ii = 1:nrSensors
        try 
            Sensors(ii).SENSOR.stopRead
        catch ME
            nrOfError = nrOfError +1;
            ErrorLog.(strcat('ErrorNr',num2str(nrOfError))) = {ME,clock};
            save(ErrorMsg,'ErrorLog')
        end
    end

    %% Data from FluoSensor
    for ii = 1:nrSensors
        try
            Data(ii) = Sensors(ii).SENSOR.result;
        catch ME
            nrOfError = nrOfError +1;
            ErrorLog.(strcat('ErrorNr',num2str(nrOfError))) = {ME,clock};
            save(ErrorMsg,'ErrorLog')
        end
    end
    for ii = 1:nrSensors
        try
            FluoFilt{ii}.time = Data(1,ii).time;
            FluoFilt{ii}.meas = Data(1,ii).measurement;
        catch ME
            nrOfError = nrOfError +1;
            ErrorLog.(strcat('ErrorNr',num2str(nrOfError))) = {ME,clock};
            save(ErrorMsg,'ErrorLog')
            FluoFilt = [];
        end
    end
    for ii = 1:nrSensors
        try
            FluoRaw{ii}.time = Data(1,ii).raw_time;
            FluoRaw{ii}.meas = Data(1,ii).raw_measurement;
        catch ME
            nrOfError = nrOfError +1;
            ErrorLog.(strcat('ErrorNr',num2str(nrOfError))) = {ME,clock};
            save(ErrorMsg,'ErrorLog')
            FluoRaw = [];
        end
    end
else
    FluoFilt = [];
    FluoRaw = [];
end
end

%% -------------------------------------------------------------------------------
function [Spectrometers] = runSpecAndLamp(Spectrometers,Lamp,Delay)
anySpecs = length(Spectrometers);
anyLamp  = Lamp.anyLamp;
if ~anySpecs
    disp('No Spectrometer is running')
end
epoch=datenum('19700101 000000','yyyymmdd HHMMSS');
if isfield(Lamp,'timeAfterLamp')
    timeAfterLamp = Lamp.timeAfterLamp;
else
    timeAfterLamp = 0.5;
end

exc_lamp_mat    = Lamp.exc_mat;
exc_str         = Lamp.exc_str;
% bgr_lamp_mat    = Lamp.bgr_mat;
% bgr_str         = Lamp.bgr_str;
delta_t         = Lamp.delta_t;
sampleTime      = Lamp.sampleTime; %Time between spec samples
exc_period      = Lamp.exc_period;

c               = exc_period/2/delta_t; %Used for the edgefile thing

samplesPerLamp = delta_t/sampleTime;
if floor(samplesPerLamp) ~= samplesPerLamp
    warning('delta_t not a multiple of sampleTime')
end

[lampSteps, ~] = size(exc_lamp_mat);
nSamples = (lampSteps) * samplesPerLamp;
sampleClock = tic;

for i=1:nSamples
    if anySpecs
        for sNr = 1:length(Spectrometers)
            Spectrometers(sNr).Spectra{i,2} = Spectrometers(sNr).Wrapper.getSpectrum(Spectrometers(sNr).Index);
            Spectrometers(sNr).Spectra{i,1} = clock; %timestamp
        end
    else
       disp(datestr(now));
       disp('Spec-measurement')
    end
    if mod(i-1, samplesPerLamp) == 0
        % This is one of the samples after which we change lamp intensities
        j = (i-1+samplesPerLamp) / samplesPerLamp;
        if j <= lampSteps % avoid access outside array bounds
            while toc(sampleClock) < sampleTime*i - timeAfterLamp - Delay
            end
            
            if anyLamp
%                 try
%                     webwrite(bgr_str{1,j},'')
% %                     webwrite(strcat('http://','192.168.100.200','/config.cgi?action=fan&mode=manual&value=255'),'')
%                 catch ME
% %                     nrOfError = nrOfError +1;
% %                     ErrorLog.(strcat('ErrorNr',num2str(nrOfError))) = {ME,clock};
% %                     save(ErrorMsg,'ErrorLog')
%                 end
                try
                    webwrite(exc_str{1,j},'')
                catch ME
%                     nrOfError = nrOfError +1;
%                     ErrorLog.(strcat('ErrorNr',num2str(nrOfError))) = {ME,clock};
%                     save(ErrorMsg,'ErrorLog')
                end
            else
                disp(fprintf('%s',exc_str{1,j}))
                disp(fprintf('%s',bgr_str{1,j}))
            end

            % do the edge file thing
%             x = clock;
%             sprintf('%d %d:%d:%d', j, x(4), x(5), floor(x(6)))
%             unixt = (datenum(x)-epoch) *86400 - timeZone;
%             fid = fopen(edgeFilename, 'a');
%             direction = mod(((j-1)-mod((j-1),c)),c*2)/c;   % 0-down, 1-up marks every lamp change independent of how delta_t relates to period_time.
%             fprintf(fid, '%.2f %d %d\n', unixt, direction, j);
% %             fprintf(fid, '%.2f %d %d\n', unixt, 1-mod(j, 2), j);
%             fclose(fid);
        end
    end

    while toc(sampleClock) < sampleTime*i-Delay
    end
    %toc(sampleClock)
end
end
