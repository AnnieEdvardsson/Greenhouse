%%getSpecSettings: Spectometer Settings used in a setup.
function [settings] = getSpecSettings(mode,varargin)
% Possible calibDates for M2 600 bare fiber.
%2015-08-26
%2016-01-29
%2014-12-17
%2013-01-13
% 2018-01-18 600M1fib

%Possible calibDate for M2 50 CCM
%'2013-06-25'
%'2015-08-26'
%'2018-01-18' 50M1fiber+CCM

settings = struct();
settings.CorrectForElectricalDark = 0;

if nargin>1
    settings.calibDate = varargin{1};
end

if strcmp(mode,'plants')
    settings.cosineCorrector = 0;
    settings.fiberWidth = 600;
    settings.BoxcarWidth = 0;
    settings.ScansToAverage = 1;
    if ~isfield(settings,'calibDate')
        settings.calibDate = '2016-01-29';
    end
    settings.IT = 10000; 
end
if strcmp(mode,'lamp')
    settings.cosineCorrector = 1;
    settings.fiberWidth = 50;
    settings.BoxcarWidth = 3;
    settings.ScansToAverage = 2;
    if ~isfield(settings,'calibDate')
        settings.calibDate = '2015-08-26';
    end
    settings.IT = 1000000; 

end
end