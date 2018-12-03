function [NLtime,NLdata,time_out,data_out] = cutNLdata(time,data,excitation,experimentname,varargin)
%function [NLtime,NLdata,time_out,data_out] = cutNLdata(time,data,excitationsignal,experimentname,varargin)
% Cuts the NL periods from the experimental data and returns both the 
% NL periods separate and the data without the NL periods. 
% Either "continuously" sampled data or period based data 
% (e.g. amplitude of period) is ok.

% Input:
% time = time vector with starttime subtracted (exp.starttime)
% data = rows should correspond to time in time vector. Any number of
%           columns works fine.
% experimentname = exp.experimentname. Used for treating data from Mar7
%                   differently, since the first phase is shorter here.
% Output:
% Outputs är i celler {[LL]; [HL]; [ML]; [LL]} respektive {[NL1]; [NL2]; [NL3]; [NL4]} 
% NLtime = timestamps corresponding to data in NL-intervals.
% NLdata = data from NL intervals
% time_out = timestamps corresponding to data_out, outside NL intervals
% data_out = data outside NL intervals
if strcmp(excitation,'sin')
    if nargin > 4
        %Om andra intervall-definitioner önskas.
        NLintervals = varargin{1};
    else if strcmp(experimentname,'Sinusoid_HLLED_Mar7')
        % Första fasen i detta experiment är 1800s kortare än övriga
        % experimentdagar.
        NLintervals =[  0           300;
                        7500        7800;
                        11400       11700;
                        18900       19200];
        else
            NLintervals = [0        300;
                           9300     9600;
                           13200    13500;
                           20700    21000];
        end
    end
end
if strcmp(excitation,'step')
    if nargin > 4
        %Om andra intervall-definitioner önskas.
        NLintervals = varargin{1};
    else if strcmp(experimentname,'SquareHLHPS_feb27') || strcmp(experimentname,'SquareHLLED_feb28')||strcmp(experimentname,'SquareLLHPS_mar1')|| strcmp(experimentname,'Square_LLLED_Mar4')
        % Första fasen i dessa experiment är 1800s kortare än övriga
        % experimentdagar.
        NLintervals =[  0           600;
                        7800        8400;
                        12000       12600;
                        19800       20400]; %done
        else
            NLintervals = [0        600;
                           9600     10200;
                           13800    14400;
                           21600    22200]; %done
        end
    end
end
[~,c]       = size(data);
[NLend,~]   = size(NLintervals);
idt1        = 1;
%idt3        = 1;

time_out = cell(1,NLend);
data_out = cell(1,NLend);
NLtime   = cell(1,NLend);
NLdata   = cell(1,NLend);

for idNL = 1:NLend
    idt2 = 1;
    time_temp = 0;
    data_temp = zeros(1,c);
    NLtime_temp = 0;
    NLdata_temp = zeros(1,c);
    while time(idt1) < NLintervals(idNL,1)
        time_temp(idt2)             = time(idt1);
        data_temp(idt2,:)           = data(idt1,:);
        %time_out(idt1-(idt3-1))     = time(idt1);
        %data_out(idt1-(idt3-1),:)   = data(idt1,:);
        idt2 = idt2 +1;
        idt1 = idt1 +1;
%         if mod(idt1,100) == 0
%             idNL
%             time(idt1)
%         end
    end
    if idNL > 1
        time_out{1,idNL-1} = time_temp';
        data_out{1,idNL-1} = data_temp;
    end
    idt3 =1;
    while time(idt1) >= NLintervals(idNL,1) && time(idt1) <= NLintervals(idNL,2)
        NLtime_temp(idt3)    = time(idt1);
        NLdata_temp(idt3,:)  = data(idt1,:);
        idt1 = idt1+1;
        idt3 = idt3+1;
        
%         if mod(idt1,10) == 0
%             idNL
%             time(idt1)
%         end
    end
    NLtime{1,idNL} = NLtime_temp';
    NLdata{1,idNL} = NLdata_temp;
end
idt2 = 1;
time_temp = 0;
data_temp = zeros(1,c);
while time(idt1) < time(end)
    time_temp(idt2)             = time(idt1);
    data_temp(idt2,:)           = data(idt1,:);       
    %time_out(idt1-(idt3-1))     = time(idt1);
    %data_out(idt1-(idt3-1),:)   = data(idt1,:);
    idt1 = idt1 +1;
    idt2 = idt2 +1;
end
time_out{1,4} = time_temp';
data_out{1,4} = data_temp;
end
    
