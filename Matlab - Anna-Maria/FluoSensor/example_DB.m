javaaddpath('./ReadFluoresensor.jar');
% 
% %% Automatic (does not work from wifi)
% Sensors = discoverFluoresensors();
% logMessage(['Found ' num2str(length(Sensors)) ' sensors.']);

%% Manual
IPs = {'192.168.1.5'};
NAMES = {'FOO'};
for ii = 1:length(IPs)
    Sensors(ii).NAME = NAMES{ii};
	Sensors(ii).IP = IPs{ii};
	Sensors(ii).SENSOR = Fluoresensor();
	Sensors(ii).SENSOR.connect(IPs{ii});
end
nrSensors =1;
for ii = 1:nrSensors
    Sensors(ii).SENSOR.beginRead
end

for ii = 1:nrSensors
    Sensors(ii).SENSOR.stopRead
end

for ii = 1:nrSensors
    Data(ii) = Sensors(ii).SENSOR.result;
end

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

