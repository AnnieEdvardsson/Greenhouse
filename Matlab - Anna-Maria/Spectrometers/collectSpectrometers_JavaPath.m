function [MATLAB_SpectList,n_spect] = collectSpectrometers_JavaPath(varargin)
% Function for connecting to spectrometers. All spectrometers, including
% their names, serial numbers, indexes and omnidriver libraries are stored
% in the MATLAB_SpecList structure. The other ouput "n_spect" refers to
% number of spectrometers. It also sets the temperature of available
% spectrometers with temperature control.

% platform=computer;
% class_path_dir=[matlabroot '\toolbox\local\'];

%javaaddpath('/opt/OceanOptics/OmniDriverSPAM/OOI_HOME/OmniDriver.jar') %
%javaaddpath('C:/Program Files/Ocean Optics/OmniDriverSPAM/OOI_HOME/OmniDriver.jar') %
wrapper = com.oceanoptics.omnidriver.api.wrapper.Wrapper;
if isempty(varargin)
    wrapper.openAllSpectrometers;
else
    JAZ_IP = varargin{1,1};
    wrapper.openNetworkSpectrometer(JAZ_IP);
end
n_spect = wrapper.getNumberOfSpectrometersFound;


idx = 0;
for i = 1:n_spect
    MATLAB_SpectList(i).NAME = char(wrapper.getSerialNumber(idx));
    MATLAB_SpectList(i).SERIAL = char(wrapper.getSerialNumber(idx));
    MATLAB_SpectList(i).INDEX=idx;
    MATLAB_SpectList(i).Spectrometer=wrapper;
    idx = idx + 1;
end


