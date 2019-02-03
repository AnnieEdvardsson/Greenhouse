clc
clear all
close all
%%
addpath(genpath('\Mapping'))
addpath(genpath('Lamp\AM_Sweeping'))

%% SINUS
settings.conv = getSinusSettings();

load(settings.conv.sweepingsMatrix, 'LEDs', 'intIRRmatrix', 'lampINTmatrix')


DATA(1,:) = intIRRmatrix(3,:);




%% BACKGROUND
settings.conv = getBackgroundSettings();
load(settings.conv.sweepingsMatrix, 'LEDs', 'intIRRmatrix', 'lampINTmatrix')
DATA(2,:) = intIRRmatrix(1,:);
DATA(3,:) = intIRRmatrix(3,:);

%% FIG

figure
plot(fliplr(DATA)')
hold on

legend("420 nm", "450 nm", "660 nm")
title("Mapping of the different wavelength channels")
xlabel("Power supply")
ylabel(sprintf("Intensity [%smol m^{-2} s^{-1}]", char(181)))
xlim([0 1000])
        

