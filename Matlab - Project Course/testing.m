close all
clc
load ("WorkspaceForBackground_120_TO_220.mat")
first = phase_error(1:880);
sec = phase_error(1100:end);

K = (mean(sec)-mean(first))/100;

% Fit Data
yrs = 1100:1800;
yrs2 = 900:1800;
b = polyfit(yrs,sec, 1);
fr = polyval(b, yrs);
fr2 = polyval(b, yrs2);
% Plot Data & Fit
figure(1)
hold on
plot(yrs, fr, '-r')
plot(yrs2, fr2, '-r')



plot(phase_error)
line([0,900],[mean(first),mean(first)])

d = mean(sec)-mean(first);
fac = d*0.67;
inc = mean(first)+fac; % AT x  = 1282

T = (1282-900)*0.5;

Kp = T/(K*(30+T*3))
Ki = Kp/T