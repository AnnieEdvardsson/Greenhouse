function [new_data] = cut_intervals (data, data_intervals, bad_intervals)

% data, data_intervals and bad_intervals are column vectors or matrices.

[nrOfintervals,~]       = size(data_intervals);
[nrOfbadintervals,~]    = size(bad_intervals);
bad_id = 1;
new_id = 1;
for interval_id = 1:nrOfintervals        
    if bad_intervals(bad_id,2) < data_intervals(interval_id,1) && bad_id < nrOfbadintervals
        bad_id = bad_id + 1;
    end
    if bad_intervals(bad_id,1) > data_intervals(interval_id,2)
        new_data(new_id,:) = data (interval_id,:);
        new_id = new_id + 1;
    end
    if bad_id == nrOfbadintervals && bad_intervals(bad_id,2) < data_intervals(interval_id,1)
        new_data(new_id,:) = data (interval_id,:);
        new_id = new_id + 1;
end
end