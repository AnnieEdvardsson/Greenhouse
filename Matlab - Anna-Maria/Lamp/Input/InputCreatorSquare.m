
clear all
clc
addpath(genpath('..\..\MyMatlab'))
%% loading swwepingdata
% lamp 110
filename110  = 'SweepAnalysis_Sweeping_M1_binary_mode2_Dec04_Jan03-01_58.mat';
path        = ['D:\Users\anna-maria\Desktop\Daniel B Matlab Files 121211\myMatlab121218\myCollectors\sweeping\' ];
%load([filename110],'intIRRmatrix','lampINTmatrix');
load([path,filename110],'intIRRmatrix','lampINTmatrix');
intIRRmatrix110 = intIRRmatrix;
lampINTmatrix110 = lampINTmatrix;

%lamp 113
filename113 = 'SweepAnalysis_Sweeping_M1_stair_mode2_Dec04_Jan03-02_01.mat';
load([path,filename113],'intIRRmatrix','lampINTmatrix');
%load([path,filename113],'intIRRmatrix113','lampINTmatrix113');
intIRRmatrix113 = intIRRmatrix;
lampINTmatrix113 = lampINTmatrix;
%% INPUT variables
%Excitation light
% wavelengthsorder = [400 420 460 530 620 660 735]
wavelengths = [0 1 0 0 0 0 0]; % wavelengths used in excitation signal 
lambda = 2;
period_t    = 10*60; % period time in seconds, could be one value or a vector of length(wavelengths)
amplitudes  = 65; %amplitude of excitation signal given in uE 

delta_t = period_t/2;      % time between inputs sent to lamp

% %Background light
run LampSettings.m
run ExperimentProtocolmar4.m

%%
background110 = LightRegime(experiment_spectra110, durations);
background113 = LightRegime(experiment_spectra113, durations);
excitation110 = ExcitationSquare(wavelengths, period_t, amplitudes);

iterations = ceil(background110.getTotDuration() / delta_t);
background_spectrum110=zeros(1,7);
background_spectrum113=zeros(1,7);
excitation_spectrum110=zeros(1,7);

for i = 1:iterations
	background_spectrum110(i,:) = background110.getIntensity((i-1)*delta_t);
    excitation_spectrum110(i,:) = excitation110.getIntensity((i-1)*delta_t);
    
    background_spectrum113(i,:) = background113.getIntensity((i-1)*delta_t);
    %excitation_spectrum113(i,:) = excitation113.getIntensity((i-1)*delta_t);
    if excitation_spectrum110(i,lambda) == 0
        lampExcitation_spectrum110(i) = 0;
    else 
        [lampExcitation_spectrum110(i) ,~, ~] = getlampLevel( intIRRmatrix110, lampINTmatrix110, excitation_spectrum110(i,:),lambda);
   
    end
end


lamp110= background_spectrum110;
%lamp110(:,2)=lampExcitation_spectrum110;
for i = 1: length(StartExc)
    lamp110(StartExc(i):EndExc(i),2)=lampExcitation_spectrum110(StartExc(i):EndExc(i));
end

lamp110(end+1,:) = [0 0 0 0 0 0 0];
lamp113=background_spectrum113;
lamp113(end+1,:) = [0 0 0 0 0 0 0];

% alt: olika p� b�da. Borde man g�ra *2 f�r att f� samma totala intensitet?
%lamp110=background_spectrum
%lamp113=excitation_spectrum

filename = sprintf('square_%s.mat', datestr(now, 'mmmdd-HH_MM'));
savepath = 'LampInput\';
save([savepath,filename],'delta_t','lamp110','lamp113');

figure
plot([1:length(lamp110)]*delta_t./3600, lamp110)
figure
plot([1:length(lamp110)]*delta_t./3600,lamp113)