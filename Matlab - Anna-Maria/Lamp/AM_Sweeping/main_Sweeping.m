%% Sweeping Anna-Maria 2017-10-10
% Creates a matrix containing a mapping between lamp input and output.

%----- How to make a good sweeping:----------------------------------
% The Light intensity from the lamp is affected by the temperature
% of the LED-plates. A warm-up period of the lamp is recommended! 
% Also, sweeping from high to low light intensities yields a more accurate
% result.
% The accuracy of the spctrometer measurements are dependent of the
% operating point of the spectrometer. The operating point should
% preferably be 45000-60000 counts. The operating point is determined by
% the integration time ('IT') of the spectrometer in relation to the measured light intensity (spectrally resolved).
% An appropriate IT is found at each light intensity  through the routine in
% the function 'findIT'. This routine works better starting from an
% integration time that is too low rather than too high (if I remember this correctly).

% Make sure that getSweepingSettings.m contains appropriate settings, e.g.,
% fiber with and CalibDate etc. If some settings need to be changed
% afterwards, use recalculateSweepings.m for recalculating the integrated irradiances.

%One complete sweeping of all LEDs and all intensity levels can take a lot
%of time and generates alot of spectra. Hence, each LED-group is swept and stored
%separately. These can be combined with combineSweepingParts.m
%---------------------------------------------------------------------

clear all
close all
clc
%% Add any info about set-up here:
Msg     = 'Sweeping_RX';
Info    = 'RX inside Styrobox. Intensities measured at aproximately 65cm from the lamp';

%% Here you need to add the ip-number of the current lamp 
% RX: '192.168.100.102'
% LX  '192.168.100.101'
lamp_ip = '192.168.100.102';
%Maximum fan speed is obtained 
webwrite(strcat('http://',lamp_ip,'/config.cgi?action=fan&mode=manual&value=255'),'')

%% Setup spectrometer: Need to add the name of the current spectrometer manually e.g. 'm2' or 'm1'.
addpath(genpath('..\..\Spectrometers'))
%addpath(genpath('D:\BoxSync\anncars\MyMatlab\Spectrometers'))
addpath('..\')

% Here settings for starting up the sweeping proceedure are fetched
% and assigned to a field with the short-name of the spectrometer used. 
% Here the spectrometer 'm2' is used, hence 'settings.m2'
% Make sure that getSweepingSettings.m contains appropriate settings. 
settings.m2     = getSweepingSettings();
Spectrometers   = jsetUpSpectrometers(settings); %The java-object(s) communicating with the spectrometer(s) is (are) created and contained in Spectrometer.Wrapper
current_spect   = Spectrometers(1);
SpecIdx         = current_spect.Index;

%Wavelength interval in nm, integration limits, used for calculation of integrated irradiances
%(mu mol photons/m^2/s^-1) from spectrometer spectra given in counts
%If sweeping one LED-group at a time, the limits can be the 'full spectrum'.
FULL_SPECTRUM             = [300 800]; 
for i = 1:length(Spectrometers)
    int_index(1,:,i)  = FULL_SPECTRUM;
end

%% Choose the LED-groups that should be swept and the lamp input values:
LEDs = [380 400 420 450 530 620 660 735 5700]; %nm
%Sweeping from high to low light intensities.
Intensities  = 1000:-100:0; %lamp-input-values

%% Variables for storage of data
IT              = zeros(length(LEDs),length(Intensities)); %stores integrationtime (ms) for each measured lamp input level
intIRRmatrix    = zeros(length(LEDs),length(Intensities)); %stores measured light intensities in mu mole photons/m^2/s^-1, calculated based on counts and calibration-values 
lampINTmatrix   = zeros(length(LEDs),length(Intensities)); %stores lamp-input-values
spectra         = cell(length(LEDs),length(Intensities));  %stores the measured raw spectra

%% Sweeping
current_spect.Wrapper.setIntegrationTime(SpecIdx,1000000);
disp(strcat('Sweeping started at', datestr(now)))
for LEDidx = 3:length(LEDs)
    if LEDs(LEDidx)<=400
        disp('--------------Warning UV-light-------------------------')
    end
    disp(strcat('Sweeping: New LED-group---',num2str(LEDs(LEDidx)),'---',datestr(now)))
    for INTidx = 1:length(Intensities)
        temp_intensity = zeros(size(LEDs));
        temp_intensity(LEDidx) = Intensities(INTidx);
        lamp_str = mat2wwString(temp_intensity,lamp_ip);
        webwrite(lamp_str{1,1},'') %Set new lamp input
        
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
        IT(LEDidx,INTidx) = current_spect.Wrapper.getIntegrationTime(SpecIdx); %read integration time from spectrometer
        current_spect.IT  = IT(LEDidx,INTidx);
        current_spect.Spectra{1,2} = spectrum_temp;
        spectra{LEDidx,INTidx} = spectrum_temp;
        
        %Calculating integrated irradiance for the wavelength interval(s) contained in int_index
        %based on calibration of the spectrometer performed at the date contained in settings.calibDate
        DATA              = amprepareData_All(current_spect, 1, int_index);
        
        intIRRmatrix(LEDidx,INTidx)  = DATA.intIRR.spec_uEin_int{1,1}; %measured light intensities in mu mole photons/m^2/s^-1
        lampINTmatrix(LEDidx,INTidx) = Intensities(INTidx); 
        %lampTEMPERATURE(LEDidx,INTidx) = 
    end
    save(strcat('Sweepings\','PART',Msg,datestr(now,'yyyy-mm-dd-HHMM')),'intIRRmatrix','lampINTmatrix','spectra','IT','settings','Info')
    clear spectra
    spectra = cell(length(LEDs),length(Intensities));
end

webwrite(strcat('http://',lamp_ip,'/config.cgi?action=fan&mode=default'),'')
disp(strcat('Sweeping ended at', datestr(now)))
save(strcat('Sweepings\',Msg,datestr(now,'yyyy-mm-dd-HHMM')),'intIRRmatrix','lampINTmatrix','spectra','IT','settings','Info','current_spect','LEDs','int_index','current_spect')
