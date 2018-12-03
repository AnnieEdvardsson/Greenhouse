function t = unixtime(v,timezone)
% t = unixtime(v,timezone)
% v är på formen [år mån dag h min s]
% v kan också vara en cellstruktur där varje cell innehåller en vektor på formen [år mån dag h min s]
% timezone = 3600 om svensk tid vintertid och 7200 om svensk tid sommartid.
if iscell(v)
    t = zeros(size(v));
    for i = 1:size(v,1)
        for j = 1:size(v,2)
            t(i,j) = unixtimeOneClock(v{i,j},timezone);
        end
    end
else
    t = unixtimeOneClock(v,timezone);
end
end

function t = unixtimeOneClock(oneTimeStamp,timezone)
if isempty (oneTimeStamp)
    t = 0;
else
    epoch   = datenum('19700101 000000','yyyymmdd HHMMSS');
    t      = (datenum(oneTimeStamp)-epoch).*86400 - timezone;
end
end
            