
%  y = 0;
% line([0,900],[y,y])
% hold on
% %  % 1 kHz and 3 kHz sine waves

%  xdata = 1:length(ydata)
% 
% myfun=@(x,xdata)(x(1)*sin(x(2)*xdata+x(3)));
% myfun2=@(x,xdata)(x(1)*sin(x(2)*(2*pi*t)/60+x(3)));
% x0=[1; 1; 1];
% [x,resnorm] = lsqcurvefit(myfun,x0,xdata,ydata);
% 
% phase_flour = x(2)
% % % % 
% plot(xdata, ydata)
% % % 
% % %%  Least squares smoothing filters
% % % 
% % % dt = 1/5;
% % % t = (0:dt:25-dt)';
% % % 
% % % x = sin(t) + 0.25*rand(size(t));
% % % 
% % % order = 4;     % How much parameters we use to fit to the measured data
% % % framelen = 11; % The bigger the less we care about the measured signal
% % % b = sgolay(order,framelen);
% % % 
% % % ycenter = conv(x,b((framelen+1)/2,:),'valid');
% % % ybegin = b(end:-1:(framelen+3)/2,:) * x(framelen:-1:1);
% % % yend = b((framelen-1)/2:-1:1,:) * x(end:-1:end-(framelen-1));
% % % 
% % % y = [ybegin; ycenter; yend];
% % % plot([x y])
% % % legend('Noisy Sinusoid','S-G smoothed sinusoid')
% % 
% % %%
% % 
fs = 1000;
t = linspace(0,2*pi,fs);
%  % 1 kHz and 3 kHz sine waves
x = sin(t) + 0.2*rand(size(t));
%Lowpass filter everything below 20 kHz
 
 % Specify the filter
 d = fdesign.bandpass(); %'Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', ...
    %1/4,3/8,5/8,6/8,60,1,60);

 % Design the filter
 hd = design(d);
 
 % apply the filter
 y = filter(hd,x);

y = bandpass(x, [0.1 2.5], fs)
%y = bandpass(x, [0.12 0.2], fs)
 subplot(211)
 plot(t,x); title('Original Waveform');
 subplot(212)
 plot(t,y); title('Filtered Waveform');
% % %  figure;
% % %  subplot(211)
% % %  plot(psd(spectrum.periodogram,x,'Fs',fs,'NFFT',length(x)));
% % %  title('Original Signal PSD');
% % %  subplot(212);
% % %  plot(psd(spectrum.periodogram,y,'Fs',fs,'NFFT',length(x)));
% % %  title('Filtered Signal PSD');
% % 
% % %% 
% % windowSize = 25; 
% % b = (1/windowSize)*ones(1,windowSize);
% % a = 1;
% % y = filter(b,a,x);
% % plot(t,x)
% % hold on
% % plot(t,y)
% % legend('Input Data','Filtered Data')
% Fs = 44100;
% NFFT = length(x);
% Y = fft(x,NFFT);
% 
% magnitudeY = abs(Y);        % Magnitude of the FFT
% phaseY = unwrap(angle(Y));  % Phase of the FFT
% 
% F = ((0:1/NFFT:1-1/NFFT)*Fs).';
% helperFrequencyAnalysisPlot1(F,magnitudeY,phaseY,NFFT)

% 
% Ts = 0.5; % In seconden
% fs = 1000; % Een beeld per 9 seconden
% np = 1;
% 
% t = linspace(0,4*pi,fs);
% u = sin(t); % + 0.2*rand(size(t));
% y = sin(t+pi/2); % + 0.2*rand(size(t));
% 
% data = iddata(y,u,Ts);
% 
% sys = tfest(data,np)
