close all
clear 
clc

% backgroundIntensityVEC = [0, 50, 75, 100, 160, 200, 300, 500];
% 
% j = 2;
% 
% load(sprintf("WorkspaceForBackground_%i", backgroundIntensityVEC(j)))
load(sprintf("WorkspaceForBackground_TEST_PID3.mat"))
plot(phase_error)
hold on
load(sprintf("WorkspaceForBackground_TEST_PID5.mat"))
plot(phase_error)
% 
% figure(1)
% plot(0:2:2*length(flourLEDsignal)-1, measured_420Signal)
% factor = mean(measured_420Signal)/17;
% hold on
% plot(0:2:2*length(flourLEDsignal)-1, flourLEDsignal*factor)
% title(sprintf("Excitation signal with BI %i", backgroundIntensityVEC(j)))
% %title(sprintf("Excitation signal", backgroundIntensityVEC(j)))
% xlabel("Seconds")
% ylabel("Normalized light intensity")
% legend("Calculated excitation signal", "Measured excitation signal")

% figure(2)
% plot(0:2:2*length(phase_error2)-1, phase_error2*-1)
% hold on
% plot(0:2:2*length(phase_error2)-1, phase_error2_meas*-1);
% legend("Phase shift with calculated excitation signal", "Phase shift with measured excitation signal")
% title(sprintf("Hilbert phase shift with background intensity %i", backgroundIntensityVEC(j)))
% xlabel("Seconds")
% ylabel("Degrees")
% 
% figure(3)
% plot(0:2:2*length(phase_error2)-1, phase_error)
% hold on
% plot(0:2:2*length(phase_error2)-1, phase_error_meas);
% legend("Phase shift with calculated excitation signal", "Phase shift with measured excitation signal")
% title(sprintf("DFT phase shift with background intensity %i", backgroundIntensityVEC(j)))
% xlabel("Seconds")
% ylabel("Degrees")

% figure(4)
% plot(0:2:2*length(phase_error)-1, phase_error)
% hold on
% plot(0:2:2*length(phase_error2)-1, phase_error2*-1)
% legend("Estimated phase shift using DFT method", "Estimated phase shift using hilbert method")
% title(sprintf("Phase shift with background intensity %i", backgroundIntensityVEC(j)))
% xlabel("Seconds")
% ylabel("Degrees")
% 
% % 
% figure(5)
% plot(0:2:2*length(measured_450Signal)-1, measured_450Signal)
% hold on
% plot(0:2:2*length(measured_660Signal)-1, measured_660Signal)
% line([0,2*length(measured_450Signal)],[backgroundIntensity,backgroundIntensity])
% legend("Measured signal 440", "Measured sugnal 660")
% title(sprintf("Phase shift with background intensity %i", backgroundIntensityVEC(j)))
% xlabel("Seconds")
% ylabel("Intensity")