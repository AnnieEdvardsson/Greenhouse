function phase_deg = estimate_phase(x,y)
%
% Syntax: Estimates phase shift between two signals
%
% Inputs:
%   x - input signal
%   y - output signal
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

%% Fourier transform both signals 
x_fft = fft(x);
y_fft = fft(y);

%% Find the bin corresponding to the frequency we care about
% using the knowledge that it has highest magnitude
[~,slot] = max(abs(x_fft/L));  
                                
%% Finds the phase shift at desired frequency and convert to degrees                           
phase_rad = angle(y_fft(slot)/x_fft(slot));     
phase_deg = phase_rad*180/pi;         

%% Unnecessary, useful to plot magnitudes only:
% f = fs*(0:(L/2))/L;
% P2x = abs(x_fft/L);
% P2y = abs(y_fft/L);
% P1x = P2x(1:L/2+1);
% P1y = P1x(1:L/2+1);
% P1x(2:end-1) = 2*P1x(2:end-1);
% P1y(2:end-1) = 2*P1y(2:end-1);

% slot = round(fsin/fs*L)+1;

end