function [Sensors] = setUpFluoSensorAM(IPs,NAMES,ReadTime)

%todo: fixa så att om connection time out error uppstår så går det att
%ansluta igen.
%javaaddpath('./ReadFluoresensor.jar');
%IPs = {'192.168.1.5'};
%NAMES = {'FluoSens3'};
for ii = 1:length(IPs)
    Sensors(ii).NAME = NAMES{ii};
	Sensors(ii).IP = IPs{ii};
	Sensors(ii).SENSOR = Fluoresensor();
	Sensors(ii).SENSOR.connect(IPs{ii});
    Sensors(ii).SENSOR.maxreadtime(ReadTime);
end
end