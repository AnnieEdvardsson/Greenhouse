function [measurement] = measure_fluorescence(Spectrometers)


SpecIdx = Spectometers.Index;
current_spect.Wrapper.setIntegrationTime(SpecIdx,8000);
Spectrometers.Spectra{1,2} = Spectrometers.Wrapper.getSpectrum(SpecIdx);

DATA = amprepareData_All(Spectrometers, 1, int_index);
measurement  = DATA.intIRR.spec_uEin_int{1,1};

end
