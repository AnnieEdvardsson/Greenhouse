function combineSweepingParts(first,last)
%%Usage:
% time_first = datenum(2017,11,01,15,46,00); %date for the first PART-file
% time_last  = datenum(2017,11,02,14,01,59); %date for the last part file
% with 'ss' = 00 and 'ss' = 59 respectively for the first and last date 
% in the datenum(yyyy,mm,dd,hh,mm,ss)

% combineSweepingParts(time_first,time_last)

load Sweepings\CompleteSweeping_2017-11-02.mat

name = 'Sweepings/PARTSweeping_LX';
D = dir(strcat(name,datestr(first,'yyyy-mm'),'*'));
% first   = datenum(time_first);
% last    = datenum(time_last); 
        
j = 0;
for i = 1:length(D)
    date = D(i).datenum;
    if (first <= date)&&(date <= last)
        j = j+1;
        load([D(i).folder,'/',D(i).name],'intIRRmatrix');
        load([D(i).folder,'/',D(i).name],'lampINTmatrix');
        load([D(i).folder,'/',D(i).name],'IT');
        load([D(i).folder,'/',D(i).name],'spectra');
        if j == 1
            intIRRcomplete   = intIRRmatrix;
            lampINTcomplete  = lampINTmatrix;
            ITcomplete       = IT;
            spectra_complete = spectra;
            load([D(i).folder,'/',D(i).name],'settings');
            load([D(i).folder,'/',D(i).name],'Info');
        else
            intIRRcomplete(j,:)   = intIRRmatrix(j,:);
            lampINTcomplete(j,:)  = lampINTmatrix(j,:);
            ITcomplete(j,:)       = IT(j,:);
            spectra_complete(j,:) = spectra(j,:);
        end
    end
end

intIRRmatrix = intIRRcomplete;
lampINTmatrix = lampINTcomplete;
IT              = ITcomplete;
spectra         = spectra_complete;

save(strcat('Sweepings/CompleteSweeping_',datestr(last,'yyyy-mm-dd')),'intIRRmatrix','lampINTmatrix','IT','spectra','settings','Info')
end