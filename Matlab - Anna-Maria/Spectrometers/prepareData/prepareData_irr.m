function specIrr = prepareData_irr(specTemp,IT,name,cosineCorrector,fiberWidth,varargin)
%Converts data in counts to data in irradiance units
%
%---------------------------------------- 
% Slightly modified by Anna-Maria: Integration times in IT are matched 
% to spectra more intuitively:
% If IT is a row-vector each IT is matched to the corresponding column in specOrg.
% If instead IT is a column-vector each IT is mapped to the corresponding row in specOrg.
%-----------------------------------------
%Parameters:
%   Input:
%       Data: data in counts
%       IT: data integration time
%       Spec: spectrometer name
%       Calib_type: name of calibration mat file
%       mode: mainAnalysis, LinearAnalysis_Mode1 or LinearAnalysis_Mode2
%   Output:
%       Data_irr: structure of spectral data in irradiance units

% Load Calibration files
if nargin <= 5
    [Cal,WLs,fiber_diameter] = getCalibration(name,cosineCorrector,fiberWidth);
else if nargin > 5
        [Cal,WLs,fiber_diameter] = getCalibration(name,cosineCorrector,fiberWidth,varargin);
    end
end
% Constants for Unit Conversion
area_m2=pi*(fiber_diameter/2)^2; area_cm2=(area_m2*1e4);
c=299792458; h=6.626068*10^-34; avogadro=6.0221415e23;

%% Unit Conversion uEinstein & uEinstein/nm
[nrows,ncolumns] = size(specTemp);
spec_uwatts_cm2_nm = cell(nrows, ncolumns);
spec_uEin_nm = cell(nrows,ncolumns);
spec_uEin = cell(nrows,ncolumns);

WLs_m = WLs.*1e-9;
Freq = c./WLs_m;
E = h.*Freq;

L = length(WLs);
bins = zeros(L,1);
for k = 2:L-1
    bins(k) = (WLs(k+1)-WLs(k-1))./2;
end
bins(1) = bins(2);
bins(L) = bins(L-1);

ITarray = IT;
for i = 1:ncolumns
    if ~iscolumn(ITarray) && isrow(ITarray)
        IT = ITarray(i);
    end
    for j = 1:nrows
        if isempty(specTemp{j,i});
            break
        end
        if iscolumn(IT) && ~isrow(ITarray)
            IT = ITarray(j);
        elseif ~iscolumn(ITarray) && ~isrow(ITarray)
            IT = ITarray(j,i);
        end
        spec = specTemp{j,i};
        spec = spec.*(spec >= 0);
        uJoules = spec.*(Cal);
        joules_m2 = uJoules.*1e-6./area_m2;
        joules_cm2 = uJoules.*1e-6./area_cm2;
        uwatts_m2 = joules_m2.*1e6./(IT*1e-6);
        uwatts_cm2 = joules_cm2*1e6./(IT*1e-6);
        uwatts_cm2_nm = uwatts_cm2./bins;
        uEin = uwatts_m2./E./avogadro;
        uEin_cm2 = uwatts_cm2./E/avogadro;
        uEin_nm = uEin ./ bins;
        
        spec_uwatts_cm2_nm{j,i} = uwatts_cm2_nm;
        spec_uEin_nm{j,i} = uEin_nm;
        spec_uEin{j,i} = uEin;
    end
end


specIrr = struct('bins',bins,'WLs',WLs);
specIrr.spec_uEin_nm = spec_uEin_nm;
specIrr.spec_uwatts_cm2_nm = spec_uwatts_cm2_nm;
specIrr.spec_uEin = spec_uEin;
end
