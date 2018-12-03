%Before measuring the lamp, turn it on all LEDs (except 380 and 400) for 10 minutes.
clear variables
close all
clc
addpath(genpath('../Spectrometers'))
addpath('../Lamp')


% lamp_ip = '192.168.100.101'; %LX
lamp_ip = '192.168.100.102'; %RX
webwrite(strcat('http://',lamp_ip,'/config.cgi?action=fan&mode=manual&value=255'),'')%max fan speed

savepath  = 'D:\BoxSync\anncars\MyMatlab\ControlExperiments_Chalmers_Autumn2017/SpectrumPlots/';
format   = {'.eps','.png','.fig'}; 
%% -- LX ----------------------
% lamp_mat = [1000 1000 600 600 1000 1000]; %1030

% lamp_mat = [1000 1000 600 550 1000 650];

% lamp_mat = [1000 1000 550 550 650 650];   %900
% lamp_mat = [1000 1000 500 500 600 600];   %850
% lamp_mat = [1000 1000 500 500 400 400];   %800
% lamp_mat = [1000 1000 500 470 400 120];   %750
% lamp_mat = [1000 1000 470 470 120 120];   %700
% lamp_mat = [1000 1000 470 430 120 0];     %650
% lamp_mat = [1000 1000 430 430 0 0];       %600
% lamp_mat = [1000 650 470 270 0 0];        %550
% lamp_mat = [1000 515 430 220 0 0];        %500
% lamp_mat = [1000 310 430 115 0 0];        %450
% lamp_mat = [515 515 220 220 0 0];         %400
% lamp_mat = [515 340 220 140 0 0];         %375
% lamp_mat = [515 310 220 115 0 0];         %350
% lamp_mat = [515 152 220 72 0 0];          %325
% lamp_mat = [310 310 115 115 0 0];         %300
% lamp_mat = [310 165 115 75 0 0];          %275
% lamp_mat = [310 110 115 65 0 0];          %250
% lamp_mat = [110 140 65 78 0 0];           %225
% lamp_mat = [110 110 65 65 0 0];           %200
% lamp_mat = [110 70 65 45 0 0];            %175
% lamp_mat = [110 50 65 33 0 0];            %150
% lamp_mat = [70 50 50 30 0 0];             %125
% lamp_mat = [50 50 33 33 0 0];             %100
% lamp_mat = [50 22 33 16 0 0];             %76
% lamp_mat = [50 0 33 0 0 0];               %50
% lamp_mat = [25 0 16 0 0 0];               %25
% % %%
% Msg     = 'LX_protocol_LX_LC_25o50BasilJan_JAZ';
% lamp_mat = [25 0 16 0 0 0;
%                 50 0 33 0 0 0;               
%                 50 22 33 16 0 0;             
%                 50 50 33 33 0 0;             
%                 70 50 50 30 0 0;
%                 110 50 65 33 0 0;
%                 110 70 65 45 0 0;
%                 110 110 65 65 0 0;
%                 110 140 65 78 0 0;
%                 310 110 115 65 0 0;
%                 310 165 115 75 0 0;
%                 310 310 115 115 0 0;
%                 515 152 220 72 0 0;
%                 515 310 220 115 0 0;
%                 515 340 220 140 0 0;
%                 515 515 220 220 0 0;
%                 1000 310 430 115 0 0;
%                 1000 515 430 220 0 0;
%                 1000 650 470 270 0 0;
%                 1000 1000 430 430 0 0;
%                 1000 1000 470 430 120 0;
%                 1000 1000 470 470 120 120;
%                 1000 1000 500 470 400 120;
%                 1000 1000 500 500 400 400;
%                 1000 1000 500 500 600 600;
%                 1000 1000 550 550 650 650;
%                 1000 1000 600 550 1000 650;
%                 1000 1000 600 600 1000 1000];

%% -- RX -----------------------------------------------------------
% LEDs = [380 400 420  450 530 620 660 735 5700];
% % lamp_mat = [0 0 0 0 0 0 20 0 30];
% lamp_mat = [0 0 0 2 3 7 7 0 0;...
%     0 0 0 7 9 27 11 0 0;...
%     0 0 0 13 16 37 19 0 0;... 
%     0 0 0 20 20 45 29 0 0;... 
%     0 0 0 27 29 59 35 0 0;... 
%     0 0 0 34 35 72 42 0 0;... 
%     0 0 0 41 40 81 52 0 0;... 
%     0 0 0 47 49 85 62 0 0;... 
%     0 0 0 53 57 90 70 0 0;... 
%     0 0 0 215 320 540 400 0 0;... 
%     0 0 0 275 480 1000 400 0 0];
%     lamp_mat = [0 0 0 0 0 0 0 0 0;...
%         0 0 0 2 3 7 0 0 0;...
%         0 0 0 7 9 27 0 0 0;...
%         0 0 0 13 16 37 0 0 0;... 
%         0 0 0 20 20 45 0 0 0;... 
%         0 0 0 27 29 59 0 0 0;... 
%         0 0 0 34 35 72 0 0 0;... 
%         0 0 0 41 40 81 0 0 0;... 
%         0 0 0 47 49 85 0 0 0;... 
%         0 0 0 53 57 90 0 0 0;... 
%         0 0 0 215 320 540 0 0 0;... 
%         0 0 0 275 480 1000 0 0 0];

Msg  = 'RX_GrowthSpectrumBasilJan_M2';
lamp_mat = [0 0 0 600 70 900 900 0 0];% Growth light RX jan 2018
%%
[SpecBands,Spectrometers,fig] = getINTirrOfLampSetting(lamp_mat,lamp_ip,format,savepath,Msg);
% [SpecBands,Spectrometers,fig] = getINTirrOfLampSetting(lamp_mat,lamp_ip);
%lamp_mat = zeros(1,9); %0
% lamp_mat = [0 0 0 2 3 7 7 0 0];%22
% %lamp_mat = [0 0 0 7 9 27 11 0 0];%40
% % lamp_mat = [0 0 0 13 16 37 19 0 0];%60
% % lamp_mat = [0 0 0 20 20 45 29 0 0];%80
% % lamp_mat = [0 0 0 27 29 59 35 0 0]; %100
% % lamp_mat = [0 0 0 34 35 72 42 0 0];%120
% % lamp_mat = [0 0 0 41 40 81 52 0 0];%140
% % lamp_mat = [0 0 0 47 49 85 62 0 0];%160
% % lamp_mat = [0 0 0 53 57 90 70 0 0];%180
% % lamp_mat  = [0 0 0 215 320 540 400 0 0];%200
% % lamp_mat  = [0 0 0 240 400 700 400 0 0];%210
% % lamp_mat  = [0 0 0 275 480 1000 400 0 0];%220


webwrite(strcat('http://',lamp_ip,'/config.cgi?action=fan&mode=default'),'')

%% ---------------------------------------
function [SpecBands,Spectrometers,fig] = getINTirrOfLampSetting(lamp_mat,lamp_ip,varargin) 
idx = 0;
% settings.JAZ                 = getSpecSettings('lamp','2018-01-18');
% settings.JAZ.IP              = '192.168.100.103';
settings.m2                 = getSpecSettings('lamp','2018-01-18');
Spectrometers               = jsetUpSpectrometers(settings);
% Spectrometers.Wrapper.setIntegrationTime(idx,1E6)

filename = cell(size(lamp_mat,1),1);
for i = 1:size(lamp_mat,1)
    lamp_str = mat2wwString(lamp_mat(i,:),lamp_ip);
    webwrite(lamp_str{1,1},'')
    filename{i} = strcat('Spectrum_',datestr(now,'yyyy-mm-dd'),'LAMPsetting_',mat2str(lamp_mat(i,:)));
    pause(4)
    ITfound                        = findIT(Spectrometers,10,true);
%     if ITfound > 999000
%         ITfound = floor(ITfound/(0.5E+6))*0.5E+6;
%     end
    Spectrometers.Wrapper.setIntegrationTime(idx,ITfound)
    
    Spectrometers(1).IT(i)         = Spectrometers.Wrapper.getIntegrationTime(idx);
    
    Spectrometers(1).Spectra{i,2}  = Spectrometers.Wrapper.getSpectrum(idx);
end

[SpecBands,fig] = getSpectrumBands(Spectrometers,1);

if exist('varargin','var')
    format = varargin{1};
    path   = varargin{2};
    Msg    = varargin{3};
    save(strcat(path,'SpecRawMeas_and_LAMPinput',datestr(now,'yyyy-mm-dd-HHMM'),Msg),'Spectrometers','lamp_mat');
    for i = 1:size(lamp_mat,1)
        for j = 1:length(format)
            saveas(fig(i),strcat(path,filename{i},format{j}))
        end
    end
end
end
