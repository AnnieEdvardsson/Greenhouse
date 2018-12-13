clc
clear 


load("flourPlantsignal2.mat")
load("flourLEDsignal3.mat")


filtredSignal = filter_fluorescent(flourPlantsignal);
plotOnTop(flourPlantsignal, filtredSignal, flourLEDsignal)



function plotOnTop(var1, var2 ,var3)
var1 = detrend(var1);
var2 =detrend(var2);
var3 =detrend(var3);
figure
hold on
plot(var1);
plot(var2);
plot(var3);
line([0,length(var1)+20],[0,0])
legend("non filtered","filtered", "LEDsignal")
%title(sprintf('Subplot 2:  %s', var2));
end
