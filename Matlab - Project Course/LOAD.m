close all
clear all
clc

j = 7;

addpath(genpath('..\DataWorkspaces19dec'))
addpath(genpath('..'))

% 18 dec
backgroundIntensityVEC = [0, 10, 75, 100, 125, 160, 170, 200, 300];



%load(sprintf("WorkspaceForBackground_18dec_%i", backgroundIntensityVEC(j)))
load(sprintf("WorkspaceForBackground_TEST_PID3.mat"))


% 
% 

%
% 
% % figure(2)
% % plot(0:2:2*length(phase_error2)-1, phase_error2*-1)
% % hold on
% % plot(0:2:2*length(phase_error2)-1, phase_error2_meas*-1);
% % legend("Phase shift with calculated excitation signal", "Phase shift with measured excitation signal")
% % title(sprintf("Hilbert phase shift with background intensity %i", backgroundIntensityVEC(j)))
% % xlabel("Seconds")
% % ylabel("Degrees")
% %

% 
% figure(4)
% plot(0:2:2*length(phase_error)-1, phase_error)
% hold on
% plot(0:2:2*length(phase_error2)-1, phase_error2*-1)
% %plot(0:2:2*length(phase_error3)-1, phase_error3*-1)
% legend("Estimated phase shift using DFT method", "Estimated phase shift using hilbert method")
% title(sprintf("Phase shift with background intensity %i %smol m^{-2} s^{-1}", backgroundIntensityVEC(j), char(181)))
% xlabel("Seconds")
% ylabel("Degrees")
% 
% %
% % figure(5)
% % plot(0:2:2*length(measured_450Signal)-1, measured_450Signal)
% % hold on
% % plot(0:2:2*length(measured_660Signal)-1, measured_660Signal)
% % line([0,2*length(measured_450Signal)],[backgroundIntensity,backgroundIntensity])
% % legend("Measured signal 440", "Measured sugnal 660")
% % title(sprintf("Phase shift with background intensity %i", backgroundIntensityVEC(j)))
% % xlabel("Seconds")
% % ylabel("Intensity")
% % 
% % % phase_error0 = phase_error0(350:1250);
% phase_error10 = phase_error10(350:1250);
% phase_error75 = phase_error75(350:1250);
% phase_error100 = phase_error100(350:1250);
% phase_error125 = phase_error125(350:1250);
% phase_error160 = phase_error160(350:1250);
% phase_error200 = phase_error200(350:1250);
% phase_error300 = phase_error300(350:1250);
% %
% 

%% PID controller phase shift behavivour
figure(4)
load("WorkspaceForBackground_TEST_PID5.mat")

phase_error  = phase_error(2:end);

plot(0:2:2*length(phase_error)-1,phase_error, 'LineWidth',1)

ylim([-12, 12])


xlabel("Time [s]",'fontweight','bold')
ylabel("Phase shift [Degree]",'fontweight','bold')

% %% Different insensities compair pahse shift

load("phaseError0")
phase_error0 = phase_error;
load("phaseError10")
phase_error10 = phase_error;
load("phaseError75")
phase_error75 = phase_error;
load("phaseError100")
phase_error100 = phase_error;
load("phaseError125")
phase_error125 = phase_error;
load("phaseError160")
phase_error160 = phase_error;
load("phaseError200")
phase_error200 = phase_error;
load("phaseError300")
phase_error300 = phase_error;

figure(5)
%plot(0:2:2*length(phase_error0)-1, phase_error0)
hold on
plot(0:2:2*length(phase_error10)-1, phase_error10, 'LineWidth',1)
plot(0:2:2*length(phase_error75)-1, phase_error75, 'LineWidth',1)
plot(0:2:2*length(phase_error100)-1, phase_error100, 'LineWidth',1)
plot(0:2:2*length(phase_error125)-1, phase_error125, 'LineWidth',1)
plot(0:2:2*length(phase_error160)-1, phase_error160, 'LineWidth',1)
plot(0:2:2*length(phase_error200)-1, phase_error200, 'LineWidth',1)
plot(0:2:2*length(phase_error300)-1, phase_error300, 'LineWidth',1)

string0 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 0, char(181));
string10 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 10, char(181));
string75 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 75, char(181));
string100 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 100, char(181));
string125 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 125, char(181));
string160 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 160, char(181));
string200 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 200, char(181));
string300 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 300, char(181));

legend({string0, string10, string75, string100, string125, string160, string200, string300},'fontweight','bold')

xlabel("Time [s]",'fontweight','bold')
ylabel("Phase Shift [Degree]",'fontweight','bold')
ylim([-2 19.5])
xlim([0 1800])

% 
% fprintf("Mean values: 0=%f, 10=%f, 75=%f, 100=%f, 125=%f, 160=%f, 200=%f, 300=%f", mean(phase_error0),mean(phase_error10), mean(phase_error75), mean(phase_error100), mean(phase_error125), mean(phase_error160), mean(phase_error200), mean(phase_error300))
% meanY = [mean(phase_error10), mean(phase_error75), mean(phase_error100), mean(phase_error125), mean(phase_error160), mean(phase_error200), mean(phase_error300)];
% meanX = [10, 75, 100, 125, 160, 200, 300];
% figure
% plot(meanX, meanY)
% 
% % 
% % 
%% Filtered vs raw 2
load(sprintf("WorkspaceForBackground_TEST_filt.mat"))
figure(3)
var1 = -phase_error2(1400:1650);
var2 = -phase_error2FILTERFILTER(1400:1650);
plot(0:2:2*length(var1)-1, var1, 'LineWidth',1)
hold on 
plot(0:2:2*length(var2)-1, var2, 'LineWidth',1)

legend({"Raw signal", "Filtered signal"},'fontweight','bold')
xlabel("Time [s]",'fontweight','bold')
ylabel("Phase shift [degree] ",'fontweight','bold')
% ylim([0,2000])

%% DFT vs HIL
figure(4)
var1 = phase_errorFILTERFILTER;
var2 = -phase_error2FILTERFILTER;
plot(0:2:2*length(var1)-1, var1, 'LineWidth',1)
hold on 
plot(0:2:2*length(var2)-1, var2, 'LineWidth',1)

legend({"DFT method", "Hilbert method"},'fontweight','bold')
xlabel("Time [s]",'fontweight','bold')
ylabel("Phase shift [Degree]",'fontweight','bold')
xlim([0,2000])

%% Different insensities compair pahse shift NY
backgroundIntensityVEC = [20, 40, 60, 80, 90, 100, 110, 120, 140, 150, 160, 170, 180, 200];
backgroundIntensityVEC = [20, 60, 80, 100, 120, 160, 200];
for i = 1:length(backgroundIntensityVEC)
    load(sprintf("phase%i", backgroundIntensityVEC(i)))
    A{i} = phase_error;
end

close all
figure(5)
hold on
for i = 1:length(backgroundIntensityVEC)
    hold on
    plot(0:2:2*length(A{i})-1, A{i}, 'LineWidth',1)
    string{i} = sprintf("Intensity %i %smol m^{-2} s^{-1}", backgroundIntensityVEC(i), char(181));
%     legend({string{i}},'fontweight','bold')
    
end
% legend(backgroundIntensityVEC)
% legend({backgroundIntensityVEC},'fontweight','bold')
string1 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 20, char(181));
string3 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 60, char(181));
string4 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 80, char(181));
string5 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 100, char(181));
string160 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 120, char(181));
string300 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 160, char(181));
string3002 = sprintf("Intensity %i %smol m^{-2} s^{-1}", 200, char(181));
legend({string1, string3, string4, string5, string160, string300, string3002},'fontweight','bold')

xlabel("Time [s]",'fontweight','bold')
ylabel("Phase shift [Degree]",'fontweight','bold')
ylim([-2 19.5])
xlim([0 1800])

for i = 1:length(backgroundIntensityVEC)
    
    meanY(i) = mean(A{i})
    
end

figure
plot(backgroundIntensityVEC, meanY, 'LineWidth',1.4)
xlabel(sprintf("Light intensity [%smol m^{-2} s^{-1}]", char(181)),'fontweight','bold')
ylabel("Mean phase shift [Degree]",'fontweight','bold')


%% COMPAIR measured LED signal and calculated 
clear
load(sprintf("AM_MODWorkspaceForBackground_150.mat"))

figure(6)
plot(0:2:2*length(flourLEDsignal)-1, detrend(measured_420Signal), 'black', 'LineWidth',1)
meean = (((max(measured_420Signal)-min(measured_420Signal))/2)+min(measured_420Signal));
factor = meean/17;
hold on
plot(0:2:2*length(flourLEDsignal)-1, detrend(flourLEDsignal*factor), 'red', 'LineWidth',1)
line([0,2*length(measured_420Signal)-1],[0,0])

ylim([-0.025,0.03])
xlim([0,150])

legend({"Calculated excitation signal", "Measured excitation signal"},'fontweight','bold')
xlabel("Time [s]",'fontweight','bold')
ylabel("Relative light intensity",'fontweight','bold')

%% Compair DFT and Hilbert method Phase shift
clear all

load(sprintf("WorkspaceForBackground_18dec_10.mat"))

figure(7)
plot(0:2:2*length(phase_error)-1, phase_error, 'LineWidth',1)
hold on
plot(0:2:2*length(phase_error2)-1, phase_error2*-1, 'LineWidth',1)

xlim([0,600])
ylim([0,6])

legend({"Estimated phase shift using DFT method", "Estimated phase shift using Hilbert method"},'fontweight','bold')
%title(sprintf("Phase shift with background intensity %i %smol m^{-2} s^{-1}", backgroundIntensityVEC(j), char(181)))
xlabel("Time [s]",'fontweight','bold')
ylabel("Phase shift [Degree]",'fontweight','bold')

%% RAW VS FILTERED SIGNAL
clear all
load(sprintf("WorkspaceForBackground_TEST_StedyBLight.mat"))

figure(8)
filtredSignal = detrend(filter_fluorescent(flourPlantsignal));
plot(0:2:2*length(flourLEDsignal)-1, detrend(flourPlantsignal))
% plot(filtredSignal)
hold on
% plot(detrend(flourPlantsignal))
plot(0:2:2*length(flourLEDsignal)-1, filtredSignal)
line([0,2*length(flourLEDsignal)],[0,0])

title("Raw vs filtered signal")
xlabel("Time [s]",'fontweight','bold')
ylabel(sprintf("Light intensity [%smol m^{-2} s^{-1}]", char(181)),'fontweight','bold')
legend({"Raw signal", "Filtered signal"}, 'fontsize',13)

%% Mapping of the different wavelength channels
clear all
load(sprintf("Sweeping_RX2018-11-27-1414.mat"))
vec(:,1) = flip(intIRRmatrix(3,:));
load(sprintf("Sweeping_LX2018-12-18-1221-3"))
vec(:,2) = flip(intIRRmatrix(1,:));
vec(:,3) = flip(intIRRmatrix(3,:));

figure(9)
plot(vec(:,1), 'LineWidth',2) % 420
hold on
plot(vec(:,2), 'LineWidth',2) % 450
plot(vec(:,3), 'LineWidth',2) % 660
xlim([0,1000])

xlabel("Power supply",'fontweight','bold')
ylabel(sprintf("Light intensity [%smol m^{-2} s^{-1}]", char(181)),'fontweight','bold')
legend({"420 nm", "450 nm", "600 nm"}, 'Location','northwest', 'fontsize',13);


