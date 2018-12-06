function phase_deg = estimate_phase_hilbert(x,y)
%
% Syntax: Estimates phase shift between two signals
%
% Inputs:
%   x - input signal, the signal from LED lights
%   y - output signal, the measured filtered fluorescence
%
% Outputs:
%   phase_deg - estimated phase shift in degrees
%
%
% Other m-files required: none
% MAT-files required: none
%
% December 2018; Last revision: 06-December-2018
%------------- BEGIN CODE -----------

%% Defines the length of the signal
L = length(x);
%% Convert time-domain signal into an analytic signal via the Hilbert transform
x_h = hilbert(x);
y_h = hilbert(y);

%% Finds the phase shift at desired frequency and convert to degrees                                
phase_rad_all = angle(x_h ./ y_h);
phase_deg_all = phase_rad_all*180/pi;  

phase_deg = mean(phase_deg_all(round(L/4):end-round(L/4)));


end