function [Errors,Sensors] = warmupFluo(Sensors)
nSensors = length(Sensors);
nErrors = 0;
Errors = [];
    for i = 1:nSensors
        try 
            Sensors(i).SENSOR.beginRead;
        catch ME
            nErrors = nErrors +1;
            Errors{nErrors} = {ME,i,clock};
            try
                Sensors(i).SENSOR.connect(Sensors(i).IP);
                Sensors(i).SENSOR.beginRead;
            catch
                nErrors = nErrors +1;
                Errors{nErrors} = {ME,i,clock};
                try 
                    Sensors(i).SENSOR.delete;
                catch
                    nErrors = nErrors +1;
                    Errors{nErrors} = {ME,i,clock};
                end
                try
                    [Sensors(i)] = setUpFluoSensorAM({Sensors(i).IP},{Sensors(i).NAME},700);
                    Sensors(i).SENSOR.beginRead;
                catch
                    nErrors = nErrors +1;
                    Errors{nErrors} = {ME,i,clock};
                end
            end
        end
    end
    
    pause(300)
    
    for i = 1:nSensors
        try 
            Sensors(i).SENSOR.stopRead;
        catch ME
            nErrors = nErrors +1;
            Errors{nErrors} = {ME,i,clock};
        end
    end
end
 