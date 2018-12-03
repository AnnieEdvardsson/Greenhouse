% function [lamp_mat,delta_t,LEDs_e,LEDs_b] = genLampMat(protocol,exc_name,exc_period,exc_wls,periodsPerAmp,exc_amps,exc_mean,SweepFileName)
% For a given protocol, (protocol ='XXX'), as defined in getExperimentProtocols.m, and a given excitation signal, exc_name ('sin' or 'square'), get predefined absolute irradiances (mu mol photons*m^-2*s^-1) for
% the protocol 'XXX', and calculate absolute irradiances for the excitation signal for each timestep in the experiment. Calculate the corresponding lamp-input matrices based on the mapping of lamp input and output stored in 'SweepFileName'. 
function [lampExcitation,background_spectrum,delta_t,LEDs_e,LEDs_b,LevelVector] = genLampMat(protocol,exc_name,exc_period,exc_wls,periodsPerAmp,exc_amps,exc_mean,SweepFileName,background_lampName)
%  
% [lamp_mat_background,lamp_mat_exc,delta_t] = genLampMat(protocol,periodsPerLev,exc_name,exc_period,exc_wl,exc_amp,SweepFileName)
% [lamp_mat_background,lamp_mat_exc,delta_t] = genLampMat('LC20',3,'square',180,420,30,'RecalcINTirrCalibDate_2015-08-26_CompleteSweeping_2017-11-02')
% exc_wl = [0 0 1 0 0 0 0 0 0]; %for example


path = '../Lamp/AM_Sweeping/Sweepings/';
filename = SweepFileName;
load(strcat(path,filename),'intIRRmatrix','lampINTmatrix');
if size(lampINTmatrix,1)==9
    exc_lampName = 'RX';
    LEDs_e   = [380 400 420  450 530 620 660 735 5700];
end

%Setting parameters related to both background and excitation light
periodsPerWl        = periodsPerAmp*length(exc_amps);
periodsPerLev       = periodsPerWl*length(exc_wls);

% Setting parameters related to the experiment protocol defining background lightintensities
% [irrLevels,durations] = getExperimentProtocols(protocol,periodtime,periodsPerLev)
[irrLevels,durations]   = getExperimentProtocols(protocol,exc_period,periodsPerLev);
[lampSpectra,LEDs_b]    = getLampSettings(irrLevels,background_lampName);
background              = LightRegime(lampSpectra,durations);

for nr = 1:length(irrLevels)
    LevelVector((nr*periodsPerLev-periodsPerLev+1):nr*periodsPerLev) = irrLevels(nr)*ones(1,periodsPerLev);
end

% parameters relating to the excitation signal
exc_wl_vector           = exc_wls(1)==LEDs_e;
[~,exc_wl_nr]           = min(abs(LEDs_e-exc_wls(1)));
if strcmp(exc_name,'step')||strcmp(exc_name,'square')
    excitation              =  ExcitationSquare(exc_wl_vector, exc_period, exc_amps(1),exc_mean(1),intIRRmatrix,lampINTmatrix);
    delta_t                 =  exc_period/4;
    exc_mean                =  exc_mean*ones(size(LEDs_e));
    step                    = true;
elseif strcmp(exc_name,'sin')
    excitation              =  ExcitationSin(exc_wl_vector,exc_period,exc_amps(1),exc_mean,intIRRmatrix,lampINTmatrix);
    delta_t                 =  1;
    step                    = false;
end

neLEDs = length(LEDs_e);
nbLEDs = length(LEDs_b);
iterations = ceil(background.getTotDuration()/delta_t);
background_spectrum     = zeros(iterations,nbLEDs);
excitation_spectrum     = zeros(iterations,neLEDs);
lampExcitation          = zeros(iterations,neLEDs);

iAmp  = 1;
nAmp  = 1;
iWl   = 1;
nextPeriod = 1;
for i = 1:iterations
    time = (i-1)*delta_t;
    if step
        excitation.determineState(time)
    end
    if nextPeriod < excitation.nextPeriodNr
        nextPeriod = excitation.nextPeriodNr;
        if nAmp ~= periodsPerAmp
            nAmp     = nAmp+1;
        elseif iAmp < length(exc_amps)
                iAmp = iAmp+1;
                excitation.setAmplitude(exc_amps(iAmp))
                nAmp = 1;
            elseif iWl < length(exc_wls)
                nAmp            = 1;
                iAmp            = 1;
                iWl             = iWl+1;
                exc_wl_vector   = exc_wls(iWl)==LEDs_e;
                [~,exc_wl_nr]   = min(abs(LEDs_e-exc_wls(iWl)));
                excitation.setWavelength(exc_wl_vector)
                excitation.setAmplitude(exc_amps(iAmp))
                excitation.setMeanvalue(exc_mean(exc_wl_nr))
        else
            nAmp            = 1;
            iAmp            = 1;
            iWl             = 1;
            exc_wl_vector   = exc_wls(iWl)==LEDs_e;
            [~,exc_wl_nr]   = min(abs(LEDs_e-exc_wls(iWl)));
            excitation.setWavelength(exc_wl_vector)
            excitation.setAmplitude(exc_amps(iAmp))
            excitation.setMeanvalue(exc_mean(exc_wl_nr))
        end
    end
    background_spectrum(i,:) = background.getIntensity(time);
    excitation_spectrum(i,:) = excitation.getIntensity(time);
    
    if excitation_spectrum(i,exc_wl_nr) == 0
        lampExcitation(i,exc_wl_nr) = 0;
    else 
        [lampExcitation(i,exc_wl_nr) ,~, ~] = getlampLevel(intIRRmatrix, lampINTmatrix, excitation_spectrum(i,:),exc_wl_nr);   
    end
%     lamp_mat(i,:)           = background_spectrum(i,:);
%     lamp_mat(i,exc_wl_nr)   = lampExcitation(i,exc_wl_nr);
end
end 