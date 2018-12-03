function [ITfound] = findIT(Spectrometers,n,pl)
%% Search for appropriate integration time for spectrometer
%%[IT] = findIT(Spectrometer,k,pl)
%%Spectrometer = Spectrometer-object.
%%k = number of iterations allowed.
%%pl = 1 generates a plot.
n_spect = length(Spectrometers);
for j = 1:n_spect
    idx = Spectrometers(j).Index;
    isInvalid = true;
    k = 1;
    Max_counts = Spectrometers(j).maxCounts*0.92;
    Min_counts = Spectrometers(j).maxCounts*0.78;
    IT = Spectrometers(1).Wrapper.getIntegrationTime(0);
    while (isInvalid && k < n)
        spectrum    = Spectrometers(j).Wrapper.getSpectrum(idx);
        maxPeak     = max(spectrum);
        if maxPeak < Max_counts && maxPeak > Min_counts
            isInvalid = false;
        else
            [IT,isInvalid] = calculateNewIT(IT,maxPeak,isInvalid,Spectrometers(j).maxCounts,Spectrometers(j).ITtargets);
            k = k + 1;
            Spectrometers(j).Wrapper.setIntegrationTime(idx,IT);
        end
    end
    ITfound(j) = IT;
    if pl
        hold on
        WLs =Spectrometers(j).Wrapper.getWavelengths(idx);
        spectrum = Spectrometers(j).Wrapper.getSpectrum(idx);
        plot(WLs,spectrum)
        plot(WLs,Max_counts*ones(size(WLs)),'r--')
        plot(WLs,Min_counts*ones(size(WLs)),'r--')
    end
end
end

function [IT,isInvalid] = calculateNewIT(IT,maxPeak,isInvalid,maxCounts,ITtargets)
%Internal function
% Same as determineITAsus_linear from Daniel B 2017-10-10
Max_counts = maxCounts*0.92;
Middle_counts = maxCounts*0.85;
Min_counts = maxCounts*0.78;

% highIT = 1E6; %highIT = 5000000;
% lowIT = 8E3; %lowIT = 13000;
% minstep = 1E3;

highIT = ITtargets(1);lowIT = ITtargets(2);minstep = ITtargets(3);

if(maxPeak > Max_counts && IT > lowIT)
    if maxPeak >= 64000 %Hits the roof at 64000 AM:changed to >= instead of >.
        IT = IT - minstep*100; %Take a really big step since we have no idea of how far off we are
        if IT <= lowIT
            IT = lowIT;
        end
    else
        IT = round(IT*(Middle_counts/(maxPeak))/1000)*1000; %Since the IT is linear
    end
elseif(maxPeak < Min_counts && IT < highIT)
    IT = round(IT*(Middle_counts/(maxPeak))/1000)*1000; %Since the IT is linear
    if IT >= highIT
        IT = highIT;
    end
elseif(maxPeak > Max_counts && IT <= lowIT)
    IT = lowIT;
    isInvalid = false;
elseif(maxPeak < Min_counts && IT >= highIT)
    IT = highIT;
    isInvalid = false;
elseif(IT >= highIT)
    IT = highIT;
    isInvalid = false;
elseif(IT <= lowIT)
    IT = lowIT;
    isInvalid = false;
end
end
