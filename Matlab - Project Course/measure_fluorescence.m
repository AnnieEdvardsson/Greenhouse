function [measured_420, measured_450, measured_660, measurement_740]  = measure_fluorescence(Spectrometers)
current_spect   = Spectrometers(1);
SpecIdx         = current_spect.Index;
IT = Spectrometers.IT;

Channels             = [410 430;
                        440 460;
                        650 670;
                        730 750];
for i = 1:length(Spectrometers)
    int_index(:,:,i)  = Channels;
end

current_spect.Wrapper.setIntegrationTime(SpecIdx,IT);
Spectrometers.Spectra{1,2} = Spectrometers.Wrapper.getSpectrum(SpecIdx);

DATA = amprepareData_All(Spectrometers, 1, int_index);
measured_420  = DATA.intIRR(1).spec_uEin_int{1};
measured_450  = DATA.intIRR(2).spec_uEin_int{1};
measured_660  = DATA.intIRR(3).spec_uEin_int{1};
measurement_740  = DATA.intIRR(4).spec_uEin_int{1};

end
