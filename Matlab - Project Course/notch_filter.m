fs = 100;                 %sample rate
t = 0:1/fs:120;
x = sin(2*pi/60*t) + randn(size(t))/100;    %noisy signal
w = 2*pi/60;              %angular frequency of sinusoid
f = w/(2*pi);             %frequency of sinusoid

wo = f/(fs/2);            %location of the notch, must be between 0 and 1                  
bw = wo/0.1;              %bandwidth at -3 dB
[b,a] = iirnotch(wo,bw);  %gives numerator and denominator coeffiecients for filter function
fvtool(b,a);              %plots the filter
z = filter(b,a,x);        %filters the noisy signal, should leave noise only
y = x-z;                  %Subtract the noise from original signal

%Plot the original and filtered signal
figure(1)
subplot(2,1,1);
plot(t,x)
subplot(2,1,2);
plot(t,y)
