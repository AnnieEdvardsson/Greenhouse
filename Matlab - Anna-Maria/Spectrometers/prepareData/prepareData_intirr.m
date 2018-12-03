function specIntirr = prepareData_intirr(specIrr, index)
%Calculates integrated irradiance over defined wavelength or bin intervals
%from spectral irradiance data.
%
%Parameters
%   Input:
%       Data: structure of spectral data in irradiance units
%       index: defined intervals for integration
%       indextype: indexes specified as wavelengths ('WL') or bins ('BIN')
%       mode:
%   Output:
%       Data_intirr: structure of integrated irradiance spectral data


WLs = specIrr.WLs;
bins = specIrr.bins;

% Integrated Irradiance
[nrows,ncolumns] = size(specIrr.spec_uEin_nm);
[~, nLEDs] = size(index);

spec_uEin_int = cell(1,ncolumns);
spec_uwatts_cm2_int = cell(1,ncolumns);
indexPixel = zeros(size(index));
for k = 1:nLEDs
    [~, idx1] = min(abs(WLs - index(1,k)));
    [~, idx2] = min(abs(WLs - index(2,k)));
    indexPixel(1,k) = idx1;
    indexPixel(2,k) = idx2;
end
for i = 1:ncolumns
    int_uEin = zeros(nrows,nLEDs);
    int_uwatts = zeros(nrows,nLEDs);
    for j = 1:nrows
        if isempty(specIrr.spec_uEin_nm{j,i});
            break
        end
        uEinRectangular = specIrr.spec_uEin_nm{j,i}.*bins;
        uwattsRectangular = specIrr.spec_uwatts_cm2_nm{j,i}.*bins;
        for k = 1:nLEDs
            int_uEin(j,k) = sum(uEinRectangular(indexPixel(1,k):indexPixel(2,k)));
            int_uwatts(j,k) = sum(uwattsRectangular(indexPixel(1,k):indexPixel(2,k)));
        end
    end
    spec_uEin_int{1,i} = int_uEin;
    spec_uwatts_cm2_int{1,i} = int_uwatts;
end


specIntirr = struct('indexPixel',indexPixel,'indexWL',index);
specIntirr.spec_uEin_int = spec_uEin_int;
specIntirr.spec_uwatts_cm2_int = spec_uwatts_cm2_int;
end