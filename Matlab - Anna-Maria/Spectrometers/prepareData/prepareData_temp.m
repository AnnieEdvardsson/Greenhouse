function specTemp = prepareData_temp(specEDZ,name)
%Subtracts my temperature noise correction term from data already corrected
%for dark-zero and electrical dark.
%
%Parameters:
%   Input:
%       Data: data corrected for dark-zero and electrical dark
%       Spec: spectrometer name
%   Output:
%       Data_temp: data subtracted with my temperature noise correction
%       term

[nrows,ncolumns] = size(specEDZ);
specTemp = cell(size(specEDZ));

if strcmp(name,'MAYP10191')
    intUV = [10 200]; % 200 -> 292 nm
    intFR = [1500 1700]; % 1500 -> 877 nm
    intSpec = [201 1499];
    intSpec2 = [100 1600];
    intLength = length(intSpec(1):intSpec(2));
    intLength2 = length(intSpec2(1):intSpec2(2));
elseif strcmp(name,'MAYP11938')
    intUV = [10 200]; % 200 -> 288
    intFR = [1500 1700]; % 1500 -> 849 nm
    intSpec = [201 1499];
    intSpec2 = [100 1600];
    intLength = length(intSpec(1):intSpec(2));
    intLength2 = length(intSpec2(1):intSpec2(2));
elseif strcmp(name,'QEA0259')
    intUV = [10 60];
    intFR = [970 1020];
    intSpec = [60 970];
    intSpec2 = [40 990];
    intLength = length(intSpec(1):intSpec(2));
    intLength2 = length(intSpec2(1):intSpec2(2));
else
    error('Specify spectrometer name, valid names are MAYA and QE')
end

for i = 1:ncolumns
    for j = 1:nrows
        if isempty(specEDZ{j,i});
            break
        end
        spec = specEDZ{j,i};
        spUV = (mean(spec(intUV(1):intUV(2))));
        spFR = (mean(spec(intFR(1):intFR(2))));
        k_sp = (spFR-spUV)/intLength2;
        x = 1:intLength2;
        Y_sp = k_sp*x+spUV;
        spec(intSpec2(1):intSpec2(2)) = spec(intSpec2(1):intSpec2(2)) - Y_sp';
        specTemp{j,i} = spec;
    end
end
end