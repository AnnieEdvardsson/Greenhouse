function filtredSignal = filter_fluorescent(signal)
% This function applies a filter to the measured fluorescent signal
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
% Other m-files required: none
% MAT-files required: none
%
% November 2019; Last revision: 30-November-2019
%------------- BEGIN CODE --------------
%% Design filter
% The size of the window (the bigger the less it follows measured signal)
windowSize = 25;    
b = (1/windowSize)*ones(1,windowSize);

% The order
a = 1;              

%% Add filter to signal
filtredSignal = filter(b,a,signal);

end