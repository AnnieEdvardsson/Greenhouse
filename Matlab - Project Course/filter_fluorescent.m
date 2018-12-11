function filtredSignal = filter_fluorescent(signal)
% This function detrends the measured fluorescent signal and applies a
% filter to it.
%
% Syntax:  filtredSignal = filter_fluorescent(signal)
%
% Inputs:
%    signal - The last n samples of measured fluorescent signal, [1,n]
%
% Outputs:
%    filtredSignal - The filtred fluorescent signal, [1,n]
%
%
% Other m-files required: signal_settings.m
% MAT-files required: none
%
% November 2018; Last revision: 11-December-2018
%------------- BEGIN CODE --------------
%% Load settings from signal_settings.m
s_settings.conv = signal_settings();

%% Design filter
wo = s_settings.conv.f/(s_settings.conv.fs/2);  % location of the notch, must be between 0 and 1                  
bw = wo/10;                                    % bandwidth at -3 dB
[b,a] = iirnotch(wo,bw);                        % gives numerator and denominator coeffiecients for filter function

%% Add filter to signal
signal = detrend(signal);
z = filter(b,a,signal);                         % filters the noisy signal, should leave noise only
filtredSignal = signal-z;                       % Subtract the noise from original signal 

end