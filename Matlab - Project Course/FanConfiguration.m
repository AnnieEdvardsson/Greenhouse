function FanConfiguration(Setting)
%
% Syntax:  FanConfiguration(Setting)
%
% Inputs:
%    Settings - Wanted value on fan
%
% Outputs:
%     - None
%
%
% Other m-files required:   getSinusSettings.m
% MAT-files required:       none
% Other:                    Need connection to LED lamp
%
% December 2018; Last revision: 06-December-2018
%------------- BEGIN CODE --------------

settings.conv = getSinusSettings();


switch Setting
    case "Default"
        webwrite(strcat('http://',settings.conv.lamp_ip,'/config.cgi?action=fan&mode=default'),'');
        
    case "Max"
        webwrite(strcat('http://',settings.conv.lamp_ip,'/config.cgi?action=fan&mode=default'),'');
        
    case "Off"
        webwrite(strcat('http://',settings.conv.lamp_ip,'/config.cgi?action=fan&mode=default'),'');

    otherwise
        webwrite(strcat('http://',settings.conv.lamp_ip,'/config.cgi?action=fan&mode=',Setting),'');
end







end

  