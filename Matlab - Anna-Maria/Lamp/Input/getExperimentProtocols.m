function [irrLevels,durations] = getExperimentProtocols(protocol,periodtime,periodsPerLev)
% Experiment protocols
if strcmp(protocol,'LC20')
    irrLevels = 0:20:100;
    durations = periodsPerLev*periodtime*ones(size(irrLevels));
    durations = num2cell(durations);
end

if strcmp(protocol,'LC10')
    irrLevels = 0:10:100;
    durations = periodsPerLev*periodtime*ones(size(irrLevels));
    durations = num2cell(durations);
end

if strcmp(protocol,'LC50')
    irrLevels = 0:50:100;
    durations = periodsPerLev*periodtime*ones(size(irrLevels));
    durations = num2cell(durations);
end

if strcmp(protocol,'LX_LC_25o50')
    irrLevels =[25 50 75 100 125 150 175 200 225 250 275 300 325 350 375 400 450 500 550 600 650 700 750 800 850 900 970 1030];
    durations = periodsPerLev*periodtime*ones(size(irrLevels));
    durations = num2cell(durations);
end
if strcmp(protocol,'LX_LC_25o100_LOW')
    irrLevels =[25 50 75 100 125 150 175 200 225 250 275 300 400 500 700];
    durations = periodsPerLev*periodtime*ones(size(irrLevels));
    durations = num2cell(durations);
end
if strcmp(protocol,'LX_LC_Down_25o50')
    irrLevelsUp =[25 50 75 100 125 150 175 200 225 250 275 300 325 350 375 400 450 500 550 600 650 700 750 800 850 900 970 1030];
    for i=1:length(irrLevelsUp)
        irrLevels(i)=irrLevelsUp(end-i+1);
    end
    durations = periodsPerLev*periodtime*ones(size(irrLevels));
    durations = num2cell(durations);
end    

if strcmp(protocol,'LCrand50_25_300')
    wished_levels = [50:25:300];
    rand_idx      = randi(length(wished_levels),1,6);
    i = 2;
    while i <= length(rand_idx) 
        if rand_idx(i) == rand_idx(i-1)
            rand_idx   = randi(length(wished_levels),1,6);
            i = 2;
        else
            i = i+1;
        end
    end
    irrLevels = [150,150,wished_levels(rand_idx),150,400,150,500];
    durations = periodsPerLev*periodtime*ones(size(irrLevels));
    durations = num2cell(durations);
end

if strcmp(protocol,'LCmorning')
    irrLevels = [0,0,100,150,200,700];
    durations = periodsPerLev*periodtime*ones(size(irrLevels));
    durations = num2cell(durations);
end

if strcmp(protocol,'LCevening')
    irrLevels = [150 100 200 700 150 0 0];
    durations = periodsPerLev*periodtime*ones(size(irrLevels));
    durations = num2cell(durations);
end

end
% StartExc    = [0, sumDurations(durations,2), sumDurations(durations,10)-(10*60) ]./delta_t+1;
% EndExc      = [sumDurations(durations,1), sumDurations(durations,9), sumDurations(durations,10)+(10*60)]./delta_t;