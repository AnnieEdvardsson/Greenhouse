function [] = getExperimentProtocol(protocol)
% Experiment protocols
if strcmp(protocol,'LC')
experiment_spectra110     = {NL, LL110, LL110, NL, HL110, NL,ML110, NL, LL110, HL110, NL, HL110};
experiment_spectra113     = {NL, LL113, LL113, NL, HL113, NL,ML113, NL, LL113, HL113, NL, HL113};
durations              = {10*60, 1*3600, 1*3600, 10*60, 1*3600, 10*60,2*3600, 10*60, 4*3600, 1.8*3600, 8*3600, 4*3600};

%NL 10min+E, LL 1h, LL 1h+E, HL 1h+E,ML 2h+E, NL 10min+E, LL 10h+E, HL > 24.00, NL > 7.00, HL 

StartExc    = [0, sumDurations(durations,2), sumDurations(durations,10)-(10*60) ]./delta_t+1;
EndExc      = [sumDurations(durations,1), sumDurations(durations,9), sumDurations(durations,10)+(10*60)]./delta_t;