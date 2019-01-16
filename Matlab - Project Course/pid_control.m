function [factor ,phase_error] = pid_control(theta, phase_error, time_step, factor)
% Finds the new control input to the lamp based on error between
% the desired phase shift and the estimated phase shift
%
% Syntax: [u,error,cum_error] = pid_control(theta,prev_error,cum_error,time_step)
%
% Inputs:
%   theta - estimated phase shift
%   r - desired phase shift
%   prev_phase_error - error in the previous time step
%   cum_error - cumulative error in the last time step
%   time_step - time passed between calling this function

%
% Outputs:
%   backgroundIntensity - new input to the lamp
%   phase_error - error in this time step, stored for the derivative part
%   cum_error - cumulative error, stored to calculate integral part
%
% Other m-files required: none
% MAT-files required: none
%
% December 2018; Last revision: 10-December-2018
%------------- BEGIN CODE -----------

%% Load settings
settings.s =    getPIDSettings();
Kp =            settings.s.Kp;
Ki =            settings.s.Ki;
Kd =            settings.s.Kd;
r =             settings.s.r;

%% PID controller
phase_error = [phase_error, r - theta];
% phase_error_mean = mean(phase_error(end-25: end));
cum_error = sum(phase_error);

% P = phase_error_mean*Kp;
P = phase_error*Kp;

I = time_step*cum_error*Ki;
% D = (phase_error(end)-phase_error(end-1))/time_step*Kd;

factor = [factor, P + I];

end