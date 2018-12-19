function phase_deg = estimate_phase_sinfit(x,y, time)
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
% December 2018; Last revision: 18-December-2018
%------------- BEGIN CODE -----------

x = detrend(x);
y = detrend(y);
A = 15;
T = 60;
offset = 0;
t = time-300+2:2:time;
fit = @(b,x)  A*(sin(2*pi*t./T + b*pi/180)) + offset;      % Function to fit
cost_y = @(b) sum((fit(b,t) - y).^2);                     % Least-Squares cost function
theta_y = fminsearch(cost_y, 1);                        % Minimise Least-Squares
cost_x = @(b) sum((fit(b,t) - x).^2);                   
theta_x = fminsearch(cost_x, 1);       

theta = theta_y - theta_x;
if theta > 180
    phase_deg = theta - 360;
elseif theta <= -180
    phase_deg = theta + 360;
else
    phase_deg = theta;
end

end

