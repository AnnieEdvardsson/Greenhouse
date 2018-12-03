function [time,data] = cut_time_for_steps(exp,time_in,data_in)
[NLtime,NLdata,phase_time,phase_data] = cutNLdata(time_in-exp.starttime,...
    data_in,'step',exp.experimentname);

time = [];
data = [];
i = 1;
while time_in(i) < exp.starttime
    %time = [time; time_in(i)-exp.starttime];
    time = [time; 0];
    data = [data; data_in(i,:)];
    i = i+1;
end
    
for i = 1:4
    if NLdata{1,i}(1) ~=0
        time = [time; NLtime{1,i}-300*i];
        data = [data; NLdata{1,i}];
    end
    if phase_data{1,i}(1) ~=0
        time = [time; phase_time{1,i}-300*i];
        data = [data; phase_data{1,i}];
    end
end

if time_in(end) > phase_time{1,4}(end)
    time = [time; time_in(end,:)-exp.starttime-300*4];
    data = [data; data_in(end,:)];
end

% clf
% hold all
% plot(time_in-exp.starttime,data_in,'k')
% plot(time,data,'g')
end
    
        




