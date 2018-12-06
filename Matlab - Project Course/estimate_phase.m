

function phase_deg = estimate_phase(x,y,L)

%Estimates phase shift between two signals
%Inputs:
%   x - input signal
%   y - output signal
%   L - number of samples
%Outputs:
%   phase_deg - estimated phase shift in degrees

%Fourier transform both signals
x_fft = fft(x);
y_fft = fft(y);
%slot = round(fsin/fs*L)+1;     %find the bin corresponding to the frequency we care about
[~,slot] = max(abs(x_fft/L));   %find the bin corresponding to the frequency we care about, 
                                %using the knowledge that it has highest magnitude
phase_rad = angle(y_fft(slot)/x_fft(slot));     %finds the phase shift at desired frequency
phase_deg = phase_rad*180/pi;                   %converts phase to degrees

% Unnecessary, useful to plot magnitudes only:
% f = fs*(0:(L/2))/L;
% P2x = abs(x_fft/L);
% P2y = abs(y_fft/L);
% P1x = P2x(1:L/2+1);
% P1y = P1x(1:L/2+1);
% P1x(2:end-1) = 2*P1x(2:end-1);
% P1y(2:end-1) = 2*P1y(2:end-1);

end