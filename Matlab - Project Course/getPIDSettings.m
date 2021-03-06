function settings = getPIDSettings()
% Settings used for PID controller
%
% Syntax:  settings = getPIDSettings()
%
% Inputs:
%    None
%
% Outputs:
%    settings - A scruct of settings
%
%
% Other m-files required: None
% MAT-files required: None
% Other requirments:None
%
% December 2018; Last revision: 03-December-2018
%------------- BEGIN CODE --------------
settings =                  struct();
settings.r =                4;            % Wanted phase shift
settings.Kp =               0.5;          % Proportionate coefficient
settings.Ki =               0.1;          % Integral coefficient
settings.Kd =               0;            % Derivativee coefficient

end