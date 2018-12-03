%%Sweeping settings: Spectometer Settings used for sweeping.
function [settings] = getSweepingSettings()
settings = struct();
settings.IT = 100000; %ms
settings.ScansToAverage = 2;
settings.CorrectForElectricalDark = 0;
settings.BoxcarWidth = 5;
settings.cosineCorrector = 1;
settings.fiberWidth = 50;
settings.calibDate = '2018-01-18';  
end