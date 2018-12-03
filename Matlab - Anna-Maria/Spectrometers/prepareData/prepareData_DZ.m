function specDZ = prepareData_DZ(specOrg, IT, name)
%Subtracts stored dark-zero from data based on integration time.
% 
%-------------------------------------
% Slightly modified by Anna-Maria: Integration times in IT are matched 
% to spectra more intuitively:
% If IT is a row-vector each IT is matched to the corresponding column in specOrg.
% If instead IT is a column-vector each IT is mapped to the corresponding row in specOrg.
%------------------------------------
%Parameters
%   Input:
%       specOrg:    cell(nrow,ncolumn) of input data raw spectrum
%       IT:         integration time; size(IT) could be 1*1, nrow*ncolumn,
%                   1*ncolumn or nrow*1
%       name:       spectrometer name
%   Output:
%       Data_DZ: output data with subtracted dark-zero

filename = 'ALLDZ_JAZ_Maya_QE_160322.mat';

load(filename);
for i = 1:length(SpectrometersDZ)
    switch SpectrometersDZ(1,i).SERIAL
        case name
            DZall = SpectrometersDZ(1,i).DZ;
            ITs = SpectrometersDZ(1,i).IT;
    end
end

[nrows,ncolumns] = size(specOrg);
if iscolumn(IT) && isrow(IT)
    DZ = DZall((ITs == IT),:);
end
specDZ = cell(size(specOrg));
for j = 1:ncolumns
    if ~iscolumn(IT) && isrow(IT)
        DZ = DZall((ITs == IT(j)),:);
    end
    for i = 1:nrows
        if isempty(specOrg{i,j})
            break
        end
        if iscolumn(IT) && ~isrow(IT)
            DZ = DZall((ITs == IT(i)),:);
        elseif ~iscolumn(IT) && ~isrow(IT)
            DZ = DZall((ITs == IT(i,j)),:);
        end
        try
            specDZ{i,j} = specOrg{i,j} - DZ';
        catch
            specDZ{i,j} = specOrg{i,j}' - DZ';
        end
    end
end
