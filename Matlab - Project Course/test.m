tStart = tic; % Restart clock
pauseAfterLEDchange = 0.5;
sampleTime = 2;
period = 59;
for i = 0:(period-1) 
        %% Pause until it can be ensured that the LEDs are set
    while toc(tStart) < sampleTime*i + pauseAfterLEDchange
    end
    
    fprintf("0,5 + time: %2.1f \n", toc(tStart));
    
    
    
        %% Pause intil the sample time of the loop is finished
    while toc(tStart) < sampleTime*(i+1)
    end
    
    fprintf("TIME after loop: %2.1f \n", toc(tStart));
    
    
end