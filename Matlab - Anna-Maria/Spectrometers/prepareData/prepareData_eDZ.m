function specEDZ = prepareData_eDZ(specDZ, specOrg, IT, name)
%Subtracts my electrical dark correction term from data with already
%subtracted dark-zero.
%
%Parameters:
%   Input:
%       Data: data with already subtracted dark-zero
%       IT: data integration time
%       Spec: spectrometer name
%       mode: mainAnalysis, LinearAnalysis_Mode1 or LinearAnalysis_Mode2
%   Output:
%       Data_eDZ: data subtracted with my electrical dark correction term

filename = 'ALLDZ_Jan30.mat';
load(filename);

for i = 1:length(SpectrometersDZ)
    switch SpectrometersDZ(1,i).SERIAL
        case name
            DZall = SpectrometersDZ(1,i).DZ;
            ITs = SpectrometersDZ(1,i).IT;
    end
end

if strcmp(name,'MAYP10191')
    eDZ_UV = [2 4];             %(change to [1 4]!?)
    eDZ_FR = [2065 2068];
    eDZ_int = [1 2068];         % [5 2068]
    x = 0:1:2067;
elseif strcmp(name,'MAYP11938')
    eDZ_UV = [2 4];             %(change to [3 4]!?)
    eDZ_FR = [2065 2068];
    eDZ_int = [1 2068];         % [5 2068]
    x = 0:1:2067;
elseif strcmp(name,'QEA0259')
    eDZ_UV = [1043 1044];
    eDZ_FR = [1043 1044];
    eDZ_int = [1 1044];         % [1 1042];
    x = 0:1:1043;
else
    error('Specify spectrometer name, valid names are MAYA and QE')
end

[nrows,ncolumns] = size(specDZ);
if iscolumn(IT) && isrow(IT)
    DZ = DZall((ITs == IT),:);
    dzUV = mean(DZ(eDZ_UV(1):eDZ_UV(2)));
    dzFR = mean(DZ(eDZ_FR(1):eDZ_FR(2)));
    k_dz = (dzFR-dzUV)/length(x);
    Y_dz = k_dz*x+dzUV;
end
specEDZ = cell(size(specDZ));
for j = 1:ncolumns
    if iscolumn(IT) && ~isrow(IT) || ~iscolumn(IT) && isrow(IT)
        DZ = DZall((ITs == IT(j)),:);
        dzUV = mean(DZ(eDZ_UV(1):eDZ_UV(2)));
        dzFR = mean(DZ(eDZ_FR(1):eDZ_FR(2)));
        k_dz = (dzFR-dzUV)/length(x);
        Y_dz = k_dz*x+dzUV;
    end
    for i = 1:nrows
        if isempty(specDZ{i,j})
            break
        end
        if ~iscolumn(IT) && ~isrow(IT)
            DZ = DZall((ITs == IT(i,j)),:);
            dzUV = mean(DZ(eDZ_UV(1):eDZ_UV(2)));
            dzFR = mean(DZ(eDZ_FR(1):eDZ_FR(2)));
            k_dz = (dzFR-dzUV)/length(x);
            Y_dz = k_dz*x+dzUV;
        end
        spec = specOrg{i,j};
        spUV = mean(spec(eDZ_UV(1):eDZ_UV(2)));
        spFR = mean(spec(eDZ_FR(1):eDZ_FR(2)));
        k_sp = (spFR-spUV)/length(x);
        Y_sp = k_sp*x+spUV;
        diff = Y_sp - Y_dz;
        spec = specDZ{i,j};
        specEDZ{i,j} = spec(eDZ_int(1):eDZ_int(2)) - diff';
    end
end
end