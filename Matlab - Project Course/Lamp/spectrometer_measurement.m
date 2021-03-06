function measurement = spectrometer_measurement(Spectrometers)
current_spect   = Spectrometers(1);
SpecIdx         = current_spect.Index;

%Wavelength interval in nm, integration limits, used for calculation of integrated irradiances
%(mu mol photons/m^2/s^-1) from spectrometer spectra given in counts
%If sweeping one LED-group at a time, the limits can be the 'full spectrum'.
FULL_SPECTRUM             = [300 800];
for i = 1:length(Spectrometers)
    int_index(1,:,i)  = FULL_SPECTRUM;
end

%% Sweeping
current_spect.Wrapper.setIntegrationTime(SpecIdx,1000000);

spectrum_temp = current_spect.Wrapper.getSpectrum(SpecIdx); %read spectrometer measurement
Max_counts = current_spect.maxCounts*0.92;
Min_counts = current_spect.maxCounts*0.78;
maxPeak     = max(spectrum_temp);
%find appropriate integration time
if ~(maxPeak < Max_counts && maxPeak > Min_counts)
    IT_temp = findIT(current_spect,10,0);
    current_spect.Wrapper.setIntegrationTime(SpecIdx,IT_temp);%set integration time
    spectrum_temp = current_spect.Wrapper.getSpectrum(SpecIdx);
end
IT = current_spect.Wrapper.getIntegrationTime(SpecIdx); %read integration time from spectrometer
current_spect.IT  = IT;
current_spect.Spectra{1,2} = spectrum_temp;

%Calculating integrated irradiance for the wavelength interval(s) contained in int_index
%based on calibration of the spectrometer performed at the date contained in settings.calibDate
DATA = amprepareData_All(current_spect, 1, int_index);

measurement  = DATA.intIRR.spec_uEin_int{1,1}; %measured light intensities in mu mole photons/m^2/s^-1
end