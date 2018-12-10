function [u,error,cum_error] = pid_control(theta,r,prev_error,cum_error,time_step,Kp,Ki,Kd)
%
% Syntax: finds the new control input to the lamp based on error between
% the desired phase shift and the estimated phase shift
%
% Inputs:
%   theta - estimated phase shift
%   r - desired phase shift
%   prev_error - error in the previous time step
%   cum_error - cumulative error in the last time step
%   time_step - time passed between calling this function
%   Kp - proportionate coefficient
%   Ki - integral coefficient
%   Kp - derivativee coefficient
%
% Outputs:
%   u - new input to the lamp
%   error - error in this time step, stored for the derivative part
%   cum_error - cumulative error, stored to calculate integral part
%
% Other m-files required: none
% MAT-files required: none
%
% December 2018; Last revision: 10-December-2018
%------------- BEGIN CODE -----------

%% PID controller

error = r - theta;
cum_error = cum_error + error;
u = error*Kp + cum_error*Ki + (error-prev_error)/time_step*Kd;


end