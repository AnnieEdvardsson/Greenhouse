%% Filtered vs raw 2
figure
var1 = -phase_error2(1400:1650);
var2 = -phase_error2FILTERFILTER(1400:1650);
plot(var1)
hold on 
plot(var2)

legend("Raw signal", "Filtered signal")
xlabel("Time [s]")
ylabel("Phase shift")
xlim([0,250])

%% DFT vs HIL
figure
var1 = phase_errorFILTERFILTER;
var2 = -phase_error2FILTERFILTER;
plot(var1)
hold on 
plot(var2)

legend("DFT method", "Hilbert method")
xlabel("Time [s]")
ylabel("Phase [Degree]")
xlim([0,2000])