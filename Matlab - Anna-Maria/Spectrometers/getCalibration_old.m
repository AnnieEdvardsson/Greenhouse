function [Cal,WLs,fiber_diameter] = getCalibration(name,cosineCorrector,fiberWidth,varargin)
% The function obtaines calibration energies (Cal [joule/count]) and
% corresponding wavelengths (WLs) from calibration files. There are
% different calibration files for each spectrometer, but also for different
% fibers, cosine correctors etc. There also exist calibration files generated different dates. 
% 
% The calibration file being used is choosen by calibration date (calibDate), Spectrometer (name), 
% cosine corrector or not (CosineCorrector = 1 or 0), fiber diameter (fiberWidth). 
% For each calibration date there exist one .mat file (filename) containing one struct with the fields: 
% names, wavelengths, OOcal. Each combination of Spectrometer - Fiber -
% Cosine corrector, that has been callibrated at the specific date, corresponds to
% one cell number in the three different fields. The number of the field is
% stored in "calibFile". The cell numbers for calibrated combinations are
% listed below.
%
% Input:
% name = Serial number of spectrometer
% cosineCorrector = 1 for CC, 0 for bare fiber.
% fiberWidth = fiber diameter, um
% varargin = calibDate, optional, if left empty, calibration date 2013-01-13 is used. 
%
%
% %%%% Calibrationfiles to choose from:
%
% Abbreviations:
%   M1 = MAYP10191
%   M2 = MAYP11938
%   Q = QEA0259
%   50/600 = fiber diameter
%   600Q = 600 um fiber calibrated together with QEA0259 2013-01-13. 
%   600M1= 600 um fiber calibrated together with MAYP10191 2013-01-13.
%   CCM = cosine corrector for Maya
%   CCQ = cosine corrector for QE
%   FIB = bare fibre (no cosine corrector)
% 
%Cell numbers for calibrated combinations from different calibration dates:
% Calibration 2012-11-30 (DH2000)
%       1) M150
%       2) M1CC
%       3) M250
%       4) M2CC
%       5) QCC
%
% Calibration 2013-01-13 (LSC2634)
%       1) M1_CCM_50um
%       2) M1_CCM_600um
%       3) M1_FIB_50um
%       4) M1_CCQ_600um
%       5) M2_CCM_600um
%       6) M2_FIB_600um
%       7) Q_CCQ_600um
%       8) Q_FIB_600um

% Calibration 2013-06-25 (LSC2634)
% The calibration files refering to 50 um fiber are with the "NEW" 50 um
% fiber.
%       1) M1_50_CCM
%       2) M2_50_CCM
%       3) Q_50_CCM
%       4) M2_600Q_FIB
%       5) Q_600M1_FIB

% Calibration 2014-12-17 (HL3p)
%     1) M1_50_CCQ
%     2) M1_600_CCM
%     3) M1_600_CCQ
%     4) M2_600_CCM
%     5) M2_600_CCQ
%     6) M2_600_FIB
%     7) QE_600_CCQ

% Calibration 2014-10-10 (HL3p)
%     1) Jaz1734 CC  
%     2) Jaz1735 CC   

% Calibration 2015-08-26 (HL3p - 089070018)
%     1) M1_50_CCQ_calib  
%     2) M1_600_fib_calib 
%     3) M2_50_CCM_calib  
%     4) M2_50_CCQ_calib  
%     5) M2_600_CCM_calib 
%     6) M2_600_fib_calib 
%     7) QE_50_CCQ_calib  
%     8) QE_600_fib_calib 

% Calibration 2015-09-09 (HL3p - 089070018)
%     1) JAZA1734_file1 box 4 (default)   
%     2) JAZA1734_file2 box 4
%     3) JAZA1734_file3 box 1
%     4) JAZA1735_file1 box 4 (default)   
%     5) JAZA1735_file2 box 4
%     6) JAZA1735_file3 box 1
%     7) JAZA2707_file1 box 4 (default)   
%     8) JAZA2707_file2 box 4
%     9) JAZA2707_file3 box 1

% Calibration 2015-06-29 (DH2000)
%     1) STS_S02091

% Calibration 2016-01-29
%     1) 'JAZ1734_box0_calib'
%     2) 'JAZ1734_box4_calib'
%     3) 'JAZ1739_box0_calib'
%     4) 'JAZ1739_box4_calib'
%     5) 'JAZ2053_box0_CCQ_calib'
%     6) 'JAZ2053_box0_fib_calib'
%     7) 'JAZ2053_box4_CCQ_calib'
%     8) 'JAZ2053_box4_fib_calib'
%     9) 'JAZ2707_box0_calib'
%     10) 'JAZ2707_box4_calib'
%     11) 'M1_50_CCM_calib'
%     12) 'M1_600_CCM_calib'
%     13) 'M1_600_fib_calib'
%     14) 'M2_600_fib_calib'
%     15) 'QE_600_CCQ_calib'
%     16) 'QE_600_fib_calib'
%     17) 'QE_600_fib_calib_HL3p18'
%     18) 'STS02091_CC_calib'

% Calibration 2016-08-09 HL3p17 & DH2000 (M2_UV_combined)
%     1) {'JAZ1405_calib'}
%     2) {'JAZ1734_calib'}
%     3) {'JAZ1735_calib'}
%     4) {'JAZ1739_calib'}
%     5) {'JAZ2053_fib50umB_CCQ_calib'}
%     6) {'JAZ2707_calib'}
%     7) {'M2_600_CCM_calib'} || {'M2_600_CCM_calib_combined'}

% Calibration 2016-12-20 HL3p17
%     1) {'JAZ1405_calib'}
%     2) {'JAZ1734_calib'}
%     3) {'M1_50_CCM_calib'}
%     4) {'M2_600_CCM_calib'}
%     5) {'STS2091_calib'}

% Calibration 2017-06-23 HL3p17
%     1) {'JAZ1739_calib'}
%     2) {'JAZ2053_CCQ_calib'}
%     3) {'STS2091_calib'}

% Calibration 2017-07-03 Camilo Calibration Lamp
%     1) {'STS2091_calib1'} {'STS2091_calib2'}

%%
if nargin == 3
    calibDate{1} = '2013-01-13';
else
    calibDate = varargin(1);
end

%% Calibrationfiles from 2013-06-25

if strcmp(calibDate{1}, '2013-06-25');
    filename = 'calib_LSC2634_Jun2013';
    load(filename);
    
    %%%%%%%%%%%% M1
    if strcmp(name,'MAYP10191')   
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 50
                calibFile = 1;
            else 
                error('No Calibfile available from 2013_06-25 for MAYP10191 for this fiber diameter')
            end
        else
            error('No Calibfile available from 2013_06-25 for MAYP10191 whithout cosine corrector')
        end
    end
 
    %%%%%%%%%%%%%%% M2
    if strcmp(name,'MAYP11938')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 50
                calibFile = 2;
            else 
                error('No Calibfile available from 2013_06-25 for MAYP11938 with cosine corrector and this fiberdiameter.')
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 4;
            else 
                error('No Calibfile available from 2013_06-25 for MAYP11938 without cosine corrector and this fiberdiameter.')
            end
        end
    end
    %%%%%%%%%%%%%%%%% QE
    if strcmp(name,'QEA0259') 
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 50
                calibFile = 3;
            else
                error('No Calibfile available for QEA0259 with cosine corrector and this fiber diameter')
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 5;
            else
                error('No Calibfile available for QEA0259 without cosine corrector and this fiber diameter')
            end
        end
    end
   Cal = calib_LSC2634_Jun2013.OOcal{1,calibFile};
   WLs = calib_LSC2634_Jun2013.WLs{1,calibFile};
end

%% Calibrationfiles from 2013-01-13 (Default)

if strcmp(calibDate{1}, '2013-01-13');
    filename = 'calib_LSC2634_Jan13';
    load(filename);
    
    %%%%%%%%%%%% M1
    if strcmp(name,'MAYP10191')   
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 600
                calibFile = 2;
            elseif fiberWidth == 50
                calibFile = 1;
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 6; % MAYP11938
                calibFileWL = 2;
            elseif fiberWidth == 50
                fiber_diameter = 50e-6;
                calibFile = 3;
            end
        end
    end
    %%%%%%%%%%%%%%% M2
    if strcmp(name,'MAYP11938')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 600
                calibFile = 5;
            elseif fiberWidth == 50
                calibFile = 1;
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 6;
            elseif fiberWidth == 50
                fiber_diameter = 50e-6;
                calibFile = 3; % MAYP10191
            end
        end
    end
    %%%%%%%%%%%%%%%%% QE
    if strcmp(name,'QEA0259') 
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 600
                calibFile = 7;
            elseif fiberWidth == 50
                error('No Calibfile available')
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 8;
            elseif fiberWidth == 50
                fiber_diameter = 50e-6;
                error('No Calibfile available')
            end
        end
    end
    if ~exist('calibFileWL','var')
        Cal = calib_LSC2634_Jan13.OOcal{1,calibFile};
        WLs = calib_LSC2634_Jan13.WLs{1,calibFile};
    else
        Cal = calib_LSC2634_Jan13.OOcal{1,calibFile};
        WLs = calib_LSC2634_Jan13.WLs{1,calibFileWL};
    end
end

%% Calibrationfiles from 2012-11-30
if strcmp(calibDate{1},'2012-11-30')
    filename = 'calib_DH2000_Nov30';
    load(filename);
    
    %%%%%%%%%%%% M1
    if strcmp(name,'MAYP10191')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 600
                calibFile = 2;
            elseif fiberWidth == 50
                error('No Calibfile available');               
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                error('No Calibfile available');  
            elseif fiberWidth == 50
                fiber_diameter = 50e-6;
                calibFile = 1;
            end
        end
    end
    %%%%%%%%%%%%%%% M2
    if strcmp(name,'MAYP11938')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 600
                calibFile = 4;
            elseif fiberWidth == 50
                error('No Calibfile available');  
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                error('No Calibfile available'); 
            elseif fiberWidth == 50
                fiber_diameter = 50e-6;
                calibFile = 3;
            end
        end
    end
    %%%%%%%%%%%%%%%%% QE
    if strcmp(name,'QEA0259')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 600
                calibFile = 5;
            elseif fiberWidth == 50
                error('No Calibfile available')
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                error('No Calibfile available')
            elseif fiberWidth == 50
                fiber_diameter = 50e-6;
                error('No Calibfile available')
            end
        end
    end
    
    Cal = calib_DH2000_Nov30.OOcal{1,calibFile};
    WLs = calib_DH2000_Nov30.WLs{1,calibFile};
end

%% Calibrationfiles from 2014-12-17

if strcmp(calibDate{1}, '2014-12-17');
    filename = 'calib_HL3p_141217.mat';
    load(filename);
    
    %%%%%%%%%%%% M1
    if strcmp(name,'MAYP10191')   
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 600
                %calibFile = 2; %CCM
                calibFile = 3; %CCQ
            elseif fiberWidth == 50
                calibFile = 1; %CCQ
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                error('No Calibfile available')
            elseif fiberWidth == 50
                fiber_diameter = 50e-6;
                error('No Calibfile available')
            end
        end
    end
    %%%%%%%%%%%%%%% M2
    if strcmp(name,'MAYP11938')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 600
                calibFile = 4; %CCM
                %calibFile = 5; %CCQ
            elseif fiberWidth == 50
                error('No Calibfile available')
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 6;
            elseif fiberWidth == 50
                fiber_diameter = 50e-6;
                error('No Calibfile available')
            end
        end
    end
    %%%%%%%%%%%%%%%%% QE
    if strcmp(name,'QEA0259') 
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 600
                calibFile = 7;
            elseif fiberWidth == 50
                error('No Calibfile available')
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                error('No Calibfile available')
            elseif fiberWidth == 50
                fiber_diameter = 50e-6;
                error('No Calibfile available')
            end
        end
    end
        Cal = calib_HL3p_141217.OOcal{1,calibFile};
        WLs = calib_HL3p_141217.WLs{1,calibFile};
end

%% Calibrationfiles from 2014-10-10

if strcmp(calibDate{1}, '2014-10-10');
    filename = 'calib_HL3p_141010_v2.mat';
    load(filename);
    %%%%%%%%%%%%%%% Jaz1734
    if strcmp(name,'JAZA1734')
        fiber_diameter = 3900e-6;
        calibFile = 1;
    elseif strcmp(name,'JAZA1735')
        fiber_diameter = 3900e-6;
        calibFile = 2;
    end
    Cal = calib_HL3p_141010.OOcal{1,calibFile};
    WLs = calib_HL3p_141010.WLs{1,calibFile};
end

%% Calibrationfiles from 2015-08-26

if strcmp(calibDate{1}, '2015-08-26');
    filename = 'calib_HL3p_150826.mat';
    load(filename);
    
    %%%%%%%%%%%% M1
    if strcmp(name,'MAYP10191')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 50
                calibFile = 1; % CCQ
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 2;
            end
        end
    end
    %%%%%%%%%%%%%%% M2
    if strcmp(name,'MAYP11938')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 600
                calibFile = 5; % CCM
            elseif fiberWidth == 50
                calibFile = 3; % CCM (4 == CCQ)
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 6;
            end
        end
    end
    %%%%%%%%%%%%%%%%% QE
    if strcmp(name,'QEA0259')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 50
                calibFile = 7; %CCQ
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 8;
            end
        end
    end
    
    Cal = calib_HL3p_150826.OOcal{1,calibFile};
    WLs = calib_HL3p_150826.WLs{1,calibFile};
end
%% Calibrationfiles from 2015-09-09
if strcmp(calibDate{1}, '2015-09-09');
    filename = 'calibData_allJAZ_2015-09-09.mat';    %filename = 'calibData2015-09-09.mat';
    load(filename);
    %%%%%%%%%%%% JAZA1734
    if strcmp(name,'JAZA1734')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 1;
        end
    end
    %%%%%%%%%%%% JAZA1735
    if strcmp(name,'JAZA1735')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 4;
        end
    end
    %%%%%%%%%%%% JAZA2707
    if strcmp(name,'JAZA2707')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 7;
        end
    end
    
    Cal = calibData.OOcal{1,calibFile};
    WLs = calibData.WLs{1,calibFile};
end

%% Calibrationfiles from 2015-06-29
if strcmp(calibDate{1}, '2015-06-29');
    filename = 'calibData_STS.mat';
    load(filename);
    %%%%%%%%%%%% STS S02091
    if strcmp(name,'S02091')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 1;
        end
    end
    
    Cal = calibData.OOcal{1,calibFile};
    WLs = calibData.WLs{1,calibFile};
    
end

%% Calibrationfiles from 2016-01-29
if strcmp(calibDate{1}, '2016-01-29');
    filename = 'calibData_allSpec_2016-01-29.mat';
    load(filename);
    
    
    %%%%%%%%%%%% M1
    if strcmp(name,'MAYP10191')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 50
                calibFile = 11; % CCM
            elseif fiberWidth == 600
                calibFile = 12;
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 13;
            end
        end
    end
    %%%%%%%%%%%%%%% M2
    if strcmp(name,'MAYP11938')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 14;
            end
        end
    end
    %%%%%%%%%%%%%%%%% QE
    if strcmp(name,'QEA0259')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            if fiberWidth == 600
                calibFile = 15; %CCQ
            end
        elseif cosineCorrector == false
            if fiberWidth == 600
                fiber_diameter = 600e-6;
                calibFile = 17;
            end
        end
    end
    
    %%%%%%%%%%%% STS S02091
    if strcmp(name,'S02091')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 18;
        end
    end
    
    %%%%%%%%%%%% JAZA1734
    if strcmp(name,'JAZA1734')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 1;
        end
    end

    %%%%%%%%%%%% JAZA2707
    if strcmp(name,'JAZA2707')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 9;
        end
    end
    
    %%%%%%%%%%%% JAZA1739
    if strcmp(name,'JAZA1739')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 3;
        end
    end
    
    %%%%%%%%%%%% JAZA2053
    if strcmp(name,'JAZA2053')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 5; % CCQ
        end
    end
    
    Cal = calibData.OOcal{1,calibFile};
    WLs = calibData.WLs{1,calibFile};
    
end

%% Calibrationfiles from 2016-08-09
if strcmp(calibDate{1}, '2016-08-09');
    %filename = 'calibData_HL3p17_2016-08-09.mat';
    filename = 'calibData_DH2000_M2_2016-08-09';
    load(filename);
    
    %%%%%%%%%%%%%%% M2
    if strcmp(name,'MAYP11938')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            %calibFile = 7;
            calibFile = 3;
        end
    end
    
    %%%%%%%%%%%% JAZA1734
    if strcmp(name,'JAZA1734')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 2;
        end
    end

    %%%%%%%%%%%% JAZA2707
    if strcmp(name,'JAZA2707')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 6;
        end
    end
    
    %%%%%%%%%%%% JAZA1739
    if strcmp(name,'JAZA1739')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 4;
        end
    end
    
    %%%%%%%%%%%% JAZA2053 % JAZ2053_fib50umB_CCQ_calib
    if strcmp(name,'JAZA2053')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 5; % CCQ
        end
    end
    
    %%%%%%%%%%%% JAZA1735
    if strcmp(name,'JAZA1735')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 3;
        end
    end
    
    %%%%%%%%%%%% JAZA1405
    if strcmp(name,'JAZA1405')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 1;
        end
    end
    
    Cal = calibData.OOcal{1,calibFile};
    WLs = calibData.WLs{1,calibFile};
    
end

%% Calibrationfiles from 2016-12-20
if strcmp(calibDate{1}, '2016-12-20');
    filename = 'calibData_HL3p17_2016-12-20.mat';
    load(filename);
    
    %%%%%%%%%%%%%%% M2
    if strcmp(name,'MAYP11938')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 4;
        end
    end
    
    %%%%%%%%%%%%%%% M1
    if strcmp(name,'MAYP10191')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 3;
        end
    end
    
    %%%%%%%%%%%% JAZA1734
    if strcmp(name,'JAZA1734')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 2;
        end
    end
    
    %%%%%%%%%%%% JAZA1405
    if strcmp(name,'JAZA1405')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 1;
        end
    end
    
    %%%%%%%%%%%% STS_S02091
    if strcmp(name,'S02091')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 5;
        end
    end
    
    Cal = calibData.OOcal{1,calibFile};
    WLs = calibData.WLs{1,calibFile};
    
end

%% Calibrationfiles from 2017-06-23
if strcmp(calibDate{1}, '2017-06-23');
    filename = 'calibData_HL3p17_2017-06-23.mat';
    load(filename);
    
    %%%%%%%%%%%%%%% JAZ1739
    if strcmp(name,'JAZA1739')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 1;
        end
    end
    
    %%%%%%%%%%%%%%% JAZ2053 (JAZ2053_CCQ_calib)
    if strcmp(name,'JAZA2053')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 2;
        end
    end

    %%%%%%%%%%%% STS_S02091
    if strcmp(name,'S02091')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 3;
        end
    end
    
    Cal = calibData.OOcal{1,calibFile};
    WLs = calibData.WLs{1,calibFile};    
end

%% Calibrationfiles from 2017-07-03
if strcmp(calibDate{1}, '2017-07-03');
    filename = 'calibData_Camilo_2017-07-03.mat';
    load(filename);

    %%%%%%%%%%%% STS_S02091
    if strcmp(name,'S02091')
        if cosineCorrector == true
            fiber_diameter = 3900e-6;
            calibFile = 2;
        end
    end
    
    Cal = calibData.OOcal{1,calibFile};
    WLs = calibData.WLs{1,calibFile};    
end

end

%% For updating this file with new callibration data:

% List names in calibration file.
% Create new code valid for the new calibration date.
