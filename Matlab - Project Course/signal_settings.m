function s_settings = signal_settings()
s_settings = struct();
s_settings.fs = 100;            % sample rate
w = 2*pi/60;                    % angular frequency of sinusoid
s_settings.f = w/(2*pi);        % frequency of sinusoid




end