function [intIRRmatrix,intIRRmatrix_old] = recalculateSweepings(path,filename,newCalibDate,int_index)
% Recalculates the integrated irradiances from a sweeping stored in
% filename, based on calibration performed at newCalibDate, and with the
% integration limits in int_index.
% [intIRRmatrix,intIRRmatrix_old] = recalculateSweepings(path,filename,newCalibDate,int_index)
% [intIRRmatrix,intIRRmatrix_old] = recalculateSweepings('Sweepings','CompleteSweeping_2017-11-02.mat','2018-01-18',[300 800]);
addpath(genpath('../../Spectrometers'))
load(strcat(path,filename),'intIRRmatrix','lampINTmatrix','spectra','IT','settings','Info')

if isfield(settings,'m2')
    specName  = 'MAYP11938';
elseif isfield(settings,'m1')
    specName ='MAYP10191';
end
Spectrometers = [];
Spectrometers.CalibDate = newCalibDate;
Spectrometers.SERIAL = specName;
Spectrometers.INDEX = 1;
Spectrometers.Index = 1;

Spectrometers.ScansToAverage = settings.m2.ScansToAverage;
Spectrometers.CorrectForElectricalDark = settings.m2.CorrectForElectricalDark;
Spectrometers.BoxcarWidth = settings.m2.BoxcarWidth;
Spectrometers.FiberWidth = settings.m2.fiberWidth;
Spectrometers.CosineCorrector = settings.m2.cosineCorrector;

intIRRmatrix_old = intIRRmatrix;
intIRRmatrix     = zeros(size(intIRRmatrix_old));
for LEDidx = 1:size(lampINTmatrix,1)
    for INTidx = 1:size(lampINTmatrix,2)   
        Spectrometers.IT  = IT(LEDidx,INTidx);
        if ~isempty(spectra{LEDidx,INTidx})
            Spectrometers.Spectra{1,2} = spectra{LEDidx,INTidx};
            DATA = amprepareData_All(Spectrometers, 1, int_index);
        
            intIRRmatrix(LEDidx,INTidx)  = DATA.intIRR.spec_uEin_int{1,1};
        end
    end
end

save(sprintf('%sRecalcINTirrCalibDate_%s_%s',path,newCalibDate,filename),'intIRRmatrix','lampINTmatrix','newCalibDate','Info','filename')
