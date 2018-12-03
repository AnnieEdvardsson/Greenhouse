function [Spectrometers] = jsetUpSpectrometers(settings)
%%Spectrometers = jsetUpSpectrometers(settings)
%%Slightly modified. 
%%Spectrometers(i).Wrapper contains the wrapper.
%%and collectSpectrometers_JavaPath() is runned internally.

if isfield(settings,'JAZ')
    JAZ_IP = settings.JAZ.IP;
    [MATLAB_SpectList,n_spect] = collectSpectrometers_JavaPath(JAZ_IP);
else
    [MATLAB_SpectList,n_spect] = collectSpectrometers_JavaPath();
end

Spectrometers = [];

for i=1:n_spect
    current_spect = MATLAB_SpectList(i);
    specName = current_spect.SERIAL;
    index = current_spect.INDEX;
    switch specName
        case 'MAYP10191'
            current_spect.Spectrometer.setIntegrationTime(index,settings.m1.IT);
            current_spect.Spectrometer.setScansToAverage(index,settings.m1.ScansToAverage);
            current_spect.Spectrometer.setCorrectForElectricalDark(index,settings.m1.CorrectForElectricalDark);
            current_spect.Spectrometer.setBoxcarWidth(index,settings.m1.BoxcarWidth);
            
            ScansToAverage = settings.m1.ScansToAverage;
            CorrectForElectricalDark = settings.m1.CorrectForElectricalDark;
            BoxcarWidth = settings.m1.BoxcarWidth;
            IT = settings.m1.IT;
            
            fiberWidth = settings.m1.fiberWidth;
            cosineCorrector = settings.m1.cosineCorrector;
            calibDate = settings.m1.calibDate;
            
            highIT = 1E6;lowIT = 13E3;minStep = 1E3;
            
        case 'MAYP11938'
            current_spect.Spectrometer.setIntegrationTime(index,settings.m2.IT);
            current_spect.Spectrometer.setScansToAverage(index,settings.m2.ScansToAverage);
            current_spect.Spectrometer.setCorrectForElectricalDark(index,settings.m2.CorrectForElectricalDark);
            current_spect.Spectrometer.setBoxcarWidth(index,settings.m2.BoxcarWidth);
            ScansToAverage = settings.m2.ScansToAverage;
            CorrectForElectricalDark = settings.m2.CorrectForElectricalDark;
            BoxcarWidth = settings.m2.BoxcarWidth;
            IT = settings.m2.IT;
            
            fiberWidth = settings.m2.fiberWidth;
            cosineCorrector = settings.m2.cosineCorrector;
            calibDate = settings.m2.calibDate;
            
            highIT = 1E6;lowIT = 8E3;minStep = 1E3;
            
        case 'QEA0259'
            current_spect.Spectrometer.setIntegrationTime(index,settings.qe.IT);
            current_spect.Spectrometer.setScansToAverage(index,settings.qe.ScansToAverage);
            current_spect.Spectrometer.setCorrectForElectricalDark(index,settings.qe.CorrectForElectricalDark);
            current_spect.Spectrometer.setBoxcarWidth(index,settings.qe.BoxcarWidth);
            ScansToAverage = settings.qe.ScansToAverage;
            CorrectForElectricalDark = settings.qe.CorrectForElectricalDark;
            BoxcarWidth = settings.qe.BoxcarWidth;
            IT = settings.qe.IT;
            
            fiberWidth = settings.qe.fiberWidth;
            cosineCorrector = settings.qe.cosineCorrector;
            calibDate = settings.qe.calibDate;
            
            highIT = 1E6;lowIT = 8E3;minStep = 1E3;
            
        %case 'JAZA1734'
        case 'JAZA1735' %||'JAZA1739' %|| 'JAZA2707' || 'JAZA1734'
            ScansToAverage = settings.JAZ.ScansToAverage;
            CorrectForElectricalDark = settings.JAZ.CorrectForElectricalDark;
            BoxcarWidth = settings.JAZ.BoxcarWidth;
            IT = settings.JAZ.IT;
            
            current_spect.Spectrometer.setIntegrationTime(index,IT);
            current_spect.Spectrometer.setScansToAverage(index,ScansToAverage);
            current_spect.Spectrometer.setCorrectForElectricalDark(index,CorrectForElectricalDark);
            current_spect.Spectrometer.setBoxcarWidth(index,BoxcarWidth);
            
            %fiberWidth = settings.JAZ.fiberWidth;
            fiberWidth = 3900;
            cosineCorrector = settings.JAZ.cosineCorrector;
            calibDate = settings.JAZ.calibDate;
            
            highIT = 65535000; lowIT = 1E3; minStep = 1E3;
            
        case 'S02091' % || 'S02091' || 'S04640'
            
            ScansToAverage = settings.STS.ScansToAverage;
            CorrectForElectricalDark = settings.STS.CorrectForElectricalDark;
            BoxcarWidth = settings.STS.BoxcarWidth;
            IT = settings.STS.IT;
            
            current_spect.Spectrometer.setIntegrationTime(index,IT);
            current_spect.Spectrometer.setScansToAverage(index,ScansToAverage);
            current_spect.Spectrometer.setCorrectForElectricalDark(index,CorrectForElectricalDark);
            current_spect.Spectrometer.setBoxcarWidth(index,BoxcarWidth);
            
            fiberWidth = settings.STS.fiberWidth;
            cosineCorrector = settings.STS.cosineCorrector;
            calibDate = settings.STS.calibDate;
            
            highIT = 1E7;lowIT = 1E4;minStep = 1E4;
    end
    
    Spectrometers(i).SERIAL = specName;
    Spectrometers(i).INDEX = index;
    Spectrometers(i).ScansToAverage = ScansToAverage;
    Spectrometers(i).CorrectForElectricalDark = CorrectForElectricalDark;
    Spectrometers(i).BoxcarWidth = BoxcarWidth;
    Spectrometers(i).IT = IT;
    Spectrometers(i).Index = index;
    
    Spectrometers(i).FiberWidth = fiberWidth;
    Spectrometers(i).CosineCorrector = cosineCorrector;
    Spectrometers(i).CalibDate = calibDate;
    
    Spectrometers(i).maxCounts = current_spect.Spectrometer.getMaximumIntensity(index);
    Spectrometers(i).ITtargets = [highIT lowIT minStep];
    
    Spectrometers(i).Wrapper   = current_spect.Spectrometer;
    Spectrometers(i).WLs       = current_spect.Spectrometer.getWavelengths(current_spect.INDEX);
end

