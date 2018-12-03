function [settings] = getSweepingSettings()
% Spectometer Settings used for sweeping
%
% Syntax:  [settings] = getSweepingSettings()
%
% Inputs:
%    None
%
% Outputs:
%    settings - A scruct of settings
%
%
% Other m-files required: None
% MAT-files required: None
% Other requirments:None
%
% December 2019; Last revision: 03-December-2019
%------------- BEGIN CODE --------------
settings = struct();
settings.IT = 100000; %ms
settings.ScansToAverage = 2;
settings.CorrectForElectricalDark = 0;
settings.BoxcarWidth = 5;
settings.cosineCorrector = 1;
settings.fiberWidth = 50;
settings.calibDate = '2018-01-18';  
end