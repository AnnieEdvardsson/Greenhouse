clear variables
close all
clc
addpath(genpath('../Spectrometers'))
addpath('../Lamp')

lamp_ip = '192.168.0.100';
webwrite(strcat('http://',lamp_ip,'/config.cgi?action=fan&mode=manual&value=255'),'')%max fan speed


format   = {'.eps','.png','.fig'}; 
%% -----------------------------------------------------------
% LEDs = [380 400 420  450 530 620 660 735 5700];
% lamp_mat = [0 0 0 0 0 0 5 0 20];
lamp_mat = [0 0 0 0 0 0 0 0 0;...
    0 0 0 2 3 7 7 0 0;...
    0 0 0 7 9 27 11 0 0;...
    0 0 0 13 16 37 19 0 0;... 
    0 0 0 20 20 45 29 0 0;... 
    0 0 0 27 29 59 35 0 0;... 
    0 0 0 34 35 72 42 0 0;... 
    0 0 0 41 40 81 52 0 0;... 
    0 0 0 47 49 85 62 0 0;... 
    0 0 0 53 57 90 70 0 0;... 
    0 0 0 215 320 540 400 0 0;... 
    0 0 0 275 480 1000 400 0 0];

%lamp_mat = zeros(1,9);

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


% lamp_mat = zeros(10,9);
% for k = 2:10
%     lamp_mat(k,:)  = lamp_mat(k-1,:)+ [0 0 0 100 0 0 100 0 0]; 
% end
%% ---------------------------------------
idx = 0;
settings.m2                 = getSpecSettings('lamp');
% settings.m2                 = getSpecSettings('plant');
Spectrometers               = jsetUpSpectrometers(settings);
Spectrometers.Wrapper.setIntegrationTime(idx,1E6)

filename = cell(size(lamp_mat,1),1);
for i = 1:size(lamp_mat,1)
    lamp_str = mat2wwString(lamp_mat(i,:),lamp_ip);
    webwrite(lamp_str{1,1},'')
    filename{i} = strcat('Spectrum_',datestr(now,'yyyy-mm-dd'),'LAMPsetting_',mat2str(lamp_mat(i,:)));
    ITfound                     = findIT(Spectrometers,10,0);
    Spectrometers.Wrapper.setIntegrationTime(idx,ITfound)
    Spectrometers(1).Spectra{i,2}    = Spectrometers.Wrapper.getSpectrum(idx);
end

[SpecBands,fig] = getSpectrumBands(Spectrometers,1);


for i = 1:size(lamp_mat,1)
    for j = 1:length(format)
        saveas(fig(i),strcat('../ControlExperiments_Chalmers_Autumn2017/SpectrumPlots/',filename{i},format{j}))
    end
end