clc
clear 
close all

addpath(genpath('..\SavedVariables'))
addpath(genpath('..'))
% 
load("flourPlantsignal2.mat")
load("flourLEDsignal3.mat")
% % 
% % 
filtredSignal = filter_fluorescent(flourPlantsignal);
plotOnTop(flourPlantsignal, filtredSignal)
% 
filtredSignal = filtredSignal(1:300);
flourLEDsignal = flourLEDsignal(1:300);

function plotOnTop(var1, var2)
var1 = detrend(var1);
var2 =detrend(var2);
%var3 =detrend(var3);
figure
hold on
plot(var1);
plot(var2);
%plot(var3);
line([0,length(var1)+20],[0,0])
legend("non filtered","filtered")
%legend("non filtered","filtered", "LEDsignal")
%title(sprintf('Subplot 2:  %s', var2));
end

% 
% load("TF.mat")
% 
% 
% settings.s =    getPIDSettings();
% Kp =            settings.s.Kp;
% Ki =            settings.s.Ki;
% Kd =            settings.s.Kd;
% 
% C = pid(Kp, Ki, Kd);
% 
% Ctf = tf(C);
% s = tf('s');
% 
% T = feedback(C*TF, 1);
% t = 0:0.01:300;
% tt = 7;
% 
% hej = step(T, t);
% plot(hej);
% 
% 
% % data = iddata(filtredSignal', flourLEDsignal', 1);
% % TF = tfest(data, 3)
% 
% 
