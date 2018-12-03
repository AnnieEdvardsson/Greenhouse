function DATA = amprepareData_All(Spectrometers, n_spect, index)
%%DATA = amprepareData_All(Spectrometers, n_spect, index)
%%i.e. index = [420 450] or index(intIdx,:,specNr)= [420 450]
DATA = [];
for intIdx = 1:size(index,1)
    for specNr=1:n_spect
        current_spect=Spectrometers(specNr);
        name = current_spect.SERIAL;
        cosineCorrector = current_spect.CosineCorrector;
        fiberWidth = current_spect.FiberWidth;

        %specOrg = current_spect.Spectra;

        %if spectra has time stamp use this to create specOrg    
        [n,~] = size(current_spect.Spectra);
        for j = 1:n
            specOrg{j} = current_spect.Spectra{j,2};
        end

        IT = current_spect.IT;
        specDZ = prepareData_DZ(specOrg,IT,name);
    %    specEDZ = prepareData_eDZ(specDZ,specOrg,IT,name);
    %    specTemp = prepareData_temp(specEDZ,name);
        specTemp = specDZ;

        %%%% Daniel B mods
        %specTemp = specEDZ;
        %specTemp = specOrg;
        %specIrr.spec_uEin = specOrg;
        %specIrr.spec_uEin_nm = specOrg;

        if any(strcmp(fieldnames(Spectrometers),'CalibDate'))
            specIrr = prepareData_irr(specTemp,IT,name,cosineCorrector,fiberWidth,current_spect.CalibDate);
        else
            specIrr = prepareData_irr(specTemp,IT,name,cosineCorrector,fiberWidth);
        end

        specIntirr = prepareData_intirr(specIrr,(index(intIdx,:,specNr))'); 

        DATA(specNr).SERIAL = name;
        DATA(specNr).IRR = specIrr;
        DATA(specNr).intIRR(intIdx) = specIntirr;    
     % Optional
    %     DATA(i).specDZ = specDZ;
    %     DATA(i).specEDZ = specEDZ;
    %     DATA(i).specTemp = specTemp;
        % Testing
    % x = specIrr.WLs;
    % y1 = specIrr.spec_uEin_nm{1,1};
    % plot(x,y1);
    % hold on
    % y2 = specIrr.spec_uEin_nm{1,3};
    % plot(x,y2,'r');
    % y3 = specIrr.spec_uEin_nm{1,7};
    % plot(x,y3,'g')
    % y4 = specIrr.spec_uEin_nm{1,11};
    % plot(x,y4,'y')
    end
end
end

