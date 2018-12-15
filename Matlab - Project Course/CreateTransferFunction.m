% Creates a transfer function (plant) of the system
%
% Syntax: CreateTransferFunction()
%
% Inputs:
%   None
%
% Outputs:
%   None
%
% Other m-files required: filter_fluorescent()
% MAT-files required: flourPlantsignal.mat, flourLEDsignal.mat
%
% December 2018; Last revision: 15-December-2018
%------------- BEGIN CODE -----------

load("flourPlantsignal2.mat")
load("flourLEDsignal3.mat")

filtredSignal = filter_fluorescent(flourPlantsignal);

if length(filtredSignal) > length(flourLEDsignal)
    NrS = length(flourLEDsignal);
    NrL = length(filtredSignal);
    
    filtredSignal = filtredSignal(NrL-NrS:end);
else
    NrS = length(filtredSignal);
    NrL = length(flourLEDsignal);
    
    flourLEDsignal = flourLEDsignal(NrL-NrS:end);
end

data = iddata(filtredSignal', filtredSignal', 1);
TF2 = tfest(data, 3);

save("TF");