function [measurement] = measure_fluorescence(Spectrometers)
current_spect   = Spectrometers(1);
SpecIdx         = current_spect.Index;

FULL_SPECTRUM             = [300 800];
for i = 1:length(Spectrometers)
    int_index(1,:,i)  = FULL_SPECTRUM;
end

current_spect.Wrapper.setIntegrationTime(SpecIdx,8000);
Spectrometers.Spectra{1,2} = Spectrometers.Wrapper.getSpectrum(SpecIdx);

DATA = amprepareData_All(Spectrometers, 1, int_index);
measurement  = DATA.intIRR.spec_uEin_int{1,1};

end
