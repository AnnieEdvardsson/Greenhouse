function s_settings = signal_settings()
s_settings = struct();
s_settings.pauseAfterLEDchange = 0.4;       % Time LED lamps have to changed to defined value
s_settings.sampleTime = 1;                  % Time for one loop 

s_settings.fs = 1/s_settings.sampleTime;    % sample rate
w = 2*pi/60;                                % angular frequency of sinusoid
s_settings.f = w/(2*pi);                    % frequency of sinusoid

s_settings.Qfactor = 2;







end